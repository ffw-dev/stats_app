import 'package:dev_basic_api/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stats_app/widgets/app_main_bar.dart';
import 'package:stats_app/widgets/summaryOverview/custom_table.dart';
import 'package:stats_app/widgets/summaryOverview/radio_item.dart';

class CollaboratorOverviewScreen extends StatefulWidget {
  final dynamic arguments;

  const CollaboratorOverviewScreen(this.arguments, {Key? key})
      : super(key: key);

  @override
  State<CollaboratorOverviewScreen> createState() =>
      _CollaboratorOverviewScreenState();
}

enum Period {
  month,
  week,
  all,
}

class _CollaboratorOverviewScreenState
    extends State<CollaboratorOverviewScreen> {
  late List<BillingTimedSummaryItem> billingTimedSummaryItems;
  bool loaded = false;
  bool noDataPresent = false;
  Period selectedPeriod = Period.month;

  @override
  void initState() {
    super.initState();
    loadBillingSummary();
  }

  void loadBillingSummary() {
    DevBasicApi.productionClientApisBillingSummaryEndpoint
        .authenticateAndGetSummary(
            baseURL: widget.arguments['baseUrl']!,
            authToken: widget.arguments['authToken']!)
        .then((value) {
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
          appBar: AppMainBar(
              widget.arguments['collaborator']!,
              () => Navigator.of(context).popAndPushNamed('/preferences'),
              () => Navigator.of(context).popAndPushNamed('/overviewScreen')),
          body: !loaded
              ? const Text('loading')
              : Stack(
                  children: [
                    Positioned(
                        top: 0,
                        width: MediaQuery.of(context).size.width,
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
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/selectCollaborators');
                            },
                            child: const Text(
                              'Select collaborator',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )),
                    Positioned(
                        top: 72,
                        height: 36,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.red),
                          child: buildPositionedHeader(),
                        )),
                    Positioned(
                      top: 108,
                      left: 0.0,
                      bottom: 0.0,
                      width: MediaQuery.of(context).size.width,
                      child: noDataPresent
                          ? const Text('no data found')
                          : RefreshIndicator(
                              onRefresh: () async => loadBillingSummary(),
                              child: buildTablesListView()),
                    ),
                  ],
                )),
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

  ListView buildTablesListView() {
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

    return ListView(
      children: [
        ...filteredItemsBySelectedPeriod.map((e) => CustomTable(
              filteredBillingTimedSummaryItems: e,
              fromPeriod: valueFromPeriod(selectedPeriod),
            ))
      ],
    );
  }

  Row buildRadioRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RadioItem(
          value: 'Week',
          onChangedHandler: (_) {
            setState(() {
              selectedPeriod = Period.week;
            });
          },
        ),
        RadioItem(
          value: 'Month',
          onChangedHandler: (_) {
            setState(() {
              selectedPeriod = Period.month;
            });
          },
        ),
        RadioItem(
          value: 'Entire period',
          onChangedHandler: (_) {
            setState(() {
              selectedPeriod = Period.all;
            });
          },
        ),
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
