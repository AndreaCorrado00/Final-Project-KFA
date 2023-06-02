import 'package:my_project/Database/entities/questionnaire.dart';
import 'package:my_project/Database/entities/statisticsData.dart';
import 'package:floor/floor.dart';

@dao
abstract class StatisticsDao {

  @insert
  Future<void> insertData(StatisticsData data);

  @update
  Future<void> updateData(StatisticsData data);

  //Query: daily steps between two dates
  @Query('SELECT dailySteps FROM statisticsData WHERE id = :id AND date = :date BETWEEN start = :startDate AND end = :endDate' )
  Future<List<int>>dateRangeSteps(int id, String date, String startDate, String endDate); 

  //Query: Distance steps between two dates
  @Query('SELECT dailyDistance FROM statisticsData WHERE id = :id AND date = :date BETWEEN start = :startDate AND end = :endDate' )
  Future<List<int>>dateRangeDistance(int id, String date, String startDate, String endDate);

  //Query: ActivityTime steps between two dates
  @Query('SELECT dailyActivityTime FROM statisticsData WHERE id = :id AND date = :date BETWEEN start = :startDate AND end = :endDate' )
  Future<List<int>>dateRangeActivityTime(int id, String date, String startDate, String endDate);

  @delete
  Future<void> deleteRecord(StatisticsData data); // You will pass to the "metod" an object of class StatisticsData

}//StatisticsDao