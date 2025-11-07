import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:educationapp/coreFolder/Model/login.body.model.dart';
import 'package:educationapp/coreFolder/Model/login.rsponse.model.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/home/home.page.dart';
import 'package:educationapp/splash/getstart.page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../complete/complete.page.dart';
import '../coreFolder/auth/login.auth.dart';
import '../register/register.page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff008080),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.5,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 343.h,
                        width: 392.w,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/loginBack.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 250.h,
                        width: 250.w,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/whitevector.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.5,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.w),
                    topRight: Radius.circular(40.w),
                  ),
                ),
                child: const RegisterForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false; // Renamed for clarity
  bool secure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await StoreData.clearData(ref);
    //   log("Data has been cleared");
    // });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<String> fcmGetToken() async {
    // ✅ Now request notification permissions
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      print('User declined permission');
      return "no_permission";
    }

    String? Fcmtoken = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $Fcmtoken');
    return Fcmtoken ?? "unknown_device";
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      final deviceToken = await fcmGetToken();

      try {
        final body = LoginBodyModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          deviceToken: deviceToken,
        );

        final service = APIStateNetwork(createDio());
        final response = await service.login(body);

        if (response.data != null) {
          final box = await Hive.openBox('userdata');
          await box.clear();
          await box.put('token', response.data!.token);
          await box.put('full_name', response.data!.fullName);
          await box.put('userType', response.data!.userType);
          await box.put('email', response.data!.email);
          await box.put('userid', response.data!.userid);

          Fluttertoast.showToast(msg: response.message!);
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (_) => HomePage(0)),
            (route) => false,
          );
        } else {
          // ✅ Clean failure handling for invalid credentials
          Fluttertoast.showToast(
            msg: response.message ?? "Invalid credentials",
            backgroundColor: Colors.purple,
          );
        }
      } on DioException catch (e) {
        final error = e.response!.data['error'];
        Fluttertoast.showToast(
          msg: error,
          backgroundColor: Colors.red,
        );
      } catch (e, st) {
        log("Login exception: $e\n$st");
        Fluttertoast.showToast(msg: "Unexpected error");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          Text(
            "Welcome Back !",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 26.w,
              letterSpacing: -0.95,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Don’t have an account? ",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.w,
                  letterSpacing: -0.50,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GetStartPAge(),
                    ),
                  );
                },
                child: Text(
                  "Sign up",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.w,
                    letterSpacing: -0.50,
                    color: const Color(0xff008080),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: const Divider(height: 1),
          ),
          SizedBox(height: 10.h),
          RegisterField(
            controller: emailController,
            label: 'Email Address',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email field required";
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return "Enter a valid email address";
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(right: 28.w, left: 28.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Password",
                      style: GoogleFonts.roboto(
                        fontSize: 13.w,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4D4D4D),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  controller: passwordController,
                  obscureText: secure,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            secure = !secure;
                          });
                        },
                        child: Icon(
                          secure ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF4D4D4D),
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password field required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          SizedBox(height: 15.h),
          GestureDetector(
            onTap: isLoading
                ? null
                : _handleLogin, // Disable button during loading
            child: Container(
              height: 52.h,
              width: 400.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.r),
                color: const Color(0xFFA8E6CF),
              ),
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 30.w,
                        height: 30.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : Text(
                        "Login",
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.4,
                          fontSize: 14.4.w,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class RegisterField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? type;
  final bool obscureText;
  final int? maxLine;
  final String? Function(String?)? validator;

  const RegisterField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.maxLine,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, right: 28.w, left: 28.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 13.w,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF4D4D4D),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            maxLines: maxLine,
            keyboardType: type,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(40.r),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(40.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}
