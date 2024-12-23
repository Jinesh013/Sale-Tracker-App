import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:saletrackerapp/src/blocks/repository.dart';
import 'package:saletrackerapp/src/models/product.dart';
import 'package:saletrackerapp/src/models/sale.dart';
import 'package:saletrackerapp/src/pages/widget/error_messege.dart';
import 'package:saletrackerapp/src/pages/widget/sale_preview.dart';

class SaleFormDialog extends StatelessWidget {
  static void display(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        maintainState: true,
        fullscreenDialog: true,
        builder: (_) => SaleFormDialog(product),
      ),
    );
  }

  static final _dateFormatter = DateFormat.yMMMEd();

  final Product product;
  late final TextEditingController dateInput;
  late final TextEditingController unitPriceInput;
  late final TextEditingController quantityInput;

  SaleFormDialog(this.product, {super.key}) {
    final now = DateTime.now();
    unitPriceInput = TextEditingController();
    quantityInput = TextEditingController();
    dateInput = TextEditingController(text: _dateFormatter.format(now));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sell Product'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundColor: Colors.black12,
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.teal,
                  size: 48,
                ),
              ),
              const SizedBox(height: 15),
              Builder(builder: buildDateInput),
              Builder(builder: buildUnitPriceInput),
              Builder(builder: buildQuantityInput),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _submitItem(context),
          child: const Icon(Icons.send),
        ),
      ),
    );
  }

  Widget buildDateInput(BuildContext context) {
    final year = DateTime.now().year;
    return TextField(
      controller: dateInput,
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Date',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      inputFormatters: [
        TextInputFormatter.withFunction((old, _) => old),
      ],
      onTap: () {
        showDatePicker(
          context: context,
          fieldLabelText: 'Date',
          firstDate: DateTime(year - 10),
          lastDate: DateTime(year + 1).subtract(const Duration(microseconds: 1)),
          initialDate: DateTime.now(),
        ).then((DateTime? value) {
          if (value != null) {
            dateInput.text = _dateFormatter.format(value);
          }
        });
      },
    );
  }

  Widget buildUnitPriceInput(BuildContext context) {
    return TextField(
      controller: unitPriceInput,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Selling Price Per Unit',
        suffixIcon: const Icon(Icons.attach_money),
        helperText: 'Cost per unit is ${product.unitPriceStr}',
      ),
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
        TextInputFormatter.withFunction(
          (oldVal, newVal) =>
              newVal.text.isEmpty || double.tryParse(newVal.text) != null
                  ? newVal
                  : oldVal,
        ),
      ],
    );
  }

  Widget buildQuantityInput(BuildContext context) {
    return TextField(
      controller: quantityInput,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Item Quantity',
        helperText: '${product.quantity} items available',
      ),
      onEditingComplete: () {
        if (int.parse(quantityInput.text) > product.quantity) {
          quantityInput.text = product.quantity.toString();
        }
        FocusScope.of(context).nextFocus();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
        TextInputFormatter.withFunction(
          (oldVal, newVal) =>
              newVal.text.isEmpty || int.tryParse(newVal.text) != null
                  ? newVal
                  : oldVal,
        ),
      ],
    );
  }

  void _submitItem(BuildContext context) async {
    // data
    DateTime date;
    double? unitPrice = double.tryParse(unitPriceInput.text);
    int? quantity = int.tryParse(quantityInput.text);
    try {
      date = _dateFormatter.parse(dateInput.text);
    } catch (err) {
      return _showError(context, 'Invalid Date');
    }

    // validations
    if (quantity == null || quantity < 0) {
      return _showError(context, 'Invalid Quantity');
    }
    if (quantity > product.quantity) {
      return _showError(context,
          'Insufficient Quantity. Maximum ${product.quantity} available.');
    }
    if (unitPrice == null || unitPrice < 0) {
      return _showError(context, 'Invalid Price');
    }

    // new sales record
    final record = SalesRecord(
      product: product,
      date: date,
      quantity: quantity,
      unitSellPrice: unitPrice,
    );

    _confirmSale(context, record);
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => ErrorMessage(
        messageText: message,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _confirmSale(BuildContext context, SalesRecord record) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.shopping_cart),
            SizedBox(width: 5),
            Text('Please Confirm'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Repository.of(context).addSalesRecord(record);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('ADD'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('CANCEL'),
          ),
        ],
        content: SalesPreview(
          record: record,
          product: product,
        ),
      ),
    );
  }
}
