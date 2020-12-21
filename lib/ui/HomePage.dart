import 'package:flutter/material.dart';
import 'Sensor.dart';
import 'Sensory.dart';
import 'Sensorz.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Exit App?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: new Text("Choose Sensor"),
          centerTitle: true,
        ),
        body: new Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("images/back.jpg"),fit: BoxFit.cover),
              ),
            ),
            new Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: MaterialButton(
                      onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute( builder: (BuildContext context) =>  SensorX() ));
                      },
                      padding: EdgeInsets.all(20.0),
                      color: Colors.purple,
                      child: Text("Acceleration X",style: TextStyle(color: Colors.white,fontSize: 25.0 ),), 
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: MaterialButton(
                      onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute( builder: (BuildContext context) =>  SensorY() ));
                      },
                      padding: EdgeInsets.all(20.0),
                      color: Colors.purple,
                      child: Text("Acceleration Y",style: TextStyle(color: Colors.white,fontSize: 25.0 ),), 
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: MaterialButton(
                      onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute( builder: (BuildContext context) =>  SensorZ() ));
                      },
                      padding: EdgeInsets.all(20.0),
                      color: Colors.purple,
                      child: Text("Acceleration Z",style: TextStyle(color: Colors.white,fontSize: 25.0 ),), 
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

}