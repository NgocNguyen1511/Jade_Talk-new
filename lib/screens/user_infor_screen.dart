import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:jade_talk/models/user_model.dart';
import 'package:jade_talk/providers/authentication_provider.dart';
import 'package:jade_talk/services/cloudinary_service.dart';
import 'package:jade_talk/utilities/constants.dart';
import 'package:jade_talk/utilities/global_methods.dart';
import 'package:jade_talk/widgets/app_bar_back_button.dart';
import 'package:jade_talk/widgets/display_user_image.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class UserInforScreen extends StatefulWidget {
  const UserInforScreen({super.key});

  @override
  State<UserInforScreen> createState() => _UserInforScreenState();
}

class _UserInforScreenState extends State<UserInforScreen> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController _nameController = TextEditingController();
  File? finalFileImage;
  String userImage = '';

  @override
  void dispose() {
    _nameController.dispose();
    _btnController.stop();
    super.dispose();
  }

  //select image from camera or gallery
  void selectImage(bool fromCamera) async {
    finalFileImage = await pickImage(
      fromCamera: fromCamera,
      onFail: (String message) {
        showSnackBar(context, message);
      },
    );

    // crop image
    cropImage(finalFileImage!.path);
  }

  Future<void> cropImage(croppedFilePath) async {
  if (croppedFilePath != null) {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: croppedFilePath,
      maxHeight: 800,
      maxWidth: 800,
      compressQuality: 90,
    );

    if (croppedFile != null) {
      setState(() {
        finalFileImage = File(croppedFile.path);
      });
    }
  }
}


  popTheDialog() {
    Navigator.of(context).pop();
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height / 5,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                selectImage(true);
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Gallery'),
              onTap: () {
                selectImage(false);
              },
            ),
          ],
        ),
      ),
    );
  }

  poptheDialog() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text('User Infomation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              DisplayUserImage(
                  finalFileImage: finalFileImage,
                  radius: 60,
                  onPressed: () {
                    showBottomSheet();
                  }),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: RoundedLoadingButton(
                  controller: _btnController,
                  onPressed: () async {
                    if (_nameController.text.isEmpty ||
                        _nameController.text.length < 3) {
                      showSnackBar(context, 'Please enter your name');
                      _btnController.reset();
                      return;
                    }

                    //save user data to firestore
                    saveUserDataToFireStore();
                  },
                  successIcon: Icons.check,
                  successColor: Colors.green,
                  errorColor: Colors.red,
                  color: Theme.of(context).primaryColor,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveUserDataToFireStore() async {
    final authProvider = context.read<AuthenticationProvider>();

    UserModel userModel = UserModel(
      uid: authProvider.uid!,
      name: _nameController.text.trim(),
      email: authProvider.email!,
      password: authProvider.password!,
      image: '',
      token: '',
      aboutMe: 'Hey there, I\'m using Jade Talk',
      lastSeen: '',
      createdAt: '',
      isOnline: true,
      friendsUIDs: [],
      friendRequestsUIDs: [],
      sentFriendRequestsUIDs: [],
    );

    authProvider.uploadImageAndSaveUserDataToFirestore(
      userModel: userModel,
      fileImage: finalFileImage,
      onSuccess: () async {
        _btnController.success();
        // save user data to shared preferences
        await authProvider.saveUserDataToSharedPreferences();

        navigateToHomeScreen();
      },
      onFail: () async {
        _btnController.error();
        showSnackBar(context, 'Failed to save user data');
        await Future.delayed(const Duration(seconds: 1));
        _btnController.reset();
      },
    );
  }

  void navigateToHomeScreen() {
    // navigate to home screen and remove all previous screens
    Navigator.of(context).pushNamedAndRemoveUntil(
      Constants.homeScreen,
      (route) => false,
    );
  }
}
