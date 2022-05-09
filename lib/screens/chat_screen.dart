import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chat Screen"),
          actions: [
            DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(children: [
                      const Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Logout"),
                    ]),
                  ),
                  value: "logout",
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == "logout") {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(child: Messages()),
              NewChat(),
            ],
          ),
        ));
  }
}
