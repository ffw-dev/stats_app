import 'package:dev_basic_api/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:stats_app/main.dart';
import 'package:stats_app/widgets/app_main_bar.dart';
import 'package:stats_app/widgets/summaryOverview/custom_table.dart';
import 'package:stats_app/widgets/summaryOverview/positioned_header_row.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  late List<BillingTimedSummaryItem> billingTimedSummaryItems = [];
  bool loaded = false;
  bool allMonitoredOff = false;
  bool noDataPresent = false;
  int OVERALL_PERIOD = 10;
  var currentLoading = 'Loading...';

  @override
  void initState() {
    super.initState();
    loadAllClientsSummary();
  }

  void loadAllClientsSummary() async {
    billingTimedSummaryItems = [];
    loaded = false;

    if (store.state.preferences.filteredUrlTokenList.isEmpty) {
      setState(() {
        allMonitoredOff = true;
      });
      return;
    } else {
      setState(() {
        allMonitoredOff = false;
      });
    }

    for (var e in store.state.preferences.filteredUrlTokenList) {
      await DevBasicApi.productionClientApisBillingSummaryEndpoint
          .authenticateAndGetSummary(
              fromPeriod: OVERALL_PERIOD, baseURL: e.url, authToken: e.token)
          .then((value) {
        setState(() {
          currentLoading = 'fetching data from: ' +
              e.url.substring(8).split('-basic')[0].toUpperCase();
          billingTimedSummaryItems.addAll(value.body.results);
        });
      });
    }

    setState(() {
      billingTimedSummaryItems.sort((a, b) => a.date.compareTo(b.date));
      List<BillingTimedSummaryItem> mergedBillingSummaryItem = [];
      var iterationCounter = 0;

      for (var i = 0; i < OVERALL_PERIOD; i++) {
        if (iterationCounter >= billingTimedSummaryItems.length) {
          break;
        }
        var item = billingTimedSummaryItems[iterationCounter];
        int y = iterationCounter;

        var tempDigCountTotal = 0;
        String tempDigDuration = '';
        var tempFinCountTotal = 0;
        String tempFinDuration = '';

        while (y < billingTimedSummaryItems.length &&
            item.date == billingTimedSummaryItems[y].date) {
          tempDigCountTotal += billingTimedSummaryItems[y].digitizationCount;
          tempDigDuration += billingTimedSummaryItems[y].digitizeDuration;
          tempFinCountTotal += billingTimedSummaryItems[y].finalizeCount;
          tempFinDuration += billingTimedSummaryItems[y].finalizeDuration;
          iterationCounter++;
          y++;
        }

        y++;

        mergedBillingSummaryItem.add(BillingTimedSummaryItem(
            date: item.date,
            digitizationCount: tempDigCountTotal,
            intermediateCount: item.intermediateCount,
            finalizeCount: tempFinCountTotal,
            exportCount: item.exportCount,
            digitizeDuration: tempDigDuration,
            intermediateDuration: '',
            finalizeDuration: tempFinDuration,
            exportDuration: '',
            fullName: item.fullName));
      }
      billingTimedSummaryItems = mergedBillingSummaryItem.reversed.toList();
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppMainBar('$OVERALL_PERIOD days overview',
            () => Navigator.of(context).popAndPushNamed('/preferences'), () =>
                Navigator.of(context).popAndPushNamed('/overviewScreen')),
        body: allMonitoredOff
            ? Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(34),
                    child: Text(
                        'All monitored clients are turned off, please turn on what clients overview you want to see'),
                  ),
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/preferences'),
                      child: const Text('go to preferences')),
                  TextButton(
                      onPressed: () =>
                          loadAllClientsSummary(),
                      child: const Text('load overview')),
                ],
              )
            : !loaded
                ? Center(
                    child: Text(
                    currentLoading,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ))
                : Stack(
                    children: [
                      Positioned(
                          top: 0,
                          height: 36,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.red),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .popAndPushNamed('/selectCollaborators');
                              },
                              child: const Text(
                                'Select collaborator',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                      Positioned(
                          top: 36,
                          height: 36,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.red),
                            child: const PositionedHeaderRow(),
                          )),
                      Positioned(
                        top: 72,
                        left: 0.0,
                        bottom: 0.0,
                        width: MediaQuery.of(context).size.width,
                        child: noDataPresent
                            ? const Text('no data found')
                            : RefreshIndicator(
                                onRefresh: () async => loadAllClientsSummary(),
                                child: ListView(
                                  children: [
                                    CustomTable(
                                        filteredBillingTimedSummaryItems:
                                            billingTimedSummaryItems,
                                        fromPeriod: 'Overall'),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              loaded = false;
              OVERALL_PERIOD += 10;
              if (OVERALL_PERIOD > 30) {
                OVERALL_PERIOD = 10;
                loadAllClientsSummary();
              } else {
                loadAllClientsSummary();
              }
            });
          },
          backgroundColor: Colors.red,
          child: Text(OVERALL_PERIOD.toString()),
        ),
      ),
    );
  }
}
