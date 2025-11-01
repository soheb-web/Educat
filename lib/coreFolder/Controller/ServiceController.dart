
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../coreFolder/network/api.state.dart';
import '../utils/preety.dio.dart';

final getServiceProvider = FutureProvider.autoDispose((ref) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);
  return service.service();
});