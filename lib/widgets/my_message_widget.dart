import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:jade_talk/models/message_model.dart';

class MyMessageWidget extends StatelessWidget {
  const MyMessageWidget({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final time = formatDate(message.timeSent, [hh, ':', nn, ' ', am]);
    final isReplying = message.repliedTo.isNotEmpty;
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          minWidth: MediaQuery.of(context).size.width * 0.3,
        ),
        child: Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
          color: Colors.deepPurple,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 30.0, top: 5.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isReplying) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10.0),
                        ), // BoxDecoration
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                message.repliedTo,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                message.repliedMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    Text(
                      message.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      time,
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      message.isSeen ? Icons.done_all : Icons.done,
                      color: message.isSeen ? Colors.blue : Colors.white60,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
