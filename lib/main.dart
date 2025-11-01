// import 'dart:developer';
// import 'package:educationapp/firebaseOption.dart';
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
//   await Firebase.initializeApp();

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

import 'dart:developer';
import 'package:educationapp/coreFolder/utils/globalroute.key.dart';
import 'package:educationapp/firebase_options.dart';
import 'package:educationapp/home/home.page.dart';
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF1B1B1B),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: ScreenUtilInit(
        designSize: const Size(440, 956),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            home: token == null ? const SplashScreen() : HomePage(0),
          );
        },
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
