import 'dart:developer';
import 'package:educationapp/coreFolder/Model/verifyOrChangePassBodyModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/login/login.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

class OtpVerifyPage extends StatefulWidget {
  final String email;
  const OtpVerifyPage({super.key, required this.email});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  String otpValue = "";
  bool isLoading = false;
  bool isResending = false; // Added to track resend OTP loading state
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  final newpasswordController = TextEditingController();
  final confirmedPassController = TextEditingController();

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
              SizedBox(height: 10.h),
              Center(
                  child: Image.asset(
                "assets/appicon.png",
                width: 170.w,
                height: 170.h,
              )),
              SizedBox(height: 30.h),
              Divider(color: Colors.black12, thickness: 1),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  "Enter OTP Code",
                  style: GoogleFonts.roboto(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B1B1B),
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              OtpPinField(
                key: _otpPinFieldController,
                maxLength: 6,
                fieldHeight: 55.h,
                fieldWidth: 55.w,
                keyboardType: TextInputType.number,
                otpPinFieldDecoration: OtpPinFieldDecoration.custom,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                onSubmit: (text) {
                  otpValue = text;
                },
                onChange: (text) {},
              ),
              SizedBox(height: 20.h),
              if (otpValue.length == 6)
                Column(
                  children: [
                    Text(
                      "New Password",
                      style: GoogleFonts.gothicA1(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF030016),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: newpasswordController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 19.w,
                          right: 10.w,
                          top: 15.h,
                          bottom: 15.h,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide: BorderSide(
                              //  color: _getLoginButtonColor(widget.title),
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      "Confirmed Password",
                      style: GoogleFonts.gothicA1(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF030016),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: confirmedPassController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 19.w,
                          right: 10.w,
                          top: 15.h,
                          bottom: 15.h,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide: BorderSide(
                              //color: _getLoginButtonColor(widget.title),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (newpasswordController.text.trim().isEmpty ||
                        confirmedPassController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please fill in all fields."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (newpasswordController.text.trim() !=
                        confirmedPassController.text.trim()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Password do not match"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      final body = verifyORChangePasswordBodyModel(
                          email: widget.email,
                          otp: otpValue,
                          password: newpasswordController.text,
                          passwordConfirmation: confirmedPassController.text);

                      final service = APIStateNetwork(createDio());
                      final response = await service.verifyORChangePass(body);
                      if (response != null) {
                        Fluttertoast.showToast(
                            msg: "Password Change Sucessfull");
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        Fluttertoast.showToast(msg: "Somethig went wrong");
                      }
                    } catch (e, st) {
                      log("${e.toString()} /n ${st.toString()}");
                      Fluttertoast.showToast(msg: "APi Error $e");
                      setState(() {
                        isLoading = false;
                      });
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
                              color: Colors.black,
                              strokeWidth: 1.5,
                            ),
                          ),
                        )
                      : Text(
                          "Verify",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      isResending = true;
                    });
                    // try {
                    //   final body = VerifyOtpBodyModel(
                    //     email: widget.email,
                    //     otp: otpValue,
                    //   );

                    //   final service = APIStateNetwork(createDio());
                    //   final response = await service.verifyOTP(body);

                    //   // SUCCESS – status 200
                    //   if (response != null) {
                    //     setState(() => isLoading = false);

                    //     Fluttertoast.showToast(
                    //       msg: "OTP Verified Successfully",
                    //     );
                    //   }
                    //   // RESPONSE FALSE
                    //   else {
                    //     setState(() => isLoading = false);

                    //     Fluttertoast.showToast(
                    //       msg: response?.message ?? "Something went wrong",
                    //     );
                    //   }
                    // } on DioException catch (e) {
                    //   setState(() => isLoading = false);

                    //   final serverMessage =
                    //       e.response?.data?["message"] ?? "Invalid OTP";

                    //   Fluttertoast.showToast(msg: serverMessage);
                    // } catch (e) {
                    //   setState(() => isLoading = false);

                    //   Fluttertoast.showToast(msg: "Error: $e");
                    // }
                  },
                  child: isResending
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Resend OTP",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            //color: _getLoginButtonColor(widget.title),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
