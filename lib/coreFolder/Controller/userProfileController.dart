import 'dart:developer';
import 'package:educationapp/coreFolder/Model/userProfileResModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// final userProfileController = FutureProvider.autoDispose<UserProfileResModel>(
//   (ref) async {
//     final service = APIStateNetwork(createDio());
//     return await service.userProfile();
//   },
// );

// 1. Hive से प्रोफाइल Map को पढ़ने के लिए Provider
final hiveProfileProvider = StateProvider<Map<dynamic, dynamic>?>((ref) {
  final box = Hive.box('userdata');
  // शुरू में Hive से डेटा पढ़ें
  return box.get('profile');
});

final userProfileController = FutureProvider.autoDispose<UserProfileResModel>(
  (ref) async {
    final service = APIStateNetwork(createDio());
    final response = await service.userProfile();

    // ✅ API se aane ke baad data Hive me save karo
    final box = Hive.box('userdata');
    final newData = {
      'full_name': response.data?.fullName,
      'email': response.data?.email,
      'phone_number': response.data?.phoneNumber,
      'profile_picture': response.data?.profilePic,
      'total_experience': response.data?.totalExperience,
      'users_field': response.data?.usersField,
      'service_type': response.data?.serviceType,
      'dob': response.data?.dob,
    };
    box.put('profile', newData);

    // ✅ Hive में डेटा सेव होने के बाद, hiveProfileProvider को अपडेट करें
    ref.read(hiveProfileProvider.notifier).state = newData;

    log('✅ Profile saved to Hive: ${response.data?.fullName}');
    return response;

    // box.put('profile', {
    //   'full_name': response.data?.fullName,
    //   'email': response.data?.email,
    //   'phone_number': response.data?.phoneNumber,
    //   'profile_picture': response.data?.profilePic,
    //   'total_experience': response.data?.totalExperience,
    //   'users_field': response.data?.usersField,
    //   'service_type': response.data?.serviceType,
    //   "dob": response.data?.dob,
    // });

    // log('✅ Profile saved to Hive: ${response.data?.fullName}');
    // return response;
  },
);
