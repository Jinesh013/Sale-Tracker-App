import 'package:saletrackerapp/src/models/items.dart';
import 'package:saletrackerapp/src/utils/formatters.dart';

export 'package:saletrackerapp/src/models/items.dart';

class Product extends Item {
  late final String name;
  late final double unitCost;

  double get cost => quantity * unitCost;

  Product({
    required this.name,
    required this.unitCost,
    required super.quantity,
    required super.date,
  });
  Product.fromJson(String id, Map<String, dynamic> data)
      : super.fromJson(id, data) {
    name = data.remove('name');
    unitCost = data.remove('unit_price');
  }

  // Map<String, dynamic> toJsonMap() {
  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    // data['id'] = id;
    data['name'] = name;
    data['unit_price'] = unitCost;
    return data;
  }
}

extension ProductFormat on Product {
  String get unitCostStr => formatCurrency(unitCost);

  String get costStr => formatCurrency(cost);
}
