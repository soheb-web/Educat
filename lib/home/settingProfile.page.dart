import 'package:educationapp/coreFolder/Model/passwordChangeBodyModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';

import 'package:hive/hive.dart';

class SettingProfilePage extends StatefulWidget {
  const SettingProfilePage({super.key});

  @override
  State<SettingProfilePage> createState() => _SettingProfilePageState();
}

class _SettingProfilePageState extends State<SettingProfilePage> {
  late TextEditingController fullNameController;
  late TextEditingController dobController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var box = Hive.box('userdata');
    final profileData = box.get('profile');
    final fullName = profileData['full_name'].toString();
    final dob = profileData['dob']?.toString() ?? "No Date of Birth";
    fullNameController = TextEditingController(text: fullName);
    dobController = TextEditingController(text: dob);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    dobController.dispose();
    super.dispose();
  }

  void showChangePasswordBottomSheet(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final repeatPasswordController = TextEditingController();
    bool isChange = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFFF9F9F9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20.w,
            right: 20.w,
            top: 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet Header
              Center(
                child: Container(
                  width: 50.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Center(
                child: Text(
                  "Password Change",
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Old Password
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 8,
                        spreadRadius: 0,
                        color: Color.fromARGB(12, 0, 0, 0),
                      )
                    ]),
                child: TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Old Password",
                    hintStyle: GoogleFonts.roboto(fontSize: 14.sp),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Align(
                alignment: AlignmentGeometry.centerRight,
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9B9B9B)),
                    )),
              ),
              SizedBox(height: 5.h),
              // New Password
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 8,
                        spreadRadius: 0,
                        color: Color.fromARGB(12, 0, 0, 0),
                      )
                    ]),
                child: TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "New Password",
                    hintStyle: GoogleFonts.roboto(fontSize: 14.sp),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),

              // Repeat New Password
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 8,
                        spreadRadius: 0,
                        color: Color.fromARGB(12, 0, 0, 0),
                      )
                    ]),
                child: TextField(
                  controller: repeatPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Repeat New Password",
                    hintStyle: GoogleFonts.roboto(fontSize: 14.sp),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.h),

              // Save Password Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff008080),
                  ),
                  onPressed: isChange
                      ? null
                      : () async {
                          final oldPass = oldPasswordController.text.trim();
                          final newPass = newPasswordController.text.trim();
                          final repeatPass =
                              repeatPasswordController.text.trim();

                          if (oldPass.isEmpty ||
                              newPass.isEmpty ||
                              repeatPass.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all fields"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (newPass != repeatPass) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Passwords do not match"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          try {
                            setState(() {
                              isChange = true;
                            });
                            final body = PasswordChangeBodyModel(
                                oldPassword: oldPass,
                                newPassword: newPass,
                                newPasswordConfirmation: repeatPass);
                            final service = APIStateNetwork(createDio());
                            final response = await service.passwordChange(body);
                            if (response != null) {
                              Fluttertoast.showToast(msg: response.message);
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(msg: response.message);
                            }
                          } catch (e, st) {
                            setState(() {
                              isChange = false;
                            });
                            log(e.toString());
                          } finally {
                            setState(() {
                              isChange = false;
                            });
                          }
                        },
                  child: isChange
                      ? Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.w,
                            ),
                          ),
                        )
                      : Text(
                          "Save Password",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 15.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    final profileImage = box.get('profile');
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              ],
            ),
            SizedBox(
              height: 25.h,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Settings",
                    style: GoogleFonts.inter(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF222222)),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Personal Information",
                    style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF222222)),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 8,
                            spreadRadius: 0,
                            color: Color.fromARGB(12, 0, 0, 0),
                          )
                        ]),
                    child: TextField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hint: Text(
                            "Full name",
                            style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9B9B9B)),
                          )),
                      onChanged: (value) {
                        var box = Hive.box('userdata');
                        box.put('fullName', value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 8,
                            spreadRadius: 0,
                            color: Color.fromARGB(12, 0, 0, 0),
                          )
                        ]),
                    child: TextField(
                      controller: dobController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hint: Text(
                            "Date of Birth",
                            style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9B9B9B)),
                          )),
                      onChanged: (value) {
                        var box = Hive.box('userdata');
                        box.put('dob', value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Password",
                        style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF222222)),
                      ),
                      InkWell(
                        onTap: () {
                          showChangePasswordBottomSheet(context);
                        },
                        child: Text(
                          "Change",
                          style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF9B9B9B)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 8,
                            spreadRadius: 0,
                            color: Color.fromARGB(12, 0, 0, 0),
                          )
                        ]),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hint: Text(
                            "*************",
                            style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9B9B9B)),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 35.h,
                  ),
                  Text(
                    "Notifications",
                    style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF222222)),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  MySwitchButton(
                    name: "Sales",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  MySwitchButton(
                    name: "New arrivals",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  MySwitchButton(
                    name: "Delivery status changes",
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class MySwitchButton extends StatefulWidget {
  final String name;
  const MySwitchButton({super.key, required this.name});

  @override
  State<MySwitchButton> createState() => _MySwitchButtonState();
}

class _MySwitchButtonState extends State<MySwitchButton> {
  bool isCheckt = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.name,
          style: GoogleFonts.inter(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF222222)),
        ),
        Spacer(),
        Transform.scale(
          scale: 0.7,
          child: Switch(
            activeColor: Color(0xFF008080),
            value: isCheckt,
            onChanged: (value) {
              setState(() {
                isCheckt = !isCheckt;
              });
            },
          ),
        )
      ],
    );
  }
}
