// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:educationapp/login/login.page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hive/hive.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// import 'globalroute.key.dart';
// final dioProvider = FutureProvider<Dio>((ref) async {
//   return await createDio();
// });
// Dio createDio() {
//   final dio = Dio();
//   // dio.interceptors.add(
//   //   PrettyDioLogger(
//   //     requestBody: true,
//   //     requestHeader: true,
//   //     responseBody: true,
//   //     responseHeader: false,
//   //   ),
//   // );
//   dio.interceptors.add(
//     InterceptorsWrapper(
//       onRequest: (options, handler) {
//         var box = Hive.box("userdata");
//         var token = box.get("token");
//         options.headers.addAll({
//           'Accept': 'application/json',
//           if (token != null) 'Authorization': 'Bearer $token',
//         });
//         handler.next(options);
//       },
//       onError: (DioException e, handler) async {
//         final context = navigatorKey.currentState?.context;
//         final statusCode = e.response?.statusCode;
//         final errorData = e.response?.data;
//         String errorMessage = "Something went wrong";
//         if (errorData is Map<String, dynamic>) {
//           // Check for Laravel-like validation error format
//           if (errorData.containsKey('errors')) {
//             final errors = errorData['errors'] as Map<String, dynamic>;
//             final allMessages = <String>[];
//             errors.forEach((key, value) {
//               if (value is List) {
//                 allMessages.addAll(value.map((v) => "$v"));
//               } else {
//                 allMessages.add(value.toString());
//               }
//             });
//             // Join all messages with newline
//             errorMessage = allMessages.join('\n');
//           } else if (errorData.containsKey('message')) {
//             errorMessage = errorData['message'].toString();
//           }
//         }
//         log("API ERROR: ($statusCode) : $errorMessage");
//         Fluttertoast.showToast(
//           msg: errorMessage,
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.TOP,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 13.0,
//         );
//         if (statusCode == 401) {
//           // final box = Hive.box("userdata");
//           // await box.delete("token");
//           // await box.flush();
//           // Fluttertoast.showToast(
//           //   msg: "Session expired, please login again",
//           //   backgroundColor: Colors.orange,
//           // );
//           // Future.microtask(() {
//           //   final navState = navigatorKey.currentState;
//           //   if (navState != null) {
//           //     log("✅ Navigator found, redirecting to login");
//           //     navState.pushAndRemoveUntil(
//           //       CupertinoPageRoute(builder: (_) => const LoginPage()),
//           //       (route) => false,
//           //     );
//           //   } else {
//           //     log("❌ Navigator was null, retrying navigation...");
//           //     /// retry after short delay
//           //     Future.delayed(const Duration(seconds: 1), () {
//           //       final retryNav = navigatorKey.currentState;
//           //       if (retryNav != null) {
//           //         retryNav.pushAndRemoveUntil(
//           //           CupertinoPageRoute(builder: (_) => const LoginPage()),
//           //           (route) => false,
//           //         );
//           //         log("✅ Navigation successful on retry");
//           //       } else {
//           //         log("❌ Navigator still null after retry");
//           //       }
//           //     });
//           //   }
//           // });
//           final path = e.requestOptions.path;
//           // ✅ Skip handling for login API (only handle post-login token expiry)
//           if (!path.contains('/login')) {
//             final box = Hive.box("userdata");
//             await box.delete("token");
//             await box.flush();
//             Fluttertoast.showToast(
//               msg: "Session expired, please login again",
//               backgroundColor: Colors.orange,
//             );
//             Future.microtask(() {
//               final navState = navigatorKey.currentState;
//               if (navState != null) {
//                 navState.pushAndRemoveUntil(
//                   CupertinoPageRoute(builder: (_) => const LoginPage()),
//                   (route) => false,
//                 );
//               } else {
//                 log("❌ Navigator was null, retrying navigation...");
//                 Future.delayed(const Duration(seconds: 1), () {
//                   final retryNav = navigatorKey.currentState;
//                   if (retryNav != null) {
//                     retryNav.pushAndRemoveUntil(
//                       CupertinoPageRoute(builder: (_) => const LoginPage()),
//                       (route) => false,
//                     );
//                     log("✅ Navigation successful on retry");
//                   } else {
//                     log("❌ Navigator still null after retry");
//                   }
//                 });
//               }
//             });
//           }
//         }
//         handler.next(e);
//       },
//       onResponse: (response, handler) {
//         handler.next(response);
//       },
//     ),
//   );
//   dio.interceptors.add(
//     PrettyDioLogger(
//       requestBody: true,
//       requestHeader: true,
//       responseBody: true,
//       responseHeader: false,
//     ),
//   );
//   return dio;
// }



import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:educationapp/home/noInternetScreen.dart';
import 'package:educationapp/login/login.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'globalroute.key.dart';

final dioProvider = FutureProvider<Dio>((ref) async {
  return createDio();
});

