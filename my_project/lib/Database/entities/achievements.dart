import 'package:floor/floor.dart';

@Entity(tableName: 'achievements', primaryKeys: ['id','date'])
        //(id + date) will be the primary key of the table.
class Achievements {
  //Attributes
  final int id; 
  final String date;
  // String _today_str = DateFormat.yMd().format(_today); this line provides a string like '2023/06/01'
  
  final int levelOfSustainability;
  final int trees;

  //Default constructor
  Achievements(this.id, this.date, this.levelOfSustainability,this.trees);
  
}//Achievements