import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class GroupChatAppBar extends StatefulWidget {
//   const GroupChatAppBar({super.key, required this.groupId});

//   final String groupId;
//   @override
//   State<GroupChatAppBar> createState() => _GroupChatAppBarState();
// }

// class _GroupChatAppBarState extends State<GroupChatAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: context
//           .read<AuthenticationProvider>()
//           .userStream(userID: widget.groupId),
//       builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: Text('Something went wrong'));
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         final groupModel =
//             GroupModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
//         return Row(
//           children: [
//             GestureDetector(
//               child: CircleAvatar(
//                 backgroundImage: NetworkImage(groupModel.groupImage),
//               ),
//               onTap: () {
//                 // navigate to group setting sccreen
                
//               },
//             ),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(groupModel.groupName),
//                 Text(
//                   // userModel.isOnline
//                   // ? 'Online'
//                   // : 'Last seen ${GlobalMethods.formatTimestamp(userModel.lastSeen)}',
//                   'Group description or group members',
//                   style: const TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
