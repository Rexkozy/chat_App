import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.isMe, this.userName, this.imageUrl,
      {required this.key});

  final Key key;
  final String message;
  final String userName;
  final String imageUrl;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              width: 160,
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                  color:
                      isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft:
                          !isMe ? Radius.circular(0) : Radius.circular(12),
                      bottomRight:
                          isMe ? Radius.circular(0) : Radius.circular(12))),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                        color: isMe ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    message,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: isMe ? Colors.black : Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10,
          right: isMe ? 150 : null,
          left: isMe ? null : 150,
          child: CircleAvatar(
            radius: 21,
            backgroundImage: NetworkImage(imageUrl),
          ),
        )
      ],
      overflow: Overflow.visible,
    );
  }
}
