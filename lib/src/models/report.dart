import 'package:intl/intl.dart';
import 'package:saletrackerapp/src/models/product.dart';
export 'package:saletrackerapp/src/models/items.dart';

class Report<T extends Item> {
  final DateTime startTime;
  final DateTime endTime;
  final List<T> items;
  final Map<DateTime, List<T>> groups = {};
  late final int totalItems;
  Report({
    required this.items,
    required this.endTime,
    required this.startTime,
  }) {
    items.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    int total = 0;
    for (T item in items) {
      total += item.quantity;
      DateTime group = DateTime(
        item.date.year,
        item.date.month,
        item.date.day,
      );
      groups.putIfAbsent(group, () => []);
      groups[group]!.add(item);
    }

    totalItems = total;
  }
}

extension ReportFormat on Report {
  String get startTimeStr => DateFormat.yMMMd().format(startTime);

  String get endTimeStr => DateFormat.yMMMd().format(endTime);
}
