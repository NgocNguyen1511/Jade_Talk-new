import 'package:flutter/material.dart';
import 'package:jade_talk/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class MessageReplyPreview extends StatelessWidget {
  const MessageReplyPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      final messageReply = chatProvider.messageReplyModel;
      final isMe = messageReply!.isMe;
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ListTile(
          title: Text(
            isMe ? 'You' : messageReply.senderName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          subtitle: Text(
            messageReply.message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () {
              chatProvider.setMessageReplyModel(null);
            },
            icon: const Icon(Icons.close),
          ),
        ),
      );
    });
  }
}
