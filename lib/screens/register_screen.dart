
import 'package:flutter/material.dart';
import 'package:jade_talk/providers/authentication_provider.dart';
import 'package:jade_talk/utilities/constants.dart';
import 'package:jade_talk/utilities/global_methods.dart';
import 'package:jade_talk/widgets/app_bar_back_button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  void navigate() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Constants.userInformationScreen,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Register your account',
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
              onPressed: () => authProvider.signUp(
                email: authProvider.emailController.text,
                password: authProvider.passwordController.text,
                context: context,
                onSuccess: navigate,
              ),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
