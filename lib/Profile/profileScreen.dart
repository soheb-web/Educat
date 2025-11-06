import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/userProfileController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../../coreFolder/Controller/profileController.dart';

class ProfilePage extends ConsumerStatefulWidget {
  ProfilePage({
    super.key,
  });

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // var box = Hive.box('userdata');
    // final userId = box.get('user_id');
    // if (userId == null) {
    //   Fluttertoast.showToast(
    //     msg: "Please log in to add a review",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.TOP,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 12.0,
    //   );
    //   return Scaffold(
    //     body: Center(
    //       child: Text(
    //         'Please log in to view profile',
    //         style: GoogleFonts.roboto(fontSize: 16.sp),
    //       ),
    //     ),
    //   );
    // }

    // // Parse userId to int for the provider (with safety check)
    // final int parsedUserId;

    // try {
    //   parsedUserId = int.parse(userId.toString());
    // } catch (e) {
    //   // Fallback: Show error and retry option
    //   return Scaffold(
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Text('Invalid user ID format: $e'),
    //           ElevatedButton(
    //             onPressed: () => setState(() {}), // Rebuild to retry Hive read
    //             child: const Text('Retry'),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
    // final profileAsync = ref.watch(profileProvider(parsedUserId));

    final userProfileProvider = ref.watch(userProfileController);
    return Scaffold(
      body: userProfileProvider.when(
        data: (userProfile) => SingleChildScrollView(
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
                            userProfile.data!.fullName ?? "No Name",
                            style: GoogleFonts.roboto(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            // profile.totalExperience ?? 'No experience listed',
                            "Total Experience ${userProfile.data!.totalExperience ?? 0}",
                            style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff666666),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.w, right: 15.w),
                            child: Text(
                              textAlign: TextAlign.center,
                              //'College: ${profile.usersField ?? 'N/A'} - Company: ${profile.companiesWorked?.toString() ?? 'N/A'}',
                              "${userProfile.data!.usersField ?? "No field"} - ${userProfile.data!.serviceType ?? "No serviceType"}",
                              style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff666666),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 12.w,
                                      right: 12.w,
                                      top: 8.h,
                                      bottom: 8.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Color(0xffDEDDEC),
                                  ),
                                  child: Text(
                                    "Placement Expert",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 12.w,
                                      right: 12.w,
                                      top: 8.h,
                                      bottom: 8.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: const Color(0xffDEDDEC),
                                  ),
                                  child: Text(
                                    "Career Coach",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 12.w,
                                      right: 12.w,
                                      top: 8.h,
                                      bottom: 8.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: const Color(0xffDEDDEC),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 16.sp,
                                        color: const Color(0xff008080),
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "4.5 Review",
                                        style: GoogleFonts.roboto(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(
                          //       left: 10.w, top: 20.h, right: 10.w),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Container(
                          //         padding: EdgeInsets.only(
                          //             left: 15.w,
                          //             right: 15.w,
                          //             top: 15.h,
                          //             bottom: 15.h),
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(20.r),
                          //           color: Color(0xffA8E6CF),
                          //         ),
                          //         child: Text(
                          //           "Placement Expert",
                          //           style: GoogleFonts.roboto(
                          //             fontSize: 14.sp,
                          //             fontWeight: FontWeight.w600,
                          //             color: Colors.black,
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(width: 20.w),
                          //       GestureDetector(
                          //         onTap: () {},
                          //         child: Container(
                          //           height: 50.h,
                          //           width: 140.w,
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(20.r),
                          //             color: Colors.white,
                          //             border:
                          //                 Border.all(color: Color(0xff008080)),
                          //           ),
                          //           child: Center(
                          //             child: Text(
                          //               "Message",
                          //               style: GoogleFonts.roboto(
                          //                 fontSize: 14.sp,
                          //                 fontWeight: FontWeight.w600,
                          //                 color: const Color(0xff008080),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
                                      "About ${userProfile.data!.fullName ?? "No Name"}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      userProfile.data!.description ??
                                          "No description",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff666666),
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    SizedBox(
                                      width: 400.w,
                                      child: Text(
                                        '${userProfile.data!.usersField ?? 'N/A'} - Company: ${userProfile.data!.serviceType?.toString() ?? 'N/A'}',
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
                                        userProfile.data!.serviceType ?? "N/A",
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
                          // Educations section
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
                                          userProfile.data!.totalExperience ??
                                              "0",
                                          style: GoogleFonts.roboto(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff666666),
                                          ),
                                        ),
                                        Text(
                                          userProfile.data!.serviceType ??
                                              "N/A",
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
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      if (userProfile.data!.skills != null &&
                                          userProfile.data!.skills!.isNotEmpty)
                                        Wrap(
                                          spacing: 10.w,
                                          runSpacing: 5.h,
                                          children: userProfile.data!.skills!
                                              .map<Widget>((skill) => Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w,
                                                            vertical: 8.h),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      color: const Color(
                                                          0xffDEDDEC),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        skill.toString(),
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        )
                                      else
                                        Text(
                                          'No skills listed',
                                          style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff666666),
                                          ),
                                        ),
                                    ],
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Divider(),
                          // Educations section
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
                                        "Language",
                                        style: GoogleFonts.roboto(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        (userProfile.data!.languageKnown ==
                                                    null ||
                                                userProfile.data!.languageKnown!
                                                    .isEmpty)
                                            ? "No Language"
                                            : userProfile.data!.languageKnown!,
                                        style: GoogleFonts.roboto(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff666666),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
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
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Container(
                    //       height: 50.h,
                    //       width: 45.w,
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: Colors.white,
                    //       ),
                    //       child: Padding(
                    //         padding:  EdgeInsets.all(8.0),
                    //         child: Icon(Icons.arrow_back_ios),
                    //       )),
                    // ),
                    Text(
                      "Profile",
                      style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    // Container(
                    //   height: 50.h,
                    //   width: 50.w,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(30),
                    //     color: Colors.white,
                    //   ),
                    //   child: const Icon(Icons.search),
                    // ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 140.h,
                child: Center(
                  child: ClipOval(
                    child: userProfile.data!.profilePic != null
                        ? Image.network(
                            userProfile.data!.profilePic!,
                            height: 182.h,
                            width: 182.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.network(
                                    "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                    height: 182.h,
                                    width: 182.w,
                                    fit: BoxFit.cover),
                          )
                        : Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                            height: 182.h,
                            width: 182.w,
                            fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          log(stack.toString());
          log(error.toString());
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error'),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
