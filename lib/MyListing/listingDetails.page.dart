import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/myListingController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Controller/userProfileController.dart';
import 'package:educationapp/coreFolder/Model/getCreateListModel.dart';
import 'package:educationapp/coreFolder/Model/sendRequestBodyModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/home/chating.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ListingDetailsPage extends ConsumerStatefulWidget {
  final Datum item;
  const ListingDetailsPage(this.item, {super.key});
  @override
  ConsumerState<ListingDetailsPage> createState() => _ListingDetailsPageState();
}

class _ListingDetailsPageState extends ConsumerState<ListingDetailsPage> {
  // bool hasApplied = false;
  bool isAccept = false;
  late int status;


  @override
  void initState() {
    super.initState();
    status = widget.item.status ?? 0;
  }

  double _getAmountInRupees(int coins) {
    return (coins * 0.1);
  }

  // Function: Rupees se Coins mein convert karega
  int _getCoinsFromRupees(double rupees) {
    // ₹1 = 10 coins → isliye rupees * 10
    return (rupees * 10).toInt(); // .toInt() se decimal hat jayega (safe rounding down)
  }

// Ya agar exact chahiye (decimal bhi allow karna ho toh double return karo)
// double _getCoinsFromRupees(double rupees) {
//   return rupees * 10;
// }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor:
          themeMode == ThemeMode.dark ? Colors.white : Color(0xFF008080),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back,
                color:
                    themeMode == ThemeMode.dark ? Colors.black : Colors.white)),
        backgroundColor:
            themeMode == ThemeMode.dark ? Colors.white : Color(0xFF008080),
        title: Text(
          "Student Requirements",
          style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: themeMode == ThemeMode.dark ? Colors.black : Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROFILE CARD
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: Image.network(
                      widget.item.student?.profilePic ??
                          "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                      height: 80.h,
                      width: 80.w,
                      fit: BoxFit.fill,
                      errorBuilder: (_, __, ___) {
                        return Image.network(
                          "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                          height: 80.h,
                          width: 80.w,
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.student?.fullName ?? "Student",
                          style: GoogleFonts.roboto(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          widget.item.education ?? "",
                          style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: Color.fromARGB(178, 0, 0, 0),
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(Icons.work_outline,
                                size: 18.sp, color: Colors.orange),
                            SizedBox(width: 4.w),
                            Text(
                              "${widget.item.experience}+ Years Experience",
                              style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.h),

            /// REQUIREMENT CARD
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Subjects Required",
                    style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: widget.item.subjects!
                        .map<Widget>(
                          (s) => Chip(
                            label: Text(
                              s,
                              style: GoogleFonts.roboto(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            backgroundColor: Color.fromARGB(225, 222, 221, 236),
                            side: BorderSide.none,
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 16.h),
                  // ================= TEACHING MODE =================
                  Row(
                    children: [
                      Icon(Icons.school, color: Colors.blue, size: 20.sp),
                      SizedBox(width: 6.w),
                      Text(
                        "Teaching Mode: ${widget.item.teachingMode ?? "N/A"}",
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

// ================= LOCATION =================
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 20.sp),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          "Location: Lucknow, ${widget.item.location ?? "N/A"}",
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

// ================= DURATION =================
                  Row(
                    children: [
                      Icon(Icons.timer, color: Colors.orange, size: 20.sp),
                      SizedBox(width: 6.w),
                      Text(
                        "Duration: ${widget.item.duration ?? "N/A"}",
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Icon(Icons.currency_rupee,
                          color: Colors.green, size: 20.sp),
                      SizedBox(width: 6.w),
                      Text(
                        "Budget: ₹${widget.item.fee}",
                        style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Description",
                    style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    widget.item.description ?? "",
                    style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        color: Color.fromARGB(178, 0, 0, 0),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            /// CONTACT SECTION (Mobile Number)
            // hasApplied
            status==1
                ? Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.phone, color: Colors.green, size: 22.sp),
                        SizedBox(width: 10.w),
                        Text(
                          widget.item.student?.phoneNumber ?? "N/A",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lock, color: Colors.grey),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            "Apply to unlock student's contact number",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            SizedBox(height: 20.h),

            /// ACTION BUTTONS (Mentor Side)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.chat,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed:   status==0
                        ? null
                        : () {
                            log("id : -  ${widget.item.id.toString()}");
                            log("Student id : -  ${widget.item.studentId.toString()}");
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ChatingPage(
                                      name: widget.item.student!.fullName ??
                                          "N/A",
                                      id: widget.item.id.toString(),
                                      otherUesrid:
                                          widget.item.studentId.toString()),
                                ));
                          },
                    label: Text(
                      "Chat Student",
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                status==1?SizedBox():
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),


                    onPressed: () async {
                      final profile = ref.read(userProfileController);

                      // Safety check
                      if (profile.value == null || profile.value!.data == null) {
                        Fluttertoast.showToast(msg: "Profile not loaded");
                        return;
                      }

                      // User ke paas kitne coins hain (String se double mein convert)
                      final String? userCoinsStr = profile.value!.data!.coins;
                      final double userCoins = double.tryParse(userCoinsStr ?? "0") ?? 0.0;

                      // Mentor apply ke liye kitni fee hai (rupees mein)
                      final double feeInRupees = double.tryParse(widget.item.fee ?? "0") ?? 0.0;

                      // Kitne coins chahiye is fee ke liye? (₹0.1 = 1 coin → ₹1 = 10 coins)
                      final int requiredCoins = (feeInRupees * 10).toInt(); // Ya function use karo niche diya hua

                      // Check karo: User ke paas kaafi coins hain ya nahi?
                      if (userCoins < requiredCoins) {
                        Fluttertoast.showToast(
                          msg: "Insufficient coins! You need $requiredCoins coins (₹$feeInRupees)",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                        return;
                      }

                      // Agar coins kaafi hain toh apply karo
                      final body = ApplybodyModel(
                        body: "Your Mentor apply",
                        title: "Hello",
                        userId: widget.item.studentId,
                      );

                      try {
                        setState(() {
                          isAccept = true;
                        });

                        final service = APIStateNetwork(createDio());
                        final response = await service.applyOrSendNotification(body);

                        if (response.response.data['success'] == true) {
                          Fluttertoast.showToast(
                            msg: "Applied successfully!",
                            backgroundColor: Colors.green,
                          );
                          setState(() {
                            status = 1; // 🔥 UI instantly refresh ho jayega
                          });

                          ref.invalidate(myListingController);
                        }

                        else {
                          Fluttertoast.showToast(
                            msg: response.response.data['message'] ?? "Application failed",
                          );
                        }
                      } catch (e, st) {
                        log("Apply Error: $e\nStackTrace: $st");
                        Fluttertoast.showToast(msg: "Something went wrong. Try again.");
                      } finally {
                        setState(() {
                          isAccept = false;
                        });
                      }
                    },
                    label: isAccept
                        ? Center(
                            child: SizedBox(
                              width: 25.w,
                              height: 25.h,
                              child: CircularProgressIndicator(
                                color: const Color.fromARGB(255, 96, 74, 74),
                                strokeWidth: 1.5,
                              ),
                            ),
                          )
                        : Text(
                            "Apply",
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),




          ],
        ),
      ),
    );
  }
}
