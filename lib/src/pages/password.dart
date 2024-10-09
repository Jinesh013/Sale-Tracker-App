import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:saletrackerapp/src/blocks/repository.dart';
import 'package:saletrackerapp/src/pages/widget/error_messege.dart';
import 'package:url_launcher/url_launcher.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});
  @override
  State createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  String? errorMessage;
  final passwordInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff62758d),
      body: Container(
        alignment: Alignment.center,
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildTitleText(),
                const Divider(),
                buildHelpText(),
                const SizedBox(height: 5),
                buildAskForPassword(),
                const Divider(),
                buildPasswordInput(),
                const Divider(),
                buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitleText() {
    return const Text(
      'Enter Password',
      style: TextStyle(fontSize: 20),
    );
  }

  Widget buildHelpText() {
    return Text(
      "A password verification is required to access this app for the first time only."
      "You will not be asked for any password again!",
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 11,
        color: Colors.grey[700],
      ),
    );
  }

  Widget buildPasswordInput() {
    return TextFormField(
      maxLength: 6,
      obscureText: true,
      controller: passwordInput,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      style: const TextStyle(letterSpacing: 10),
      decoration: const InputDecoration(
        labelText: 'Password',
        suffixIcon: Icon(Icons.password),
        labelStyle: TextStyle(letterSpacing: 1),
        border: OutlineInputBorder(),
      ),
      onFieldSubmitted: (text) {
        verifyPassword(context, passwordInput.text);
      },
    );
  }

  Widget buildAskForPassword() {
    return OutlinedButton(
      onPressed: askForPassword,
      child: const Text("But I do not have the password!"),
    );
  }

  Widget buildActions() {
    return Row(
      children: [
        const Spacer(),
        ElevatedButton(
          onPressed: () => FirebaseAuth.instance.signOut(),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
            backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
          ),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () => verifyPassword(context, passwordInput.text),
          icon: const Icon(Icons.verified),
          label: const Text('Verify'),
        ),
      ],
    );
  }

  void verifyPassword(BuildContext context, String password) async {
    try {
      final repository = Repository.of(context);
      await repository.registerAsVerified(password);
    } catch (err) {
      showDialog(
        context: context,
        builder: (context) {
          return ErrorMessage(
            messageText: 'Please enter the correct password',
            errorDetails: err,
            onDismiss: () => Navigator.of(context).pop(),
          );
        },
      );
    }
  }

  void askForPassword() async {
    User user = FirebaseAuth.instance.currentUser!;
    final mailtoLink = Mailto(
      to: ['dipu.sudipta@gmail.com'],
      cc: [user.email!],
      subject: 'Password for Sales Tracker',
      body: [
        'Hi,',
        '<br><br>',
        'Please send me the password for your Sales Tracker app!',
        '<br><br>',
        'My email is: <b>${user.email!}</b>',
        '<br><br>',
        'Thanks,',
        '<br>',
        '${user.displayName}',
      ].join('\n'),
    );
    await launch('$mailtoLink');
  }
}
