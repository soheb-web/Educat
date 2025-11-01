import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api.state.dart';
import '../Model/CollegeSearchModel.dart';
import '../Model/SearchCompanyModel.dart';
import '../Model/GetSkillModel.dart';
import '../Model/searchMentorModel.dart';
import '../utils/preety.dio.dart';

final apiClientProvider =
    FutureProvider.autoDispose<APIStateNetwork>((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return APIStateNetwork(dio);
});

final searchCollegeProvider =
    FutureProvider.autoDispose.family<SearchCollegeModel, Map<String, String>>(
  (ref, params) async {
    final client = await ref.watch(apiClientProvider.future);
    return await ApiController.searchCollege(client, params);
  },
);

final searchCompanyProvider =
    FutureProvider.autoDispose.family<SearchCompanyModel, Map<String, String>>(
  (ref, params) async {
    final client = await ref.watch(apiClientProvider.future);
    return await ApiController.searchCompany(client, params);
  },
);

final searchMentorProvider =
    FutureProvider.autoDispose.family<SearchMentorModel, Map<String, String>>(
  (ref, params) async {
    final client = await ref.watch(apiClientProvider.future);
    return await ApiController.searchMentor(client, params);
  },
);

class ApiController {
  static Future<SearchCollegeModel> searchCollege(
    APIStateNetwork api,
    Map<String, String> params,
  ) async {
    try {
      final result = await api.getAllSearchCollege(
        params['location'] ?? '',
        params['course'] ?? '',
        params['college_name'] ?? '',
      );
      developer.log('College API Response: $result', name: 'ApiController');
      return result;
    } catch (e, stackTrace) {
      developer.log('College API Error: $e',
          name: 'ApiController', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Future<SearchCompanyModel> searchCompany(
    APIStateNetwork api,
    Map<String, String> params,
  ) async {
    try {
      final result = await api.getAllSearchCompany(
        params['skills'] ?? '',
        params['industry'] ?? '',
        params['location'] ?? '',
      );
      developer.log('Company API Response: $result', name: 'ApiController');
      return result;
    } catch (e, stackTrace) {
      developer.log('Company API Error: $e',
          name: 'ApiController', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Future<SearchMentorModel> searchMentor(
    APIStateNetwork api,
    Map<String, String> params,
  ) async {
    try {
      final result = await api.getAllSearchMentor(
        params['skills_id'] ?? '',
        params['users_field'] ?? '',
        params['total_experience'] ?? '',
      );
      developer.log('Mentor API Response: $result', name: 'ApiController');
      return result;
    } catch (e, stackTrace) {
      developer.log('Mentor API Error: $e',
          name: 'ApiController', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Future<SkillGetModel> getSkill(
    APIStateNetwork api,
    Map<String, String> params,
  ) async {
    try {
      final result =
          await api.getSkill(params['level'] ?? '', params['industry'] ?? '');
      developer.log('Mentor API Response: $result', name: 'ApiController');
      return result;
    } catch (e, stackTrace) {
      developer.log('Mentor API Error: $e',
          name: 'ApiController', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
