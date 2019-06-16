import 'dart:async';
//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      home: MainPage()
    );
  }
}

class Cats{

  final String catList;

  Cats({this.catList});

  factory Cats.fromJson(dynamic json){
    return(Cats(catList: json.toString()));
  }
}

class MainPage extends StatefulWidget{
  @override
  createState() => MainPageState();
}

class MainPageState extends State<MainPage>{

  String maintext = "42";
  String text = "is the Answer to the Ultimate Question of Life, the Universe, and Everything";

  bool change = true;

  final biggerFont = TextStyle(fontSize: 50.0, fontFamily: "Times New Roman");
  final smallerFont = TextStyle(fontSize: 20.0);

  Future<Cats> fetchCats(String cat) async {

    String ht;

    if(cat == "year"){
      ht = "http://numbersapi.com/random/year";
    
    }else if(cat == "math"){
      ht = "http://numbersapi.com/random/math";
    }else{
      ht = "http://numbersapi.com/"+cat;
    }

    final response = 
          await http.get(ht);
    
    var a = response.body.toString().split(" ");
    print(cat);
    setState(() {
      if(change){
        maintext = a[0];
        text = "";
        for(int i=1;i<a.length;i++){
          text += a[i];
          text += " ";
        }
        change = false;
        }
    });
      
    return Cats.fromJson(response.body);
  }

  void numbershit(String val){
    fetchCats(val);
  }


  final numberController = TextEditingController();

  Widget numberShower(BuildContext context){
    return Container(
      
     decoration: new BoxDecoration(
          color: Colors.teal,
          borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(60.0),
          topRight: const Radius.circular(60.0),
        )
      ),
      padding: EdgeInsets.all(12.0),
      
      child: Center(
              child: Column(
                children: <Widget>[
                  Text("$maintext",style: biggerFont),
                  Text(" \n "),
                  Text("$text",style: smallerFont),
                  Text(" \n "),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                            change =  true;
                            fetchCats("year");
                        },
                        child: Text("Year")
                      ),
                      FlatButton(
                        onPressed: (){
                          change = true;
                          fetchCats("math");
                        },
                        child: Text("Math") 
                      ),
                      FlatButton(
                        onPressed: (){
                          change = true;
                          fetchCats("");
                        },
                        child: Text("Random")
                      ),
                      FlatButton(
                        onPressed: (){
                          change = true;
                          fetchCats("trivia");
                        },
                        child: Text("Trivia")
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  Container(child: TextFormField(
                    decoration: InputDecoration(labelText: "Enter Number",
                    hintText: "Number",                            
                    ),
                    onSaved:(String val) => numbershit(val),
                    controller: numberController,
                    ),
                    margin: const EdgeInsets.all(20.0)),
                    FlatButton(
                      child: Text("Submit"),
                      onPressed: (){
                          change = true;
                          print(numberController.text);
                          fetchCats(numberController.text);
                      },
                    )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            )
    );
  }

  Widget build(BuildContext context){
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.blueGrey,
      body: numberShower(context),
      bottomSheet: Container(
        padding: EdgeInsets.all(5.0),
        color: Colors.teal,
        child: Text(
          "Powered by numbersapi.com"
        ),
        
      ),
    );
  }
}