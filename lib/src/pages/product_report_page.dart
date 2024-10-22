import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saletrackerapp/src/blocks/repository.dart';
import 'package:saletrackerapp/src/models/product_report.dart';
import 'package:saletrackerapp/src/pages/widget/abstract_report_page.dart';
import 'package:saletrackerapp/src/pages/widget/product_report_view.dart';
import 'package:saletrackerapp/src/utils/generate_product_report.dart';

class ProductReportPage extends AbstractReportPage<ProductReport> {
  static Future<void> display(BuildContext context) {
    return showReportPage(
      context: context,
      saveButtonText: 'Generate Product Report',
      builder: (start, end) => ProductReportPage(start, end),
    );
  }

  ProductReportPage(DateTime start, DateTime end)
      : super(
          startDate: start,
          endDate: end,
          titleText: 'Product Report',
          fetchFailureText: 'Could not fetch products',
        );
  @override
  Stream<ProductReport> getReportStream(BuildContext context) {
    return Repository.of(context).getProductReport(startDate, endDate);
  }

  @override
  Widget buildReportView(ProductReport report) {
    return ProductReportView(report);
  }

  @override
  Future<Uint8List> generateReport(ProductReport report) {
    return generateProductReport(report);
  }

  @override
  String getReportFileName(ProductReport report) {
    final formatter = DateFormat('yyyy-MM-dd');
    final startStr = formatter.format(startDate);
    final endStr = formatter.format(endDate);
    return 'Products_${startStr}_$endStr.pdf';
  }
}
