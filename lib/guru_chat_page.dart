
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuruChatPage extends StatelessWidget {
  const GuruChatPage({super.key});

  static const Color primaryColor = Color(0xFF2457C5);
  static const Color backgroundColor = Color(0xFFF5F7FB);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text('Silakan login terlebih dahulu.'),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Chat Orang Tua',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _errorView(
              'Gagal memuat daftar pengguna.',
              snapshot.error,
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Data pengguna tidak ditemukan.'),
            );
          }

          final parents = snapshot.data!.docs.where((doc) {
            final data = doc.data();

            final role = (data['role'] ?? '')
                .toString()
                .toLowerCase()
                .replaceAll(' ', '')
                .replaceAll('_', '')
                .replaceAll('-', '');

            return doc.id != currentUser.uid &&
                (role == 'orangtua' || role == 'parent');
          }).toList();

          parents.sort((a, b) {
            final namaA = (a.data()['nama'] ?? '')
                .toString()
                .toLowerCase();
            final namaB = (b.data()['nama'] ?? '')
                .toString()
                .toLowerCase();

            return namaA.compareTo(namaB);
          });

          if (parents.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 65,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Belum ada orang tua terdaftar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Akun orang tua akan muncul di sini '
                      'setelah terdaftar di aplikasi.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: parents.length,
            itemBuilder: (context, index) {
              final parent = parents[index];
              final data = parent.data();

              final nama = data['nama']?.toString().trim().isNotEmpty == true
                  ? data['nama'].toString()
                  : 'Orang Tua';

              final email = data['email']?.toString() ?? '';

              return Card(
                color: Colors.white,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFFDCE7FF),
                    child: Icon(
                      Icons.person,
                      color: primaryColor,
                    ),
                  ),
                  title: Text(
                    nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    email.isEmpty ? 'Orang Tua Siswa' : email,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: primaryColor,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConversationPage(
                          receiverId: parent.id,
                          receiverName: nama,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  static Widget _errorView(String title, Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 45,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConversationPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ConversationPage({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ConversationPage> createState() =>
      _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _messageController =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  static const Color primaryColor = Color(0xFF2457C5);

  bool _sending = false;

  String get conversationId {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ids = [uid, widget.receiverId]..sort();

    return '${ids[0]}_${ids[1]}';
  }

  // Mengirim pesan ke Firebase.
  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (message.isEmpty || user == null || _sending) {
      return;
    }

    setState(() {
      _sending = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('Messages')
          .add({
        'conversationId': conversationId,
        'participants': [
          user.uid,
          widget.receiverId,
        ],
        'senderId': user.uid,
        'receiverId': widget.receiverId,
        'isiPesan': message,
        'waktuKirim': FieldValue.serverTimestamp(),
        'statusBaca': false,
      });

      _messageController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pesan gagal dikirim: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  // Mengurutkan pesan dari yang paling lama.
  List<QueryDocumentSnapshot<Map<String, dynamic>>>
      _sortMessages(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final messages = [...docs];

    messages.sort((a, b) {
      final waktuA = a.data()['waktuKirim'];
      final waktuB = b.data()['waktuKirim'];

      final tanggalA = waktuA is Timestamp
          ? waktuA.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0);

      final tanggalB = waktuB is Timestamp
          ? waktuB.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0);

      return tanggalA.compareTo(tanggalB);
    });

    return messages;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Silakan login kembali.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.receiverName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<
                QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Messages')
                  .where(
                    'conversationId',
                    isEqualTo: conversationId,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 45,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Gagal memuat percakapan.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('Data percakapan tidak ditemukan.'),
                  );
                }

                final messages =
                    _sortMessages(snapshot.data!.docs);

                if (messages.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.forum_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Belum ada pesan.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Mulai percakapan sekarang!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data();

                    final isMe =
                        data['senderId'] == user.uid;

                    final message =
                        data['isiPesan']?.toString() ?? '';

                    final timestamp = data['waktuKirim'];

                    final time = timestamp is Timestamp
                        ? TimeOfDay.fromDateTime(
                            timestamp.toDate(),
                          ).format(context)
                        : 'Mengirim...';

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
                          horizontal: 15,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? primaryColor
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [
                            Text(
                              message,
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

          // Kolom untuk mengirim pesan.
          Container(
            padding: const EdgeInsets.fromLTRB(
              12,
              10,
              12,
              15,
            ),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization:
                        TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan...',
                      filled: true,
                      fillColor: const Color(0xFFF1F3F8),
                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: primaryColor,
                  child: IconButton(
                    onPressed:
                        _sending ? null : _sendMessage,
                    icon: _sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