Dio createDio() {
  final dio = Dio();

  // Helper function for Toast
  void showToast(String msg,
      {Color? color, ToastGravity gravity = ToastGravity.TOP}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      backgroundColor: color ?? Colors.red,
      textColor: Colors.white,
      fontSize: 13.0,
    );
  }

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // **✅ सुधार 1: हर रिक्वेस्ट पर Hive से token लें**
        var box = Hive.box("userdata");
        var token = box.get("token");

        options.headers.addAll({
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        });
        handler.next(options);
      },
      onResponse: (response, handler) => handler.next(response),
      onError: (DioException e, handler) async {
        final statusCode = e.response?.statusCode;
        final path = e.requestOptions.path;
        final errorData = e.response?.data;
        String errorMessage = "Something went wrong";

        // 🔥 1. Internet OFF error
        if (e.type == DioExceptionType.connectionError ||
            e.error.toString().contains("SocketException")) {
          Future.microtask(() {
            final navState = navigatorKey.currentState;

            final isNavigatingToNoInternet = navState?.context
                    .findAncestorWidgetOfExactType<NoInternetScreen>() !=
                null;

            if (navState != null &&
                navState.context.mounted &&
                !isNavigatingToNoInternet) {
              // **CHANGE: Simple push() instead of pushAndRemoveUntil to avoid clearing stack**
              navState.push(
                CupertinoPageRoute(builder: (_) => NoInternetScreen()),
              );
            } else {
              log("⚠️ Navigation skipped: Already on NoInterNet page or context unmounted.");
            }
          });
          handler.next(e);
          return;
        }

        // 🔥 2. Timeout errors
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          showToast("Connection timeout. Please try again.");
          handler.next(e);
          return;
        }

        // 🔥 3. Server unreachable
        if (e.error.toString().contains("Failed host lookup")) {
          showToast("Server unreachable. Check connection.");
          handler.next(e);
          return;
        }

        log("❌ API ERROR: ($statusCode) on $path");

        // Error message parsing logic (kept for 422, etc.)
        if (errorData is Map<String, dynamic>) {
          if (errorData.containsKey('errors')) {
            final errors = errorData['errors'] as Map<String, dynamic>;
            final allMessages = <String>[];
            errors.forEach((key, value) {
              if (value is List) {
                allMessages.addAll(value.map((v) => "$v"));
              } else {
                allMessages.add(value.toString());
              }
            });
            errorMessage = allMessages.join('\n');
          } else if (errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          }
        }

        // --- 401 Unauthorized Handling ---
        if (statusCode == 401) {
          // **✅ सुधार 2: केवल उन API कॉल के लिए 401 हैंडल करें जो login/refresh API नहीं हैं**
          if (!path.contains('/login') && !path.contains('/refresh')) {
            final box = Hive.box("userdata");
            // Token delete करने से पहले toast दिखाएँ
            showToast("Session expired, please login again",
                color: Colors.orange, gravity: ToastGravity.BOTTOM);

            await box.delete("token");
            await box.flush();
            log("Token cleared due to 401 error.");

            // **✅ सुधार 3: Navigator को मुख्य thread पर और सुरक्षित तरीके से चलाएँ**
            Future.microtask(() {
              final navState = navigatorKey.currentState;
              // सुनिश्चित करें कि हम पहले से ही LoginPage पर नहीं जा रहे हैं।
              // क्योंकि 401 error एक साथ कई जगह से आ सकता है।
              final isNavigatingToLogin = navState?.context
                      .findAncestorWidgetOfExactType<LoginPage>() !=
                  null;

              if (navState != null &&
                  navState.context.mounted &&
                  !isNavigatingToLogin) {
                log("✅ Redirecting to login page...");
                navState.pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              } else {
                log("⚠️ Navigation skipped: Already on login page or context unmounted.");
              }
            });
          }
          // 401 के मामले में, हम यहाँ handler.next(e) कॉल नहीं करेंगे यदि हम नेविगेट कर रहे हैं
          // ताकि calling function को error न मिले और UI पर कोई असर न पड़े।
          // लेकिन Dio Interceptor API के अनुसार, हमें 'handler.next' कॉल करना चाहिए।
        }

        // --- General Error Toast ---
        // 401 Unauthorized error के लिए हमने Toast ऊपर दिखा दिया है,
        // इसलिए बाकि errors के लिए Toast दिखाएँ:
        if (statusCode != 401) {
          showToast(errorMessage);
        }

        // एरर को आगे बढ़ाएँ (calling function में error throw होगा)
        handler.next(e);
        return; // Return added to explicitly exit the onError function
      },
    ),
  );

  // PrettyDioLogger को InterceptorWrapper के बाद रखें ताकि log में अंतिम state दिखे
  dio.interceptors.add(
    PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: false,
    ),
  );

  return dio;
}
