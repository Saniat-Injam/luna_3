import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/web.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/logging/logger.dart';
import 'package:barbell/features/auth/controller/create_account_controller.dart';
import 'package:barbell/features/auth/controller/login_controller.dart';

class FirebaseAuthService {
  // firebase auth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final logger = Logger();

  // get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  // google sign in
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // begin interactive sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        // User cancelled the sign-in process
        logger.e('Google sign-in cancelled by user.');
        return null;
      }

      // get the auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken:
            gAuth.idToken, // Fixed: was using accessToken instead of idToken
      );

      // finally, let's sign in
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      logger.e('Error during Google sign-in: $e');
      return null;
    }
  }

  /// Complete Google Sign-In with integration to LoginController
  Future<bool> signInWithGoogleAndNavigate() async {
    try {
      final UserCredential? userCredential = await signInWithGoogle();

      if (userCredential != null && userCredential.user != null) {
        final user = userCredential.user!;
        logger.i('Google Sign-In successful: ${user.email}');

        if (user.email == null || user.email!.isEmpty) {
          _showEassyLoadingError(
            'Unable to get email from Google account. Please try again.',
          );
          return false;
        }

        // try to login with social login
        final bool socialLoginSuccess = await Get.put(
          LoginController(),
        ).socialAuthentication(email: user.email!, method: "google");

        if (!socialLoginSuccess) {
          logger.i('Social login failed, proceeding to sign up');

          // Ensure name is not null
          final String name = user.displayName ?? "Google User";
          logger.i(
            'Attempting to create account for: ${user.email} with name: $name',
          );

          // Initialize CreateAccountController if not already initialized
          CreateAccountController createAccountController;
          try {
            if (Get.isRegistered<CreateAccountController>()) {
              createAccountController = Get.find<CreateAccountController>();
            } else {
              createAccountController = Get.put(CreateAccountController());
            }

            final String password = DateTime.now().toIso8601String();

            final bool signUpSuccess = await createAccountController
                .onClickSignUp({
                  "email": user.email!,
                  "name": name,
                  "password": password,
                  "confirmPassword": password,
                  "aggriedToTerms": true,
                });

            if (signUpSuccess) {
              logger.i('Google sign-up successful');
              return true;
            } else {
              logger.e('Google sign-up failed');
              _showEassyLoadingError(
                'Failed to create account with Google. Please try again.',
              );
              return false;
            }
          } catch (e) {
            logger.e('Error during Google sign-up: $e');
            _showEassyLoadingError(
              'An error occurred during account creation. Please try again.',
            );
            return false;
          }
        } else {
          await StorageService.saveName(user.displayName ?? "unknown");
          await StorageService.saveImgUrl(user.photoURL ?? "");
          return true;
        }
      } else {
        AppLoggerHelper.error('Google Sign-In failed: No user credential received');
        return false;
      }
    } catch (e) {
      AppLoggerHelper.error('Error in signInWithGoogleAndNavigate', e);
      _showEassyLoadingError(
        'An error occurred during Google sign-in. Please try again.',
      );
      return false;
    }
  }

  /// Sign out from both Firebase and Google
  Future<void> signOutCompletely() async {
    try {
      await _firebaseAuth.signOut();
      await GoogleSignIn().signOut();
      AppLoggerHelper.info('Successfully signed out from Firebase and Google');
    } catch (e) {
      AppLoggerHelper.error('Error during sign out', e);
    }
  }

  /// Helper method to show error messages
  void _showEassyLoadingError(String message) {
    Logger().e('Error: $message');
    EasyLoading.showError(message);
  }
}
