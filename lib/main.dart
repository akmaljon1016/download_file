import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // requestPermission();
    super.initState();
  }

  void requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: Center(
          child: MaterialButton(
            onPressed: () {
              postData();
            },
            child: Text(
              "Download",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}

Future downloadFile() async {
  var dio = Dio();
  Directory directory = await getApplicationDocumentsDirectory();
  var response = await dio.download(
      "https://filesamples.com/samples/document/doc/sample2.doc",
      '${directory.path}/file1.doc');
  print(response.statusCode);
}

Future uploadPhoto() async {
  var dio = Dio();

  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    File file = File(result.files.single.path ?? "");
    String filename = file.path.split('/').last;
    String filePath = file.path;

    FormData data = FormData.fromMap({
      'key': '896bbb56ca07566c821c528862ede8c4',
      'image': await MultipartFile.fromFile(filePath, filename: filename),
      'name': "$filename"
    });

    Directory directory = await getApplicationDocumentsDirectory();
    var response = await dio.post("https://api.imgbb.com/1/upload", data: data,
        onSendProgress: (int sent, int total) {
      print('$sent,$total');
    });
    print(response.data);
  } else {
    print("result null");
  }
}

Future getData() async {
  var dio = Dio();
  var response = await dio.get("https://jsonplaceholder.typicode.com/todos/1");
  print(response.data);
}

void postData() async {
  var dio = Dio();
  var response =
      await dio.post("https://jsonplaceholder.typicode.com/posts", data: {
    'name': "Alisher",
    'email': 'alisher@gmail.com',
  });
  print(response.statusCode);
  print(response.data.toString());
}
