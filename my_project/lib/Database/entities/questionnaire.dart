import 'package:floor/floor.dart';


@Entity(tableName: 'questionnaire', primaryKeys: ['id','date'])
        //(id + date) will be the primary key of the table.
class Questionnaire {
  //Attributes
  final int id; 
  final String date;
  // String _today_str = DateFormat.yMd().format(_today); this line provides a string like '2023/06/01'
  
  final int question1;
  final int question2;
  final int question3;
  final int total; // I don't know if is possible defing a defoult value...probably with a clever function...

  //Default constructor
  Questionnaire(this.id, this.date, this.question1,this.question2,this.question3,this.total);
  
}//Questionnaire