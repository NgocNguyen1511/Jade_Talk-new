import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jade_talk/enums/enums.dart';
import 'package:jade_talk/widgets/friends_list.dart';

class FriendsRequestsScreen extends StatefulWidget {
  const FriendsRequestsScreen({super.key});

  @override
  State<FriendsRequestsScreen> createState() => _FriendsRequestsScreenState();
}

class _FriendsRequestsScreenState extends State<FriendsRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends Requests'),
      ),
      body: Column(
          children: [
            // CupertinoSearchBar
            CupertinoSearchTextField(
              placeholder: 'Search',
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                print(value);
              },
            ), 
            const Expanded(child: FriendsList(viewType: FriendViewType.friendRequests,)),
          ], 
        ),
    );
  }
}