import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:jade_talk/minor_screens/reactions_context_menu.dart';
import 'package:jade_talk/models/message_model.dart';
import 'package:jade_talk/models/message_reply_model.dart';
import 'package:jade_talk/providers/authentication_provider.dart';
import 'package:jade_talk/providers/chat_provider.dart';
import 'package:jade_talk/utilities/global_methods.dart';
import 'package:jade_talk/utilities/hero_dialog_route.dart';
import 'package:jade_talk/widgets/message_widget.dart';
import 'package:jade_talk/widgets/stacked_reations.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key, required this.contactUID, required this.groupId});

  final String contactUID;
  final String groupId;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  //scroll controller
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onContextMenuClicked(
      {required String item, required MessageModel message}) {
    switch (item) {
      case 'Reply':
        // set the message reply to true
        final messageReply = MessageReplyModel(
          message: message.message,
          senderUID: message.senderUID,
          senderName: message.senderName,
          senderImage: message.senderImage,
          messageType: message.messageType,
          isMe: true,
        );

        context.read<ChatProvider>().setMessageReplyModel(messageReply);
        break;

      case 'Copy':
        // copy message to clipboard
        Clipboard.setData(ClipboardData(text: message.message));
        showSnackBar(context, 'Message copied to clipboard');
        break;
      case 'Delete':
        // //delete message
        //   context.read<ChatProvider>().deleteMessage(
        //         userId: uid,
        //         contactUID: widget.contactUID,
        //         messageId: message.messageId,
        //         groupId: widget.groupId,
        //       );
        break;
    }
  }

  

  void sendReactionToMessage(
      {required String reaction, required String messageId}) {
    // get the sender uid
    final senderUID = context.read<AuthenticationProvider>().userModel!.uid;

    context.read<ChatProvider>().sendReactionToMessage(
          senderUID: senderUID,
          contactUID: widget.contactUID,
          messageId: messageId,
          reaction: reaction,
          groupId: widget.groupId.isNotEmpty,
        );
  }

  void showEmojiContainer({required String messageId}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 300,
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            Navigator.pop(context);
            // add emoji to message
            sendReactionToMessage(reaction: emoji.emoji, messageId: messageId);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //current user id
    final uid = context.read<AuthenticationProvider>().userModel!.uid;
    return GestureDetector(
      onVerticalDragDown: (_) {
        //automatically hide the keyboard when scrolling down
        FocusScope.of(context).unfocus();
      },
      child: StreamBuilder<List<MessageModel>>(
        stream: context.read<ChatProvider>().getMessagesStream(
              userId: uid,
              contactUID: widget.contactUID,
              isGroup: widget.groupId,
            ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Start a conversation',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            );
          }

          // automatically scroll to the bottom on new message
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          });

          if (snapshot.hasData) {
            final messagesList = snapshot.data!;
            return GroupedListView<dynamic, DateTime>(
              reverse: true,
              controller: _scrollController,
              elements: messagesList,
              groupBy: (element) {
                return DateTime(
                  element.timeSent!.year,
                  element.timeSent!.month,
                  element.timeSent!.day,
                );
              },
              groupHeaderBuilder: (dynamic groupedByValue) =>
                  SizedBox(height: 40, child: buildDateTime(groupedByValue)),
              itemBuilder: (context, dynamic element) {
                final padding1 = element.reactions.isEmpty ? 8.0 : 20.0;
                final padding2 = element.reactions.isEmpty ? 8.0 : 25.0;

                // set message as seen
                if (!element.isSeen && element.senderUID != uid) {
                  context.read<ChatProvider>().setMessageAsSeen(
                        userId: uid,
                        contactUID: widget.contactUID,
                        messageId: element.messageId,
                        groupId: widget.groupId,
                      );
                }

                // check if we sent the last message
                final isMe = element.senderUID == uid;
                return Stack(
                  children: [
                    InkWell(
                      onLongPress: () async {
                        //showReactionsDialog(isMe: isMe, message: element);

                        String? item = await Navigator.of(context).push(
                          HeroDialogRoute(
                            builder: (context) {
                              return ReactionsContextMenu(
                                isMyMessage: isMe,
                                message: element,
                                contactUID: widget.contactUID,
                                groupId: widget.groupId,
                              );
                            },
                          ),
                        );
                        if (item ==null) return;

                        if (item == '➕') {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            // show emoji keyboard
                            showEmojiContainer(messageId: element.messageId);
                          }); 
                        }else{
                          Future.delayed(const Duration(milliseconds: 300), () {
                            // on context menu clicked
                            onContextMenuClicked(item: item, message: element);
                          }); 
                          
                        }

                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8.0, bottom: isMe ? padding1 : padding2),
                        child: Hero(
                          tag: element.messageId,
                          child: MessageWidget(
                            message: element,
                            onRightSwipe: () {
                              //set the message reply to true
                              final messageReply = MessageReplyModel(
                                message: element.message,
                                senderUID: element.senderUID,
                                senderName: element.senderName,
                                senderImage: element.senderImage,
                                messageType: element.messageType,
                                isMe: isMe,
                              );

                              context
                                  .read<ChatProvider>()
                                  .setMessageReplyModel(messageReply);
                            },
                            isViewOnly: false,
                            isMe: isMe,
                          ),
                        ),
                      ),
                    ),
                    isMe
                        ? Positioned(
                            bottom: 4,
                            right: 90,
                            child: StackedReations(
                              size: 20,
                              message: element,
                              onTap: () {
                                //TODO show bottom sheet with list of peoople who reacted
                              },
                            ))
                        : Positioned(
                            bottom: 0,
                            left: 50,
                            child: StackedReations(
                              size: 20,
                              message: element,
                              onTap: () {
                                //TODO show bottom sheet with list of peoople who reacted
                              },
                            )),
                  ],
                );
              },
              //groupComparator to make which is the latest message at the last time
              groupComparator: (value1, value2) => value2.compareTo(value1),
              itemComparator: (item1, item2) {
                var firstItem = item1.timeSent;
                var secondItem = item2.timeSent;

                return secondItem!.compareTo(firstItem);
              },
              useStickyGroupSeparators: true,
              floatingHeader: true,
              order: GroupedListOrder.ASC,
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
