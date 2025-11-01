
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';

final getDropDownProvider = FutureProvider.autoDispose((ref) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);
  return service.getDropDownApi();
});