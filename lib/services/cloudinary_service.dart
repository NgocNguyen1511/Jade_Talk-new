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

  //get resource type from the file extension
  String getResourceType(String extension){
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'ico', 'tiff', 'svg', 'eps', 'jpe', 'jpg2', 'j2k', 'jpf', 'jpx', 'jpm', 'mj2'];
    final videoExtensions = ['mp4', 'avi', 'flv', 'wmv', 'mov', 'webm', 'mkv', '3gp', 'ogg', 'ogv', 'm4v', 'mpg', 'mpeg', 'm2v', 'm4v', '3g2'];
    final audioExtensions = ['mp3', 'wav', 'wma', 'ogg', 'flac', 'aac', 'alac', 'aiff', 'dsd', 'pcm', 'm4a', 'm4b', 'm4p', 'm4r', 'm4v', '3g2'];

    if (imageExtensions.contains(extension)) {
      return 'image';
    } else if (videoExtensions.contains(extension)) {
      return 'video';
    } else if (audioExtensions.contains(extension)) {
      return 'raw';
    } else {
      return 'raw';
    }
  }

  //read the file content as bytes
  var fileBytes = await file.readAsBytes();

  var multipartFile = http.MultipartFile.fromBytes('file', fileBytes,
      filename: file.path.split('/').last);

  var fileExtension = file.path.split('.').last;
  var resourceType = getResourceType(fileExtension);

    //create a MultiPart request to upload the file
  var uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload');
  var request = http.MultipartRequest('POST', uri);

  //add file part to the request
  request.files.add(multipartFile);

  request.fields['upload_preset'] = uploadPreset;
  request.fields['resource_type'] = resourceType;

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



