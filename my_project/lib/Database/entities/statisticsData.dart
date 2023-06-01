import 'package:floor/floor.dart';

@Entity(tableName: 'statisticsData', primaryKeys: ['id','date'])
        //(id + date) will be the primary key of the table.
class StatisticsData {
  //Attributes
  final int id; 
  final String date;
  // String _today_str = DateFormat.yMd().format(_today); this line provides a string like '2023/06/01'
  
  final int dailySteps;
  final int dailyDistance;
  final int dailyActivityTime;

  //Default constructor
  StatisticsData(this.id, this.date, this.dailySteps,this.dailyDistance,this.dailyActivityTime);
  
}//StatisticsData