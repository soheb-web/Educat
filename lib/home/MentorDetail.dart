import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/getRequestStudentController.dart';
import 'package:educationapp/coreFolder/Controller/reviewController.dart';
import 'package:educationapp/coreFolder/Model/sendRequestBodyModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
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
  bool isConnected = false;
  bool isLoading = false;

  // Future<void> sendConnectRequest() async {
  //   try {
  //     final body = SendRequestBodyModel(mentorId: widget.id);
  //     final service = APIStateNetwork(createDio());
  //     final response = await service.studentSendRequest(body);

  //     if (response.status == true) {
  //       Fluttertoast.showToast(msg: response.message);
  //       setState(() {
  //         isConnected = true;
  //       });
  //     } else {
  //       Fluttertoast.showToast(msg: response.message);
  //     }
  //   } catch (e, st) {
  //     log("${e.toString()} \n $st");
  //     Fluttertoast.showToast(msg: "No Request sent");
  //   }
  // }

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

        // ✅ Save connected mentor ID in Hive
        var box = Hive.box('userdata');
        List connectedMentors = box.get('connectedMentors', defaultValue: []);
        if (!connectedMentors.contains(widget.id)) {
          connectedMentors.add(widget.id);
          box.put('connectedMentors', connectedMentors);
        }

        setState(() {
          isConnected = true;
        });
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
  void initState() {
    super.initState();
    checkConnectionStatus();
  }

  void checkConnectionStatus() {
    var box = Hive.box('userdata');
    List connectedMentors = box.get('connectedMentors', defaultValue: []);
    if (connectedMentors.contains(widget.id)) {
      setState(() {
        isConnected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');

    final profileAsync = ref.watch(profileProvider(widget.id));

    return Scaffold(
      body: profileAsync.when(
        data: (profile) => SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 220.h,
                    width: double.infinity,
                    color: const Color(0xff008080),
                  ),
                  Container(
                    color: Colors.white,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 100.h),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            profile.fullName!,
                            style: GoogleFonts.roboto(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            profile.totalExperience ?? 'No experience listed',
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
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Container(
                          //       padding: EdgeInsets.only(
                          //           left: 12.w,
                          //           right: 12.w,
                          //           top: 8.h,
                          //           bottom: 8.h),
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(20.r),
                          //         color: const Color(0xffDEDDEC),
                          //       ),
                          //       child: Text(
                          //         "Placement Expert",
                          //         style: GoogleFonts.roboto(
                          //           fontSize: 12.sp,
                          //           fontWeight: FontWeight.w600,
                          //           color: Colors.black,
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(width: 20.w),
                          //     Container(
                          //       padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          //       height: 30.h,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(20),
                          //         color: const Color(0xffDEDDEC),
                          //       ),
                          //       child: Center(
                          //         child: Text(
                          //           "Career Coach",
                          //           style: GoogleFonts.roboto(
                          //             fontSize: 12.sp,
                          //             fontWeight: FontWeight.w600,
                          //             color: Colors.black,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(width: 20.w),
                          //     Container(
                          //       padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          //       height: 30.h,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(20),
                          //         color: const Color(0xffDEDDEC),
                          //       ),
                          //       child: Center(
                          //         child: Row(
                          //           children: [
                          //             Icon(
                          //               Icons.star,
                          //               size: 14.sp,
                          //               color: const Color(0xff008080),
                          //             ),
                          //             SizedBox(width: 5.w),
                          //             Text(
                          //               "4.5 Review",
                          //               style: GoogleFonts.roboto(
                          //                 fontSize: 12.sp,
                          //                 fontWeight: FontWeight.w600,
                          //                 color: Colors.black,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          if (profile.skills != null)
                            if (profile.skills is List &&
                                profile.skills.isNotEmpty)
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
                                if (isConnected)
                                  SizedBox()
                                else
                                  InkWell(
                                    onTap: isLoading
                                        ? null
                                        : () async {
                                            await sendConnectRequest();
                                          },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 10.w, right: 10.w),
                                      height: 50.h,
                                      width: 140.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        //color: const Color(0xffA8E6CF),
                                        color: isConnected
                                            ? const Color(
                                                0xffFF8A80) // red for disconnect
                                            : const Color(0xffA8E6CF),
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
                                                "Connect",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 20.w),
                                GestureDetector(
                                  onTap: () {
                                    // Handle message action
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10.w, right: 10.w),
                                    height: 50.h,
                                    width: 140.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color(0xff008080)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Message",
                                        style: GoogleFonts.roboto(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff008080),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "About ${profile.fullName}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
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
                              margin: EdgeInsets.only(left: 20.w, top: 15.h),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          profile.totalExperience ??
                                              'No education details available',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Skills",
                                      style: GoogleFonts.roboto(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    if (profile.skills != null)
                                      if (profile.skills is List &&
                                          profile.skills.isNotEmpty)
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
                                                        BorderRadius.circular(
                                                            20.r),
                                                    color:
                                                        const Color(0xffDEDDEC),
                                                  ),
                                                  child: Text(
                                                    skill.toString(),
                                                    style: GoogleFonts.roboto(
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
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 60.h,
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
                            child: Icon(Icons.arrow_back_ios),
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
                top: 140.h,
                child: Center(
                  child: ClipOval(
                    child: profile.profilePic != null
                        ? Image.network(
                            profile.profilePic!,
                            height: 182.h,
                            width: 182.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              "assets/girlpic.png",
                              height: 182.h,
                              width: 182.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            "assets/girlpic.png",
                            height: 182.h,
                            width: 182.w,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
