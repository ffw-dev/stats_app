import 'package:dev_basic_api/response_models/billing_timed_summary_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final String fromPeriod;

  final List<BillingTimedSummaryItem> filteredBillingTimedSummaryItems;

  const CustomTable({Key? key, required this.filteredBillingTimedSummaryItems, required this.fromPeriod}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: const TableBorder(
          horizontalInside: BorderSide(color: Colors.black26)),
      children: <TableRow>[
        ...buildTableRowsFromFilteredBillingTimedSummaryItems(
            filteredBillingTimedSummaryItems),
        buildTotalFooter(filteredBillingTimedSummaryItems, fromPeriod)
      ],
    );
  }

  TableRow buildTableHeader() {
    return TableRow(
        decoration:
        BoxDecoration(border: Border.all(color: Colors.blueGrey, width: 3)),
        children: [
          buildTableCell('Date'),
          buildTableCell('Finalized time'),
          buildTableCell('Finalized parts'),
          buildTableCell('Exported time'),
          buildTableCell('Exported parts'),
        ]);
  }

  TableRow buildTotalFooter(
      List<BillingTimedSummaryItem> filteredBillingTimedSummaryItems,
      String fromPeriod) {
    var finalizedTotal = 0;
    for (var item in filteredBillingTimedSummaryItems) {
      finalizedTotal += item.finalizeCount;
    }

    var exportedTotal = 0;
    for (var item in filteredBillingTimedSummaryItems) {
      exportedTotal += item.digitizationCount;
    }

    return TableRow(
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            border: Border.all(color: Colors.blueGrey, width: 3)),
        children: [
          buildTableCell('$fromPeriod total', color: Colors.white),
          buildTableCell(''),
          buildTableCell(finalizedTotal.toString(), color: Colors.white),
          buildTableCell(''),
          buildTableCell(exportedTotal.toString(), color: Colors.white),
        ]);
  }

  Column buildTableCell(String value, {Color color = Colors.black}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value, style: TextStyle(fontSize: 11.0, color: color)),
      )
    ]);
  }

  List<TableRow> buildTableRowsFromFilteredBillingTimedSummaryItems(
      List<BillingTimedSummaryItem> items) {
    return items
        .map((e) => TableRow(children: [
      buildTableCell(
          "${DateTime.fromMillisecondsSinceEpoch(e.date).year.toString().substring(2)}/"
              "${DateTime.fromMillisecondsSinceEpoch(e.date).month.toString()}/"
              "${DateTime.fromMillisecondsSinceEpoch(e.date).day.toString()}"),
      buildTableCell(e.finalizeDuration.toString().substring(0, 10)),
      buildTableCell(e.finalizeCount.toString()),
      buildTableCell(e.digitizeDuration.toString().substring(0, 10)),
      buildTableCell(e.digitizationCount.toString()),
    ]))
        .toList();
  }
}
