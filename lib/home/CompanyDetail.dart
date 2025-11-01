import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../coreFolder/Controller/reviewController.dart';
import '../coreFolder/Model/ReviewGetModel.dart';
import 'AllReviewPage.dart';

class CompanyDetailPage extends ConsumerStatefulWidget {
  int id;
  CompanyDetailPage(this.id, {super.key});

  @override
  ConsumerState<CompanyDetailPage> createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends ConsumerState<CompanyDetailPage> {
  @override
  Widget build(BuildContext context) {
    final reviewAsync = ref.watch(reviewProvider(widget.id));

    // return Scaffold(
    //   body: reviewAsync.when(
    //     data: (propertyDetail) => _buildBody(context, propertyDetail),
    //     loading: () => const Center(child: CircularProgressIndicator()),
    //     error: (error, stack) => Center(child: Text(error.toString())),
    //   ),
    // );
    return Scaffold(
        body: reviewAsync.when(
      data: (snap) {
        return SingleChildScrollView(
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
                            snap.collage!.name.toString(),
                            style: GoogleFonts.roboto(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            // profile.totalExperience ?? 'No experience listed',
                            "${snap.collage!.description ?? "No description"}",
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
                              snap.collage!.website.toString(),
                              style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff666666),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.w),
                          Row(
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
                                  color: const Color(0xffDEDDEC),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 5.w),
                                    Text(
                                      "${snap.collage!.city.toString()}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
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
                                      "${snap.collage?.rating ?? 0} Rating",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
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
                                    SizedBox(width: 5.w),
                                    Text(
                                      "Total Review ${snap.collage!.totalReviews.toString()}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Divider(),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16.w, right: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Reviews & Testimonials",
                                  style: GoogleFonts.roboto(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff1B1B1B),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => AllReviewPage(
                                                  id: snap.collage!.id ?? 0,
                                                )));
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "View All",
                                        style: GoogleFonts.roboto(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff008080),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20.sp,
                                        color: Color(0xff008080),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snap.reviews!.length,
                            itemBuilder: (context, index) {
                              final review = snap.reviews![index];
                              return Container(
                                padding: EdgeInsets.only(
                                    left: 16.w,
                                    right: 16.w,
                                    top: 16.h,
                                    bottom: 16.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Color(0xFFF1F2F6)),
                                margin: EdgeInsets.only(
                                    bottom: 20.h, left: 15.w, right: 15.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      review.description ?? '',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        color: const Color(0xff666666),
                                      ),
                                    ),
                                    Text(
                                      "Posted on ${review.createdAt?.toString().split(' ')[0] ?? ''}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Divider(),
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
                            padding: EdgeInsets.only(left: 6.w),
                            child: Icon(Icons.arrow_back_ios),
                          )),
                    ),
                    Text(
                      "Company Review",
                      style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        // color: Colors.white,
                      ),
                      // child: const Icon(Icons.search),
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
                    child: snap.collage!.image.toString() != null
                        ? Image.network(
                            snap.collage!.image.toString(),
                            height: 182.h,
                            width: 182.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.network(
                                    "https://t4.ftcdn.net/jpg/06/71/92/37/360_F_671923740_x0zOL3OIuUAnSF6sr7PuznCI5bQFKhI0.jpg",
                                    height: 182.h,
                                    width: 182.w,
                                    fit: BoxFit.cover),
                          )
                        : Image.network(
                            "https://t4.ftcdn.net/jpg/06/71/92/37/360_F_671923740_x0zOL3OIuUAnSF6sr7PuznCI5bQFKhI0.jpg",
                            height: 182.h,
                            width: 182.w,
                            fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(error.toString())),
    ));
  }

  // Widget _buildBody(BuildContext context, ReviewGetModel propertyDetail) {
  //   final collage = propertyDetail.collage!;
  //   final baseUrl = 'https://education.globallywebsolutions.com';
  //   final fullImageUrl = baseUrl + (collage.image ?? '');

  //   return Stack(
  //     children: [
  //       // Background container
  //       Column(
  //         children: [
  //           Container(
  //             height: 220.h,
  //             width: double.infinity,
  //             color: const Color(0xff008080),
  //           ),
  //           Expanded(
  //             child: Container(
  //               color: Colors.white,
  //               child: Container(
  //                 width: double.infinity,
  //                 margin: EdgeInsets.only(top: 100.h),
  //                 child: Column(
  //                   children: [
  //                     // College Name
  //                     Text(
  //                       collage.name ?? '',
  //                       style: GoogleFonts.roboto(
  //                         fontSize: 16.sp,
  //                         fontWeight: FontWeight.w600,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                     SizedBox(height: 4.h),
  //                     // Description
  //                     Text(
  //                       collage.description ?? '',
  //                       style: GoogleFonts.roboto(
  //                         fontSize: 12.sp,
  //                         fontWeight: FontWeight.w600,
  //                         color: const Color(0xff666666),
  //                       ),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                     SizedBox(height: 8.h),
  //                     // College Details
  //                     Text(
  //                       "City: ${collage.city ?? ''} | Pincode: ${collage.pincode ?? ''}",
  //                       style: GoogleFonts.roboto(
  //                         fontSize: 12.sp,
  //                         fontWeight: FontWeight.w600,
  //                         color: const Color(0xff666666),
  //                       ),
  //                     ),
  //                     SizedBox(height: 10.h),
  //                     // Tags and Rating (adjusted for college)
  //                     Container(
  //                       margin: EdgeInsets.only(
  //                           left: 15.w, top: 10.h, right: 15.w, bottom: 10.h),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Container(
  //                             padding: EdgeInsets.only(
  //                                 left: 15.w,
  //                                 right: 15.w,
  //                                 top: 10.h,
  //                                 bottom: 10.h),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(20),
  //                               color: const Color(0xffDEDDEC),
  //                             ),
  //                             child: Center(
  //                               child: Text(
  //                                 "${collage.type ?? 'College'}",
  //                                 style: GoogleFonts.roboto(
  //                                   fontSize: 12.sp,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: Colors.black,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(width: 20.w),
  //                           Container(
  //                             padding: EdgeInsets.only(
  //                                 left: 15.w,
  //                                 right: 15.w,
  //                                 top: 10.h,
  //                                 bottom: 10.h),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(20),
  //                               color: const Color(0xffDEDDEC),
  //                             ),
  //                             child: Center(
  //                               child: Row(
  //                                 children: [
  //                                   Icon(
  //                                     Icons.star,
  //                                     size: 14.sp,
  //                                     color: const Color(0xff008080),
  //                                   ),
  //                                   SizedBox(width: 5.w),
  //                                   Text(
  //                                     "${collage.rating ?? 0} (${collage.totalReviews ?? 0} Reviews)",
  //                                     style: GoogleFonts.roboto(
  //                                       fontSize: 12.sp,
  //                                       fontWeight: FontWeight.w600,
  //                                       color: Colors.black,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     SizedBox(height: 10.h),
  //                     const Divider(),
  //                     SizedBox(height: 10.h),
  //                     Container(
  //                       margin: EdgeInsets.only(left: 20.w, right: 20.w),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             "Reviews & Testimonials",
  //                             style: GoogleFonts.roboto(
  //                               fontSize: 16.sp,
  //                               fontWeight: FontWeight.w600,
  //                               color: const Color(0xff666666),
  //                             ),
  //                           ),
  //                           GestureDetector(
  //                             onTap: () {
  //                               Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (context) => AllReviewPage(
  //                                             id: collage.id!,
  //                                           )));
  //                             },
  //                             child: Row(
  //                               children: [
  //                                 Text(
  //                                   "View All",
  //                                   style: GoogleFonts.roboto(
  //                                     fontSize: 15.sp,
  //                                     fontWeight: FontWeight.w600,
  //                                     color: const Color(0xff008080),
  //                                   ),
  //                                 ),
  //                                 Icon(
  //                                   Icons.arrow_forward_ios,
  //                                   size: 20.sp,
  //                                   color: Color(0xff008080),
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     SizedBox(height: 10.h),
  //                     // Reviews List
  //                     Expanded(
  //                       child: ListView.builder(
  //                         padding: EdgeInsets.symmetric(horizontal: 10.w),
  //                         itemCount: propertyDetail.reviews?.length ?? 0,
  //                         itemBuilder: (context, index) {
  //                           final review = propertyDetail.reviews![index];
  //                           return Card(
  //                             margin: EdgeInsets.only(bottom: 10.h),
  //                             child: Padding(
  //                               padding: EdgeInsets.all(10.w),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Row(
  //                                     children: [
  //                                       Icon(
  //                                         Icons.star,
  //                                         color: const Color(0xff008080),
  //                                         size: 16.sp,
  //                                       ),
  //                                       SizedBox(width: 5.w),
  //                                       Text(
  //                                         "${review.rating}/5",
  //                                         style: GoogleFonts.roboto(
  //                                           fontSize: 12.sp,
  //                                           fontWeight: FontWeight.w600,
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                   SizedBox(height: 5.h),
  //                                   Text(
  //                                     review.description ?? '',
  //                                     style: GoogleFonts.roboto(
  //                                       fontSize: 12.sp,
  //                                       color: const Color(0xff666666),
  //                                     ),
  //                                   ),
  //                                   SizedBox(height: 5.h),
  //                                   Text(
  //                                     "Posted on ${review.createdAt?.toString().split(' ')[0] ?? ''}",
  //                                     style: GoogleFonts.roboto(
  //                                       fontSize: 10.sp,
  //                                       color: Colors.grey,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       // App bar row
  //       Positioned(
  //         top: 60.h,
  //         left: 20.w,
  //         right: 20.w,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             // Left circle
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Container(
  //                 height: 50.h,
  //                 width: 48.w,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   color: Colors.white,
  //                 ),
  //                 child: Padding(
  //                   padding: EdgeInsets.only(left: 10.w),
  //                   child: Icon(Icons.arrow_back_ios),
  //                 ),
  //               ),
  //             ),
  //             // Title
  //             Text(
  //               "Company Review",
  //               style: GoogleFonts.roboto(
  //                 fontSize: 16.sp,
  //                 fontWeight: FontWeight.w600,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             // Right circle
  //             Container(
  //               height: 50.h,
  //               width: 50.w,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(30),
  //                 //color: Colors.white,
  //               ),
  //               //child: const Icon(Icons.search),
  //             ),
  //           ],
  //         ),
  //       ),
  //       // College Image
  //       Positioned(
  //         left: 0,
  //         right: 0,
  //         top: 140.h,
  //         child: Container(
  //           height: 182.h,
  //           width: 182.w,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(30),
  //             color: Colors.white,
  //           ),
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(30),
  //             child: Image.network(
  //               fullImageUrl,
  //               fit: BoxFit.cover,
  //               errorBuilder: (context, error, stackTrace) =>
  //                   Image.asset("assets/girlpic.png"),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
