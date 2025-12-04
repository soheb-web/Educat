import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../network/api.state.dart';
import '../utils/preety.dio.dart';

final saveReviewProvider = FutureProvider.family
    .autoDispose<void, Map<String, dynamic>>((ref, data) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);
  final response = await service.saveReview(data);
  final statusCode = response.response.statusCode;
  final message = response.response.data['message'] ?? "Unknown";
  if (statusCode == 200 || statusCode == 201) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 12.0,
    );
  } else {
    throw Exception(message);
  }
});
