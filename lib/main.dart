 import 'dart:convert';
 import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
 import 'package:http/http.dart' as http;
 import 'dart:async';
Map _data;
List _features;
Map _data7;
List _features7;
 void main() async{
  _data=await getQuakes();
    _data7=await getQuakes7();
  _features=_data['features'];
  _features7=_data7['features'];
   runApp(new MaterialApp(
     title: "Quakes",
     home: new Home(),
     debugShowCheckedModeBanner: false,
   ));

}


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
          child: new Scaffold(


        appBar: new AppBar(
          title: new Text("Quake app",style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.green,
          centerTitle: true,
          actions: <Widget>[
           
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(child: new Text("Today"),)
              ,
              Tab(child: new Text("Past week"),)
            ],
          ),
        ),

        body: TabBarView(
          children: <Widget>[
            new Container(
              child: new Center(
                child: new ListView.builder(
                    itemCount: _features.length,
                    padding: EdgeInsets.all(15.0),
                    itemBuilder:(BuildContext context,int position)
                    {
                      var date=new DateTime.fromMillisecondsSinceEpoch(_features[position]['properties']['time']);
                      return new Container(
                        decoration: BoxDecoration(border: BorderDirectional(bottom: BorderSide(color: Colors.grey,width: 1.0))),
                        child: new ListTile(
                          title: new Text("${_features[position]['properties']['place']}",
                            style:new TextStyle(color: Colors.black,fontSize: 20.0),),
                          subtitle: new Text(" AT $date"),
                          leading: new CircleAvatar(
                            radius:28.0 ,
                            backgroundColor:_features[position]['properties']['mag']<4?Colors.green:Colors.red ,
                            child: new Text("${_features[position]['properties']['mag']}",style: TextStyle(color: Colors.white,fontSize:20),),
                          ),

                          onTap: (){
                            tapMessage(context,"Title:${_features[position]['properties']['title']} \n"
                                "\n Time: $date\n"
                                "\n Mag:${_features[position]['properties']['mag']}\n"
                                " \n url:${_features[position]['properties']['url']}\n"
                                ,_features[position]['properties']['url']
                                  );}     
                        ),
                      );
                    }
                ),
              ),
            ),
             new Container(
              child: new Center(
                child: new ListView.builder(
                    itemCount: _features7.length,
                    padding: EdgeInsets.all(15.0),
                    itemBuilder:(BuildContext context,int position)
                    {
                      var date7=new DateTime.fromMillisecondsSinceEpoch(_features7[position]['properties']['time']);
                      return new Container(
                        decoration: BoxDecoration(border: BorderDirectional(bottom: BorderSide(color: Colors.grey,width: 1.0))),
                        child: new ListTile(
                          title: new Text("${_features7[position]['properties']['place']}",
                            style:new TextStyle(color: Colors.black,fontSize: 20.0),),
                          subtitle: new Text(" AT $date7"),
                          leading: new CircleAvatar(
                            radius:28.0 ,
                            backgroundColor:_features7[position]['properties']['mag']<4?Colors.green:Colors.red ,
                            child: new Text("${_features7[position]['properties']['mag']}",style: TextStyle(color: Colors.white,fontSize:20),),
                          ),

                          onTap: (){
                            tapMessage(context,"Title:${_features7[position]['properties']['title']} \n"
                                "\n Time: $date7\n"
                                "\n Mag:${_features7[position]['properties']['mag']}\n"
                                " \n url:${_features7[position]['properties']['url']}\n"
                                ,_features7[position]['properties']['url']
                                  );}     
                        ),
                      );
                    }
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}


void tapMessage(BuildContext context , String data,String url)
{
  var alert=new AlertDialog(
    title: new Text("Details"),
    content: new Text(data),
    actions: <Widget>[
       new FlatButton(onPressed:(){_launchURL(url);} , child: new Text("Go to website")),
      new FlatButton(onPressed:(){Navigator.pop(context);} , child: new Text("OK")),
      new FlatButton(onPressed: (){},child: new Text("see on maps"),)
    ],
  );
  showDialog(context: context,child: alert);
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<Map>getQuakes() async {
  String apiUrl="https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response=await http.get(apiUrl);

  return json.decode(response.body);//returns list type

}

Future<Map>getQuakes7() async {
  String apiUrl="https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/1.0_week.geojson";
  http.Response response1=await http.get(apiUrl);

  return json.decode(response1.body);//returns list type

}