import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:jade_talk/enums/enums.dart';
import 'package:jade_talk/models/message_model.dart';
import 'package:jade_talk/widgets/display_message_type.dart';
import 'package:swipe_to/swipe_to.dart';

class ContactMessageWidget extends StatelessWidget {
  const ContactMessageWidget({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final time = formatDate(message.timeSent, [hh, ':', nn, ' ']);
    final isReplying = message.repliedTo.isNotEmpty;
    final senderName = message.repliedTo == 'You' ?  message.senderName : 'You';
    //check if its dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          minWidth: MediaQuery.of(context).size.width * 0.3,
        ),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          color: isDarkMode?const Color.fromARGB(255, 46, 35, 68): Color.fromARGB(255, 241, 233, 247),
          child: Stack(
            children: [
              Padding(
                padding: message.messageType == MessageEnum.text
                    ? const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 20.0)
                    : const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isReplying) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                senderName,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ), 
                              ),
                              DisplayMessageType(
                                message: message.repliedMessage,
                                type: message.messageType,
                                color: Colors.black,
                                isReply: true,
                                maxLines: 1,
                                overFlow: TextOverflow.ellipsis,
                              ),
                            ], 
                          ), 
                        ), 
                      ), 
                    ],
                    DisplayMessageType(
                      message: message.message,
                      type: message.messageType,
                      color: Colors.black,
                      isReply: false,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  time,
                  style:  TextStyle(color: isDarkMode? Colors.white: Colors.black, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
