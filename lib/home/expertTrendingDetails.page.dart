import 'package:educationapp/coreFolder/Controller/profileController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpertTrendingDetailsPage extends ConsumerStatefulWidget {
  final int id;
  const ExpertTrendingDetailsPage({super.key, required this.id});

  @override
  ConsumerState<ExpertTrendingDetailsPage> createState() =>
      _ExpertTrendingDetailsPageState();
}

class _ExpertTrendingDetailsPageState
    extends ConsumerState<ExpertTrendingDetailsPage> {
  @override
  Widget build(BuildContext context) {
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
                              Container(
                                padding:
                                    EdgeInsets.only(left: 10.w, right: 10.w),
                                height: 50.h,
                                width: 140.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xffA8E6CF),
                                ),
                                child: Center(
                                  child: Text(
                                    "Placement Expert",
                                    style: GoogleFonts.roboto(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
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
                                  padding:
                                      EdgeInsets.only(left: 10.w, right: 10.w),
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
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 45.h,
                      width: 45.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.arrow_back_ios_new,
                          size: 24.sp, color: Colors.black),
                    ),
                  ),
                  Text(
                    "Expert Details",
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
    ));
  }
}
