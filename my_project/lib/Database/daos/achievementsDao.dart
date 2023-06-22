import 'package:my_project/Database/entities/achievements.dart';
import 'package:floor/floor.dart';

@dao
abstract class AchievementsDao {

  @insert
  Future<void> insertAchievements(Achievements answers);

  @update
  Future<void> updateAchievements(Achievements answers);

  //Query: select all the records of a certain user
  @Query('SELECT * FROM Achievements WHERE id = :id')
  Future<List<Achievements>> userAllSingleAchievemnts(int id);  

  //Query:select the  achievements for a certain user this day
  @Query('SELECT  *  FROM Achievements WHERE id = :id AND date = :date')
  Future<List<Achievements>> dailyAchievement(int id, String date);



  @delete
  Future<void> deleteAchievements(Achievements achievement); // You will pass to the "metod" an object of class Achievements

}//AchievementsDao