import 'package:flutter/material.dart';
import 'package:jade_talk/models/message_model.dart';
import 'package:jade_talk/widgets/contact_message_widget.dart';
import 'package:jade_talk/widgets/my_message_widget.dart';
import 'package:swipe_to/swipe_to.dart';

class SwipeToWidget extends StatelessWidget {
  const SwipeToWidget({
    super.key,
    required this.onRightSwipe,
    required this.message,
    required this.isMe,
  });

  final Function() onRightSwipe;
  final MessageModel message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onRightSwipe: (details) {
        onRightSwipe();
      },
      child: isMe ? MyMessageWidget(message: message): ContactMessageWidget(message: message),
    );
  }
}
