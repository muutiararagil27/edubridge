
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuruChatPage extends StatefulWidget {
  const GuruChatPage({super.key});

  @override
  State<GuruChatPage> createState() => _GuruChatPageState();
}

class _GuruChatPageState extends State<GuruChatPage> {
  final TextEditingController _messageController =
      TextEditingController();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String? currentUid =
      FirebaseAuth.instance.currentUser?.uid;

  bool _sending = false;

  CollectionReference get _users =>
      _firestore.collection('Users');

  CollectionReference get _messages =>
      _firestore.collection('Messages');

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Mencari akun lawan bicara
  Stream<DocumentSnapshot> get _currentUserStream {
    return _users.doc(currentUid).snapshots();
  }

  Widget _buildChat() {
    if (currentUid == null) {
      return const Center(
        child: Text('Silakan login terlebih dahulu.'),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _currentUserStream,
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!userSnapshot.data!.exists) {
          return const Center(
            child: Text('Data akun tidak ditemukan.'),
          );
        }

        final userData =
            userSnapshot.data!.data() as Map<String, dynamic>;

        final role = (userData['role'] ?? '')
            .toString()
            .toLowerCase();

        final isGuru = role == 'guru';

        return StreamBuilder<QuerySnapshot>(
          stream: _users.snapshots(),
          builder: (context, usersSnapshot) {
            if (!usersSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final candidates = usersSnapshot.data!.docs.where((doc) {
              if (doc.id == currentUid) return false;

              final data = doc.data() as Map<String, dynamic>;
              final otherRole = (data['role'] ?? '')
                  .toString()
                  .toLowerCase()
                  .replaceAll(' ', '_');

              if (isGuru) {
                return [
                  'orang_tua',
                  'orangtua',
                  'parent',
                  'wali',
                ].contains(otherRole);
              }

              return otherRole == 'guru';
            }).toList();

            if (candidates.isEmpty) {
              return const Center(
                child: Text(
                  'Akun guru/orang tua belum ditemukan.',
                  textAlign: TextAlign.center,
                ),
              );
            }

            // Karena hanya satu kelas, gunakan satu lawan bicara.
            final otherUser = candidates.first;
            final otherUid = otherUser.id;
            final otherData =
                otherUser.data() as Map<String, dynamic>;

            final otherName =
                otherData['nama'] ?? 'Guru / Orang Tua';

            return Column(
              children: [
                _buildHeader(otherName.toString()),

                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _messages
                        .where(
                          'participants',
                          arrayContains: currentUid,
                        )
                        .snapshots(),
                    builder: (context, messageSnapshot) {
                      if (messageSnapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Gagal memuat percakapan.',
                          ),
                        );
                      }

                      if (!messageSnapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final chatDocs = messageSnapshot
                          .data!.docs.where((doc) {
                        final data =
                            doc.data() as Map<String, dynamic>;

                        final participants =
                            List<String>.from(
                          data['participants'] ?? [],
                        );

                        return participants.contains(otherUid);
                      }).toList();

                      chatDocs.sort((a, b) {
                        final aData =
                            a.data() as Map<String, dynamic>;
                        final bData =
                            b.data() as Map<String, dynamic>;

                        final aTime =
                            aData['waktuKirim'] as Timestamp?;
                        final bTime =
                            bData['waktuKirim'] as Timestamp?;

                        return (bTime?.millisecondsSinceEpoch ?? 0)
                            .compareTo(
                          aTime?.millisecondsSinceEpoch ?? 0,
                        );
                      });

                      if (chatDocs.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 55,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Belum ada percakapan.',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Mulai kirim pesan sekarang.',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: chatDocs.length,
                        itemBuilder: (context, index) {
                          final data = chatDocs[index].data()
                              as Map<String, dynamic>;

                          final isMe =
                              data['senderId'] == currentUid;

                          final message =
                              data['isiPesan'] ?? '';

                          final timestamp =
                              data['waktuKirim'] as Timestamp?;

                          final time = timestamp != null
                              ? TimeOfDay.fromDateTime(
                                  timestamp.toDate(),
                                ).format(context)
                              : '';

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width *
                                        0.75,
                              ),
                              margin: const EdgeInsets.only(
                                bottom: 12,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? const Color(0xFF2457C5)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    message.toString(),
                                    style: TextStyle(
                                      color: isMe
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    time,
                                    style: TextStyle(
                                      color: isMe
                                          ? Colors.white70
                                          : Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                _buildInput(otherUid),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(String name) {
    return Container(
      padding: const EdgeInsets.all(14),
      color: Colors.white,
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE5EDFF),
            child: Icon(
              Icons.person,
              color: Color(0xFF2457C5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  'EduBridge • XI-A3',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String receiverId) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tulis pesan...',
                filled: true,
                fillColor: const Color(0xFFF1F3F8),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF2457C5),
            child: IconButton(
              onPressed: _sending
                  ? null
                  : () => _sendMessage(receiverId),
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mengirim pesan ke Firestore
  Future<void> _sendMessage(String receiverId) async {
    final message = _messageController.text.trim();

    if (message.isEmpty || currentUid == null) return;

    setState(() => _sending = true);

    try {
      final participants = [currentUid!, receiverId]..sort();

      // Gunakan ID percakapan yang sudah ada jika tersedia.
      final existingMessages = await _messages
          .where('participants', arrayContains: currentUid)
          .get();

      String? conversationId;

      for (final doc in existingMessages.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final members =
            List<String>.from(data['participants'] ?? []);

        if (members.contains(receiverId)) {
          conversationId = data['conversationId']?.toString();
          if (conversationId != null) break;
        }
      }

      // Jika belum ada percakapan, buat ID konsisten.
      conversationId ??= participants.join('_');

      await _messages.add({
        'conversationId': conversationId,
        'isiPesan': message,
        'participants': participants,
        'receiverId': receiverId,
        'senderId': currentUid,
        'statusBaca': false,
        'waktuKirim': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim pesan: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: _buildChat(),
      ),
    );
  }
}
