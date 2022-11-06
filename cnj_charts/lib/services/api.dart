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
