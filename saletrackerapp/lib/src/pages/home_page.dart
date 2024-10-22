import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:saletrackerapp/src/models/product.dart';
import 'package:saletrackerapp/src/blocks/repository.dart';
import 'package:saletrackerapp/src/pages/report_page.dart';
import 'package:saletrackerapp/src/pages/widget/product_items.dart';
import 'package:saletrackerapp/src/pages/widget/product_form_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(),
      backgroundColor: Colors.grey[300],
      appBar: buildAppBar(context),
      floatingActionButton: buildAddItemButton(context),
      body: StreamBuilder<List<Product>>(
        stream: Repository.of(context).nonZeroProducts,
        builder: (context, snapshot) {
          // print(snapshot.connectionState);
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return ErrorWidget.withDetails(
                  message: 'Could not get product list',
                  error: FlutterError("${snapshot.error}"),
                );
              }
              return buildListView(context, snapshot.requireData);
          }
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Sales Tracker"),
      actions: [
        Container(
          height: 26,
          margin: const EdgeInsets.all(10),
          child: ElevatedButton.icon(
            onPressed: () {
              ReportPage.display(context);
            },
            icon: const Icon(Icons.history),
            label: const Text('Report'),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            GoogleSignIn().signOut();
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  FloatingActionButton buildAddItemButton(BuildContext context) {
    return FloatingActionButton(
      // onPressed: () {
      //   // AddProductDialog.display(context);
      //   print('adding new product...');
      //   Repository.of(context).addProduct(
      //     Product(
      //       name: 'Dummy #${(Random.secure().nextInt(1023)).toRadixString(16)}',
      //       date: DateTime.now(),
      //       quantity: Random.secure().nextInt(100),
      //       unitPrice: Random.secure().nextDouble() * 100.0,
      //     ),
      //   );
      // },
      onPressed: () => ProductFormDialog.display(context),
      child: const Icon(Icons.add),
    );
  }

  Widget buildListView(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return Container(
        color: const Color(0xffe0e0e0),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Text(
          'Click on the + button below to add new items',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.separated(
      itemCount: products.length,
      padding: const EdgeInsets.only(bottom: 100, top: 15),
      separatorBuilder: (context, index) => const Divider(height: 5),
      itemBuilder: (context, index) => ProductItemTile(products[index]),
    );
  }
}
