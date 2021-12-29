import 'package:dev_basic_api/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stats_app/widgets/app_main_bar.dart';
import 'package:stats_app/widgets/summaryOverview/custom_table.dart';
import 'package:stats_app/widgets/summaryOverview/radio_item.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

  bool isPeriodSelected = false;

  DateTime? toPeriod = null;
  DateTime fromPeriod = DateTime.now().subtract(Duration(days: 20000));

  @override
  void initState() {
    super.initState();
    loadBillingSummary();
  }

  void loadBillingSummary() {
    DevBasicApi.productionClientApisBillingSummaryEndpoint
        .authenticateAndGetSummaryFromRange(
            to: toPeriod,
            fromPeriod: fromPeriod,
            baseURL: widget.arguments['baseUrl']!,
            authToken: widget.arguments['authToken']!)
        .then((value) {
      setState(() {
        if(value.body.results.isEmpty) {
          noDataPresent = true;
        } else {
          noDataPresent = false;
        }
        billingTimedSummaryItems = value.body.results;
        loaded = true;
      });
    });
  }

  void showDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (_, __, ___) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SfDateRangePicker(

                onSelectionChanged: (args) {
                  setState(() {
                    fromPeriod = args.value.startDate;
                    toPeriod = args.value.endDate;
                    toPeriod = toPeriod?.add(Duration(days: 1));
                    isPeriodSelected = true;
                    loadBillingSummary();
                  });
                },
                backgroundColor: Colors.white,
                selectionMode: DateRangePickerSelectionMode.range,
                navigationDirection: DateRangePickerNavigationDirection.vertical,
              ),
              TextButton(onPressed: () {Navigator.of(context).pop();}, child: Text('Select'))
            ],
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppMainBarConnector(widget.arguments['collaborator']!),
          body: !loaded
              ? const Center(child: Text('loading'))
              : Stack(
                  children: [
                    Positioned(
                        top: 0,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                            height: 36,
                            decoration: const BoxDecoration(color: Colors.red),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  buildRadioRow(),
                                  TextButton(
                                    onPressed: () {
                                      showDialog();
                                    },
                                    child: const Text(
                                      'From period',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ]))),
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
                          ? Center(child: const Text('no data found'))
                          : RefreshIndicator(
                              onRefresh: () async => loadBillingSummary(),
                              child: buildTablesListView()),
                    ),
                    if (isPeriodSelected)
                      Positioned(
                        top: MediaQuery.of(context).size.height / 1.4,
                          left: MediaQuery.of(context).size.width / 2 - MediaQuery.of(context).size.width % 50,
                          bottom: 0.0,
                          child: TextButton(child: Text('Reset period'),
                        onPressed: () {
                          setState(() {
                            isPeriodSelected = false;
                            loaded = false;
                            toPeriod = null;
                            fromPeriod = DateTime.now().subtract(Duration(days: 20000));
                            loadBillingSummary();
                          });
                        },))
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
        do {
          filtered.add(billingTimedSummaryItems[i++]);
        } while (i <= billingTimedSummaryItems.length - 1 &&
            itemsDate.month ==
                DateTime.fromMillisecondsSinceEpoch(
                        billingTimedSummaryItems[i].date)
                    .month);
      } else if (selectedPeriod == Period.week) {
        var maxDay = DateTime.fromMillisecondsSinceEpoch(
                    billingTimedSummaryItems[i].date)
                .day +
            4;
        var year = DateTime.fromMillisecondsSinceEpoch(
                billingTimedSummaryItems[i].date)
            .year;
        do {
          filtered.add(billingTimedSummaryItems[i++]);
        } while (i <= billingTimedSummaryItems.length - 1 &&
            DateTime.fromMillisecondsSinceEpoch(
                        billingTimedSummaryItems[i].date)
                    .weekday !=
                5 &&
            DateTime.fromMillisecondsSinceEpoch(
                        billingTimedSummaryItems[i].date)
                    .day <=
                maxDay &&
            DateTime.fromMillisecondsSinceEpoch(
                        billingTimedSummaryItems[i].date)
                    .year ==
                year);
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
          value: 'All',
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
