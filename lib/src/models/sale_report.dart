import 'package:saletrackerapp/src/models/report.dart';
import 'package:saletrackerapp/src/models/sale.dart';
import 'package:saletrackerapp/src/utils/formatters.dart';
export 'package:saletrackerapp/src/models/items.dart';

class SalesReport extends Report<SalesRecord> {
  late final double totalCost;
  late final double totalPrice;
  double get profit => totalPrice - totalCost;
  SalesReport({
    required DateTime startTime,
    required DateTime endTime,
    required List<SalesRecord> sales,
  }) : super(
          startTime: startTime,
          endTime: endTime,
          items: sales,
        ) {
    double cost = 0;
    double price = 0;
    for (final record in sales) {
      cost += record.buyingPrice;
      price += record.sellingPrice;
    }
    totalCost = cost;
    totalPrice = price;
  }
}

extension SalesReportFormat on SalesReport {
  String get totalPriceStr => formatCurrency(totalPrice);
  String get totalCostStr => formatCurrency(totalCost);
  String get profitStr => formatCurrency(profit);
}
