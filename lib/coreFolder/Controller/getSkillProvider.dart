import 'package:educationapp/coreFolder/Model/budgetResModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api.state.dart';
import '../utils/preety.dio.dart';

final getSkillProvider = FutureProvider.autoDispose((ref) async {
  final service = APIStateNetwork(createDio());
  return service.getAllSkill();
});

final budgetController = FutureProvider<BudgetResModel>(
  (ref) async {
    final service = APIStateNetwork(createDio());
    return await service.fetchBudget();
  },
);
