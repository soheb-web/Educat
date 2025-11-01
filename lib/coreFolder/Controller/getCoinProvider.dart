
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api.state.dart';
import '../utils/preety.dio.dart';

final getCoinProvider = FutureProvider.autoDispose((ref) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);
  return service.getCoinApi();
});