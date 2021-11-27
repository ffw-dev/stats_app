import 'package:dev_basic_api/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<BillingTimedSummaryItem> billingTimedSummaryItem;
  bool loaded = false;
  bool noDataPresent = false;

  @override
  void initState() {
    super.initState();
    DevBasicApi.billingTimedEventEndpoints.getSummary(20000).then((value) {
      setState(() {
        billingTimedSummaryItem = value.body.results;
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('ffw statistics'),
          ),
          body: !loaded
              ? const Text('loading')
              : Center(
                  child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    buildRadioRow(),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: noDataPresent
                          ? const Text('no data found')
                          : Table(
                              border: TableBorder.symmetric(
                                  inside: const BorderSide(color: Colors.grey)),
                              children: [
                                buildTableHeaderRow(),
                                ...buildListOfRows()
                              ],
                            ),
                    ),
                  ]),
                ))),
    );
  }

  List<TableRow> buildListOfRows() {
    var listOfRows = billingTimedSummaryItem
        .map((e) => TableRow(children: [
              buildTableCell(
                  "${DateTime.fromMillisecondsSinceEpoch(e.date).year.toString()}/"
                  "${DateTime.fromMillisecondsSinceEpoch(e.date).month.toString()}/"
                  "${DateTime.fromMillisecondsSinceEpoch(e.date).day.toString()}"),
              buildTableCell(e.finalizeDuration),
              buildTableCell(e.finalizeCount.toString()),
              buildTableCell(e.digitizeDuration.toString()),
              buildTableCell(e.digitizationCount.toString()),
            ]))
        .toList();

    int weekRowsInserted = 0;
    for (var i = 0; i < billingTimedSummaryItem.length;) {
      int currentMonth =
          DateTime.fromMillisecondsSinceEpoch(billingTimedSummaryItem[i].date)
              .month;
      int monthFinalizedTotal = 0;
      int monthExportedTotal = 0;

      while (i <= billingTimedSummaryItem.length - 1 &&
          DateTime.fromMillisecondsSinceEpoch(billingTimedSummaryItem[i].date)
                  .month ==
              currentMonth) {
        monthFinalizedTotal += billingTimedSummaryItem[i].finalizeCount;
        monthExportedTotal += billingTimedSummaryItem[i++].exportCount;
      }

      listOfRows.insert(
          weekRowsInserted++ + i,
          buildMonthTotal(monthFinalizedTotal, monthExportedTotal,
              DateTime.fromMillisecondsSinceEpoch(0)));

      monthFinalizedTotal = 0;
      monthExportedTotal = 0;
    }

    return listOfRows;
  }

  TableRow buildMonthTotal(int monthFinalizedTotal, int monthExportedTotal,
      DateTime finalizedTotal) {
    return TableRow(
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            border: Border.all(color: Colors.blueGrey, width: 3)),
        children: [
          buildTableCell('Month total', color: Colors.white),
          buildTableCell(''),
          buildTableCell(monthFinalizedTotal.toString(), color: Colors.white),
          buildTableCell(''),
          buildTableCell(monthExportedTotal.toString(), color: Colors.white),
        ]);
  }

  TableRow buildTableHeaderRow() {
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

  Column buildTableCell(String value, {Color color = Colors.black}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value, style: TextStyle(fontSize: 15.0, color: color)),
      )
    ]);
  }

  Row buildRadioRow() {
    return Row(
      children: [
        buildRadioItem("week", getSummaryWithPeriod(7)),
        buildRadioItem("month", getSummaryWithPeriod(30)),
        buildRadioItem("all the time", getSummaryWithPeriod(20000)),
      ],
    );
  }

  Row buildRadioItem(String value, void Function(dynamic) onChangedHandler) {
    return Row(
      children: [
        Radio(value: value, groupValue: null, onChanged: onChangedHandler),
        Text(value)
      ],
    );
  }

  void Function(dynamic) getSummaryWithPeriod(int daysOld) {
    return (dynamic) {
      loaded = false;
      DevBasicApi.billingTimedEventEndpoints.getSummary(daysOld).then((value) {
        setState(() {
          if (value.body.totalCount != 0) {
            billingTimedSummaryItem = value.body.results;
            loaded = true;
            noDataPresent = false;
          } else {
            noDataPresent = true;
            loaded = true;
          }
        });
      });
    };
  }
}
