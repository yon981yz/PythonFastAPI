import 'dart:convert';
import 'package:crud_app/view/remove_students.dart';
import 'package:crud_app/view/update_students.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/route_manager.dart';
import 'package:crud_app/view/insert_students.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QueryStudents extends StatefulWidget {
  const QueryStudents({super.key});

  @override
  State<QueryStudents> createState() => _QueryStudentsState();
}

class _QueryStudentsState extends State<QueryStudents> {
  //property
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
      appBar: AppBar(
        title: const Text('CRUD for students'),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(const InsertStudents())!.then((value) => getJSONData());
              },
              icon: const Icon(
                (Icons.add_outlined),
              )),
        ],
      ),
      body: Center(
        child: data.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(const UpdateStudents(), arguments: [
                        data[index]['code'],
                        data[index]['name'],
                        data[index]['dept'],
                        data[index]['phone'],
                        data[index]['address'] ?? "",
                      ])!
                          .then((value) => getJSONData());
                    },
                    onLongPress: () {
                      Get.to(const RemoveStudents(), arguments: [
                        data[index]['code'],
                        data[index]['name'],
                        data[index]['dept'],
                        data[index]['phone'],
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
                                    deleteJSONData(data[index]['code']);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Code : ${data[index]['name'].toString()}",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Name : ${data[index]['code'].toString()}",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Dept : ${data[index]['dept'].toString()}",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Phone : ${data[index]['phone'].toString()}",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  ///fuction
    deleteJSONData(String code)async{
    var url = Uri.parse('http://127.0.0.1:8000/remove?code=$code');
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
    Get.back();
  }

  errorSnackBar(){
  print("Error");
    Get.back();
  }
}
