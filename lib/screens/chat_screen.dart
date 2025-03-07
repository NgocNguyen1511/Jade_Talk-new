import 'package:flutter/material.dart';
import 'package:jade_talk/providers/authentication_provider.dart';
import 'package:jade_talk/utilities/constants.dart';
import 'package:jade_talk/widgets/bottom_chat_field.dart';
import 'package:jade_talk/widgets/chat_app_bar.dart';
import 'package:jade_talk/widgets/chat_list.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {

    //get arguments passed from previous screen
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    //get contactUID from the arguments
    final contactUID = arguments[Constants.contactUID];
    //get contactName from the arguments
    final contactName = arguments[Constants.contactName];
    //get contactImage from the arguments
    final contactImage = arguments[Constants.contactImage];
    //get the groupId from the arguments
    final groupId = arguments[Constants.groupId];

    //check if the groupId is emty -then its a chat with a friend else its a group chat
    final isGroupChat = groupId.isNotEmpty ? true : false;

    return Scaffold(
      appBar: AppBar(
        title: ChatAppBar(contactUID: contactUID),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ChatList(contactUID: contactUID, groupId: groupId),
            ),
            BottomChatField(
              contactUID: contactUID,
              contactName: contactName,
              contactImage: contactImage,
              groupId: groupId,
            ),
          ],
        ),
      ),
    );
  }
}
