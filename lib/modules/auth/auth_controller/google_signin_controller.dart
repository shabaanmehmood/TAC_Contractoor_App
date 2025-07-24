
// 129556296565-8pri0ang8e1nvon9h98sao1uk8347a2i.apps.googleusercontent.com

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '129556296565-8pri0ang8e1nvon9h98sao1uk8347a2i.apps.googleusercontent.com',
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
      'openid',
    ],
  );

  var isLoggedIn = false.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhoto = ''.obs;
  var userId = ''.obs;
  var idToken = ''.obs;

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        final GoogleSignInAuthentication auth = await account.authentication;

        isLoggedIn.value = true;
        userName.value = account.displayName ?? '';
        userEmail.value = account.email;
        userPhoto.value = account.photoUrl ?? '';
        userId.value = account.id;
        idToken.value = auth.idToken ?? '';

        print('--- Google User Data ---');
        print('Name: ${account.displayName}');
        print('Email: ${account.email}');
        print('Photo URL: ${account.photoUrl}');
        print('ID: ${account.id}');
        print('ID Token: ${auth.idToken}');
        print('Access Token: ${auth.accessToken}');
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    isLoggedIn.value = false;
    userName.value = '';
    userEmail.value = '';
    userPhoto.value = '';
    userId.value = '';
    idToken.value = '';
    print('User signed out.');
  }
}
