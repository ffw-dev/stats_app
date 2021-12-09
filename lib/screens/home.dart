import 'package:dev_basic_api/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stats_app/widgets/app_main_bar.dart';

class HomeScreen extends StatefulWidget {
  dynamic arguments;

  HomeScreen(this.arguments, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum Period {
  month,
  week,
  all,
}

class _HomeScreenState extends State<HomeScreen> {
  late List<BillingTimedSummaryItem> billingTimedSummaryItems;
  bool loaded = false;
  bool noDataPresent = false;
  Period selectedPeriod = Period.all;

  @override
  void initState() {
    print('adasd');
    print(widget.arguments);
    super.initState();
    DevBasicApi.productionClientApisBillingSummaryEndpoint.authenticateAndGetSummary(widget.arguments['baseUrl']!, widget.arguments['authToken']!).then((value) {
      setState(() {
        billingTimedSummaryItems = value.body.results;
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppMainBar('SVT-0 Overview'),
          body: !loaded
              ? const Text('loading')
              : Center(
                  child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(children: <Widget>[
                        Container(
                            margin: const EdgeInsets.all(2),
                            child: noDataPresent
                                ? const Text('no data found')
                                : buildTablesColumn()),
                      ]),
                    ),
                    Positioned(
                        child: Container(
                            height: 36,
                            decoration: const BoxDecoration(color: Colors.red),
                            child: buildRadioRow())),
                    Positioned(
                        top: 36,
                        height: 36,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.red),
                          child: buildPositionedHeader(),
                        )),
                    Positioned(
                        top: 72,
                        height: 36,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.red),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/selectCollaborators');
                            },
                            child: const Text(
                              'Select collaborator',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ))
                  ],
                ))),
    );
  }

  Row buildPositionedHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        Text(
          'Date',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        Text(
          'Fin. time',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        Text(
          'Fin. parts',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        Text(
          'Exp. time',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        Text(
          'Exp. parts',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
      ],
    );
  }

  Column buildTablesColumn() {
    List<List<BillingTimedSummaryItem>> filteredItemsBySelectedPeriod = [];

    for (int i = 0; i < billingTimedSummaryItems.length;) {
      var item = billingTimedSummaryItems[i];
      var itemsDate = DateTime.fromMillisecondsSinceEpoch(item.date);
      List<BillingTimedSummaryItem> filtered = [];

      if (selectedPeriod == Period.month) {
        while (i < billingTimedSummaryItems.length - 1 &&
            itemsDate.month ==
                DateTime.fromMillisecondsSinceEpoch(
                        billingTimedSummaryItems[i].date)
                    .month) {
          filtered.add(billingTimedSummaryItems[i++]);
        }
        i++;
      } else if (selectedPeriod == Period.week) {
        while (i < billingTimedSummaryItems.length - 1 &&
            itemsDate.weekday % 7 ==
                DateTime.fromMillisecondsSinceEpoch(
                            billingTimedSummaryItems[i].date)
                        .weekday %
                    7) {
          filtered.add(billingTimedSummaryItems[++i]);
        }
        i++;
      } else {
        filteredItemsBySelectedPeriod.add(billingTimedSummaryItems);
        break;
      }

      filteredItemsBySelectedPeriod.add(filtered);
    }

    return Column(
      children: [
        ...filteredItemsBySelectedPeriod
            .map((e) => buildTable(e, valueFromPeriod(selectedPeriod)))
      ],
    );
  }

  Table buildTable(
      List<BillingTimedSummaryItem> filteredBillingTimedSummaryItems,
      String fromPeriod) {
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

  Column buildTableCell(String value, {Color color = Colors.black}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value, style: TextStyle(fontSize: 11.0, color: color)),
      )
    ]);
  }

  Row buildRadioRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildRadioItem("week", (_) => selectPeriod(Period.week)),
        buildRadioItem("month", (_) => selectPeriod(Period.month)),
        buildRadioItem("entire period", (_) => selectPeriod(Period.all)),
      ],
    );
  }

  void selectPeriod(Period period) {
    setState(() {
      selectedPeriod = period;
    });
  }

  Row buildRadioItem(String value, void Function(dynamic) onChangedHandler) {
    return Row(
      children: [
        Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Radio(
              value: value,
              groupValue: null,
              onChanged: onChangedHandler,
              activeColor: Colors.white,
            )),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        )
      ],
    );
  }

  void Function(dynamic) getSummaryWithPeriod(int daysOld) {
    return (dynamic) {
      loaded = false;
      DevBasicApi.billingTimedEventEndpoints.getSummary(daysOld).then((value) {
        setState(() {
          if (value.body.totalCount != 0) {
            billingTimedSummaryItems = value.body.results;
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

  List<BillingTimedSummaryItem> getFilteredItemsFromPeriod(
      int? month, int? week, int year) {
    if (month == null && week == null) {
      throw Exception(
          'in getFilteredItemsFromPeriod() you must specify at least month or week');
    }

    return billingTimedSummaryItems.where((element) {
      var eYear = DateTime.fromMillisecondsSinceEpoch(element.date).year;

      if (month != null &&
          month != DateTime.fromMillisecondsSinceEpoch(element.date).month &&
          eYear != year) {
        return false;
      } else if (week != null &&
          DateTime.fromMillisecondsSinceEpoch(element.date).weekday % 7 !=
              week &&
          eYear != year) {
        return false;
      }

      return true;
    }).toList();
  }

  String valueFromPeriod(Period period) {
    switch (period) {
      case Period.month:
        {
          return "Month";
        }
      case Period.week:
        {
          return "Week";
        }
      case Period.all:
        {
          return "Overall";
        }
    }
  }
}
