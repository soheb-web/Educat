
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../network/api.state.dart';
import '../Model/ReviewGetModel.dart';
import '../utils/preety.dio.dart';
final reviewProvider = FutureProvider.autoDispose.family<ReviewGetModel, int>((ref, id) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);

  try {
    final review = await service.getReview(id.toString());
    if (review.status == true) {
      return review;
    } else {
      Fluttertoast.showToast(msg: "Search Failed");
      throw Exception("Search failed");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Search API Error");
    throw Exception("API Error: $e");
  }
});