  import 'package:flutter/material.dart';
  import 'package:jade_talk/providers/authentication_provider.dart';
  import 'package:jade_talk/utilities/assets_manager.dart';
  import 'package:jade_talk/utilities/constants.dart';
  import 'package:lottie/lottie.dart';
  import 'package:provider/provider.dart';

  class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
  }

  class _SplashScreenState extends State<SplashScreen> {
    @override
    void initState() {
      checkAuthentication();
      super.initState();
    }

    void checkAuthentication() async {
      final authProvider = context.read<AuthenticationProvider>();
      bool isAuthenticated = await authProvider.checkAuthenticationState();
      if (isAuthenticated) {
        // get user data from firestore
        await authProvider.getUserDataFromFireStore(context);

        // save user data to shared preferences
        await authProvider.saveUserDataToSharedPreferences();
        navigate(isAuthenticated: isAuthenticated);
      } else {
        navigate(isAuthenticated: isAuthenticated);
      }
    }


    navigate({required bool isAuthenticated}) {
      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, Constants.homeScreen);
      } else {
        Navigator.pushReplacementNamed(context, Constants.loginScreen);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            height: 400,
            width: 200,
            child: Column(
              children: [
                Lottie.asset(AssetsManager.chatBubble),
                const LinearProgressIndicator(),
              ],
            ),
          ),
        ),
      );
    }
  }