import 'dart:developer';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:educationapp/login/login.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import '../Model/login.body.model.dart';
import '../Model/login.rsponse.model.dart';
import '../Model/ResisterModel.dart';
import '../network/api.state.dart';
import '../utils/preety.dio.dart';
import 'package:path/path.dart' as path;

// Future<String> fcmGetToken() async {
//   // Permission request करें (iOS/Android पर जरूरी)
//   NotificationSettings settings =
//       await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//     provisional: true, // iOS के लिए provisional permission
//     carPlay: true,
//   );

//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('User granted permission');
//   } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//     print('User granted provisional permission');
//   } else {
//     print('User declined or has not accepted permission');
//     return "no_permission"; // Return a fallback string instead of void
//   }

//   // FCM Token निकालें
//   String? token = await FirebaseMessaging.instance.getToken();
//   // setState(() {
//   //   _fcmToken = token;
//   // });
//   print('FCM Token: $token'); // Console में print होगा - moved before return
//   return token ?? "unknown_device";
// }

// Future<String> fcmGetToken() async {
//   // ✅ Now request notification permissions
//   NotificationSettings settings =
//       await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );

//   if (settings.authorizationStatus != AuthorizationStatus.authorized) {
//     print('User declined permission');
//     return "no_permission";
//   }

//   String? Fcmtoken = await FirebaseMessaging.instance.getToken();
//   print('FCM Token: $Fcmtoken');
//   return Fcmtoken ?? "unknown_device";
// }

class Auth {
  // static Future<void> login(
  //   String email,
  //   String password,
  //   BuildContext context,
  // ) async {
  //   try {
  //     final deviceToken = await fcmGetToken();
  //     final dio = await createDio();
  //     final service = APIStateNetwork(dio);
  //     // final response = await service.login(
  //     //   LoginBodyModel(
  //     //     email: email,
  //     //     password: password,
  //     //     deviceToken: deviceToken,
  //     //   ),
  //     // );
  //     // ✅ Send as JSON body, not multipart
  //     final body = {
  //       "email": email,
  //       "password": password,
  //       "device_token": deviceToken,
  //     };
  //     final response = await service.login(body);
  //     if (response.response.statusCode == 200) {
  //       final data = response.response.data;
  //       final loginData = LoginResponseModel.fromJson(data);
  //       final box = await Hive.openBox('userdata');
  //       await box.clear(); // Optional: Clear previous session
  //       await box.put('token', loginData.data!.token);
  //       await box.put('full_name', loginData.data!.fullName);
  //       await box.put('userType', loginData.data!.userType);
  //       await box.put("email", loginData.data!.email);
  //       await box.put("userid", loginData.data!.userid);
  //       var userType = box.get("userType");
  //       log("userID ${box.get("userid")}");
  //       log("userType : - $userType");
  //       Fluttertoast.showToast(
  //         msg: data['message'] ?? 'Login successful',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.TOP,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 12.0,
  //       );
  //       developer.log('Login successful: $data');
  //     }
  //   } on DioException catch (e) {
  //     String errorMessage = e.response?.data['message'] ?? 'Login failed';
  //     // if (e.response?.statusCode == 403) {
  //     //   errorMessage =
  //     //       'Your profile is under review. Please wait for approval.';
  //     //   Fluttertoast.showToast(
  //     //     msg: errorMessage,
  //     //     toastLength: Toast.LENGTH_LONG,
  //     //     gravity: ToastGravity.TOP,
  //     //     backgroundColor: Colors.orange,
  //     //     textColor: Colors.white,
  //     //     fontSize: 12.0,
  //     //   );
  //     // } else {
  //     //   Fluttertoast.showToast(
  //     //     msg: errorMessage,
  //     //     toastLength: Toast.LENGTH_SHORT,
  //     //     gravity: ToastGravity.TOP,
  //     //     backgroundColor: Colors.red,
  //     //     textColor: Colors.white,
  //     //     fontSize: 12.0,
  //     //   );
  //     // }
  //     // throw Exception('Failed to login: ${e.message}');
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: 'An unexpected error occurred: $e',
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.TOP,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 12.0,
  //     );
  //     throw Exception('Failed to login: $e');
  //   }
  // }

  // static Future<void> register(
  //   String email,
  //   String password,
  //   String fullName,
  //   String phoneNumber,
  //   String serviceType,
  //   String userType,
  //   BuildContext context,
  // ) async {
  //   final dio = await createDio();
  //   final service = APIStateNetwork(dio);
  //   final response = await service.register(
  //     RegisterBodyModel(
  //         email: email,
  //         password: password,
  //         fullName: fullName,
  //         phoneNumber: phoneNumber,
  //         serviceType: serviceType,
  //         userType: userType),
  //   );

