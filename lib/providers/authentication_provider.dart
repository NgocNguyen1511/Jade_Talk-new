import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jade_talk/models/user_model.dart';
import 'package:jade_talk/services/cloudinary_service.dart';
import 'package:jade_talk/utilities/constants.dart';
import 'package:jade_talk/utilities/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  UserModel? _userModel;
  String? _uid;
  String? _email;
  String? _password;

  bool get isLoading => _isLoading;
  String? get uid => _uid;
  UserModel? get userModel => _userModel;
  String? get email => _email;
  String? get password => _password;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //check authentication state
  Future<bool> checkAuthenticationState() async {
    bool isSignedIn = false;
    await Future.delayed(const Duration(seconds: 2));

    if (_auth.currentUser != null) {
      _uid = _auth.currentUser!.uid;
      notifyListeners();
      isSignedIn = true;
    } else {
      isSignedIn = false;
    }
    return isSignedIn;
  }

  //check if user exists
  Future<bool> checkUserExists() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection(Constants.users).doc(uid).get();
    if (documentSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  //get user data from firestore
  Future<void> getUserDataFromFireStore(BuildContext context) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection(Constants.users).doc(_uid).get();
    _userModel =
        UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    notifyListeners();
  }

  //save user data to shared preferences
  Future<void> saveUserDataToSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        Constants.userModel, jsonEncode(userModel?.toMap()));
  }

  // get data from shared preferences
  Future<void> getUserDataFromSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userModelString =
        sharedPreferences.getString(Constants.userModel) ?? '';
    _userModel = UserModel.fromMap(jsonDecode(userModelString));
    _uid = _userModel!.uid;
    notifyListeners();
  }

  // sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _uid = _auth.currentUser!.uid;
      _email = email;
      _password = password;
      _isLoading = false;
      notifyListeners();
      onSuccess();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      showSnackBar(context, 'Lỗi: $e');
    }
  }

  // sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _uid = _auth.currentUser!.uid;
      _email = email;
      _password = password;
      _isLoading = false;
      notifyListeners();
      onSuccess();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      showSnackBar(context, 'Lỗi: $e');
    }
  }

  // sign out
  Future<void> logOut() async {
    await _auth.signOut();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    notifyListeners();
  }

  //save user data to firestore
  void uploadImageAndSaveUserDataToFirestore({
    required UserModel userModel,
    required File? fileImage,
    required Function onSuccess,
    required Function onFail,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // upload image to cloudinary and get the url
      if (fileImage != null) {
        String? imageUrl = await uploadToCloudinary(fileImage);
        userModel.image = imageUrl!;
      }

      userModel.lastSeen = DateTime.now().millisecondsSinceEpoch.toString();
      userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();

      _userModel = userModel;
      _uid = userModel.uid;

      //save user data to firestore
      await _firestore
          .collection(Constants.users)
          .doc(userModel.uid)
          .set(userModel.toMap());
      _isLoading = false;
      onSuccess();
    } on FirebaseException catch (e) {
      _isLoading = false;
      notifyListeners();
      onFail(e.toString());
    }
  }

  // get user stream
  Stream<DocumentSnapshot> userStream({required String userID}) {
    return _firestore.collection(Constants.users).doc(userID).snapshots();
  }

  // get all users stream
  Stream<QuerySnapshot> getAllUsersStream({required String userID}) {
    return _firestore
        .collection(Constants.users)
        .where(Constants.uid, isNotEqualTo: userID)
        .snapshots();
  }
}
