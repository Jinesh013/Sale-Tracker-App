import 'package:intl/intl.dart';
import 'package:saletrackerapp/src/models/product.dart';
import 'package:saletrackerapp/src/utils/formatters.dart';

export 'package:saletrackerapp/src/models/items.dart';

class SalesRecord extends Item {
  final String productId;
  final String productName;
  final double unitBuyPrice;
  final double unitSellPrice;

  // Calculate total buying price
  double get buyingPrice => quantity * unitBuyPrice;

  // Calculate total selling price
  double get sellingPrice => quantity * unitSellPrice;

  // Calculate profit
  double get profit => sellingPrice - buyingPrice;

  // Calculate profit per unit
  double get profitPerUnit => quantity > 0 ? profit / quantity : 0;

  // SalesRecord constructor
  SalesRecord({
    required Product product,
    required this.unitSellPrice,
    required super.quantity,
    required super.date,
  })  : productId = product.id!,
        productName = product.name,
        unitBuyPrice = product.unitCost;

  // Create SalesRecord from JSON
  SalesRecord.fromJson(String id, Map<String, dynamic> data)
      : productId = data['product_id'],
        productName = data['product_name'],
        unitBuyPrice = (data['buy_price'] as num).toDouble(),
        unitSellPrice = (data['sell_price'] as num).toDouble(),
        super.fromJson(id, data);

  // Convert SalesRecord to JSON
  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['buy_price'] = unitBuyPrice;
    data['sell_price'] = unitSellPrice;

    return data;
  }
}

extension SalesRecordFormat on SalesRecord {
  String get dateStr => DateFormat.yMMMd().format(date);

  // Format unit buy price as string
  String get unitBuyPriceStr => formatCurrency(unitBuyPrice);

  // Format unit sell price as string
  String get unitSellPriceStr => formatCurrency(unitSellPrice);

  // Format total buying price as string
  String get buyingPriceStr => formatCurrency(buyingPrice);

  // Format total selling price as string
  String get sellingPriceStr => formatCurrency(sellingPrice);

  // Format total profit as string
  String get profitStr => formatCurrency(profit);

  // Format profit per unit as string
  String get profitPerUnitStr => formatCurrency(profitPerUnit);
}
