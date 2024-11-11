import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:saletrackerapp/src/blocks/repository.dart';
import 'package:saletrackerapp/src/models/product.dart';
import 'package:saletrackerapp/src/pages/widget/product_form_dialog.dart';
import 'package:saletrackerapp/src/pages/widget/sale_form_dialog.dart';

class ProductItemTile extends StatelessWidget {
  final Product product;

  const ProductItemTile(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(product.id),
      actionPane: const SlidableBehindActionPane(),
      actionExtentRatio: 0.18,
      actions: <Widget>[
        buildDeleteAction(context),
        buildEditAction(context),
      ],
      secondaryActions: product.quantity > 0
          ? <Widget>[
              buildSaleAction(context),
            ]
          : null,
      child: Material(
        color: Colors.white,
        elevation: 1,
        child: ListTile(
          title: Text(product.name),
          leading: buildQuantity(),
          subtitle: buildSubtitle(),
          trailing: buildPrice(),
          onLongPress: () => _saleProduct(context),
          onTap: () => FocusScope.of(context).unfocus(),
        ),
      ),
    );
  }

  IconSlideAction buildSaleAction(BuildContext context) {
    return IconSlideAction(
      caption: 'Sell',
      color: Colors.teal,
      icon: Icons.add_shopping_cart,
      onTap: () => _saleProduct(context),
    );
  }

  IconSlideAction buildEditAction(BuildContext context) {
    return IconSlideAction(
      caption: 'Update',
      color: Colors.blueAccent,
      icon: Icons.edit,
      onTap: () => ProductFormDialog.display(context, product),
    );
  }

  IconSlideAction buildDeleteAction(BuildContext context) {
    return IconSlideAction(
      caption: 'Delete',
      color: Colors.redAccent,
      icon: Icons.delete,
      onTap: () => _confirmAndDelete(context),
    );
  }

  void _confirmAndDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () {
              Repository.of(context).deleteProduct(product.id);
              Navigator.of(context).pop();
            },
            child: const Text('YES'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:
                const Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _saleProduct(BuildContext context) {
    if (product.quantity > 0) {
      SaleFormDialog.display(context, product);
    }
  }

  CircleAvatar buildQuantity() {
    return CircleAvatar(
      backgroundColor: Colors.grey.shade300,
      child: Text(
        '${product.quantity > 99 ? '99+' : product.quantity}',
        style: const TextStyle(
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Text buildSubtitle() {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Added on '),
          TextSpan(
              text: product.dateStr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget buildPrice() {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 75,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            product.costStr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${product.quantity} × ${product.unitCostStr}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
