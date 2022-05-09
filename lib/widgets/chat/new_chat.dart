import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewChat extends StatefulWidget {
  const NewChat({
    Key? key,
  }) : super(key: key);

  @override
  State<NewChat> createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  var _newmessage = "";
  final _controller = TextEditingController();

  void _sendmessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection("users").doc(
      user?.uid).get();
    FirebaseFirestore.instance.collection("chat").add({
      "text": _newmessage,
      "createdAt": Timestamp.now(),
      "userId": user?.uid,
      "username":userData["username"],
      "userImage":userData['image_url']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter your message",
                fillColor: Colors.white54,
              ),
              onChanged: (value) {
                setState(() {
                  _newmessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: _newmessage.trim().isEmpty ? null : _sendmessage,
            icon: Icon(
              Icons.send,
            ),
          ),
        ],
      ),
    );
  }
}
