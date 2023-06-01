import 'package:floor/floor.dart';


@Entity(tableName: 'questionnaire', primaryKeys: ['id','date'])
        //(id + date) will be the primary key of the table.
class Questionnaire {
  //Attributes
  final int id; 
  final DateTime date;

  
  final int question1;
  final int question2;
  final int question3;
  final int total; 

  //Default constructor
  Questionnaire(this.id, this.date, this.question1,this.question2,this.question3,this.total);
  
}//Todo