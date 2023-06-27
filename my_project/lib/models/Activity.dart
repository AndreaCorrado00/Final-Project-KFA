import 'package:intl/intl.dart';

class Activity{
  final DateTime time;
  final double minutes;

  Activity({required this.time, required this.minutes});
  

  Activity.fromJson(String date, Map<String, dynamic> json) :
      time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
      minutes = json["duration"]+0.0;
  
  double getValue(){
    return minutes;
  }


  @override
  String toString() {
    return 'Activities(Data_time: $time, minutes: $minutes)';
  }//toString
}//Steps

