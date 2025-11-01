
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api.state.dart';
import '../utils/preety.dio.dart';

final buyCoinProvider = FutureProvider.family.autoDispose<void, Map<String, dynamic>>((ref, data) async {
  // final dio = await createDio();
  // final service = APIStateNetwork(dio);
  final dio = await createDio();
  final service = APIStateNetwork(dio);
  final response = await service.buyCoin(data);

  final statusCode = response.response.statusCode;
  final message = response.response.data['message'] ?? 'Unknown error';

  if (statusCode == 200 || statusCode == 201) {
    // Success: Optionally invalidate other providers here
    // ref.invalidate(getCoinProvider);  // Refresh balance
    // ref.invalidate(transactionProvider);  // Refresh transactions (pass userId if needed)
    return;  // Void provider, so no return value
  } else {
    throw Exception(message);  // e.g., "Insufficient funds" or backend error
  }
});