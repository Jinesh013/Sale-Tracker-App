import 'package:flutter/material.dart';
import 'package:saletrackerapp/src/blocks/repository.dart';
import 'package:saletrackerapp/src/models/product.dart';
import 'package:saletrackerapp/src/pages/product_report_page.dart';
import 'package:saletrackerapp/src/pages/sale_report_page.dart';
import 'package:saletrackerapp/src/pages/widget/home_page_drawer.dart';
import 'package:saletrackerapp/src/pages/widget/product_form_dialog.dart';
import 'package:saletrackerapp/src/pages/widget/product_list.dart';

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
        stream: Repository.of(context).allProducts,
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
              return ProductListView(snapshot.requireData);
          }
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Sales Tracker"),
      actions: [
        PopupMenuButton<int>(
          icon: const Icon(Icons.history),
          // label: const Text('Report'),
          // style: ButtonStyle(
          //   elevation: MaterialStateProperty.all(0),
          // ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 1,
              child: Text('Product Report'),
            ),
            const PopupMenuItem(
              value: 2,
              child: Text('Sales Report'),
            ),
          ],
          onSelected: (index) {
            switch (index) {
              case 1:
                ProductReportPage.display(context);
                break;
              case 2:
                SalesReportPage.display(context);
                break;
            }
          },
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
}
