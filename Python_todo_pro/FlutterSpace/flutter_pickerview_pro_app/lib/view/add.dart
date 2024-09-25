import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {


  late TextEditingController titleController = TextEditingController();
  late List<String> imageName;
  late int selectedItem;

  @override
  void initState() {
    super.initState();

    imageName = [
      'images/Arsenal.png',
      'images/chelsea.png',
      'images/liverpool.png',
    ];
    selectedItem = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add page'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      imageName[selectedItem],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: CupertinoPicker(
                      backgroundColor: Color.fromARGB(255, 200, 159, 171),
                      itemExtent: 50, 
                      scrollController: FixedExtentScrollController(
                        initialItem: 0,
                      ),
                      onSelectedItemChanged:(value) {
                        selectedItem = value;
                        setState(() {});
                      }, 
                      children: List.generate(
                        3, 
                        (index) => Center(
                          child: Image.asset(
                            imageName[index],
                            width: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: SizedBox(
                height: 50,
                width: 400,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Plese input list title',
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  insertJSONData();
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Input')),
            )
          ],
        ),
      ),
    );


  }

    ////function
  insertJSONData()async{
    var url = Uri.parse('http://127.0.0.1:8000/insert?&title=${titleController.text}&image=${imageName[selectedItem]}&date=${formatDate(DateTime.now()).toString()}');
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
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }




}