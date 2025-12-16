import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/getMentorReveiwController.dart';
import 'package:educationapp/coreFolder/Controller/getRequestStudentController.dart';
import 'package:educationapp/coreFolder/Controller/reviewController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/sendRequestBodyModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/home/chating.page.dart';
import 'package:educationapp/home/mentorAddReview.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../coreFolder/Controller/profileController.dart';

class MentorDetailPage extends ConsumerStatefulWidget {
  final int id;
  MentorDetailPage({super.key, required this.id});

  @override
  ConsumerState<MentorDetailPage> createState() => _MentorDetailPageState();
}

class _MentorDetailPageState extends ConsumerState<MentorDetailPage> {
  bool isLoading = false;

  Future<void> sendConnectRequest() async {
    setState(() {
      isLoading = true;
    });
    try {
      final body = SendRequestBodyModel(mentorId: widget.id);
      final service = APIStateNetwork(createDio());
      final response = await service.studentSendRequest(body);

      if (response.status == true) {
        Fluttertoast.showToast(msg: response.message);
        ref.invalidate(getRequestStudentController); // keep this
        ref.read(requestRefreshTrigger.notifier).state =
            !ref.read(requestRefreshTrigger); // toggle to trigger rebuild
        ref.invalidate(profileProvider(widget.id));
        // Do not add to connectedMentors or set isConnected here - wait for API refresh to confirm status
      } else {
        Fluttertoast.showToast(msg: response.message);
      }
    } catch (e, st) {
      log("${e.toString()} \n $st");
      Fluttertoast.showToast(msg: "No Request sent");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider(widget.id));
    final getMentorReviewProvider =
        ref.watch(getMentorReviewController(widget.id.toString()));
    final themeMode = ref.watch(themeProvider);
    var box = Hive.box('userdata');
    return Scaffold(
      body: profileAsync.when(
        data: (profile) {
          final mentorRequestsList = profile.mentorRequests;

          final String? status = (mentorRequestsList != null)
              ? mentorRequestsList.status
              : null; // यदि लिस्ट खाली है तो null

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(profileProvider(widget.id));
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(), // IMPORTANT
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 200.h,
                        width: double.infinity,
                        color: const Color(0xff008080),
                      ),
                      Container(
                        //   color: Colors.white,
                        color: themeMode == ThemeMode.light
                            ? Color(0xFF1B1B1B)
                            : Colors.white,
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 100.h),
                          child: SingleChildScrollView(
                            child: Column(children: [
                              SizedBox(
                                height: 15.h,
                              ),
                              Text(
                                profile.fullName!,
                                style: GoogleFonts.roboto(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  //color: Colors.black,
                                  color: themeMode == ThemeMode.dark
                                      ? Color(0xFF1B1B1B)
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                "Total Exprience ${profile.totalExperience ?? 'No experience listed'}",
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff666666),
                                ),
                              ),
                              Text(
                                'College: ${profile.usersField ?? 'N/A'} - Company: ${profile.companiesWorked?.toString() ?? 'N/A'}',
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff666666),
                                ),
                              ),
                              SizedBox(height: 15.w),
                              if (profile.skills != null)
                                if (profile.skills is List &&
                                    profile.skills!.isNotEmpty)
                                  Wrap(
                                    spacing: 10.w,
                                    runSpacing: 10.h,
                                    children: (profile.skills as List)
                                        .map<Widget>(
                                          (skill) => Container(
                                            padding: EdgeInsets.only(
                                                left: 20.w,
                                                right: 20.w,
                                                top: 8.h,
                                                bottom: 8.h),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                              color: const Color(0xffDEDDEC),
                                            ),
                                            child: Text(
                                              skill.toString(),
                                              style: GoogleFonts.roboto(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  )
                                else
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 15.w,
                                        right: 15.w,
                                        top: 10.h,
                                        bottom: 10.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xffDEDDEC),
                                    ),
                                    child: Text(
                                      profile.skills.toString(),
                                      style: GoogleFonts.roboto(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                              else
                                Text(
                                  'No skills listed',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff666666),
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10.w, top: 10.h, right: 10.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: isLoading
                                          ? null
                                          : () async {
                                              if (status == null ||
                                                  status.toLowerCase() ==
                                                      "connected") {
                                                await sendConnectRequest();
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Request already: $status");
                                              }
                                            },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        height: 50.h,
                                        width: 140.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: status == "connected"
                                              ? Color(0xff008080)
                                              : status == "pending"
                                                  ? Colors.red
                                                  : status == "accepted"
                                                      ? Colors.green
                                                      : Colors.grey,
                                        ),
                                        child: Center(
                                          child: isLoading
                                              ? SizedBox(
                                                  width: 30.w,
                                                  height: 30.h,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2.w,
                                                  ),
                                                )
                                              : Text(
                                                  status == "connected"
                                                      ? "Send Request"
                                                      : status == "pending"
                                                          ? "Pending"
                                                          : status == "accepted"
                                                              ? "Accepted"
                                                              : "Send Request",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20.w),
                                    if (status == "accepted") ...[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    ChatingPage(
                                                        otherUesrid: profile.id
                                                            .toString(),
                                                        id: box
                                                            .get("userid")
                                                            .toString(),
                                                        name: profile.fullName
                                                            .toString()),
                                              ));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10.w, right: 10.w),
                                          height: 50.h,
                                          width: 140.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: const Color(0xff008080)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Message",
                                              style: GoogleFonts.roboto(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff008080),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      InkWell(
                                        onTap: () {
                                          Fluttertoast.showToast(
                                              msg: "Request not accepted yet!");
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10.w, right: 10.w),
                                          height: 50.h,
                                          width: 140.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: const Color(0xff008080)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Message",
                                              style: GoogleFonts.roboto(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff008080),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Divider(),
                              Container(
                                margin: EdgeInsets.only(left: 20.w, top: 15.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "About ${profile.fullName}",
                                          style: GoogleFonts.roboto(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xFF1B1B1B)
                                                : Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                        SizedBox(
                                          width: 400.w,
                                          child: Text(
                                            profile.description ??
                                                'No description available',
                                            style: GoogleFonts.roboto(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff666666),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                        SizedBox(
                                          width: 400.w,
                                          child: Text(
                                            'College: ${profile.usersField ?? 'N/A'} - Company: ${profile.companiesWorked?.toString() ?? 'N/A'}',
                                            style: GoogleFonts.roboto(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff666666),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Divider(),
                              Container(
                                  margin:
                                      EdgeInsets.only(left: 20.w, top: 15.h),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Educations",
                                              style: GoogleFonts.roboto(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Color(0xFF1B1B1B)
                                                        : Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              "Total Exprience ${profile.totalExperience ?? 'No experience listed'}",
                                              style: GoogleFonts.roboto(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff666666),
                                              ),
                                            ),
                                            Text(
                                              'College: ${profile.usersField ?? 'N/A'} - Company: ${profile.companiesWorked?.toString() ?? 'N/A'}',
                                              style: GoogleFonts.roboto(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff666666),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ])),
                              SizedBox(
                                height: 10.h,
                              ),
                              Divider(),
                              Container(
                                margin: EdgeInsets.only(left: 20.w, top: 15.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Skills",
                                          style: GoogleFonts.roboto(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xFF1B1B1B)
                                                : Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        if (profile.skills != null)
                                          if (profile.skills is List &&
                                              profile.skills!.isNotEmpty)
                                            Wrap(
                                              spacing: 10.w,
                                              runSpacing: 10.h,
                                              children: (profile.skills as List)
                                                  .map<Widget>(
                                                    (skill) => Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15.w,
                                                          right: 15.w,
                                                          top: 10.h,
                                                          bottom: 10.h),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.r),
                                                        color: const Color(
                                                            0xffDEDDEC),
                                                      ),
                                                      child: Text(
                                                        skill.toString(),
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            )
                                          else
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 15.w,
                                                  right: 15.w,
                                                  top: 10.h,
                                                  bottom: 10.h),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: const Color(0xffDEDDEC),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  profile.skills.toString(),
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            )
                                        else
                                          Text(
                                            'No skills listed',
                                            style: GoogleFonts.roboto(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff666666),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Divider(),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16.w, right: 16.w, top: 15.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Reviews & Testimonials",
                                      style: GoogleFonts.roboto(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: themeMode == ThemeMode.light
                                            ? Color(0xffDEDDEC)
                                            : Color(0xFF008080),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  MentoraddReviewPage(
                                                      id: widget.id.toString()),
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "View All",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  themeMode == ThemeMode.light
                                                      ? Color(0xffDEDDEC)
                                                      : Color(0xFF008080),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 20.sp,
                                            color: themeMode == ThemeMode.light
                                                ? Color(0xffDEDDEC)
                                                : Color(0xFF008080),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              getMentorReviewProvider.when(
                                data: (snp) {
                                  if (snp.reviews!.isEmpty) {
                                    return Center(
                                      child: Text(
                                        "No Review yet.",
                                        style: GoogleFonts.inter(
                                          fontSize: 16.sp,
                                          color: themeMode == ThemeMode.dark
                                              ? const Color(0xFF1B1B1B)
                                              : Colors.white,
                                        ),
                                      ),
                                    );
                                  }
                                  // 👇 Take only top 5
                                  final limitedReviews =
                                      snp.reviews!.take(5).toList();

                                  return ListView.builder(
                                    reverse: true,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: limitedReviews.length,
                                    itemBuilder: (context, index) {
                                      final review = limitedReviews[index];

                                      final double avg = double.tryParse(
                                              review.rating.toString() ?? "") ??
                                          0.0;
                                      final int rating =
                                          avg.clamp(0, 5).toInt();

                                      return Container(
                                        padding: EdgeInsets.only(
                                            left: 16.w,
                                            right: 16.w,
                                            top: 16.h,
                                            bottom: 16.h),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                          // color: Color(0xFFF1F2F6),
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xffF1F2F6)
                                              : Color(0xFF008080),
                                        ),
                                        margin: EdgeInsets.only(
                                            bottom: 20.h,
                                            left: 15.w,
                                            right: 15.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                ...List.generate(
                                                  rating,
                                                  (indiex) => Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 20.0,
                                                  ),
                                                ),
                                                ...List.generate(
                                                  5 - rating, // Remaining stars (5 - filled stars)
                                                  (i) => const Icon(
                                                    Icons
                                                        .star_border, // Outlined star icon
                                                    color: Colors
                                                        .amber, // Use the same color for visual consistency
                                                    size: 20.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              review.description ?? '',
                                              style: GoogleFonts.roboto(
                                                fontSize: 16.sp,
                                                color:
                                                    themeMode == ThemeMode.light
                                                        ? Color(0xffDEDDEC)
                                                        : Color(0xFF666666),
                                              ),
                                            ),
                                            Text(
                                              review.userName ?? "N/A",
                                              style: GoogleFonts.roboto(
                                                fontSize: 14.sp,
                                                color:
                                                    themeMode == ThemeMode.light
                                                        ? Color(0xffDEDDEC)
                                                        : Color(0xFF666666),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 10.h,
                                            // )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                error: (error, stackTrace) {
                                  log(stackTrace.toString());
                                  return Center(
                                    child: Text(error.toString()),
                                  );
                                },
                                loading: () => Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              )
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 30.h,
                    left: 20.w,
                    right: 20.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              height: 50.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                        Text(
                          "Mentor Details",
                          style: GoogleFonts.roboto(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          height: 50.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            //color: Colors.white,
                          ),
                          //child: const Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 110.h,
                    child: Center(
                      child: ClipOval(
                        child: profile.profilePic != null
                            ? Image.network(
                                profile.profilePic!,
                                height: 182.w,
                                width: 182.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                  height: 182.w,
                                  width: 182.w,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.network(
                                "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                height: 182.h,
                                width: 182.h,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () => ref.invalidate(profileProvider(widget.id)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
