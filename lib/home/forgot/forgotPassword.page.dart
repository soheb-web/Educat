import 'dart:developer';

import 'package:educationapp/coreFolder/Model/sendOTPResModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/home/forgot/verify.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                    top: 0,
                    bottom: 0,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
              SizedBox(height: 20.h),
              Center(
                  child: Image.asset(
                "assets/appicon.png",
                width: 180.w,
                height: 180.h,
              )),
              SizedBox(height: 30.h),
              Divider(color: Colors.black12, thickness: 1),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  "Forget Your Password",
                  style: GoogleFonts.roboto(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B1B1B),
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                "Your Email Address",
                style: GoogleFonts.gothicA1(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF030016),
                ),
              ),
              SizedBox(height: 15.h),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 19.w,
                    right: 10.w,
                    top: 15.h,
                    bottom: 15.h,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    borderSide: BorderSide(
                        //color: _getLoginButtonColor(widget.title),
                        ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter email")),
                      );
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      final body =
                          sendOTPBodyModel(email: emailController.text);
                      final service = APIStateNetwork(createDio());
                      final response = await service.sendOTP(body);
                      if (response != null) {
                        Fluttertoast.showToast(msg: "OTP Send to your email");
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => OtpVerifyPage(email: emailController.text,),
                            ));
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        Fluttertoast.showToast(msg: "something went wrong");
                      }
                    } catch (e, st) {
                      setState(() {
                        isLoading = false;
                      });
                      Fluttertoast.showToast(msg: "Api Error : $e");
                      log("$e, $st");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA8E6CF),
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                  ),
                  child: isLoading
                      ? Center(
                          child: SizedBox(
                            width: 30.w,
                            height: 30.h,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1.5.w,
                            ),
                          ),
                        )
                      : Text(
                          "Reset Password",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
