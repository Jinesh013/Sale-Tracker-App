import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saletrackerapp/src/models/report.dart';
import 'package:saletrackerapp/src/models/sale.dart';

class ReportView extends StatelessWidget {
  final Report report;

  const ReportView(this.report, {super.key});

  @override
  Widget build(BuildContext context) {
    if (report.totalItems == 0) {
      return buildEmptyMessage();
    }
    List<Widget> children = [];
    report.groups.forEach((date, salesList) {
      children.add(buildGroupHeader(date));
      children.add(const Divider());
      salesList.map(buildRecordItem).forEach((child) {
        children.add(child);
        children.add(const SizedBox(height: 10));
      });
      children.add(const SizedBox(height: 10));
    });

    children += [
      const Divider(height: 1),
      const SizedBox(height: 10),
      buildItemRow(
          'Days in Report', '${report.groups.length}', Colors.grey[700]),
      const SizedBox(height: 10),
      buildItemRow('Items Sold', '${report.totalItems}', Colors.grey[700]),
      const SizedBox(height: 10),
      const Divider(height: 1),
      const SizedBox(height: 10),
      buildItemRow('Selling Price', report.totalPriceStr, Colors.blueGrey[700]),
      const SizedBox(height: 10),
      buildItemRow('Production Cost', report.totalCostStr, Colors.grey[700]),
      const SizedBox(height: 10),
      const Divider(height: 1),
      const SizedBox(height: 10),
      buildItemRow('Total Profit', report.profitStr),
    ];

    return ListView(
      padding: const EdgeInsets.only(
        left: 15,
        top: 15.0,
        right: 15.0,
        bottom: 100.0,
      ),
      children: children,
    );
  }

  Widget buildEmptyMessage() {
    return Container(
      padding: const EdgeInsets.all(15),
      alignment: Alignment.center,
      child: const Text(
        'No sales record was found',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildGroupHeader(DateTime date) {
    return Row(
      children: [
        const Icon(
          Icons.calendar_today,
          size: 16,
          color: Colors.blueGrey,
        ),
        const SizedBox(width: 5),
        Text(
          DateFormat.yMMMEd().format(date),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildRecordItem(SalesRecord record) {
    return Row(
      children: [
        Text(
          '${record.quantity}'.padLeft(3, ' '),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            color: Colors.orange[800],
            fontWeight: FontWeight.w600,
          ),
        ),
        const Text(' × '),
        Expanded(
          child: Text(
            '${record.productName} @ ${record.unitSellPriceStr} per unit',
            softWrap: true,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
            ),
          ),
        ),
        const Text(' = '),
        Text(
          record.sellingPriceStr.padRight(10, ' '),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey[800],
          ),
        ),
      ],
    );
  }

  Widget buildItemRow(String label, String value, [Color? valueColor]) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey[800],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black,
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}
