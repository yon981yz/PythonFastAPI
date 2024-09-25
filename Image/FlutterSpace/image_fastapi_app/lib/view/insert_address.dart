import 'dart:convert';
import 'dart:io';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InsertAddress extends StatefulWidget {
  const InsertAddress({super.key});

  @override
  State<InsertAddress> createState() => _InsertAddressState();
}

class _InsertAddressState extends State<InsertAddress> {
  //property
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController relationController = TextEditingController();

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  // ImagePicker에서 선택된 filename
  String filename = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주소록 입력'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '이름을 입력 하세요'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: '전화번호를 입력 하세요'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: '주소를 입력 하세요'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: relationController,
                  decoration: const InputDecoration(
                    labelText: '관계를 입력 하세요'
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  getImageFromGallery(ImageSource.gallery);
                }, 
                child: const Text('이미지 가져오기')
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  color: Colors.grey,
                  child: Center(
                    child:  imageFile == null
                    ? const Text('이미지가 선택되지 않았습니다')
                    :Image.file(File(imageFile!.path)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    insertAction();
                  }, 
                  child: const Text('입력')
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Function
  getImageFromGallery(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    imageFile = XFile(pickedFile!.path);
    setState(() {});
    // print(imageFile!.path);
  }

  insertAction() async {
    // filename이 필요하므로 filename을 얻기 전 까지는 다음 단계를 멈춘다.
    await uploadImage();
    insertJSONData();
  }

  uploadImage() async {
    var request = http.MultipartRequest( // 이미지를 잘라서 보내는 방식
      "POST", Uri.parse("http://127.0.0.1:8000/upload"));
    var multipartFile = 
      await http.MultipartFile.fromPath('file', imageFile!.path);
    request.files.add(multipartFile);

    // for get file name
    List preFilename = imageFile!.path.split('/');
    filename = preFilename[preFilename.length - 1];
    print("upload file name : $filename");

    var response = await request.send();

    if(response.statusCode == 200){
      print("Image uploaded successfully");
    }else{
      print("Image upload failed");
    }
  }

  insertJSONData() async {
    var url = Uri.parse('http://127.0.0.1:8000/insert?name=${nameController.text}&phone=${phoneController.text}&address=${addressController.text}&relation=${relationController.text}&filename=${filename}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    if (result == 'OK'){
      _showDialog();
    }else{
      _errorSnackBar();
    }
  }
  _showDialog(){
    print("sucessful");
    Get.back();
    Get.back();
  }

  _errorSnackBar(){
    print("Error");
  }
} // END