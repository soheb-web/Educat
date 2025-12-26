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
import 'package:intl/intl.dart';

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
    return (rupees * 10)
        .toInt(); // .toInt() se decimal hat jayega (safe rounding down)
  }

  String timeAgoFromTime(String timeString) {
    try {
      DateTime now = DateTime.now();

      // "7:00 PM" parse karo
      DateTime parsedTime = DateFormat("h:mm a").parse(timeString);

      // Aaj ki date ke saath time set karo
      DateTime postDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );

      Duration difference = now.difference(postDateTime);

      if (difference.inMinutes < 1) {
        return "Just now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes} min ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} hour ago";
      } else {
        return "${difference.inDays} day ago";
      }
    } catch (e) {
      return timeString; // fallback
    }
  }

  String timeAgo(String dateTimeString) {
    DateTime postTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();

    Duration diff = now.difference(postTime);

    if (diff.inSeconds < 60) {
      return "Just now";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} min ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} hour ago";
    } else if (diff.inDays < 7) {
      return "${diff.inDays} day ago";
    } else if (diff.inDays < 30) {
      return "${(diff.inDays / 7).floor()} week ago";
    } else if (diff.inDays < 365) {
      return "${(diff.inDays / 30).floor()} month ago";
    } else {
      return "${(diff.inDays / 365).floor()} year ago";
    }
  }

  String createAtago(String dateTimeString) {
    DateTime postTime = DateTime.parse(dateTimeString); // ISO string parse
    DateTime now = DateTime.now();

    Duration diff = now.difference(postTime);

    if (diff.inSeconds < 60) {
      return "Just now";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} min ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} hour ago";
    } else if (diff.inDays < 7) {
      return "${diff.inDays} day ago";
    } else if (diff.inDays < 30) {
      return "${(diff.inDays / 7).floor()} week ago";
    } else if (diff.inDays < 365) {
      return "${(diff.inDays / 30).floor()} month ago";
    } else {
      return "${(diff.inDays / 365).floor()} year ago";
    }
  }

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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 20.sp),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          "Location : ${widget.item.localAddress ?? ''} ${widget.item.state} India ${widget.item.pincode}",
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.date_range_outlined,
                          color: Colors.grey, size: 20.sp),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          // "Posted : ${widget.item.time ?? ''}",
                          "Posted : ${timeAgo(widget.item.createdAt.toString())}",
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(Icons.school, color: Colors.blue, size: 20.sp),
                      SizedBox(width: 6.w),
                      Text(
                        "Leval : ${widget.item.education ?? "N/A"}",
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),
                  // ================= TEACHING MODE =================
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.green, size: 20.sp),
                      SizedBox(width: 6.w),
                      Text(
                        "Requires : ${widget.item.requires ?? "N/A"}",
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),
                  // ================= TEACHING MODE =================
                  Row(
                    children: [
                      Icon(Icons.person_2_outlined,
                          color: Colors.deepPurple, size: 20.sp),
                      SizedBox(width: 6.w),
                      Text(
                        "Posted By : ${widget.item.student!.fullName ?? "N/A"} (Student)",
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Icon(Icons.people_outline_outlined,
                          color: Colors.black, size: 20.sp),
                      SizedBox(width: 6.w),
                      Text(
                        "Gender Preference : ${widget.item.gender ?? "None"}",
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Icon(Icons.monetization_on,
                          color: Colors.amber, size: 20.sp),
                      SizedBox(width: 6.w),
                      Text(
                        "Coins : ",
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 10.h,
                  ),
                  if (widget.item.teachingMode != null)
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.brown, size: 20.sp),
                        SizedBox(width: 6.w),
                        Text(
                          "Available : ${widget.item.teachingMode ?? "None"}",
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
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
                        "Duration : ${widget.item.duration ?? "N/A"}",
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  if (widget.item.mobileNumber != null)
                    Row(
                      children: [
                        Icon(Icons.phone_android,
                            color: Colors.blueGrey, size: 20.sp),
                        SizedBox(width: 6.w),
                        Text(
                          "Phone : ${widget.item.mobileNumber ?? ""}",
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 10.h,
                  ),
                  if (widget.item.communicate != null)
                    Row(
                      children: [
                        Icon(Icons.message,
                            color: Colors.deepOrange, size: 20.sp),
                        SizedBox(width: 6.w),
                        Text(
                          "Can Communicate in : ${widget.item.communicate ?? ""}",
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
                        "Budget : ₹${(double.tryParse(widget.item.budget ?? '0') ?? 0).toInt()}",
                        style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            /// CONTACT SECTION (Mobile Number)
            // hasApplied
            status == 1
                ? Column(
                    children: [
                      InkWell(
                        onTap: status == 0
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
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.h),
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.email, color: Colors.white),
                              SizedBox(width: 10.w),
                              Text(
                                "Message",
                                style: GoogleFonts.inter(
                                    fontSize: 18.sp, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20.h),
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.phone, color: Colors.white),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                "phone number ${widget.item.student!.phoneNumber ?? ""}",
                                style: GoogleFonts.inter(
                                    fontSize: 14.sp, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20.h),
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.email, color: Colors.white),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                "Message & view phone number (${(double.tryParse(widget.item.budget ?? '0') ?? 0).toInt()} coins)",
                                style: GoogleFonts.inter(
                                    fontSize: 14.sp, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20.h),
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.phone, color: Colors.white),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                "view phone number (${(double.tryParse(widget.item.budget ?? '0') ?? 0).toInt()} coins)",
                                style: GoogleFonts.inter(
                                    fontSize: 14.sp, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 20.h),

            /// ACTION BUTTONS (Mentor Side)
            Row(
              children: [
                status == 1
                    ? SizedBox()
                    : Expanded(
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
                            if (profile.value == null ||
                                profile.value!.data == null) {
                              Fluttertoast.showToast(msg: "Profile not loaded");
                              return;
                            }

                            // User ke paas kitne coins hain (String se double mein convert)
                            final String? userCoinsStr =
                                profile.value!.data!.coins;
                            final double userCoins =
                                double.tryParse(userCoinsStr ?? "0") ?? 0.0;

                            // Mentor apply ke liye kitni fee hai (rupees mein)
                            final double feeInRupees =
                                double.tryParse(widget.item.budget ?? "0") ??
                                    0.0;

                            // Kitne coins chahiye is fee ke liye? (₹0.1 = 1 coin → ₹1 = 10 coins)
                            // final int requiredCoins = (feeInRupees * 10)
                            //     .toInt(); // Ya function use karo niche diya hua

                            // Check karo: User ke paas kaafi coins hain ya nahi?
                            if (userCoins < feeInRupees) {
                              Fluttertoast.showToast(
                                msg:
                                    "Insufficient coins! You need $feeInRupees coins (₹$feeInRupees)",
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                              return;
                            }

                            // Agar coins kaafi hain toh apply karo
                            final body = ApplybodyModel(
                              body:
                                  "A mentor has applied to your request. Check details now!",
                              title: "Mentor Application",
                              userId: widget.item.studentId,
                            );

                            try {
                              setState(() {
                                isAccept = true;
                              });

                              final service = APIStateNetwork(createDio());
                              final response =
                                  await service.applyOrSendNotification(body);

                              if (response.response.data['success'] == true) {
                                Fluttertoast.showToast(
                                  msg: "Applied successfully!",
                                  backgroundColor: Colors.green,
                                );
                                setState(() {
                                  status =
                                      1; // 🔥 UI instantly refresh ho jayega
                                });

                                ref.invalidate(myListingController);
                              } else {
                                Fluttertoast.showToast(
                                  msg: response.response.data['message'] ??
                                      "Application failed",
                                );
                              }
                            } catch (e, st) {
                              log("Apply Error: $e\nStackTrace: $st");
                              Fluttertoast.showToast(
                                  msg: "Something went wrong. Try again.");
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
                                      color:
                                          const Color.fromARGB(255, 96, 74, 74),
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
