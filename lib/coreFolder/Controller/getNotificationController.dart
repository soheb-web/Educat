import 'package:educationapp/coreFolder/Model/getNotificationResModel.dart';
import 'package:educationapp/coreFolder/Model/mentorNotificationResModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getNotificationController = FutureProvider<GetNotificationResModel>(
  (ref) async {
    final service = APIStateNetwork(createDio());
    return await service.getNotification();
  },
);

final mentorSideNotificationController =
    FutureProvider<MentorNotificationResModel>(
  (ref) async {
    final service = APIStateNetwork(createDio());
    return await service.mentorSideNotification();
  },
);
