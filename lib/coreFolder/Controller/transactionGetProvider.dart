
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../coreFolder/network/api.state.dart';
import '../Model/TransactionGetModel.dart';
import '../utils/preety.dio.dart';

final transactionProvider = FutureProvider.autoDispose.family<TransactionGetModel, int>((ref, id) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);

  try {
    final transaction = await service.getTransaction(id.toString());
    if (transaction.status == true) {
      return transaction;
    } else {
      Fluttertoast.showToast(msg: "Search Failed");
      throw Exception("Search failed");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Search API Error");
    throw Exception("API Error: $e");
  }
});