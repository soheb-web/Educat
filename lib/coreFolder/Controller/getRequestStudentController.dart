import 'package:educationapp/coreFolder/Model/getStudentRequestResModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final getRequestStudentController =
//     FutureProvider.autoDispose<GetStudentRequestResModel>(
//   (ref) async {
//     final service = APIStateNetwork(createDio());
//     return await service.getRequestStudent();
//   },
// );

final requestRefreshTrigger = StateProvider<bool>((ref) => false);

final getRequestStudentController =
    FutureProvider.autoDispose<GetStudentRequestResModel>((ref) async {
  // When this value changes, ref.refresh will auto-run
  ref.watch(requestRefreshTrigger);
  final service = APIStateNetwork(createDio());
  return await service.getRequestStudent();
});
