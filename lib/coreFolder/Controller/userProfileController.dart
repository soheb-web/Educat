import 'package:educationapp/coreFolder/Model/userProfileResModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileController = FutureProvider.autoDispose<UserProfileResModel>(
  (ref) async {
    final service = APIStateNetwork(createDio());
    return await service.userProfile();
  },
);
