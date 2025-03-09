import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jade_talk/providers/authentication_provider.dart';
import 'package:jade_talk/screens/groups_screen.dart';
import 'package:jade_talk/screens/my_chats_screen.dart';
import 'package:jade_talk/screens/people_screen.dart';
import 'package:jade_talk/utilities/constants.dart';
import 'package:jade_talk/utilities/global_methods.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  final List<Widget> pages = const [
    MyChatsScreen(),
    GroupScreen(),
    PeopleScreen(),
  ];

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      // user comes back to the app
      // update user status to online
        context.read<AuthenticationProvider>().updateUserStatus(
          value: true,
        );
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      // app is inactive, paused, detached or hidden
      // update user status to offline
        context.read<AuthenticationProvider>().updateUserStatus(
          value: false,
        );
        break;
      default:
      //handle other states
        break;
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      appBar: AppBar(
        title: title(),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: userImageWidget(
              imageUrl: authProvider.userModel?.image ?? '',
              radius: 20,
              onTap: () {
                //navigate to user profile
                Navigator.pushNamed(
                  context,
                  Constants.profileScreen,
                  arguments: authProvider.userModel!.uid,
                );
              },
            ),
          ),

          // logout button
          TextButton(
            onPressed: () async {
              // logout
              await context
                  .read<AuthenticationProvider>()
                  .logOut()
                  .whenComplete(() {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Constants.loginScreen,
                  (route) => false,
                );
              });
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.globe),
            label: 'People',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          // animate to the page
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
