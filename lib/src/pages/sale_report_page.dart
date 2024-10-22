import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saletrackerapp/src/blocks/repository.dart';
import 'package:saletrackerapp/src/models/sale_report.dart';
import 'package:saletrackerapp/src/pages/widget/report_page_widget.dart';
import 'package:saletrackerapp/src/pages/widget/sale_report_view.dart';
import 'package:saletrackerapp/src/utils/generate_sale_report.dart';

class SalesReportPage extends StatelessWidget {
  // const SalesReportPage({super.key});

  static Future<void> display(BuildContext context) async {
    final navigator = Navigator.of(context, rootNavigator: true);

    DateTimeRange? range = await selectDateRange(
      context,
      'Generate Sales Report',
    );
    if (range == null) return;
    await navigator.push(
      MaterialPageRoute(
        maintainState: true,
        fullscreenDialog: false,
        builder: (context) => SalesReportPage(range.start, range.end),
      ),
    );
  }

  final DateTime start;
  final DateTime end;

  const SalesReportPage(this.start, this.end, {super.key});

  @override
  Widget build(BuildContext context) {
    return ReportPageWidget<SalesReport>(
      startDate: start,
      endDate: end,
      titleText: 'Sales Report',
      fetchFailureText: 'Could not fetch sales records',
      onGenerateReport: generateSalesReport,
      onGetReportStream: () =>
          Repository.of(context).getSalesReport(start, end),
      reportViewBuilder: (report) => SalesReportView(report),
      onGetReportFileName: (report) {
        final formatter = DateFormat('yyyy-MM-dd');
        final startStr = formatter.format(start);
        final endStr = formatter.format(end);
        return 'Sales_${startStr}_$endStr.pdf';
      },
    );
  }
}
