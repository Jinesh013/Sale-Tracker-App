// // ignore_for_file: void_checks
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_file_dialog/flutter_file_dialog.dart';
// import 'package:saletrackerapp/src/blocks/repository.dart';
// import 'package:saletrackerapp/src/models/report.dart';
// import 'package:saletrackerapp/src/pages/widget/error_messege.dart';
// import 'package:saletrackerapp/src/pages/widget/report_view.dart';


// class ReportPage extends StatelessWidget {
//   static Future<void> display(BuildContext context) async {
//     DateTime now = DateTime.now();
//     DateTime startOfMonth = DateTime(now.year, now.month);

//     DateTimeRange? range = await showDateRangePicker(
//       context: context,
//       saveText: 'Generate Report',
//       firstDate: DateTime(now.year - 10),
//       lastDate:
//           DateTime(now.year + 1).subtract(const Duration(microseconds: 1)),
//       initialDateRange: DateTimeRange(
//         start: startOfMonth,
//         end: DateTime.now(),
//       ),
//     );
//     if (range == null) return;
//     DateTime start = range.start;
//     DateTime end = range.end;
//     await Navigator.of(context).push(
//       MaterialPageRoute(
//         maintainState: true,
//         fullscreenDialog: false,
//         builder: (_) => ReportPage(
//           startDate: DateTime(start.year, start.month, start.day),
//           endDate: DateTime(end.year, end.month, end.day)
//               .add(const Duration(days: 1))
//               .subtract(const Duration(milliseconds: 1)),
//         ),
//       ),
//     );
//   }

//   final DateTime startDate;
//   final DateTime endDate;

//   const ReportPage({
//     required this.startDate,
//     required this.endDate,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       appBar: AppBar(
//         title: const Text('Report'),
//       ),
//       body: buildReportView(context),
//     );
//   }

//   Widget buildReportView(BuildContext context) {
//     return StreamBuilder<Report>(
//       stream: Repository.of(context).getSalesReport(startDate, endDate),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.none:
//           case ConnectionState.waiting:
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           case ConnectionState.active:
//           case ConnectionState.done:
//             if (snapshot.hasError || snapshot.data == null) {
//               return ErrorMessage(
//                 messageText: 'Could not fetch sales records',
//                 errorDetails: snapshot.error,
//                 onDismiss: () => Navigator.of(context).pop(),
//               );
//             }
//             return Column(
//               children: [
//                 Expanded(
//                   child: ReportView(snapshot.data!),
//                 ),
//                 buildSaveAsPdfButton(context, snapshot.data!),
//               ],
//             );
//         }
//       },
//     );
//   }

//   Widget buildSaveAsPdfButton(BuildContext context, Report report) {
//     if (report.totalItems == 0) {
//       return Container();
//     }
//     return ListTile(
//       tileColor: Colors.green,
//       title: const Text('Save as PDF'),
//       trailing: const Icon(Icons.save_alt),
//       onTap: () => _generatePdf(context, report),
//     );
//   }

//   void _generatePdf(BuildContext context, Report report) async {
//     Uint8List? result = await showDialog<Uint8List?>(
//       context: context,
//       builder: (_) => FutureBuilder(
//         future: generateReport(report),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState != ConnectionState.done) {
//             return Center(
//               child: Card(
//                 child: Container(
//                   margin: const EdgeInsets.all(15),
//                   child: const Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CircularProgressIndicator(),
//                       SizedBox(height: 10),
//                       Text('Generating PDF...'),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }
//           if (snapshot.hasError || snapshot.data == null) {
//             return ErrorMessage(
//               messageText: 'Failed to generate PDF',
//               errorDetails: snapshot.error,
//               onDismiss: () => Navigator.of(context).pop(),
//             );
//           }
//           Navigator.of(context).pop(snapshot.data!);
//           return Container();
//         },
//       ),
//     );
//     print(result?.lengthInBytes);
//     if (result == null) return;

//     final fileName =
//         'Report_${report.startTimeMinStr}_${report.endTimeMinStr}.pdf';
//     print(fileName);

//     final filePath = await FlutterFileDialog.saveFile(
//       params: SaveFileDialogParams(
//         data: result,
//         fileName: fileName,
//         mimeTypesFilter: ['application/pdf'],
//       ),
//     );
//     print(filePath);
//   }
// }
