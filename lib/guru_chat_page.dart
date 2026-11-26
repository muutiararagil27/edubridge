
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuruChatPage extends StatelessWidget {
  const GuruChatPage({super.key});

  static const Color primaryColor = Color(0xFF2457C5);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('Silakan login terlebih dahulu.'));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
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
            return const Center(
              child: Text('Gagal memuat daftar pengguna.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final parents = snapshot.data!.docs.where((doc) {
            final data = doc.data();
            final role = (data['role'] ?? '')
                .toString()
                .toLowerCase()
                .replaceAll(' ', '');

            return doc.id != currentUser.uid &&
                (role == 'orangtua' || role == 'parent');
          }).toList();

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
                      'Daftar orang tua akan muncul di sini '
                      'setelah akun mereka terdaftar.',
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

              final nama = data['nama']?.toString() ?? 'Orang Tua';
              final email = data['email']?.toString() ?? '';

              return Card(
                color: Colors.white,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
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
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _messageController =
      TextEditingController();

  final ScrollController _scrollController = ScrollController();

  static const Color primaryColor = Color(0xFF2457C5);

  bool _sending = false;

  String get conversationId {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ids = [uid, widget.receiverId]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (text.isEmpty || user == null || _sending) return;

    setState(() => _sending = true);

    try {
      await FirebaseFirestore.instance.collection('Messages').add({
        'conversationId': conversationId,
        'participants': [user.uid, widget.receiverId],
        'senderId': user.uid,
        'receiverId': widget.receiverId,
        'isiPesan': text,
        'waktuKirim': FieldValue.serverTimestamp(),
        'statusBaca': false,
      });

      _messageController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pesan gagal dikirim: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: primaryColor),
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
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Messages')
                  .where('conversationId', isEqualTo: conversationId)
                  .orderBy('waktuKirim')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Gagal memuat percakapan.'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data!.docs;

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
                    final isMe = data['senderId'] == uid;
                    final message = data['isiPesan']?.toString() ?? '';

                    final timestamp = data['waktuKirim'] as Timestamp?;

                    final time = timestamp == null
                        ? ''
                        : TimeOfDay.fromDateTime(
                            timestamp.toDate(),
                          ).format(context);

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? primaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              message,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
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
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 15),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan...',
                      filled: true,
                      fillColor: const Color(0xFFF1F3F8),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
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
                    onPressed: _sending ? null : _sendMessage,
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
