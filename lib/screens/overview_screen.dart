import 'package:dev_basic_api/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  bool noDataPresent = false;

  @override
  void initState() {
    super.initState();
    DevBasicApi.productionClientApisBillingSummaryEndpoint
        .authenticateAndGetSummary(
            fromPeriod: 10,
            baseURL: dotenv.env['SVT0BASEURL']!,
            authToken: dotenv.env['SVT0TOKEN']!)
        .then((value) {
          setState(() {
            billingTimedSummaryItems.addAll(value.body.results);
            loaded = true;
          });
        })
        .then((value) => DevBasicApi.productionClientApisBillingSummaryEndpoint
                .authenticateAndGetSummary(
                    fromPeriod: 10,
                    baseURL: dotenv.env['SVT1BASEURL']!,
                    authToken: dotenv.env['SVT1TOKEN']!)
                .then((value) {
              setState(() {
                billingTimedSummaryItems.addAll(value.body.results);
                loaded = true;
              });
            }))
        .then((value) => DevBasicApi.productionClientApisBillingSummaryEndpoint
                .authenticateAndGetSummary(
                    fromPeriod: 10,
                    baseURL: dotenv.env['SVT2BASEURL']!,
                    authToken: dotenv.env['SVT2TOKEN']!)
                .then((value) {
              setState(() {
                billingTimedSummaryItems.addAll(value.body.results);
                loaded = true;
              });
            }))
        .then((value) => DevBasicApi.productionClientApisBillingSummaryEndpoint
                .authenticateAndGetSummary(
                    fromPeriod: 10,
                    baseURL: dotenv.env['YFEBASEURL']!,
                    authToken: dotenv.env['YFETOKEN']!)
                .then((value) {
              setState(() {
                billingTimedSummaryItems.addAll(value.body.results);
                loaded = true;
              });
            }))
        .then((value) => DevBasicApi.productionClientApisBillingSummaryEndpoint
                .authenticateAndGetSummary(
                    fromPeriod: 10,
                    baseURL: dotenv.env['RTE0BASEURL']!,
                    authToken: dotenv.env['RTE0TOKEN']!)
                .then((value) {
              setState(() {
                billingTimedSummaryItems.addAll(value.body.results);
                loaded = true;
              });
            }))
        .then((value) => DevBasicApi.productionClientApisBillingSummaryEndpoint
                .authenticateAndGetSummary(
                    fromPeriod: 10,
                    baseURL: dotenv.env['RTE1BASEURL']!,
                    authToken: dotenv.env['RTE1TOKEN']!)
                .then((value) {
              setState(() {
                billingTimedSummaryItems.addAll(value.body.results);
                loaded = true;
              });
            })).then((value) => DevBasicApi.productionClientApisBillingSummaryEndpoint
        .authenticateAndGetSummary(
        fromPeriod: 10,
        baseURL: dotenv.env['BBCBRISTOLBASEURL']!,
        authToken: dotenv.env['BBCBRISTOLTOKEN']!)
        .then((value) {
      setState(() {
        billingTimedSummaryItems.addAll(value.body.results);
        loaded = true;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppMainBar('10 days overview'),
          body: !loaded
              ? const Text('loading')
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
                                  .pushNamed('/selectCollaborators');
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
                      bottom:0.0,
                      width: MediaQuery.of(context).size.width,
                      child:  noDataPresent
                          ? const Text('no data found')
                          : CustomTable(
                          filteredBillingTimedSummaryItems:
                          billingTimedSummaryItems,
                          fromPeriod: 'Overall'),
                    ),
                  ],
                )),
    );
  }
}
