# <strong>Building a Flutter Crypto Trading App: Part 1</strong>

<p align = "center">
<img src= "https://raw.githubusercontent.com/Obikwelu/mediafile/main/blog%20media/banner.jpg" width ="300" height="300"  />

<h2><strong> Introduction</strong></h2>
Flutter enables us to build beautiful apps with great performance. One of the great thing about flutter is that it has cool packages and plugins that can enable us build most features we need in our applications hence eliminating the time needed to create the app from scratch.
In this article, we will be building a flutter trading app using 

<h2><strong> Pre-requisite
</strong></h2>

<p align = "center">
<img src= "https://raw.githubusercontent.com/Obikwelu/mediafile/main/blog%20media/flutter.jpg" width ="300" height="300"  />

In order to follow along with this article, you must have installed flutter and android studio and also setup the necessary environment which will enable you to run your flutter app. Also, you can use any IDE you like but I prefer VS code.

<h2><strong> About the app
</strong></h2>

We are going to build a flutter app to display trading candlesticks in charts which is siimilar to most trading platforms such as Metatrader 4 etc. This app is first in the series of app we will be building. We will be using CoinGecko API to get our real time trading data and using syncfusion to display this data in our flutter app.

COINGECKO
SYNCFUSION

Note: This article is for instructional purpose and will be refactored in later tutorials. No state management package was used for this tutorial.

***
<h2><strong> Building the app
</strong></h2>

<p align = "center">
<img src= "https://raw.githubusercontent.com/Obikwelu/mediafile/main/blog%20media/building.jpg" width ="300" height="300"  />



* I will name the app `cnj_charts`. In your command prompt run

```
flutter create cnj_charts
```

* In the `pubspec.yaml` file add the following packages

```yaml
  http: ^0.13.5
  syncfusion_flutter_charts: ^19.1.54
```

* Checking out the API data, we will observe that it returns a list of list of data i.e a List of data containing list of chart data as seen below.

```json
[
    [
        1667651400000, // time in Epoch milliseconds
        21379.78, // open
        21379.78, // high
        21329.8, // low
        21329.8 // close
    ],
    [
        1667653200000,
        21304.06,
        21328.06,
        21299.17,
        21299.17
    ]
]
```

* Our folder structure is  `models, screens, services, widget`

* In the models folder, we create ```candle.dart```

```dart
class CandleItem {
  final num? time;
  final num? open;
  final num? high;
  final num? low;
  final num? close;

  CandleItem({
    this.time,
    this.open,
    this.high,
    this.low,
    this.close,
  });
  factory CandleItem.fromJson(Map<String, dynamic> json) {
    return CandleItem(
      time: json['time'],
      open: json['open'],
      high: json['high'],
      low: json['low'],
      close: json['close'],
    );
  }
}

var candleList = [];
List<CandleItem> wickList = [];
```
* Create api.dart file in the services folder

we create a function  `fetchData(String cryptocurrency)` with argument cryptocurrency since we will be fetching different coin data from the API. on fetching this, we decode the response and pass the values of the decoded response which is a list to an empty list we created `values`. Then for each values[index], we add it to our candleList. Then create a list of `name` which holds the name of the data we received from our api and finally we use the Map.fromIterables function to map the `name and candlesList` this is the sample data we obtain

```json
{
    "time": "1667651400000",
    "open": "21379.78",
    "high": "21379.78", 
    "low": "21329.8",
    "close": "21329.8"
}
```
Then we add the json data to our wickList.

```dart
import 'dart:convert';
import 'package:cnj_charts/models/candles.dart';
import 'package:http/http.dart' as http;

Future<dynamic> fetchData(String cryptocurrency) async {
  var url =
      "https://api.coingecko.com/api/v3/coins/$cryptocurrency/ohlc?vs_currency=usd&days=1";
  final uri = Uri.parse(url);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    List<dynamic> values = [];
    values = json.decode(response.body);
    if (values.isNotEmpty) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          var map = values[i];
          candleList.add(map);
          List<String> name = ["time", "open", "high", "low", "close"];
          final json = Map<String, dynamic>.fromIterables(
            name,
            map,
          );
          wickList.add(CandleItem.fromJson(json));
        }
      }
      return wickList;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
```
* In our `home.dart` file, we create a scaffold with body is `SfCartesianChart()` widget which returns the chart. Then in the initState, enable trackball behaviour and zoompan behaviour

```dart
void initState() {
    fetchData(cryptocurrency);

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
```
* The values of the series is then passed to the corresponding data from the wick List.

```dart
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
```
* We then define the x and y axis.
```dart
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
```

The complete code for the home screen 

```dart
import 'package:cnj_charts/models/candles.dart';
import 'package:cnj_charts/services/api.dart';
import 'package:cnj_charts/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String cryptocurrency = 'bitcoin';
  late TrackballBehavior _trackballBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    fetchData(cryptocurrency);

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
                    return Container(
                      color: Colors.white,
                      child: SfCartesianChart(
                        enableAxisAnimation: true,
                        plotAreaBorderWidth: 1,
                        zoomPanBehavior: _zoomPanBehavior,
                        title: ChartTitle(
                          text: 'BTC/USD',
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
 
```

* Also, we create our `drawer.dart` file in widget folder called Crypto drawer and which contains four listTiles which we can use to view the chart for each of the cryptocurrencies bitcoin, ethereum, solana and cardano.
```dart
import 'package:cnj_charts/models/candles.dart';
import 'package:cnj_charts/screens/cardano.dart';
import 'package:cnj_charts/screens/ethereum.dart';
import 'package:cnj_charts/screens/home.dart';
import 'package:cnj_charts/screens/solana.dart';
import 'package:flutter/material.dart';

class CryptoDrawer extends StatelessWidget {
  const CryptoDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      backgroundColor: Colors.black,
      child: ListView(
        children: [
          ListTile(
            title: const Text(
              "BITCOIN/USD",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onTap: () {
              wickList = [];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const Home(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              "SOLANA/USD",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onTap: () {
              wickList = [];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const Solana(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              "ETHEREUM/USD",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onTap: () {
              wickList = [];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const Ethereum(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              "CARDANO/USD",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onTap: () {
              wickList = [];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => const Cardano(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```
In the main.dart file add home screen as your home
```dart
import 'package:cnj_charts/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home());
  }
}

```
 In case you want to build an apk for using the app in release mode you have to include internet and network permissions in your AndroidManifest.xml file
 ```xml
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission  android:name="android.permission.ACCESS_NETWORK_STATE"  />
 ```

 Finally, we have our app up and running.

 <p align = "center">
<img src= "https://raw.githubusercontent.com/Obikwelu/mediafile/main/blog%20media/final.gif" width ="300" height="300"  />


*Final note: We can refactor the code to return any coin chart data instead of returning screens of specific coins in the drawer. Also, incorporating a state management package will enable us better manage the state of the app especially if we plan on moving it to production. The Date could be better formatted using the `intl` package*

Download code:
[GitHub Link](https://github.com/codenjobs/Blogs/tree/main/Francis/price_tracker)

[Link to original article at CodenJobs](https://www.codenjobs.com/blog?&title=Building-a-Crypto-Price-Tracker-with-Flutter&id=6b632988-bd80-4052-90b5-7f6015e51ea2)

To know more about codenjobs click [CodenJobs]((https://www.codenjobs.com)

```
Want to Connect?

This article is also published at codenjobs.com .
```