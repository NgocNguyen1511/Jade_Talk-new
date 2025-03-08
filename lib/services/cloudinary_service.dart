import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

//uploading files to cloudinary
Future<String?> uploadToCloudinary(File file) async {
  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  String uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  if (file == null) {
  print("Can't upload an empty file");
  return null;
  }

  //create a MultiPart request to upload the file
  var uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
  var request = http.MultipartRequest('POST', uri);

  //read the file content as bytes
  var fileBytes = await file.readAsBytes();

  var multipartFile = http.MultipartFile.fromBytes('file', fileBytes,
      filename: file.path.split('/').last);

  //add file part to the request
  request.files.add(multipartFile);

  request.fields['upload_preset'] = uploadPreset;
  request.fields['resource_type'] = "raw";

  request.fields['folder'] = 'my-chats-folder';

  //send the request and await the response
  var response = await request.send();

  //get the response as text
  var responseBody = await response.stream.bytesToString();

  //parse the response body
  var jsonResponse = jsonDecode(responseBody);

  if (response.statusCode == 200) {
    print("upload successful!");
    return jsonResponse['secure_url'];
  } else {
    print("upload failed with status code: ${response.statusCode}");
    print("responseBody: $responseBody");
    return null;
  }
}



