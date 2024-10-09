import 'package:flutter/material.dart';
import 'package:saletrackerapp/src/blocks/repository.dart';
import 'package:saletrackerapp/src/models/product.dart';
import 'package:saletrackerapp/src/pages/report_page.dart';
import 'package:saletrackerapp/src/pages/widget/home_page_drawer.dart';
import 'package:saletrackerapp/src/pages/widget/product_form_dialog.dart';
import 'package:saletrackerapp/src/pages/widget/product_items.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: buildAppBar(context),
      floatingActionButton: buildAddItemButton(context),
      drawer: const Drawer(
        child: HomePageDrawer(),
      ),
      body: StreamBuilder<List<Product>>(
        stream: Repository.of(context).nonZeroProducts,
        builder: (context, snapshot) {
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
        ElevatedButton.icon(
          onPressed: () => ReportPage.display(context),
          icon: const Icon(Icons.history),
          label: const Text('Report'),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
          ),
        ),
      ],
    );
  }

  FloatingActionButton buildAddItemButton(BuildContext context) {
    return FloatingActionButton(
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