  //   if (response.data != null) {
  //     Fluttertoast.showToast(msg: response.data['message']);
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       CupertinoPageRoute(
  //         builder: (context) => LoginPage(),
  //       ),
  //       (route) => false,
  //     );
  //   } else {
  //     Fluttertoast.showToast(msg: "Something went wrong");
  //   }

  //   // if (response.response.data['message'] == "Registration successful") {
  //   //   Fluttertoast.showToast(
  //   //     msg: response.response.data['message'],
  //   //     toastLength: Toast.LENGTH_SHORT,
  //   //     gravity: ToastGravity.TOP,
  //   //     backgroundColor: Colors.green,
  //   //     textColor: Colors.white,
  //   //     fontSize: 12.0,
  //   //   );
  //   //   log('Register successful: ${response.response.data}');
  //   //   // Navigator.pop(context);
  //   //   Navigator.pushAndRemoveUntil(
  //   //     context,
  //   //     CupertinoPageRoute(
  //   //       builder: (context) => LoginPage(),
  //   //     ),
  //   //     (route) => false,
  //   //   );
  //   // } else {
  //   //   Fluttertoast.showToast(
  //   //     msg: response.response.data['message'],
  //   //     toastLength: Toast.LENGTH_SHORT,
  //   //     gravity: ToastGravity.TOP,
  //   //     backgroundColor: Colors.red,
  //   //     textColor: Colors.white,
  //   //     fontSize: 12.0,
  //   //   );
  //   //   throw Exception('Failed to login');
  //   // }

  //   // final message = (response.response.data['message'] ?? '').toString().trim();

  //   // // ✅ check for any success message
  //   // final isSuccess = message.toLowerCase().contains('success');

  //   // if (isSuccess) {
  //   //   Fluttertoast.showToast(
  //   //     msg: message,
  //   //     toastLength: Toast.LENGTH_SHORT,
  //   //     gravity: ToastGravity.TOP,
  //   //     backgroundColor: Colors.green, // green for success
  //   //     textColor: Colors.white,
  //   //     fontSize: 12.0,
  //   //   );

  //   //   log('✅ Register successful: ${response.response.data}');

  //   //   Navigator.pushAndRemoveUntil(
  //   //     context,
  //   //     CupertinoPageRoute(builder: (context) => const LoginPage()),
  //   //     (route) => false,
  //   //   );

  //   //   return;
  //   // }
  //   // Fluttertoast.showToast(
  //   //   msg: message.isNotEmpty ? message : 'Something went wrong',
  //   //   toastLength: Toast.LENGTH_SHORT,
  //   //   gravity: ToastGravity.TOP,
  //   //   backgroundColor: Colors.red, // red for failure
  //   //   textColor: Colors.white,
  //   //   fontSize: 12.0,
  //   // );

  //   // throw Exception('Registration failed: $message');
  // }

  static Future<void> updateUserProfile({
    required String userType,
    File? resumeFile,
    required String totalExperience,
    required String usersField,
    required String skillsId,
    required String languageKnown,
    required String linkedinUser,
    required String description,
    required String fullName,
    required String dob,
    File? profileImage,
  }) async {
    try {
      final dio = await createDio();
      final url = 'https://educatservicesindia.com/admin/api/update-profile';

      // final formData = FormData.fromMap({
      //   'user_type': userType,
      //   'total_experience': totalExperience,
      //   'users_field': usersField, // Fixed typo
      //   'skills_id': skillsId,
      //   'language_known': languageKnown, // Fixed typo
      //   'linkedin_user': linkedinUser,
      //   'description': description,
      //   'full_name': fullName,
      //   // 'email': email,
      //   // 'phone': phone,
      //   // 'password': password,
      //   // 'date_of_birth': dateOfBirth,
      //   // 'address': address,
      //   // 'gender': gender,
      //   // 'semester': semester,
      //   if (resumeFile != null)
      //     'resume_upload': await MultipartFile.fromFile(
      //       resumeFile.path,
      //       filename: path.basename(resumeFile.path),
      //     ),
      // });

      final Map<String, dynamic> body = {
        'user_type': userType,
        'total_experience': totalExperience,
        'users_field': usersField,
        'skills_id': skillsId,
        'language_known': languageKnown,
        'linkedin_user': linkedinUser,
        'description': description,
        'full_name': fullName,
        'dob': dob,
      };

      // Resume File
      if (resumeFile != null) {
        body['resume_upload'] = await MultipartFile.fromFile(
          resumeFile.path,
          filename: path.basename(resumeFile.path),
        );
      }

      // Profile Image (IMPORTANT)
      if (profileImage != null) {
        body['profile_pic'] = await MultipartFile.fromFile(
          profileImage.path,
          filename: path.basename(profileImage.path),
        );
      }

      final formData = FormData.fromMap(body);

      final response = await dio.post(url, data: formData);

      log("UPLOAD RESPONSE = ${response.data}");

      // final response = await dio.post(
      //   url,
      //   data: formData,
      // );
      // final formData = FormData.fromMap(data);

      // final response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        final box = await Hive.openBox('userdata');
        final userId = response.data['data']['id'].toString(); // Corrected
        await box.put('user_id', userId); // Use 'user_id' instead of 'token'
        Fluttertoast.showToast(
          msg: response.data['message'] ?? 'Profile updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        log('Profile update successful: ${response.data}');
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          error: response.data['message'] ?? 'Failed to update profile',
        );
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Failed to update profile';
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to update profile: $errorMessage');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to update profile: $e');
    }
  }
}
