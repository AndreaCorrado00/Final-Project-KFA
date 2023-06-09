import 'package:my_project/Database/entities/questionnaire.dart';
import 'package:floor/floor.dart';

@dao
abstract class QuestionnaireDao {

  @insert
  Future<void> insertAnswers(Questionnaire answers);

  @update
  Future<void> updateAnswers(Questionnaire answers);

  //Query  select a certain set of answers for a certain user in a certain date
  @Query('SELECT * FROM Questionnaire WHERE id = :id AND date = :date')
  Future<List<Questionnaire>> dailyQuestionaire(int id, String date); 

  @delete
  Future<void> deleteQuestions(Questionnaire answersGiven); // You will pass to the "metod" an object of class Questionnaire

}//QuestionnaireDao