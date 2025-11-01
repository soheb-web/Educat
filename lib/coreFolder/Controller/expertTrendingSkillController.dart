import 'package:educationapp/coreFolder/Model/trendingSkillExpertResModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expertTrendingSkillController =
    FutureProvider.family<TrendingExpertResModel, String>(
  (ref, id) async {
    final service = APIStateNetwork(createDio());
    return await service.exprtTrendingSkill(id);
  },
);
