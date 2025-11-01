
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../coreFolder/network/api.state.dart';
import '../Model/profileGetModel.dart';
import '../utils/preety.dio.dart';

final profileProvider = FutureProvider.autoDispose.family<ProfileGetModel, int>((ref, id) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);

  try {
    final profile = await service.mentorProfile(id.toString());
    // if (
    // profile. == true) {
      return profile;
  //   } else {
  //     Fluttertoast.showToast(msg: "Profile fetch failed");
  //     throw Exception("Profile fetch failed");
  //   }
  } catch (e) {
    Fluttertoast.showToast(msg: "Profile API Error");
    throw Exception("API Error: $e");
  }
});
