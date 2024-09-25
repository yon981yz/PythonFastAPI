import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_fastapi_app/view/insert_address.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_fastapi_app/view/update_address.dart';

class QueryAddress extends StatefulWidget {
  const QueryAddress({super.key});

  @override
  State<QueryAddress> createState() => _QueryAddressState();
}

class _QueryAddressState extends State<QueryAddress> {

  //property
  List data = [];

  @override
  void initState() {
    super.initState();
    getJSONData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const InsertAddress())!.then((value) => getJSONData());
            }, 
            icon: const Icon(Icons.add_outlined)
          ),
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
                Get.to(const UpdateAddress(), arguments: [
                  data[index][0],
                  data[index][1],
                  data[index][2],
                  data[index][3],
                  data[index][4],
                  data[index][5],
                ]);
              },
              child: Card(
                child: Row(
                  children: [
                    Image.network(
                      'http://127.0.0.1:8000/view/${data[index][5]}',
                      width: 100,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '이름 : ${data[index][1]}'
                          ),
                        Text(
                          '전화번호 : ${data[index][2]}'
                          ),
                        Text(
                          '주소 : ${data[index][3]}'
                          ),
                        Text(
                          '관계 : ${data[index][4]}'
                          ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  // ---Functions ---
  getJSONData() async {
    var url = Uri.parse('http://127.0.0.1:8000/select');
    var response = await http.get(url);
    data.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    print(result);
    data.addAll(result);
    setState(() {});
  }

}//END