import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jade_talk/models/user_model.dart';
import 'package:jade_talk/providers/authentication_provider.dart';
import 'package:jade_talk/utilities/constants.dart';
import 'package:jade_talk/utilities/global_methods.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatAppBar extends StatefulWidget {
  const ChatAppBar({super.key, required this.contactUID});

  final String contactUID;

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context
          .read<AuthenticationProvider>()
          .userStream(userID: widget.contactUID),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final userModel =
            UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

        DateTime lastSeen =
            DateTime.fromMillisecondsSinceEpoch(int.parse(userModel.lastSeen));
        return Row(
          children: [
            userImageWidget(
                imageUrl: userModel.image,
                radius: 20,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Constants.profileScreen,
                    arguments: userModel.uid,
                  );
                }),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel.name,
                ),
                Text(
                  userModel.isOnline
                      ? 'Online'
                      : 'Last seen ${timeago.format(lastSeen)}',
                  style: TextStyle(
                      fontSize: 14,
                      color: userModel.isOnline
                          ? Colors.green
                          : Colors.grey.shade600),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
