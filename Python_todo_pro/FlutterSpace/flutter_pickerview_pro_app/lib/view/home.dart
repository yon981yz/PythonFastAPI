import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pickerview_pro_app/view/add.dart';
import 'package:flutter_pickerview_pro_app/view/detail.dart';
import 'package:flutter_pickerview_pro_app/view/modify.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

///property
  List data = [];

  @override
  void initState() {
    super.initState();
    getJSONData();

  }
  getJSONData() async {
    var url = Uri.parse('http://127.0.0.1:8000/select');
    var response = await http.get(url);
    // print(response.body);
    data.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    data.addAll(result);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Todolist'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const Add())!.then((value) => getJSONData());
            }, 
            icon: const Icon(Icons.add_outlined)
            ),
        ],
      ),

      body: Center(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                      Get.to(const Modify(), arguments: [
                        data[index]['seq'],                        
                        data[index]['title'],
                        data[index]['image'],
                        data[index]['date'],
                      ])!
                          .then((value) => getJSONData());
                },
                onTap: () {
                      Get.to(const Detail(), arguments: [
                        data[index]['title'],
                        data[index]['image'],
                        data[index]['date'],
                      ])!
                          .then((value) => getJSONData());
                },
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const BehindMotion(), 
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: 'Delete',
                        onPressed: (context) {
                          deleteJSONData(data[index]['seq']);
                          setState(() {});
                        },
                      ),
                    ]
                    ),
                  child: Card(
                      color: index % 2 == 0 ? Colors.red : Colors.amberAccent,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              data[index]['image'],
                              width: 30,
                              height: 30,
                            ),
                          ),
                          Text(
                            '${data[index]['title']}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                ),
              );
              }
              ),
            ),
      );
  }

  ///function
  deleteJSONData(int int)async{
    var url = Uri.parse('http://127.0.0.1:8000/remove?seq=${int}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];

    setState(() {});
    if(result == 'OK'){
      _showDialog();
    }else{
      errorSnackBar();
    }
  }

  _showDialog(){
    print("complete");
    getJSONData();
    setState(() {});
  }

  errorSnackBar(){
  print("Error");
  }
  
}// End