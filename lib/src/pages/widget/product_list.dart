import 'package:flutter/material.dart';
import 'package:saletrackerapp/src/models/product.dart';
import 'package:saletrackerapp/src/pages/widget/product_items.dart';

class ProductListView extends StatefulWidget {
  final List<Product> products;
  const ProductListView(this.products, {super.key});
  @override
  State createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  String filter = '';
  final filterInput = TextEditingController();
  List<Product> get filteredProducts => filter.isEmpty
      ? widget.products
      : widget.products.where((product) {
          return product.name.toLowerCase().contains(filter);
        }).toList();
  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return buildEmptyView();
    }
    List<Product> filteredProducts = filter.isEmpty
        ? widget.products
        : widget.products.where((product) {
            return product.name.toLowerCase().contains(filter);
          }).toList();
    return ListView.separated(
      itemCount: filteredProducts.length + 2,
      padding: const EdgeInsets.only(bottom: 100, top: 0),
      separatorBuilder: (context, index) => Container(height: 5),
      itemBuilder: (context, index) {
        if (index == 0) {
          return buildFilterInput();
        } else if (index <= filteredProducts.length) {
          return ProductItemTile(filteredProducts[index - 1]);
        } else if (index == 1) {
          return buildEmptyFilter();
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildEmptyView() {
    return Container(
      padding: const EdgeInsets.all(15),
      alignment: Alignment.center,
      child: const Text(
        'Click on the + button below to add new items',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget buildEmptyFilter() {
    return Container(
      padding: const EdgeInsets.all(15),
      alignment: Alignment.center,
      child: Text(
        'No items found containing "$filter"',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget buildFilterInput() {
    if (widget.products.length < 7) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: filterInput,
        textInputAction: TextInputAction.search,
        onChanged: (text) {
          filter = text.trim().toLowerCase();
          if (mounted) setState(() {});
        },
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          hintText: 'Filter items',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: SizedBox(
            height: 24,
            child: filter.isEmpty
                ? null
                : IconButton(
                    onPressed: clearFilter,
                    icon: const Icon(Icons.clear),
                  ),
          ),
        ),
      ),
    );
  }

  void clearFilter() {
    filter = '';
    filterInput.clear();
    if (mounted) setState(() {});
    Future.delayed(
      const Duration(milliseconds: 100),
      () => FocusScope.of(context).unfocus(),
    );
  }
}
