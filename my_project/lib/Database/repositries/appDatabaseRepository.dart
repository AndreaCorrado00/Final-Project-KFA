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
  final resoult = await database.achievementsDao.dateRangeLoS(id, date, startDate, endDate);
  return resoult;
}
// totalTrees
Future<int?> totalTrees(int id, String date) async {
  final resoult = await database.achievementsDao.totalTrees(id, date);
  return resoult;
}
// totalLoS
Future<int?> totalLoS(int id, String date) async {
  final resoult = await database.achievementsDao.totalLoS(id, date);
  return resoult;
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
Future<void> deleteQuestions(Achievements achievements) async {
  await database.achievementsDao.deleteQuestions(achievements);
  notifyListeners();
}

// QUESTIONNAIRE METODS
//dailyTotal
Future<int?> dailyTotal(int id, String date)async{
  int? resoult = await database.questionnaireDao.dailyTotal(id, date);
  return resoult;
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
//updateAnswers
// Future<void> deleteQuestions(Questionnaire answersGiven) async {
//   await database.questionnaireDao.deleteQuestions(answersGiven);
//   notifyListeners();
// }


}


  //The state of the database is just the AppDatabase
  

//   //Default constructor
//   DatabaseRepository({required this.database});

//   //This method wraps the findAllTodos() method of the DAO
//   Future<List<Todo>> findAllTodos() async{
//     final results = await database.todoDao.findAllTodos();
//     return results;
//   }//findAllTodos

//   //This method wraps the insertTodo() method of the DAO. 
//   //Then, it notifies the listeners that something changed.
//   Future<void> insertTodo(Todo todo)async {
//     await database.todoDao.insertTodo(todo);
//     notifyListeners();
//   }//insertTodo

//   //This method wraps the deleteTodo() method of the DAO. 
//   //Then, it notifies the listeners that something changed.
//   Future<void> removeTodo(Todo todo) async{
//     await database.todoDao.deleteTodo(todo);
//     notifyListeners();
//   }//removeTodo
  
// }//DatabaseRepository

 