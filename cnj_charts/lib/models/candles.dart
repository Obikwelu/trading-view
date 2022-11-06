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
