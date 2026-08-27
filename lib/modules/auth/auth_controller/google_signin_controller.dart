import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taccontractor/modules/auth/sign_in_view.dart';
import '../../../controllers/user_controller.dart';
import '../../../dataproviders/api_service.dart';
import '../../../models/getUserById_model.dart';
import '../../../models/userdata_model.dart';
import '../../../routes/app_routes.dart';

class GoogleAuthService {
  MyApIService myApIService = MyApIService();

  // ✅ CORRECT: Use Get.find() instead of Get.put() to avoid multiple instances
  SignInViewController get signInViewController =>
      Get.find<SignInViewController>();
  static String get androidClientId {
    // For debug builds (local development)
    if (kDebugMode) {
      return '419940175084-eno0oq3bfrdnr147bgcse032v3p0h0au.apps.googleusercontent.com';
    }
    // For release builds (including Play Store)
    return '419940175084-fq4l4e0mvlopqu3la2b1ldgsc0imgup2.apps.googleusercontent.com';
  }

  // ✅ CORRECT: Simple initialization without complex setup
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
    clientId: androidClientId, // Use the correct client ID for Android
    // ✅ Use your Web Client ID for server authentication
    serverClientId:
        '419940175084-s1nht5ir6gn7nkt5lp08atmpe4pg9vi1.apps.googleusercontent.com',
  );

  Future<void> signInWithGoogle() async {
    try {
      debugPrint("Starting Google sign-in...");

      // ✅ CORRECT: Check if user is signed in and force sign out
      bool isSignedIn = await _googleSignIn.isSignedIn();
      debugPrint("Is user signed in: $isSignedIn");

      if (isSignedIn) {
        debugPrint(
            "User is already signed in. Signing out to show account list...");
        await _googleSignIn.signOut();
        await Future.delayed(const Duration(milliseconds: 500));

        // ✅ OPTIONAL: Also disconnect to clear cached credentials
        try {
          await _googleSignIn.disconnect();
          await Future.delayed(const Duration(milliseconds: 300));
        } catch (e) {
          debugPrint("Disconnect error (normal): $e");
        }
      }

      // ✅ CORRECT METHOD: Use signIn() instead of authenticate()
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      debugPrint("Google user selected: $googleUser");

      if (googleUser == null) {
        Get.snackbar("Sign-In Cancelled", "You cancelled the Google sign-in.");
        return;
      }

      final email = googleUser.email;
      debugPrint("User email: $email");

      // Get authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // ✅ DEBUG: Check both tokens
      debugPrint(
          "ID Token: ${googleAuth.idToken != null ? 'Received' : 'NULL'}");
      debugPrint(
          "Access Token: ${googleAuth.accessToken != null ? 'Received' : 'NULL'}");

      if (googleAuth.idToken == null) {
        Get.snackbar("Error", "No ID token received from Google.");
        return;
      }

      // Get FCM token safely
      final fcmToken = signInViewController.fcmToken;
      if (fcmToken == null) {
        Get.snackbar("Error", "FCM token not available.");
        return;
      }

      debugPrint("Calling API with ID token...");

      // Call your API
      final response =
          await myApIService.googleLogin(googleAuth.idToken!, fcmToken);

      await _handleApiResponse(response, googleUser);
    } catch (error) {
      // ✅ CORRECT: Handle all exceptions properly
      _handleError(error);
    }
  }

  // ✅ NEW: Alternative method that always shows account list
  Future<void> signInWithGoogleForceAccountList() async {
    try {
      debugPrint("Forcing account list display...");

      // Always sign out and disconnect to ensure account list is shown
      await _googleSignIn.signOut();
      await Future.delayed(const Duration(milliseconds: 500));

      try {
        await _googleSignIn.disconnect();
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
        debugPrint("Disconnect may fail if not connected: $e");
      }

      // Now proceed with sign-in
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        Get.snackbar("Cancelled", "Sign-in was cancelled.");
        return;
      }

      // Continue with authentication...
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        Get.snackbar("Error", "No ID token received from Google.");
        return;
      }

      final fcmToken = signInViewController.fcmToken;
      if (fcmToken == null) {
        Get.snackbar("Error", "FCM token not available.");
        return;
      }

      final response =
          await myApIService.googleLogin(googleAuth.idToken!, fcmToken);

      await _handleApiResponse(response, googleUser);
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> _handleApiResponse(
      response, GoogleSignInAccount googleUser) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      final userDataModel = UserDataModel.fromJson(jsonData);

      if (userDataModel.data != null) {
        final userId = userDataModel.data!.id;
        debugPrint('User ID: $userId');

        final getUserResponse = await myApIService.getUserByID(userId!);

        if (getUserResponse.statusCode == 200) {
          final userData =
              GetUserById.fromJson(jsonDecode(getUserResponse.body)).data;

          if (userData != null) {
            Get.find<UserController>().setUser(userData);
            Get.snackbar("Success", "Welcome ${googleUser.displayName}!");
            debugPrint("Data from API: ${response.body}");
            Get.offAndToNamed(AppRoutes.getLandingPageRoute());
          } else {
            Get.snackbar("Error", "User data is null.");
          }
        } else {
          Get.snackbar("Error",
              "Failed to fetch user data. Status: ${getUserResponse.statusCode}");
        }
      } else {
        Get.snackbar("Error", "User data model is null.");
      }
    } else {
      try {
        final errorResponse = jsonDecode(response.body);
        Get.snackbar(
            "Error",
            errorResponse["message"] ??
                "Google login failed. Status: ${response.statusCode}");
      } catch (e) {
        Get.snackbar(
            "Error", "Google login failed. Status: ${response.statusCode}");
      }
    }
  }

  void _handleError(error) {
    debugPrint('Google Sign-In Error: $error');
    final errStr = error.toString().toLowerCase();

    if (errStr.contains('cancel') || errStr.contains('12501')) {
      Get.snackbar("Cancelled", "Sign-in was cancelled.");
    } else if (errStr.contains('network')) {
      Get.snackbar("Network Error", "Please check your internet connection.");
    } else if (errStr.contains('sign_in_failed')) {
      Get.snackbar(
          "Sign-In Failed", "Please check your Google Console configuration.");
    } else {
      Get.snackbar(
          "Error", "An unexpected error occurred: ${error.toString()}");
    }
  }

  // ✅ IMPROVED: Sign out method
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
      debugPrint("User signed out and disconnected from Google");
    } catch (e) {
      debugPrint("Error during sign-out: $e");
    }
  }

  // ✅ NEW: Check current sign-in status properly
  Future<bool> isUserSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  // ✅ NEW: Get current user properly
  Future<GoogleSignInAccount?> getCurrentUser() async {
    if (await _googleSignIn.isSignedIn()) {
      return _googleSignIn.currentUser;
    }
    return null;
  }
}
