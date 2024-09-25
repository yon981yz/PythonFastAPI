import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

class RemoveStudents extends StatefulWidget {
  const RemoveStudents({super.key});

  @override
  State<RemoveStudents> createState() => _RemoveStudentsState();
}

class _RemoveStudentsState extends State<RemoveStudents> {
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController deptController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var value = Get.arguments ?? "__";

  @override
  void initState() {
    super.initState();

    codeController.text = value[0];
    nameController.text = value[1];
    deptController.text = value[2];
    phoneController.text = value[3];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete for CRUD"),
      ),

      body: Center(
        child: Column(
          children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  readOnly: true,
                  controller: codeController,
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  readOnly: true,
                  controller: nameController,
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  readOnly: true,
                  controller: deptController,
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  readOnly: true,
                  controller: phoneController,
                  keyboardType: TextInputType.text,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteJSONData();
                }, 
                child: const Text('삭제')
            ),
          ],
        ),
      ),


    );
  }
  ////function
  deleteJSONData()async{
    var url = Uri.parse('http://127.0.0.1:8000/remove?code=${codeController.text}');
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