import 'package:flutter/material.dart';

import 'package:my_project/Database/entities/achievements.dart';
import 'package:my_project/Database/entities/questionnaire.dart';
import 'package:my_project/Database/entities/statisticsData.dart';

import 'package:my_project/Database/appdata_database.dart';

class DatabaseRepository extends ChangeNotifier{

final AppDatabase database;

//Default constructor
DatabaseRepository({required this.database});

// ACHIEVEMENTS METODS
// dataRangeLoS
Future<List<Achievements>> userAllSingleAchievemnts(int id) async {
  final result = await database.achievementsDao.userAllSingleAchievemnts(id);
  return result;
}
// dailyAchievement
Future<List<Achievements>> dailyAchievement(int id, String date) async {
  final result = await database.achievementsDao.dailyAchievement(id, date);
  return result;
}

// insert 
Future<void> insertAchievements(Achievements achievements) async {
  await database.achievementsDao.insertAchievements(achievements);
  notifyListeners();
}
// update
Future<void> updateAchievements(Achievements achievements) async {
  await database.achievementsDao.updateAchievements(achievements);
  notifyListeners();
}
// delete 
Future<void> deleteAchievements(Achievements achievements) async {
  await database.achievementsDao.deleteAchievements(achievements);
  notifyListeners();
}

// QUESTIONNAIRE METODS
//dailyTotal
Future<List<Questionnaire>> dailyQuestionaire(int id, String date)async{
  final result = await database.questionnaireDao.dailyQuestionaire(id, date);
  return result;
}
//insertAnswers
Future<void> insertAnswers(Questionnaire answers) async {
  await database.questionnaireDao.insertAnswers(answers);
  notifyListeners();
}
//updateAnswers
Future<void> updateAnswers(Questionnaire answers) async {
  await database.questionnaireDao.updateAnswers(answers);
  notifyListeners();
}
//deleteQuestions
Future<void> deleteQuestions(Questionnaire answersGiven) async {
  await database.questionnaireDao.deleteQuestions(answersGiven);
  notifyListeners();
}

// STATISTICS DATA METODS
//dateRangeSteps
Future<List<StatisticsData>>userAllSingleStatisticsData(int id) async {
  List<StatisticsData> result = await database.statisticsDataDao.userAllSingleStatisticsData(id);
  return result;
}

//insert
Future<void> insertData(StatisticsData data) async {
  await database.statisticsDataDao.insertData(data);
  notifyListeners();
}
//udate
Future<void> updateData(StatisticsData data) async {
  await database.statisticsDataDao.updateData(data);
  notifyListeners();
}
//delete
Future<void> deleteRecord(StatisticsData data) async {
  await database.statisticsDataDao.deleteRecord(data);
  notifyListeners();
}


}


 