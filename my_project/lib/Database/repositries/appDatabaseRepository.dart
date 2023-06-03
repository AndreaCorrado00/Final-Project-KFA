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
Future<List<int>> dateRangeLoS(int id, String date, String startDate, String endDate) async {
  final result = await database.achievementsDao.dateRangeLoS(id, date, startDate, endDate);
  return result;
}
// totalTrees
Future<int?> totalTrees(int id, String date) async {
  final result = await database.achievementsDao.totalTrees(id, date);
  return result;
}
// totalLoS
Future<int?> totalLoS(int id, String date) async {
  final result = await database.achievementsDao.totalLoS(id, date);
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
Future<List<Questionnaire>> dailyTotal(int id, String date)async{
  final result = await database.questionnaireDao.dailyTotal(id, date);
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
Future<List<int>>dateRangeSteps(int id, String date, String startDate, String endDate) async {
  List<int> result = await database.statisticsDataDao.dateRangeSteps(id, date, startDate, endDate);
  return result;
}
//dateRangeDistance
Future<List<int>>dateRangeDistance(int id, String date, String startDate, String endDate) async {
  List<int> result = await database.statisticsDataDao.dateRangeDistance(id, date, startDate, endDate);
  return result;
}
//dateRangeActivityTime
Future<List<int>>dateRangeActivityTime(int id, String date, String startDate, String endDate) async {
  List<int> result = await database.statisticsDataDao.dateRangeActivityTime(id, date, startDate, endDate);
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


 