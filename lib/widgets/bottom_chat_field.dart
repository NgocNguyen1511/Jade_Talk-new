import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jade_talk/enums/enums.dart';
import 'package:jade_talk/providers/authentication_provider.dart';
import 'package:jade_talk/providers/chat_provider.dart';
import 'package:jade_talk/services/cloudinary_service.dart';
import 'package:jade_talk/utilities/global_methods.dart';
import 'package:jade_talk/widgets/message_reply_preview.dart';
import 'package:provider/provider.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({
    super.key,
    required this.contactUID,
    required this.contactName,
    required this.contactImage,
    required this.groupId,
  });

  final String contactUID;
  final String contactName;
  final String contactImage;
  final String groupId;

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;
  File? finalFileImage;
  String filePath = '';

  bool isShowEmojiPicker = false;

  //hide emoji container
  void hideEmojiContainer() {
    setState(() {
      isShowEmojiPicker = false;
    });
  }

  //show emoji container
  void showEmojiContainer() {
    setState(() {
      isShowEmojiPicker = true;
    });
  }

  //show key board
  void showKeyBoard() {
    _focusNode.requestFocus();
  }

  //hide key board
  void hideKeyBoard() {
    _focusNode.unfocus();
  }

  //toggle emoji and keyboard container
  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiPicker) {
      showKeyBoard();
      hideEmojiContainer();
    } else {
      hideKeyBoard();
      showEmojiContainer();
    }
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  //select image from camera or gallery
  void selectImage(bool fromCamera) async {
    finalFileImage = fromCamera
        ? await pickImageFromImagePicker(ImageSource.camera)
        : await pickImageFromImagePicker(ImageSource.gallery);
    if (finalFileImage != null) {
      setState(() {
        //send
        sendFileMessage(messageType: MessageEnum.image);
      });
    }
    poptheDialog();
  }

  poptheDialog() {
    Navigator.of(context).pop();
  }

  //send image message to firestore
  void sendFileMessage({
    required MessageEnum messageType,
  }) async {
    final currentUser = context.read<AuthenticationProvider>().userModel!;
    final chatProvider = context.read<ChatProvider>();

    if (finalFileImage != null) {
      chatProvider.sendFileMessage(
          sender: currentUser,
          contactUID: widget.contactUID,
          contactName: widget.contactName,
          contactImage: widget.contactImage,
          file: finalFileImage!,
          messageType: messageType,
          groupId: widget.groupId,
          onSuccess: () {
            finalFileImage = null;
          },
          onError: (error) {
            showSnackBar(context, error);
          });
    }
  }

  //send text message to firestore
  void sendTextMessage() {
    final currentUser = context.read<AuthenticationProvider>().userModel!;
    final chatProvider = context.read<ChatProvider>();

    chatProvider.sendTextMessage(
        sender: currentUser,
        contactUID: widget.contactUID,
        contactName: widget.contactName,
        contactImage: widget.contactImage,
        message: _textEditingController.text,
        messageType: MessageEnum.text,
        groupId: widget.groupId,
        onSuccess: () {
          _textEditingController.clear();
          _focusNode.requestFocus();
        },
        onError: (error) {
          showSnackBar(context, error);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final messageReply = chatProvider.messageReplyModel;
        final isMessageReply = messageReply != null;
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).cardColor,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Column(
                children: [
                  isMessageReply ? MessageReplyPreview() : SizedBox.shrink(),
                  Row(
                    children: [
                      //emoji button
                      IconButton(
                        onPressed: toggleEmojiKeyboardContainer,
                        icon: Icon(isShowEmojiPicker
                            ? Icons.keyboard_alt
                            : Icons.emoji_emotions_outlined),
                      ),
                      chatProvider.isLoading
                          ? const CircularProgressIndicator()
                          : IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 200,
                                      child: Column(
                                        children: [
                                          // select image from camera
                                          ListTile(
                                            leading:
                                                const Icon(Icons.camera_alt),
                                            title: const Text('Camera'),
                                            onTap: () {
                                              selectImage(true);
                                            },
                                          ),
                                          // select image from gallery
                                          ListTile(
                                            leading: const Icon(Icons.image),
                                            title: const Text('Gallery'),
                                            onTap: () {
                                              selectImage(false);
                                            },
                                          ),
                                          // select a video file from device
                                          ListTile(
                                            leading:
                                                const Icon(Icons.video_library),
                                            title: const Text('Video'),
                                            onTap: () {},
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.attachment),
                            ),
                      Expanded(
                        child: TextFormField(
                          controller: _textEditingController,
                          focusNode: _focusNode,
                          decoration: const InputDecoration.collapsed(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Type a message',
                          ),
                          onTap: () {
                            hideEmojiContainer();
                          },
                        ),
                      ),
                      chatProvider.isLoading
                          ? const CircularProgressIndicator()
                          : GestureDetector(
                              onTap:
                                  sendTextMessage, //send text message to firestore
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.deepPurple,
                                ),
                                margin: const EdgeInsets.all(5),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.arrow_upward,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            //show emoji container
            isShowEmojiPicker
                ? SizedBox(
                    height: 280,
                    child: EmojiPicker(
                      onEmojiSelected: (category, Emoji emoji) {
                        _textEditingController.text =
                            _textEditingController.text + emoji.emoji;
                      },
                      onBackspacePressed: () {
                        _textEditingController.text = _textEditingController
                            .text.characters
                            .skipLast(1)
                            .toString();
                      },
                      // config: const Config(
                      //   columns: 7,
                      //   emojiSizeMax: 32.0,
                      //   verticalSpacing: 0,
                      //   horizontalSpacing: 0,
                      //   initCategory: Category.RECENT,
                      //   bgColor: Color(0xFFF2F2F2),
                      //   indicatorColor: Colors.blue,
                      //   iconColor: Colors.grey,
                      //   iconColorSelected: Colors.blue,
                      //   progressIndicatorColor: Colors.blue,
                      //   backspaceColor: Colors.blue,
                      //   showRecentsTab: true,
                      //   recentsLimit: 28,
                      //   noRecentsText: 'No Recents',
                      //   noRecentsStyle: const TextStyle(
                      //       fontSize: 20, color: Colors.black26),
                      //   tabIndicatorAnimDuration: kTabScrollDuration,
                      //   categoryIcons: const CategoryIcons(),
                      //   buttonMode: ButtonMode.MATERIAL,
                      // ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
