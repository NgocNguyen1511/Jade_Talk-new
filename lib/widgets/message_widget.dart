import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:jade_talk/models/message_model.dart';
import 'package:jade_talk/widgets/contact_message_widget.dart';
import 'package:jade_talk/widgets/my_message_widget.dart';
import 'package:jade_talk/widgets/swipe_to_widget.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.message,
    required this.onRightSwipe,
    required this.isViewOnly,
    required this.isMe,
  });

  final MessageModel message;
  final Function() onRightSwipe;
  final bool isViewOnly;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final time = formatDate(message.timeSent, [hh, ':', nn, ' ']);
    final isReplying = message.repliedTo.isNotEmpty;

    return isMe
        ? isViewOnly
            ? MyMessageWidget(
                message: message,
              )
            : SwipeToWidget(
                onRightSwipe: onRightSwipe,
                message: message,
                isMe: isMe,
              )
        : isViewOnly
            ? ContactMessageWidget(
                message: message,
              )
            : SwipeToWidget(
                onRightSwipe: onRightSwipe,
                message: message,
                isMe: isMe,);
  }
}
