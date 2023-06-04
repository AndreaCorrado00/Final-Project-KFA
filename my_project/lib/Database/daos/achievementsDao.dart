import 'package:my_project/Database/entities/achievements.dart';
import 'package:floor/floor.dart';

@dao
abstract class AchievementsDao {

  @insert
  Future<void> insertAchievements(Achievements answers);

  @update
  Future<void> updateAchievements(Achievements answers);

  //Query: daily level of sustainability between two dates
  @Query('SELECT * FROM Achievements WHERE id = :id AND date = :date BETWEEN start = :startDate AND end = :endDate')
  Future<List<Achievements>> dateRangeLoS(int id, String date, String startDate, String endDate);  

  //Query: totals achievements this day
  @Query('SELECT  *  FROM Achievements WHERE id = :id AND date = :date')
  Future<List<Achievements>> dailyAchievement(int id, String date);

  //Query: sum of the LoS achieved up to now
  @Query('SELECT * FROM Achievements WHERE id = :id AND date = :date ')
  Future<List<Achievements>> rangeAchievements(int id, String date);

  @delete
  Future<void> deleteAchievements(Achievements achievement); // You will pass to the "metod" an object of class Achievements

}//AchievementsDao