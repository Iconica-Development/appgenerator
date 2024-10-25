//#pragma: imports
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';



//#pragma: declaration
class HydroBarChart extends StatelessWidget {
  const HydroBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    var dataList = ##SOURCE##;
    return SizedBox(
      width: 500,
      height: 500,
      child: BarChart(BarChartData(
      barGroups: 
      dataList.asMap().entries.map((e) => BarChartGroupData(
        x: e.key,
        barRods: [BarChartRodData(toY: e.value.yValue)],
      )).toList(),
      titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  var label = dataList[value.toInt()].xLabel;
                  return Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          )
    )));
  }
}





//#pragma: execution
HydroBarChart(),