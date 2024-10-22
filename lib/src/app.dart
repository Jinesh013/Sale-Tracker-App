import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saletrackerapp/src/blocks/global_block.dart';
import 'package:saletrackerapp/src/pages/home_page.dart';
import 'package:saletrackerapp/src/pages/login_page.dart';

class SalesTrackerApp extends StatelessWidget {
  const SalesTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalBloc(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        title: 'Sales Tracker',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.idTokenChanges(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.data == null) {
                  return const LoginPage();
                } else {
                  return const HomePage();
                }
              // return withUserVerification(context);
            }
          },
        ),
      ),
    );
  }

  // Widget withUserVerification(BuildContext context) {
  //   return StreamBuilder<bool?>(
  //     stream: Repository.of(context).userVerified,
  //     builder: (context, snapshot) {
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.none:
  //         case ConnectionState.waiting:
  //           return buildLoading();
  //         case ConnectionState.active:
  //         case ConnectionState.done:
  //           if (snapshot.hasError) {
  //             FirebaseAuth.instance.signOut();
  //           }
  //           if (snapshot.data == true) {
  //             return const HomePage();
  //           }
  //           return const LoginPage();
  //       }
  //     },
  //   );
  // }

  // Widget buildLoading() {
  //   return const Scaffold(
  //     body: Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );
  // }
}
