import 'package:saletrackerapp/src/models/product.dart';
import 'package:saletrackerapp/src/models/report.dart';
import 'package:saletrackerapp/src/utils/formatters.dart';

class ProductReport extends Report<Product> {
  late final double totalCost;
  ProductReport({
    required super.startTime,
    required super.endTime,
    required List<Product> products,
  }) : super(
          items: products,
        ) {
    double cost = 0;
    for (final item in products) {
      cost += item.cost;
    }
    totalCost = cost;
  }
}

extension ProductReportFormat on ProductReport {
  String get totalCostStr => formatCurrency(totalCost);
}
