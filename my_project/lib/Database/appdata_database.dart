//Imports that are necessary 
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

//Dao
import 'daos/achievementsDao.dart';
import 'daos/questionnaireDao.dart';
import 'daos/statisticsDataDao.dart';

// Entity
import 'entities/achievements.dart';
import 'entities/questionnaire.dart';
import 'entities/statisticsData.dart';

 //The generated code will be in database.g.dart
part 'appdata_database.g.dart';

//Here we are saying that this is the first version of the Database and it has just 1 entity, i.e., Todo
@Database(version: 1, entities: [Achievements,Questionnaire,StatisticsData] )
abstract class AppDatabase extends FloorDatabase {
  //All daos
  AchievementsDao get achievementsDao;
  QuestionnaireDao get questionnaireDao;
  StatisticsDao get statisticsDataDao;

}//AppDatabase