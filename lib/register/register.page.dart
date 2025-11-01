import 'dart:developer';
import 'package:educationapp/login/login.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../coreFolder/auth/login.auth.dart';
import '../main.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});
  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff008080),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200.h,
                      width: 323.w,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/resisterBack.png"),
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
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: const RegisterForm(),
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
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool buttonLoader = false;
  final _formKey = GlobalKey<FormState>();
  bool register = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formData = ref.watch(formDataProvider);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          Text(
            "Create Your Account",
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
                "Already have an account? ",
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
                    CupertinoPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text(
                  "Login",
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
            controller: fullNameController,
            label: 'Full Name',
            validator: (value) =>
                value!.isEmpty ? "Full Name is required" : null,
          ),
          RegisterField(
            controller: emailController,
            label: 'Email Address',
            validator: (value) {
              if (value!.isEmpty) return "Email is required";
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
          SizedBox(height: 18.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 30.w),
              Text(
                "Phone Number",
                style: GoogleFonts.roboto(
                  fontSize: 13.w,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF4D4D4D),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 28.w, right: 28.w, top: 10.h),
            child: IntlPhoneField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: "XXXXXXXXXXX",
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
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
              initialCountryCode: 'IN',
              invalidNumberMessage: "Invalid phone number",
              onChanged: (phone) {
                log("Phone Number: ${phone.completeNumber}");
              },
            ),
          ),
          RegisterField(
            controller: passwordController,
            label: 'Password',
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) return "Password is required";
              if (value.length < 6)
                return "Password must be at least 6 characters";
              return null;
            },
          ),
          RegisterField(
            controller: confirmPasswordController,
            label: 'Confirm Password',
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) return "Confirm Password is required";
              if (value != passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: buttonLoader
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        buttonLoader = true; // show loader
                      });
                      try {
                        await Auth.register(
                            emailController.text,
                            passwordController.text,
                            fullNameController.text,
                            phoneController.text,
                            formData.serviceType ?? "Opportunities",
                            formData.userType ?? "Professional",
                            context);
                      } catch (e) {
                        setState(() {
                          buttonLoader = false;
                        });
                        Fluttertoast.showToast(msg: e.toString());
                        log("Register Error $e");
                      } finally {
                        setState(() => buttonLoader = false);
                      }
                    }
                  },
            child: Container(
              height: 52.h,
              width: 400.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.r),
                color: const Color(0xFFA8E6CF),
              ),
              child: Center(
                child: buttonLoader
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        "Register Now",
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
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

class RegisterField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  const RegisterField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
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
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
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
            validator: validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return "$label field required";
                  }
                  return null;
                },
          ),
        ],
      ),
    );
  }
}
