import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({
    super.key,
  });

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final newpasswordController = TextEditingController();
  final confirmedPassController = TextEditingController();
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
                  "Confirm Password",
                  style: GoogleFonts.roboto(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B1B1B),
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
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
                    borderSide: BorderSide(color: Colors.black, width: 1.w),
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
                    borderSide: BorderSide(color: Colors.black, width: 1.w),
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
                    // try {
                    //   final body = PasswordChangeBodyModel(
                    //     email: widget.emal,
                    //     password: newpasswordController.text,
                    //     passwordConfirmation: confirmedPassController.text,
                    //   );
                    //   final service = APIStateNetwork(createDio());
                    //   final response = await service.passwordChange(body);
                    //   if (response != null) {
                    //     Fluttertoast.showToast(msg: response.message);
                    //     Navigator.pushAndRemoveUntil(
                    //       context,
                    //       CupertinoPageRoute(
                    //         builder: (context) => LoginPage(widget.title),
                    //       ),
                    //       (route) => false,
                    //     );
                    //     setState(() {
                    //       isLoading = false;
                    //     });
                    //   } else {
                    //     Fluttertoast.showToast(msg: response.message);
                    //     setState(() {
                    //       isLoading = false;
                    //     });
                    //   }
                    // } catch (e) {
                    //   setState(() {
                    //     isLoading = false;
                    //   });
                    //   log(e.toString());
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    //  backgroundColor: _getLoginButtonColor(widget.title),
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                  ),
                  child: isLoading
                      ? Center(
                          child: SizedBox(
                            width: 30.w,
                            height: 30.h,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1.5,
                            ),
                          ),
                        )
                      : Text(
                          "Change Password",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
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
