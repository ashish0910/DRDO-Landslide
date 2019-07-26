/// Line chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SensorZ extends StatefulWidget {
  @override
  _SensorZState createState() => _SensorZState();
}
var datasend;
bool done = false ;
var time;
class _SensorZState extends State<SensorZ> {
  static var chartsdisplay ;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Future<dynamic> getData() async {
    var response =  await http.get(
      Uri.encodeFull("https://api.thingspeak.com/channels/784367/fields/3"),
      headers: {
        "Accept" : "application/json"
      }
    );
    // debugPrint(response.body);
    Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
    var list;
    time = map["channel"]["updated_at"].split("T");
    debugPrint(time[0]);
    var one = map["feeds"][0]["field3"];
    debugPrint(map["feeds"].length.toString());
    list = [
      LinearSales(0, int.parse(one)),
    ];
    for(var i=1 ;i < map["feeds"].length ; i++){
      var x = map["feeds"][i]["field3"];
      var y = int.parse(x);
      if( y>=8){
        _showNotificationWithDefaultSound();
      }
      list.add(LinearSales(i,y));
    }
    
    var series = [charts.Series(
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        id: 'Sales',
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
        title: Text("Acceleration Z"),
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
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}