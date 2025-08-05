import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void showStatusSnackBar({
  required BuildContext context,
  required bool isSuccess,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: isSuccess ? Colors.green[800] : Colors.red[800],
      duration: const Duration(seconds: 1),
    ),
  );
}

void clearAllControllers({required List<TextEditingController> controllers}) {
  for (var controller in controllers) {
    controller.clear();
  }
}

void disposeAllControllers({required List<TextEditingController> controllers}) {
  for (var controller in controllers) {
    controller.dispose();
  }
}

Future<String> uploadImageToImgbb(File imageFile, String imgbbAPIKey) async {
  final uri = Uri.parse('https://api.imgbb.com/1/upload?key=$imgbbAPIKey');

  final request = http.MultipartRequest('POST', uri)
    ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  final response = await request.send();

  if (response.statusCode == 200) {
    final responseBody = await response.stream.bytesToString();
    final jsonData = jsonDecode(responseBody);
    if (jsonData['success']) {
      return jsonData['data']['url'];
    } else {
      throw Exception(
        'Failed to upload image: ${jsonData['error']['message']}',
      );
    }
  } else {
    throw Exception(
      'Failed to upload image. Status code: ${response.statusCode}',
    );
  }
}
