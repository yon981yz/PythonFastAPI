import 'dart:convert';
import 'package:get/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsertStudents extends StatefulWidget {
  const InsertStudents({super.key});

  @override
  State<InsertStudents> createState() => _InsertStudentsState();
}

class _InsertStudentsState extends State<InsertStudents> {
  // property
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController deptController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert for CRUD'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: '학번을 입력 하세요'
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '성명을 입력 하세요'
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: deptController,
                  decoration: const InputDecoration(
                    labelText: '전공을 입력 하세요'
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: '전화번호를 입력 하세요'
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: '주소를 입력 하세요'
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              ElevatedButton(
                onPressed: () => insertJSONData(), 
                child: const Text('입력')
              ),
            ],
          ),
        ),
      ),
    );
  }

  //// function
  insertJSONData()async{
    var url = Uri.parse('http://127.0.0.1:8000/insert?code=${codeController.text}&name=${nameController.text}&dept=${deptController.text}&phone=${phoneController.text}&address=${addressController.text}');
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
}// END