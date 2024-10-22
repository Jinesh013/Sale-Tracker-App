// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:saletrackerapp/src/blocks/repository.dart';
import 'package:saletrackerapp/src/pages/product_report_page.dart';
import 'package:saletrackerapp/src/pages/sale_report_page.dart';
import 'package:saletrackerapp/src/pages/widget/product_form_dialog.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/res/pattern_back.jpg'),
          alignment: Alignment.center,
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              buildHeader(),
              const Divider(),
              const SizedBox(height: 10),
              buildUserAvatar(),
              const SizedBox(height: 5),
              buildUserName(),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 5),
              Builder(builder: buildAddButton),
              const SizedBox(height: 5),
              Builder(builder: buildProductReportButton),
              const SizedBox(height: 5),
              Builder(builder: buildSalesReportButton),
              const Divider(),
              Builder(builder: buildResetButton),
              const Spacer(),
              const Divider(),
              buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return const Text(
      'Sales Tracker',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.deepOrange,
        fontSize: 30,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget buildUserAvatar() {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.photoURL == null) return Container();
    return Container(
      width: 80,
      height: 80,
      alignment: Alignment.center,
      child: ClipOval(
        child: Image.network(
          user!.photoURL!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.displayName == null) return Container();
    return Text(
      user!.displayName!,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.blueGrey,
        fontFamily: 'sans',
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget buildLogoutButton() {
    return ElevatedButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
        GoogleSignIn().signOut();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Row(
          children: [
            Text('Sign Out'),
            Spacer(),
            Icon(Icons.logout),
          ],
        ),
      ),
    );
  }

  Widget buildProductReportButton(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[100],
      title: const Text('Product Report'),
      leading: const Icon(Icons.history),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      onTap: () async {
        await ProductReportPage.display(context);
        Navigator.of(context).pop();
        // ReportPage.display(context);
        // SalesReportPage.display(context);
      },
    );
  }

  Widget buildSalesReportButton(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[100],
      title: const Text('Sales Report'),
      leading: const Icon(Icons.history_edu),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      onTap: () async {
        await SalesReportPage.display(context);
        Navigator.of(context).pop();
        // SalesReportPage.display(context);
      },
    );
  }

  Widget buildAddButton(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[100],
      title: const Text('Add Product'),
      leading: const Icon(Icons.add),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      onTap: () {
        Navigator.of(context).pop();
        ProductFormDialog.display(context);
      },
    );
  }

  Widget buildResetButton(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[100],
      title: const Text('Reset Data'),
      leading: const Icon(Icons.cleaning_services),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      onTap: () {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Reset'),
            content: const Text(
                'Resetting will clear all data you have entered so far!'),
            actions: [
              TextButton(
                child: const Text('Continue'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Repository.of(context).clearAllData();
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}
