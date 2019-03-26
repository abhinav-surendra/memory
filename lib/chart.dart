import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Chart extends StatelessWidget {
  final int correct;
  final int total;

  const Chart({Key key, this.correct, this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = [
      new Accuracy('Correct', correct, Colors.green),
      new Accuracy('Incorrect', total - correct, Colors.red),
    ];

    final series = [
      new charts.Series(
        id: 'Performance',
        domainFn: (Accuracy accuracy, _) => accuracy.accuracy,
        measureFn: (Accuracy accuracy, _) => accuracy.count,
        colorFn: (Accuracy accuracy, _) => accuracy.color,
        labelAccessorFn: (Accuracy row, _) => '${row.accuracy}: ${row.count}',
        data: data,
      )
    ];
    return charts.PieChart(
      series,
      animate: true,
      // Configure the width of the pie slices to 60px. The remaining space in
      // the chart will be left as a hole in the center.
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 120,
      ),
    );
  }
}

class Accuracy {
  final String accuracy;
  final int count;
  final charts.Color color;

  Accuracy(this.accuracy, this.count, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
