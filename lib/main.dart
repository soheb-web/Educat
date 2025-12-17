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
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/utils/globalroute.key.dart';
import 'package:educationapp/firebase_options.dart';
import 'package:educationapp/home/home.page.dart';
import 'package:educationapp/home/noInternetScreen.dart';
import 'package:educationapp/login/login.page.dart';
import 'package:educationapp/splash/splash.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("BG Notification: ${message.notification?.title}");
}

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

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  String? token;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void initState() {
    super.initState();
    _checkToken();
    _setupConnectivityListener();
  }

  void _setupConnectivityListener() {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final hasNoInternet = results.contains(ConnectivityResult.none);

      if (hasNoInternet) {
        log("⚠️ No Internet");

        // **CHANGE: Add check to avoid pushing multiples (consistent with Dio interceptor)**
        Future.microtask(() {
          final navState = navigatorKey.currentState;
          final isNavigatingToNoInternet = navState?.context
                  .findAncestorWidgetOfExactType<NoInternetScreen>() !=
              null;

          if (navState != null &&
              navState.context.mounted &&
              !isNavigatingToNoInternet) {
            navState.pushNamed("/NoInternetScreen");
          } else {
            log("⚠️ Navigation skipped: Already on NoInternet page or context unmounted.");
          }
        });
      } else {
        log("✅ Internet Restored");

        // **CHANGE: Simplified to always pop if possible (now safe since stack isn't cleared)**
        Future.delayed(const Duration(milliseconds: 300), () {
          if (navigatorKey.currentState?.canPop() ?? false) {
            navigatorKey.currentState?.pop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel(); // IMPORTANT FIX
    super.dispose();
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
    final themeModeProvider = ref.watch(themeProvider);
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
              themeMode: themeModeProvider,
              theme: ThemeData.light(), // light
              darkTheme: ThemeData.dark(), // dark
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
