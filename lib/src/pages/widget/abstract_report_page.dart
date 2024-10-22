import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:saletrackerapp/src/models/report.dart';
import 'package:saletrackerapp/src/pages/widget/error_messege.dart';
import 'package:saletrackerapp/src/pages/widget/future_loading.dart';

abstract class AbstractReportPage<T extends Report> extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String titleText;
  final String fetchFailureText;
  const AbstractReportPage({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.titleText,
    required this.fetchFailureText,
  });
  String getReportFileName(T report);
  Stream<T> getReportStream(BuildContext context);
  Widget buildReportView(T report);
  Future<Uint8List> generateReport(T report);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(titleText),
      ),
      body: StreamBuilder<T>(
        stream: getReportStream(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError || snapshot.data == null) {
                return ErrorMessage(
                  messageText: fetchFailureText,
                  errorDetails: snapshot.error,
                  onDismiss: () => Navigator.of(context).pop(),
                );
              }
              return Column(
                children: [
                  Expanded(child: buildReportView(snapshot.data!)),
                  buildSaveAsPdfButton(context, snapshot.data!),
                ],
              );
          }
        },
      ),
    );
  }

  Widget buildSaveAsPdfButton(BuildContext context, T report) {
    if (report.totalItems == 0) {
      return Container();
    }
    return ListTile(
      tileColor: Colors.green,
      title: const Text('Save as PDF'),
      trailing: const Icon(Icons.save_alt),
      onTap: () => _generatePdf(context, report),
    );
  }

  void _generatePdf(BuildContext context, T report) async {
    Uint8List? result = await showFutureLoading(
      context: context,
      future: generateReport(report),
      loadingText: 'Generating PDF...',
      errorText: 'Failed to generate PDF',
    );
    print(result?.lengthInBytes);
    final fileName = getReportFileName(report);
    print(fileName);
    final filePath = await FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(
        data: result,
        fileName: fileName,
        mimeTypesFilter: ['application/pdf'],
      ),
    );
    print(filePath);
  }
}

Future<void> showReportPage({
  required BuildContext context,
  required String saveButtonText,
  required Widget Function(DateTime start, DateTime end) builder,
}) async {
  DateTime now = DateTime.now();
  DateTime startOfMonth = DateTime(now.year, now.month);
  DateTimeRange? range = await showDateRangePicker(
    context: context,
    saveText: saveButtonText,
    firstDate: DateTime(now.year - 10),
    lastDate: DateTime(now.year + 10).subtract(const Duration(microseconds: 1)),
    initialDateRange: DateTimeRange(
      start: startOfMonth,
      end: DateTime.now(),
    ),
  );
  if (range == null) return;
  DateTime start = range.start;
  DateTime end = range.end;
  await Navigator.of(context).push(
    MaterialPageRoute(
      maintainState: true,
      fullscreenDialog: false,
      builder: (context) => builder(
        DateTime(start.year, start.month, start.day),
        DateTime(end.year, end.month, end.day)
            .add(const Duration(days: 1))
            .subtract(const Duration(milliseconds: 1)),
      ),
    ),
  );
}
