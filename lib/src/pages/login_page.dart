import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rive/rive.dart';
import 'package:saletrackerapp/src/pages/widget/error_messege.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            child: RiveAnimation.asset(
              'lib/res/portable-table.riv',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: const Color(0xff62758d),
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => signInWithGoogle(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber),
              ),
              child: const ListTile(
                title: Text('SIGN IN'),
                trailing: Icon(Icons.login),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleAuth = await googleUser!.authentication;

      // Create a new credential
      final auth = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(auth);
    } catch (err) {
      showDialog(
        context: context,
        builder: (_) => ErrorMessage(
          messageText: 'Failed to sign in',
          errorDetails: err,
          onDismiss: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      );
    }
  }
}
