import 'dart:async';

import 'package:cnj_charts/models/candles.dart';
import 'package:cnj_charts/services/api.dart';
import 'package:cnj_charts/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Cardano extends StatefulWidget {
  const Cardano({Key? key}) : super(key: key);

  @override
  State<Cardano> createState() => _CardanoState();
}

class _CardanoState extends State<Cardano> {
  String cryptocurrency = 'cardano';
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    fetchData(cryptocurrency);
    // setState(() {
    //   fetchData();
    //   //wickList;
    // });

    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.doubleTap,
    );
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      enableSelectionZooming: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CryptoDrawer(),
        appBar: AppBar(
          //leading: const Icon(Icons.monetization_on_outlined),
          centerTitle: true,
          title: const Text('CodenJobs charts'),
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder(
            future: fetchData(cryptocurrency),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                default:
                  if (snapshot.hasData) {
                    // var chart = [];
                    // chart.add(snapshot.data!);
                    return Container(
                      color: Colors.white,
                      child: SfCartesianChart(
                        //  margin: const EdgeInsets.symmetric(horizontal: 20),
                        enableAxisAnimation: true,
                        plotAreaBorderWidth: 1,
                        zoomPanBehavior: _zoomPanBehavior,
                        title: ChartTitle(
                          text: 'CARDANO/USD',
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trackballBehavior: _trackballBehavior,
                        series: <CandleSeries>[
                          CandleSeries<CandleItem, DateTime>(
                            dataSource: wickList,
                            xValueMapper: (CandleItem wick, _) {
                              int x = int.parse(wick.time.toString());
                              DateTime time =
                                  DateTime.fromMillisecondsSinceEpoch(x);
                              return time;
                            },
                            lowValueMapper: (CandleItem wick, _) => wick.low,
                            highValueMapper: (CandleItem wick, _) => wick.high,
                            openValueMapper: (CandleItem wick, _) => wick.open,
                            closeValueMapper: (CandleItem wick, _) =>
                                wick.close,
                          )
                        ],
                        primaryXAxis: DateTimeAxis(
                            visibleMinimum: DateTime.fromMillisecondsSinceEpoch(
                                int.parse(wickList[0].time.toString())),
                            visibleMaximum: DateTime.fromMillisecondsSinceEpoch(
                                int.parse(wickList[wickList.length - 1]
                                    .time
                                    .toString())),
                            intervalType: DateTimeIntervalType.auto,
                            minorGridLines: const MinorGridLines(width: 0),

                            // dateFormat: DateFormat.MMM(),
                            majorGridLines: const MajorGridLines(width: 0.5),
                            edgeLabelPlacement: EdgeLabelPlacement.shift),
                        primaryYAxis: NumericAxis(
                          opposedPosition: true,
                          majorGridLines: const MajorGridLines(width: 0),
                          enableAutoIntervalOnZooming: true,
                          // interval: 59,
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            snapshot.hasData;
                          });
                        },
                        child: const Text("Oops!!! no internet connection"),
                      ),
                    );
                  }
              }
            }),
      ),
    );
  }
}
