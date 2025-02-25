import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jade_talk/enums/enums.dart';
import 'package:jade_talk/widgets/friends_list.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        centerTitle: true,
        title: const Text('Friends'),
      ), 
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // CupertinoSearchBar
            CupertinoSearchTextField(
              placeholder: 'Search',
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                print(value);
              },
            ), 
            const Expanded(child: FriendsList(viewType: FriendViewType.friends,)),
          ], 
        ), 
      ), 
    );
  }
}
