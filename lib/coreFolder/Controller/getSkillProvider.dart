import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api.state.dart';
import '../utils/preety.dio.dart';

final getSkillProvider = FutureProvider.autoDispose((ref) async {
  final service = APIStateNetwork(createDio());
  return service.getAllSkill();
});
