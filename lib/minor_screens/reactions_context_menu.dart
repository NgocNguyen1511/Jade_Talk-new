import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jade_talk/models/message_model.dart';
import 'package:jade_talk/providers/authentication_provider.dart';
import 'package:jade_talk/providers/chat_provider.dart';
import 'package:jade_talk/utilities/global_methods.dart';
import 'package:jade_talk/widgets/align_message_left_widget.dart';
import 'package:jade_talk/widgets/align_message_right_widget.dart';
import 'package:provider/provider.dart';

class ReactionsContextMenu extends StatefulWidget {
  const ReactionsContextMenu({
    super.key,
    required this.isMyMessage,
    required this.message,
    required this.contactUID,
    required this.groupId,
  });

  final bool isMyMessage;
  final MessageModel message;
  final String contactUID;
  final String groupId;

  @override
  State<ReactionsContextMenu> createState() => _ReactionsContextMenuState();
}

class _ReactionsContextMenuState extends State<ReactionsContextMenu> {
  bool reactionClicked = false;
  int? clickedReactionIndex;
  int? clickedContextMenuIndex;

  Future<void> sendReactionToMessage(
      {required String reaction, required String messageId}) async {
    // get the sender uid
    final senderUID = context.read<AuthenticationProvider>().userModel!.uid;

    await context.read<ChatProvider>().sendReactionToMessage(
          senderUID: senderUID,
          contactUID: widget.contactUID,
          messageId: messageId,
          reaction: reaction,
          groupId: widget.groupId.isNotEmpty,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: widget.isMyMessage ? Alignment.centerRight: Alignment.centerLeft,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final reaction in reactions)
                          FadeInRight(
                            from: 0 + reactions.indexOf(reaction) * 20,
                            duration: const Duration(milliseconds: 500),
                            child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    reactionClicked = true;
                                    clickedReactionIndex =
                                        reactions.indexOf(reaction);
                                  });
                                  // if its a plus reaction show bottom with emoji keyboard
                                  if (reaction == '➕') {
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      Navigator.pop(context, '➕');
                                    }); 
                                  } else {
                                    await sendReactionToMessage(
                                            reaction: reaction,
                                            messageId: widget.message.messageId)
                                        .whenComplete(() {
                                      Navigator.pop(context);
                                    });
                                  }

                                  // set back to false after milliseconds second
                                  // Future.delayed(
                                  //   const Duration(milliseconds: 500),
                                  //   () {
                                  //     setState(() {
                                  //       reactionClicked = false;
                                  //     });
                                  //   },
                                  // );
                                },
                                child: Pulse(
                                  infinite: false,
                                  duration: Duration(milliseconds: 500),
                                  animate: reactionClicked &&
                                      clickedReactionIndex ==
                                          reactions.indexOf(reaction),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      reaction,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                )),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Hero(
                tag: widget.message.messageId,
                child: widget.isMyMessage ? AlignMessageRightWidget(
                  message: widget.message,
                ): AlignMessageLeftWidget(
                  message: widget.message,
                ),
              ),
              Align(
                alignment: widget.isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          for (final menu in contextMenu)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  clickedContextMenuIndex =
                                      contextMenu.indexOf(menu);
                                });
                                Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      Navigator.pop(context, menu);
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      menu,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Pulse(
                                      infinite: false,
                                      duration: Duration(milliseconds: 500),
                                      animate: clickedContextMenuIndex ==
                                          contextMenu.indexOf(menu),
                                      child: Icon(menu == 'Reply'
                                          ? Icons.reply
                                          : menu == 'Copy'
                                              ? Icons.copy
                                              : Icons.delete, color: Colors.black,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
