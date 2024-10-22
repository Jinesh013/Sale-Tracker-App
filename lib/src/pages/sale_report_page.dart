import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saletrackerapp/src/blocks/repository.dart';
import 'package:saletrackerapp/src/models/sale_report.dart';
import 'package:saletrackerapp/src/pages/widget/abstract_report_page.dart';
import 'package:saletrackerapp/src/pages/widget/sale_report_view.dart';
import 'package:saletrackerapp/src/utils/generate_sale_report.dart';


class SalesReportPage extends AbstractReportPage<SalesReport> {
  static Future<void> display(BuildContext context) {
    return showReportPage(
      context: context,
      saveButtonText: 'Generate Sales Report',
      builder: (start, end) => SalesReportPage(start, end),
    );
  }

  SalesReportPage(DateTime start, DateTime end)
      : super(
          startDate: start,
          endDate: end,
          titleText: 'Sales Report',
          fetchFailureText: 'Could not fetch sales records',
        );
  @override
  Stream<SalesReport> getReportStream(BuildContext context) {
    return Repository.of(context).getSalesReport(startDate, endDate);
  }

  @override
  Widget buildReportView(SalesReport report) {
    return SalesReportView(report);
  }

  @override
  Future<Uint8List> generateReport(SalesReport report) {
    return generateSalesReport(report);
  }

  @override
  String getReportFileName(SalesReport report) {
    final formatter = DateFormat('yyyy-MM-dd');
    final startStr = formatter.format(startDate);
    final endStr = formatter.format(endDate);
    return 'Sales_${startStr}_$endStr.pdf';
  }
}