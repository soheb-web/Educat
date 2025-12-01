// import 'dart:developer';
// import 'package:educationapp/firebase_options.dart';
// import 'package:educationapp/home/home.page.dart';
// import 'package:educationapp/splash/splash.page.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   await Hive.initFlutter();
//   await Hive.openBox('userdata');

//   // try {
//   //   await Hive.initFlutter();
//   //   if (!Hive.isBoxOpen('userdata')) {
//   //     await Hive.openBox('userdata');
//   //   }
//   // } catch (e) {
//   //   log("Hive initialization failed: $e");
//   // }

//   runApp(const ProviderScope(child: MyApp()));
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var box = Hive.box('userdata');
//     var token = box.get('token');
//     log(token ?? "No token found");
//     return ScreenUtilInit(
//       designSize: const Size(440, 956),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp(
//           navigatorKey: navigatorKey,
//           home: token == null ? const SplashScreen() : HomePage(0),
//         );
//       },
//     );
//   }
// }

// class MyFormDataModel {
//   final String userType;
//   final String serviceType;
//   final String skillId;

//   MyFormDataModel({
//     required this.userType,
//     required this.serviceType,
//     required this.skillId,
//   });

//   MyFormDataModel copyWith({
//     String? userType,
//     String? serviceType,
//     String? skillId,
//   }) {
//     return MyFormDataModel(
//       userType: userType ?? this.userType,
//       serviceType: serviceType ?? this.serviceType,
//       skillId: skillId ?? this.skillId,
//     );
//   }
// }

// class FormDataNotifier extends StateNotifier<MyFormDataModel> {
//   FormDataNotifier()
//       : super(MyFormDataModel(userType: '', serviceType: '', skillId: ''));

//   void updateUserType(String userType) {
//     state = state.copyWith(userType: userType);
//   }

//   void updateServiceType(String serviceType) {
//     state = state.copyWith(serviceType: serviceType);
//   }

//   void updateSkillId(String skillId) {
//     state = state.copyWith(skillId: skillId);
//   }
// }

// final formDataProvider =
//     StateNotifierProvider<FormDataNotifier, MyFormDataModel>((ref) {
//   return FormDataNotifier();
// });

import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:educationapp/coreFolder/utils/globalroute.key.dart';
import 'package:educationapp/firebase_options.dart';
import 'package:educationapp/home/home.page.dart';
import 'package:educationapp/home/noInternetScreen.dart';
import 'package:educationapp/login/login.page.dart';
import 'package:educationapp/splash/splash.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen('userdata')) {
      await Hive.openBox('userdata');
    }
  } catch (e) {
    log("Hive initialization failed: $e");
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;

  @override
  void initState() {
    super.initState();
    _checkToken();
    _setupConnectivityListener(); // नया फंक्शन
  }

  void _setupConnectivityListener() {
    _subscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        // समस्या यहाँ थी: results.isEmpty की जगह results.first == ConnectivityResult.none
        // 'results.isEmpty' हमेशा false होगा क्योंकि 'results' में कम से कम एक ConnectivityResult होगी।
        // 'results.first != ConnectivityResult.none' का मतलब है कि इंटरनेट है।

        final bool hasNoInternet = results.contains(ConnectivityResult.none);

        if (hasNoInternet) {
          log("⚠️ No Internet connection detected - navigating to NoInternetScreen");
          // Pushing the route to show the No Internet screen
          // Use 'pushNamed' instead of 'push' for named routes
          navigatorKey.currentState?.pushNamed("/NoInternetScreen");
        } else {
          log("✅ Internet connection restored - popping NoInternetScreen if it's on top");
          // Check if the current route is NoInternetScreen before popping
          // A safer check is to simply pop, as it won't crash if it can't pop.
          // However, using canPop and ensuring we're not popping the main route is good practice.

          // You may need a better check than just 'canPop' to ensure you're popping *only* the NoInternetScreen,
          // but for simplicity, we'll use a delayed pop.

          Future.delayed(
            const Duration(
                seconds:
                    1), // Delay to ensure the pop happens after the route is fully built
            () {
              // This logic should ideally pop the specific route if it's the one we pushed.
              // Since routes are pushed on top, a simple check to see if we can pop is often enough in a simple setup.
              if (navigatorKey.currentState?.canPop() == true) {
                // Pop the last route (which is expected to be NoInternetScreen)
                navigatorKey.currentState?.pop();
              }
            },
          );
        }
      },
    );
  }

  Future<void> _checkToken() async {
    var box = Hive.box('userdata');
    var savedToken = box.get('token');

    if (savedToken == null) {
      log("🔴 No token found — will show LoginPage");
      setState(() => token = null);
      return;
    }

    log("🟢 Found saved token: $savedToken");

    // Optional: validate token by pinging a simple endpoint or decode JWT
    final isExpired = await _isTokenExpired(savedToken);

    if (isExpired) {
      log("⚠️ Token is expired — clearing Hive and showing LoginPage");
      await box.delete('token');
      await box.flush();
      setState(() => token = null);
    } else {
      log("✅ Token is valid — proceed to HomePage");
      setState(() => token = savedToken);
    }
  }

  Future<bool> _isTokenExpired(String token) async {
    try {
      // Simple example — you can decode JWT or call /me API to verify
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload = String.fromCharCodes(
        Uri.decodeFull(parts[1]).codeUnits.map((e) => e).toList(),
      );
      // You could also add logic to check "exp" claim if available.
      return false;
    } catch (e) {
      log("Token validation failed: $e");
      return true;
    }
  }

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF1B1B1B),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: ScreenUtilInit(
          designSize: const Size(440, 956),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, __) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              home: token == null ? const SplashScreen() : HomePage(0),
              routes: {"/NoInternetScreen": (context) => NoInternetScreen()},
            );
          },
        ),
      ),
    );
  }
}

class MyFormDataModel {
  final String userType;
  final String serviceType;
  final String skillId;

  MyFormDataModel({
    required this.userType,
    required this.serviceType,
    required this.skillId,
  });

  MyFormDataModel copyWith({
    String? userType,
    String? serviceType,
    String? skillId,
  }) {
    return MyFormDataModel(
      userType: userType ?? this.userType,
      serviceType: serviceType ?? this.serviceType,
      skillId: skillId ?? this.skillId,
    );
  }
}

class FormDataNotifier extends StateNotifier<MyFormDataModel> {
  FormDataNotifier()
      : super(MyFormDataModel(userType: '', serviceType: '', skillId: ''));

  void updateUserType(String userType) {
    state = state.copyWith(userType: userType);
  }

  void updateServiceType(String serviceType) {
    state = state.copyWith(serviceType: serviceType);
  }

  void updateSkillId(String skillId) {
    state = state.copyWith(skillId: skillId);
  }
}

final formDataProvider =
    StateNotifierProvider<FormDataNotifier, MyFormDataModel>((ref) {
  return FormDataNotifier();
});
