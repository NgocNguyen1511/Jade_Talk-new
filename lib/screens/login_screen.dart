import 'package:flutter/material.dart';
import 'package:jade_talk/providers/authentication_provider.dart';
import 'package:jade_talk/screens/register_screen.dart';
import 'package:jade_talk/utilities/constants.dart';
import 'package:jade_talk/utilities/global_methods.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Login your account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            entryField('email', authProvider.emailController),
            const SizedBox(height: 20),
            entryField('password', authProvider.passwordController),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => signInToApp(
                email: authProvider.emailController.text,
                password: authProvider.passwordController.text,
              ),
              child: const Text('Sign In'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Dont have a account?", style: TextStyle(color: Colors.black)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Register instead'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



void signInToApp({
  required String email,
  required String password,
}) async {
  final authProvider = context.read<AuthenticationProvider>();
  authProvider.signIn(
    email: email,
    password: password,
    context: context,
    onSuccess: () async{
      //1. check if user exists in firestore
          bool userExists = await authProvider.checkUserExists();

          if (userExists) {
            //2. if user exists

            //*get user infomation from firestore
            await authProvider.getUserDataFromFireStore(context);
            //save user infomation to provider // shared preferences
            await authProvider.saveUserDataToSharedPreferences();
            // *navigate to home screen
            navigate(userExists: true);
          } else {
            //3. if user doesn't exist, navigate to user infomation screen
            navigate(userExists: false);
          }
    },
  );
}

void navigate({required bool userExists}) {
    if (userExists) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Constants.homeScreen,
        (route) => false,
      );
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Constants.loginScreen,
        (route) => false,
      );
    }
  }

}
