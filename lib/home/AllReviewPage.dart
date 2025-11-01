import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../coreFolder/Controller/reviewController.dart';
import '../coreFolder/Model/ReviewGetModel.dart';
import 'saveReview.page.dart';

class AllReviewPage extends ConsumerStatefulWidget {
  int id;
  AllReviewPage({super.key, required this.id});

  @override
  ConsumerState<AllReviewPage> createState() => _AllReviewPageState();
}

class _AllReviewPageState extends ConsumerState<AllReviewPage> {
  @override
  Widget build(BuildContext context) {
    final reviewAsync = ref.watch(reviewProvider(widget.id));

    return Scaffold(
      body: reviewAsync.when(
        data: (reviewData) => _buildBody(context, reviewData),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          Fluttertoast.showToast(msg: "Error loading reviews: $error");
          return const Center(child: Text("Failed to load reviews"));
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ReviewGetModel reviewData) {
    final collage = reviewData.collage!;
    final id = reviewData.collage!.id!;
    final totalReviews = collage.totalReviews ?? 0;
    final distribution = collage.distribution ?? {};
    final averageRating = collage.rating?.toDouble() ?? 0.0;

    return Scaffold(
      backgroundColor: Color(0xff1B1B1B),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 50.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ),
                Text(
                  "All Reviews",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SaveReviewPage(id: id)));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 15.w, right: 15.w, top: 12.h, bottom: 12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffA8E6CF),
                    ),
                    child: Center(
                      child: Text(
                        "Add Reviews",
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff1B1B1B),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            margin: EdgeInsets.only(
              top: 30.h,
              left: 20.w,
              right: 20.w,
            ),
            height: 216.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: const Color(0xff262626),
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: const Color(0xffF3CA12),
                      size: 20.sp,
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "$totalReviews Review",
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                  ],
                ),
                Divider(color: Colors.grey),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final starLevel = 5 - index;
                      final count = distribution[starLevel.toString()] ?? 0;
                      final progress = totalReviews > 0
                          ? (count / totalReviews).toDouble()
                          : 0.0;
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.white, size: 16.sp),
                                Text(
                                  "$starLevel",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                height: 8.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.transparent,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Color(0xffA8E6CF)),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "$count",
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.r),
                  topLeft: Radius.circular(30).r,
                ),
              ),
              child: Column(
                children: [
                  // Container(
                  //   width: double.infinity,
                  //   margin: EdgeInsets.only(top: 20.h),
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         collage.name ?? '',
                  //         style: GoogleFonts.roboto(
                  //           fontSize: 16.sp,
                  //           fontWeight: FontWeight.w600,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //       SizedBox(height: 4.h),
                  //       Text(
                  //         collage.description ?? '',
                  //         style: GoogleFonts.roboto(
                  //           fontSize: 12.sp,
                  //           fontWeight: FontWeight.w600,
                  //           color: const Color(0xff666666),
                  //         ),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //       SizedBox(height: 8.h),
                  //       Text(
                  //         "City: ${collage.city ?? ''} | Pincode: ${collage.pincode ?? ''}",
                  //         style: GoogleFonts.roboto(
                  //           fontSize: 12.sp,
                  //           fontWeight: FontWeight.w600,
                  //           color: const Color(0xff666666),
                  //         ),
                  //       ),
                  //       SizedBox(height: 10.h),
                  //       Container(
                  //         margin: EdgeInsets.only(
                  //             left: 10.w, top: 10.h, right: 10.w),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Container(
                  //               padding: EdgeInsets.only(
                  //                   left: 10.w,
                  //                   right: 10.w,
                  //                   top: 6.h,
                  //                   bottom: 6.h),
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(20),
                  //                 color: const Color(0xffDEDDEC),
                  //               ),
                  //               child: Text(
                  //                 "${collage.type ?? 'College'}",
                  //                 style: GoogleFonts.roboto(
                  //                   fontSize: 12.sp,
                  //                   fontWeight: FontWeight.w600,
                  //                   color: Colors.black,
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(width: 20.w),
                  //             Container(
                  //               padding: EdgeInsets.only(
                  //                   left: 10.w,
                  //                   right: 10.w,
                  //                   top: 6.h,
                  //                   bottom: 6.h),
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(20),
                  //                 color: const Color(0xffDEDDEC),
                  //               ),
                  //               child: Row(
                  //                 children: [
                  //                   Icon(
                  //                     Icons.star,
                  //                     size: 14.sp,
                  //                     color: const Color(0xff008080),
                  //                   ),
                  //                   SizedBox(width: 5.w),
                  //                   Text(
                  //                     "${averageRating.toStringAsFixed(1)} (${totalReviews} Reviews)",
                  //                     style: GoogleFonts.roboto(
                  //                       fontSize: 12.sp,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: Colors.black,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Reviews list
                  Expanded(
                    child: reviewData.reviews?.isEmpty ?? true
                        ? Center(
                            child: Text(
                              "No reviews yet",
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                color: const Color(0xff666666),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 20.h),
                            itemCount: reviewData.reviews?.length ?? 0,
                            itemBuilder: (context, index) {
                              final review = reviewData.reviews![index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 20.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Color(0xFFF1F2F6)),
                                child: Padding(
                                  padding: EdgeInsets.all(16.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: const Color(0xff008080),
                                            size: 16.sp,
                                          ),
                                          SizedBox(width: 5.w),
                                          Text(
                                            "${review.rating}/5",
                                            style: GoogleFonts.roboto(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        review.description ?? '',
                                        style: GoogleFonts.roboto(
                                          fontSize: 16.sp,
                                          color: const Color(0xff666666),
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      Text(
                                        "Posted on ${review.createdAt?.toString().split(' ')[0] ?? ''}",
                                        style: GoogleFonts.roboto(
                                          fontSize: 14.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // children: [

      // App bar
      // Positioned(
      //   top: 60.h,
      //   left: 20.w,
      //   right: 20.w,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       GestureDetector(
      //         onTap: () => Navigator.pop(context),
      //         child: Container(
      //           height: 50.h,
      //           width: 48.w,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(30.r),
      //             color: Colors.white,
      //           ),
      //           child: Padding(
      //             padding: EdgeInsets.only(left: 8.w),
      //             child: Icon(Icons.arrow_back_ios),
      //           ),
      //         ),
      //       ),
      //       Text(
      //         "All Reviews",
      //         style: GoogleFonts.roboto(
      //           fontSize: 16.sp,
      //           fontWeight: FontWeight.w600,
      //           color: Colors.white,
      //         ),
      //       ),
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) => SaveReviewPage(id: id)));
      //         },
      //         child: Container(
      //           padding: EdgeInsets.only(
      //               left: 15.w, right: 15.w, top: 12.h, bottom: 12.h),
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(20),
      //             color: const Color(0xffA8E6CF),
      //           ),
      //           child: Center(
      //             child: Text(
      //               "Add Reviews",
      //               style: GoogleFonts.roboto(
      //                 fontSize: 12.sp,
      //                 fontWeight: FontWeight.w600,
      //                 color: const Color(0xff1B1B1B),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // ],
    );
  }
}
