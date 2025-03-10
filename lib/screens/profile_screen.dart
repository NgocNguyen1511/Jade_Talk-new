import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jade_talk/models/user_model.dart';
import 'package:jade_talk/providers/authentication_provider.dart';
import 'package:jade_talk/utilities/constants.dart';
import 'package:jade_talk/utilities/global_methods.dart';
import 'package:jade_talk/widgets/app_bar_back_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationProvider>().userModel!;

    // get user data from arguments
    final uid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text('Profile'),
        actions: [
          currentUser.uid == uid
              ? // logout button
              IconButton(
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      Constants.settingsScreen,
                      arguments: uid,
                    );
                  },
                  icon: const Icon(Icons.settings),
                )
              : const SizedBox(),
        ],
      ),
      body: StreamBuilder(
        stream: context.read<AuthenticationProvider>().userStream(userID: uid),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userModel =
              UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          return Column(
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    // navigate to user profile with uid as argument
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userModel.image),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      userModel.name, //name of the user
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildFriendRequestButton(
                      currentUser: currentUser,
                      userModel: userModel,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildFriendsButton(
                      currentUser: currentUser,
                      userModel: userModel,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [],
                    ),
                    Text(
                      userModel.aboutMe,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  // friend request button
  Widget buildFriendRequestButton({
    required UserModel currentUser,
    required UserModel userModel,
  }) {
    if (currentUser.uid == userModel.uid &&
        userModel.friendRequestsUIDs.isNotEmpty) {
      return buildElevatedButton(
        onPressed: () {
          // navigate to friend requests screen
          Navigator.pushNamed(context, Constants.friendsRequestsScreen);
        },
        label: 'View Friend Requests',
        width: MediaQuery.of(context).size.width * 0.7,
        backgroundColor: const Color.fromARGB(122, 124, 77, 255),
        textColor: Theme.of(context).colorScheme.primary,
      );
    } else {
      // not in our profile
      return SizedBox.shrink();
    }
  }

// friends button
  Widget buildFriendsButton({
    required UserModel currentUser,
    required UserModel userModel,
  }) {
    if (currentUser.uid == userModel.uid && userModel.friendsUIDs.isNotEmpty) {
      return buildElevatedButton(
        onPressed: () {
          // navigate to friends screen
          Navigator.pushNamed(context, Constants.friendsScreen);
        },
        label: 'View Friends',
        width: MediaQuery.of(context).size.width * 0.7,
        backgroundColor: Colors.deepPurple,
        textColor: Colors.white,
      );
    } else {
      if (currentUser.uid != userModel.uid) {
        // show cancel friend request button

        if (userModel.friendRequestsUIDs.contains(currentUser.uid)) {
          //show friend request button
          return buildElevatedButton(
            onPressed: () async {
              await context
                  .read<AuthenticationProvider>()
                  .cancelFriendRequest(friendID: userModel.uid)
                  .whenComplete(() {
                showSnackBar(context, 'friend request cancelled');
              });
            },
            label: 'Cancel Friend Request',
            width: MediaQuery.of(context).size.width * 0.7,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
          );
        } else if (userModel.sentFriendRequestsUIDs.contains(currentUser.uid)) {
          return buildElevatedButton(
            onPressed: () async {
              await context
                  .read<AuthenticationProvider>()
                  .acceptFriendRequest(friendID: userModel.uid)
                  .whenComplete(() {
                showSnackBar(
                    context, 'You are now friends with ${userModel.name}');
              });
            },
            label: 'Accept Friend Request',
            width: MediaQuery.of(context).size.width * 0.7,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
          );
        } else if (userModel.friendsUIDs.contains(currentUser.uid)) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Unfriend'),
                      content: Text(
                        'Are you sure you want to unfriend ${userModel.name}?',
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // remove friends
                            await context
                                .read<AuthenticationProvider>()
                                .removeFriend(friendID: userModel.uid)
                                .whenComplete(() {
                              if (context.mounted) {
                                Navigator.pop(
                                    context); // only pop if the context is mounted
                                showSnackBar(
                                  context,
                                  'You are no longer friends with ${userModel.name}',
                                );
                              }
                            });
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
                label: 'Unfriend',
                width: MediaQuery.of(context).size.width * 0.4,
                backgroundColor: Colors.deepPurple,
                textColor: Colors.white,
              ),
              buildElevatedButton(
                onPressed: () async {
                  //navigate to chat screen
                  Navigator.pushNamed(context, Constants.chatScreen,
                      arguments: {
                        Constants.contactUID: userModel.uid,
                        Constants.contactName: userModel.name,
                        Constants.contactImage: userModel.image,
                        Constants.groupId: '',
                      });
                },
                label: 'chat',
                width: MediaQuery.of(context).size.width * 0.4,
                backgroundColor: Colors.deepPurple,
                textColor: Colors.white,
              ),
            ],
          );
        } else {
          return buildElevatedButton(
            onPressed: () async {
              await context
                  .read<AuthenticationProvider>()
                  .sendFriendRequest(friendID: userModel.uid)
                  .whenComplete(() {
                showSnackBar(context, 'friend request sent');
              });
            },
            label: 'Send Friend Request',
            width: MediaQuery.of(context).size.width * 0.7,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
          );
        }
      } else {
        return const SizedBox.shrink();
      }
    }
  }

  Widget buildElevatedButton({
    required VoidCallback onPressed,
    required String label,
    required double width,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
