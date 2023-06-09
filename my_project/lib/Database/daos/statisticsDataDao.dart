import 'package:my_project/Database/entities/questionnaire.dart';
import 'package:my_project/Database/entities/statisticsData.dart';
import 'package:floor/floor.dart';

@dao
abstract class StatisticsDao {

  @insert
  Future<void> insertData(StatisticsData data);

  @update
  Future<void> updateData(StatisticsData data);

  //Query: select all the records of a certain user. The date will be managed into a function
  @Query('SELECT * FROM StatisticsData WHERE id = :id' )
  Future<List<StatisticsData>>userAllSingleStatisticsData(int id); 


  @delete
  Future<void> deleteRecord(StatisticsData data); // You will pass to the "metod" an object of class StatisticsData

}//StatisticsDao