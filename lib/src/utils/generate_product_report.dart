import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:saletrackerapp/src/models/product.dart';
import 'package:saletrackerapp/src/models/product_report.dart';
import 'package:saletrackerapp/src/models/report.dart';

Future<Uint8List> generateProductReport(ProductReport report) async {
  final regularFont = await rootBundle.load('lib/res/RobotoSlab-Regular.ttf');
  final boldFont = await rootBundle.load('lib/res/RobotoSlab-Bold.ttf');
  final pdf = pw.Document(
    compress: true,
    title: 'Product Report',
    subject: 'Sales Tracker',
    producer: 'https://github.com/dipu-bd/sales_tracker',
    theme: pw.ThemeData.withFont(
      base: pw.Font.ttf(regularFont),
      bold: pw.Font.ttf(boldFont),
      italic: pw.Font.ttf(regularFont),
      boldItalic: pw.Font.ttf(boldFont),
    ),
  );
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(50),
      build: (context) {
        return [
          buildHeader(report),
          buildSalesTable(report),
          pw.Divider(
            height: 20,
            thickness: 1,
            color: PdfColors.grey300,
          ),
          buildSummaryItem('Total Products', '${report.items.length} ps.'),
          buildSummaryItem('Total Item Quantity', '${report.totalItems} ps.'),
          pw.Divider(
            height: 20,
            thickness: 1,
            color: PdfColors.grey300,
          ),
          buildSummaryItem('Total Cost', report.totalCostStr),
        ];
      },
      header: (context) {
        return pw.Container();
      },
      footer: (context) {
        return pw.Container(
          alignment: pw.Alignment.center,
          padding: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(
              color: PdfColors.grey600,
            ),
          ),
        );
      },
    ),
  );
  Uint8List data = await pdf.save();
  return data;
}

pw.Widget buildSalesTable(ProductReport report) {
  return pw.Table(
    children: [
      pw.TableRow(
        children: [
          buildHeadCell('Date'),
          buildHeadCell('Item Name'),
          buildHeadCell('Unit Cost'),
          buildHeadCell('Quantity'),
          buildHeadCell('Total Cost'),
        ],
        decoration: const pw.BoxDecoration(
          color: PdfColors.grey200,
        ),
      ),
      ...report.items.map(
        (product) => pw.TableRow(
          children: [
            buildItemCell(product.dateStr),
            buildItemCell(product.name),
            buildItemCell(product.unitCostStr),
            buildItemCell(product.quantityStr),
            buildItemCell(product.costStr),
          ],
        ),
      ),
    ],
  );
}

pw.Widget buildHeader(ProductReport report) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    margin: const pw.EdgeInsets.only(bottom: 20),
    alignment: pw.Alignment.center,
    child: pw.Text(
      'Sales Report (${report.startTimeStr} to ${report.endTimeStr})',
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
        fontSize: 24.0,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );
}

pw.Widget buildHeadCell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(5),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );
}

pw.Widget buildItemCell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(5),
    child: pw.Text(
      text,
    ),
  );
}

pw.Widget buildSummaryItem(String label, String value) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(5),
    alignment: pw.Alignment.centerRight,
    child: pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          label,
          textAlign: pw.TextAlign.right,
        ),
        pw.Container(
          width: 100,
          child: pw.Text(
            value,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
