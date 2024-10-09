import 'package:flutter/material.dart';
import 'package:saletrackerapp/src/models/product.dart';
import 'package:saletrackerapp/src/models/sale.dart';

class SalesPreview extends StatelessWidget {
  final Product product;
  final SalesRecord record;

  const SalesPreview({
    super.key,
    required this.record,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildLabelRow('Date', record.dateStr),
          const SizedBox(height: 5),
          buildLabelRow('Product', record.productName),
          const SizedBox(height: 5),
          buildLabelRow('Product Cost', record.unitBuyPriceStr),
          const SizedBox(height: 5),
          buildLabelRow('Available', '${product.quantity} ps.'),
          const SizedBox(height: 5),
          buildLabelRow('Selling Price', record.unitSellPriceStr),
          const SizedBox(height: 5),
          buildLabelRow('Sell Quantity', '${record.quantity} ps.'),
          const Divider(),
          buildLabelRow('Total Cost', record.buyingPriceStr),
          const SizedBox(height: 5),
          buildLabelRow('Total Price', record.sellingPriceStr),
          const SizedBox(height: 5),
          buildLabelRow('Profit per Unit', record.profitPerUnitStr),
          const Divider(),
          buildLabelRow('Net Profit', record.profitStr),
        ],
      ),
    );
  }

  Widget buildLabelRow(String labelText, String valueText) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            labelText,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey[700],
            ),
          ),
        ),
        const Text(' : '),
        Expanded(
          child: Text(
            valueText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
