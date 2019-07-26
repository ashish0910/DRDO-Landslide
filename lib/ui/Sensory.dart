/// Line chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SensorY extends StatefulWidget {
  @override
  _SensorYState createState() => _SensorYState();
}
var datasend;
bool done = false ;
var time;
class _SensorYState extends State<SensorY> {
  static var chartsdisplay ;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Future<dynamic> getData() async {
    var response =  await http.get(
      Uri.encodeFull("https://api.thingspeak.com/channels/784367/fields/2"),
      headers: {
        "Accept" : "application/json"
      }
    );
    // debugPrint(response.body);
    Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
    var list;
    time = map["channel"]["updated_at"].split("T");
    debugPrint(time[0]);
    var one = map["feeds"][0]["field2"];
    debugPrint(map["feeds"].length.toString());
    list = [
      LinearState(0, int.parse(one)),
    ];
    for(var i=1 ;i < map["feeds"].length ; i++){
      var x = map["feeds"][i]["field2"];
      if(x!=null){
        var y = int.parse(x);
      if( y>=3){
        _showNotificationWithDefaultSound();
      }
      list.add(LinearState(i,y));
      }
    }
    
    var series = [charts.Series(
        domainFn: (LinearState value, _) => value.time,
        measureFn: (LinearState value, _) => value.value,
        id: 'value',
        data: list,
      ),];

      chartsdisplay = charts.LineChart(series,animationDuration: Duration(milliseconds: 1000),);
      done = true;
      setState(() {});
      
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin(); 
      flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
          
      getData();

    }
    Future onSelectNotification(String payload) async {
        showDialog(
          context: context,
          builder: (_) {
            return new AlertDialog(
              title: Text("PayLoad"),
              content: Text("Payload : $payload"),
            );
          },
        );
      }

    Future _showNotificationWithDefaultSound() async {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.Max, priority: Priority.High);
      var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
      var platformChannelSpecifics = new NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'Alert',
        'Value above Limit',
        platformChannelSpecifics,
        payload: 'Default_Sound',
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Acceleration Y"),
      ),
      body: Container(
        
        child: Center(
          child: done==false ? CircularProgressIndicator() : Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height*0.80,
                child: chartsdisplay,
              ),
              Center(
                child: Text(time[0]),
              ),
              Center(
                child: Text(time[1]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sample linear data type.
class LinearState {
  final int time;
  final int value;

  LinearState(this.time, this.value);
}