import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_project/screens/Barplot/bar_data.dart';
import 'package:my_project/utils/constants.dart';

class BarGraph extends StatelessWidget{
  final List dailySteps;
  const BarGraph({super.key, required this.dailySteps});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      mondaySteps: dailySteps[0],
      tuesdaySteps: dailySteps[1],
      wednesdaySteps: dailySteps[2],
      thursdaySteps: dailySteps[3],
      fridaySteps:  dailySteps[4],
      saturdaySteps: dailySteps[5],
      sundaySteps: dailySteps[6],
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 25000,// dovrebbe essere il massimo dei passi del giorno, è possibile?
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getBottomTitles,),),
        ),
        barGroups: myBarData.barData.map((data) => BarChartGroupData(
          x: data.x,
          barRods: [BarChartRodData(
            toY: data.y,
            color: Constants.secondaryColor,
            width: 10,
            borderRadius: BorderRadius.circular(25),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 100,
            ),
          ),
          ],
          ),
          )
          .toList(),
      ),
    );
  }

}

Widget getBottomTitles (double value, TitleMeta meta){
  const style = TextStyle(
    color: Color.fromARGB(255, 1, 76, 4),
    fontWeight: FontWeight.bold,
     fontSize: 14
     );
     Widget text;
     switch(value.toInt()){ // in realtà non abbiamo memoria di giorno ma solo di date...forse sarebbe meglio mettere un altro simbolo...
      case 1:
        text = const Text('°',style: style);
        break;
      case 2:
        text = const Text('°',style: style);
        break;
      case 3:
        text = const Text('°',style: style);
        break;
      case 4:
        text = const Text('°',style: style);
        break;
      case 5:
        text = const Text('°',style: style);
        break;
      case 6:
        text = const Text('°',style: style);
        break;
      case 7:
        text = const Text('°',style: style);
        break;
      default:
        text = const Text('',style: style);
        break;
     } 
    return SideTitleWidget(child: text, axisSide: meta.axisSide);
}