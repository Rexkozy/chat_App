import 'package:chat_app/widgets/chat/message_bubble.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (BuildContext context, AsyncSnapshot<User?> futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final chatDocs = streamSnapshot.data!.docs;
                return ListView.builder(
                    reverse: true,
                    itemCount: chatDocs.length,
                    itemBuilder: (BuildContext context, int index) =>
                        MessageBubble(
                          chatDocs[index]['text'],
                          chatDocs[index]["userId"] == futureSnapshot.data!.uid,
                          chatDocs[index]['username'],
                          chatDocs[index]["userImage"],
                          key: ValueKey(chatDocs[index].id),
                        ));
              });
        });
  }
}
