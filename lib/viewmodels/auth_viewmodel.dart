import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker/models/user_model.dart';

class AuthViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _user;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  // Create a user object based on Firebase User
  UserModel _userFromFirebaseUser(User? user) {
    return UserModel(uid: user!.uid, email: user.email);
  }

  // Check if the user is already logged in
  Future<void> checkAuthStatus() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      _user = _userFromFirebaseUser(firebaseUser);
    } else {
      _user = null;
    }
    // Avoid calling notifyListeners() here if it's not needed
  }

  // Sign in with email and password
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      _user = _userFromFirebaseUser(firebaseUser);
      notifyListeners();
      return _user;
    } catch (error) {
      return null;
    }
  }

  // Register with email and password
  Future signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      _user = _userFromFirebaseUser(firebaseUser);
      notifyListeners();
      return _user;
    } catch (error) {
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (error) {
      return null;
    }
  }
}
