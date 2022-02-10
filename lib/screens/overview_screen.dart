import 'package:async_redux/async_redux.dart';
import 'package:dev_basic_api/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stats_app/data/client_setup_item.dart';
import 'package:stats_app/redux/app_state.dart';
import 'package:stats_app/screens/select_collaborators_screen.dart';
import 'package:stats_app/widgets/app_main_bar.dart';
import 'package:stats_app/widgets/summaryOverview/custom_table.dart';
import 'package:stats_app/widgets/summaryOverview/reel_part_headers_row.dart';

class OverviewScreenConnector extends StatelessWidget {
  const OverviewScreenConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, OverviewScreenViewModel>(
    vm: () => OverviewScreenFactory(),
    builder: (BuildContext context, OverviewScreenViewModel vm) {
      return OverviewScreen(filteredClientSetupItem: vm.filteredClientSetupItem, isAllClientsOff: vm.isAllClientSetupItemOff);
    },
  );
}

class OverviewScreenFactory extends VmFactory<AppState, OverviewScreenConnector> {
  @override
  Vm fromStore() =>
      OverviewScreenViewModel(state.preferences.filteredUrlTokenList, state.preferences.filteredUrlTokenList.isEmpty);

}

class OverviewScreenViewModel extends Vm {
  final List<ClientSetupItem> filteredClientSetupItem;
  final bool isAllClientSetupItemOff;

  OverviewScreenViewModel(this.filteredClientSetupItem, this.isAllClientSetupItemOff) : super(equals: [...filteredClientSetupItem, isAllClientSetupItemOff]);
}

class OverviewScreen extends StatefulWidget {
  final List<ClientSetupItem> filteredClientSetupItem;
  final bool isAllClientsOff;

  const OverviewScreen({Key? key, required this.filteredClientSetupItem, required this.isAllClientsOff}) : super(key: key);

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {

  late List<BillingTimedSummaryItem> billingTimedSummaryItems = [];
  bool isDataLoaded = false;
  bool noDataFound = false;
  int overallPeriod = 10;
  var currentLoading = 'Loading...';

  @override
  void didUpdateWidget(covariant OverviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadAllClientsSummary();
  }

  @override
  void initState() {
    super.initState();
    loadAllClientsSummary();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppMainBarConnector('$overallPeriod days overview',),
      body: widget.isAllClientsOff
          ? buildAllMonitoredOffColumn(context)
          : !isDataLoaded
          ? buildCurrentLoading()
          : Stack(
        children: [
          buildSelectCollaborator(context),
          buildReelPartHeadersRow(context),
          buildRefreshIndicatorBillingSummaryTables(context),
        ],
      ),
      floatingActionButton: buildIncrementPeriodButton(),
    );
  }

  void loadAllClientsSummary() async {
    billingTimedSummaryItems = [];
    isDataLoaded = false;

    for (var e in widget.filteredClientSetupItem) {
      await DevBasicApi.productionClientApisBillingSummaryEndpoint
          .authenticateAndGetSummary(
              fromPeriod: DateTime.now().subtract(Duration(days: overallPeriod)), baseURL: e.url, authToken: e.token)
          .then((value) {
        setState(() {
          currentLoading = 'fetching data from: ' +
              e.url.substring(8).split('-basic')[0].toUpperCase();
          billingTimedSummaryItems.addAll(value.body.results);
        });
      });
    }

    billingTimedSummaryItems.sort((a, b) => a.date.compareTo(b.date));
    List<BillingTimedSummaryItem> mergedBillingSummaryItem = [];
    var iterationCounter = 0;

    for (var i = 0; i < overallPeriod; i++) {
      if (iterationCounter >= billingTimedSummaryItems.length) {
        break;
      }
      var item = billingTimedSummaryItems[iterationCounter];
      int y = iterationCounter;

      var tempExpCount = 0;
      String tempExpDuration = '';
      var tempFinCountTotal = 0;
      String tempFinDuration = '';

      while (y < billingTimedSummaryItems.length &&
          item.date == billingTimedSummaryItems[y].date) {
        tempExpCount += billingTimedSummaryItems[y].exportCount;
        tempExpDuration += billingTimedSummaryItems[y].exportDuration;
        tempFinCountTotal += billingTimedSummaryItems[y].finalizeCount;
        tempFinDuration += billingTimedSummaryItems[y].finalizeDuration;
        iterationCounter++;
        y++;
      }

      y++;

      mergedBillingSummaryItem.add(BillingTimedSummaryItem(
          date: item.date,
          digitizationCount: item.digitizationCount,
          intermediateCount: item.intermediateCount,
          finalizeCount: tempFinCountTotal,
          exportCount: tempExpCount,
          digitizeDuration: item.digitizeDuration,
          intermediateDuration: '',
          finalizeDuration: tempFinDuration,
          exportDuration: tempExpDuration,
          fullName: item.fullName));
    }
    setState(() {
      billingTimedSummaryItems = mergedBillingSummaryItem.reversed.toList();
      isDataLoaded = true;
    });
  }

  void incrementOverallPeriod() {
    setState(() {
      isDataLoaded = false;
      overallPeriod += 10;
      if (overallPeriod > 30) {
        overallPeriod = 10;
        loadAllClientsSummary();
      } else {
        loadAllClientsSummary();
      }
    });
  }

  FloatingActionButton buildIncrementPeriodButton() {
    return FloatingActionButton(
        onPressed: () {
          incrementOverallPeriod();
        },
        backgroundColor: Colors.red,
        child: Text(overallPeriod.toString()),
      );
  }

  Positioned buildRefreshIndicatorBillingSummaryTables(BuildContext context) {
    return Positioned(
                      top: 72,
                      left: 0.0,
                      bottom: 0.0,
                      width: MediaQuery.of(context).size.width,
                      child: noDataFound
                          ? const Text('no data found')
                          : RefreshIndicator(
                              onRefresh: () async {
                                loadAllClientsSummary();
                              },
                              child: ListView(
                                children: [
                                  CustomTable(
                                      filteredBillingTimedSummaryItems:
                                          billingTimedSummaryItems,
                                      fromPeriod: 'Overall'),
                                ],
                              ),
                            ),
                    );
  }

  Positioned buildReelPartHeadersRow(BuildContext context) {
    return Positioned(
                        top: 36,
                        height: 36,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.red),
                          child: const ReelPartHeadersRow(),
                        ));
  }

  Positioned buildSelectCollaborator(BuildContext context) {
    return Positioned(
                        top: 0,
                        height: 36,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.red),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(builder: (_) => const SelectCollaborator()));
                            },
                            child: const Text(
                              'Select collaborator',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ));
  }

  Center buildCurrentLoading() {
    return Center(
                  child: Text(
                  currentLoading,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ));
  }

  Column buildAllMonitoredOffColumn(BuildContext context) {
    return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(34),
                  child: Text(
                      'All monitored clients are turned off, please turn on what clients overview you want to see'),
                ),
                TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/preferences').then((value) => setState((){})),
                    child: const Text('go to preferences')),
                TextButton(
                    onPressed: () =>
                        loadAllClientsSummary(),
                    child: const Text('load overview')),
              ],
            );
  }
}
