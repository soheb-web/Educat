// Updated widget
import 'dart:developer';
import 'package:educationapp/home/webView.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../coreFolder/Controller/reviewController.dart';
import '../coreFolder/Model/ReviewGetModel.dart';
import 'AllReviewPage.dart';

class CollegeDetailPage extends ConsumerStatefulWidget {
  int id;
  CollegeDetailPage(this.id, {super.key});

  @override
  ConsumerState<CollegeDetailPage> createState() => _CollegeDetailPageState();
}

class _CollegeDetailPageState extends ConsumerState<CollegeDetailPage> {
  @override
  Widget build(BuildContext context) {
    final reviewAsync = ref.watch(reviewProvider(widget.id));
    return Scaffold(
      body: reviewAsync.when(
        data: (snap) => SingleChildScrollView(
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
                            "${snap.collage!.description.toString()}, ${snap.collage!.type.toString()}, ${snap.collage!.city.toString()}",
                            style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff666666),
                            ),
                          ),
                          Text(
                            // profile.totalExperience ?? 'No experience listed',
                            "+91${snap.collage!.phone.toString()}, ${snap.collage!.pincode.toString()}",
                            style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff666666),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.w, right: 15.w),
                            child: InkWell(
                              onTap: () async {
                                String url =
                                    snap.collage!.website.toString().trim();

                                if (url.isEmpty) return;

                                url = url.replaceAll(" ", "");

                                if (url.startsWith("http://")) {
                                  url = url.replaceFirst("http://", "https://");
                                }

                                if (!url.startsWith("https://")) {
                                  url = "https://$url";
                                }

                                final uri = Uri.tryParse(url);
                                if (uri == null) {
                                  log("Invalid URL: $url");
                                  return;
                                }

                                // OPEN WEBVIEW PAGE
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => WebViewPage(url: url),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10.w,
                                    right: 10.w,
                                    top: 6.h,
                                    bottom: 6.h),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  snap.collage!.website.toString(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue, // clickable color
                                    decoration: TextDecoration
                                        .underline, // highlight clickable effect
                                  ),
                                ),
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
                      "Collage Review",
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
                top: 110.h,
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
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(error.toString())),
      ),
    );
  }

  // Widget _buildBody(BuildContext context, ReviewGetModel propertyDetail) {
  //   final collage = propertyDetail.collage!;
  //   final baseUrl = 'https://educatservicesindia.com';
  //   final fullImageUrl = baseUrl + (collage.image ?? '');

  //   // return Stack(
  //   //   children: [
  //   //     Column(
  //   //       children: [
  //   //         Container(
  //   //           height: 220.h,
  //   //           width: double.infinity,
  //   //           color: const Color(0xff008080),
  //   //         ),
  //   //         Expanded(
  //   //           child: Container(
  //   //             color: Colors.white,
  //   //             child: Container(
  //   //               width: double.infinity,
  //   //               margin: EdgeInsets.only(top: 100.h),
  //   //               child: Column(
  //   //                 children: [
  //   //                   // College Name
  //   //                   Text(
  //   //                     collage.name ?? '',
  //   //                     style: GoogleFonts.roboto(
  //   //                       fontSize: 16.sp,
  //   //                       fontWeight: FontWeight.w600,
  //   //                       color: Colors.black,
  //   //                     ),
  //   //                   ),
  //   //                   SizedBox(height: 4.h),
  //   //                   // Description
  //   //                   Text(
  //   //                     collage.description ?? '',
  //   //                     style: GoogleFonts.roboto(
  //   //                       fontSize: 12.sp,
  //   //                       fontWeight: FontWeight.w600,
  //   //                       color: const Color(0xff666666),
  //   //                     ),
  //   //                     textAlign: TextAlign.center,
  //   //                   ),
  //   //                   SizedBox(height: 8.h),
  //   //                   // College Details
  //   //                   Text(
  //   //                     "City: ${collage.city ?? ''} | Pincode: ${collage.pincode ?? ''}",
  //   //                     style: GoogleFonts.roboto(
  //   //                       fontSize: 12.sp,
  //   //                       fontWeight: FontWeight.w600,
  //   //                       color: const Color(0xff666666),
  //   //                     ),
  //   //                   ),
  //   //                   SizedBox(height: 10.h),
  //   //                   // Tags and Rating (adjusted for college)
  //   //                   Container(
  //   //                     margin: EdgeInsets.only(
  //   //                       left: 10.w,
  //   //                       top: 10.h,
  //   //                       right: 10.w,
  //   //                     ),
  //   //                     child: Row(
  //   //                       mainAxisAlignment: MainAxisAlignment.center,
  //   //                       children: [
  //   //                         Container(
  //   //                           padding: EdgeInsets.only(left: 5.w, right: 5.w),
  //   //                           height: 30.h,
  //   //                           decoration: BoxDecoration(
  //   //                             borderRadius: BorderRadius.circular(20),
  //   //                             color: const Color(0xffDEDDEC),
  //   //                           ),
  //   //                           child: Center(
  //   //                             child: Text(
  //   //                               "${collage.type ?? 'College'}",
  //   //                               style: GoogleFonts.roboto(
  //   //                                 fontSize: 12.sp,
  //   //                                 fontWeight: FontWeight.w600,
  //   //                                 color: Colors.black,
  //   //                               ),
  //   //                             ),
  //   //                           ),
  //   //                         ),
  //   //                         SizedBox(width: 20.w),
  //   //                         Container(
  //   //                           padding: EdgeInsets.only(left: 5.w, right: 5.w),
  //   //                           height: 30.h,
  //   //                           decoration: BoxDecoration(
  //   //                             borderRadius: BorderRadius.circular(20),
  //   //                             color: const Color(0xffDEDDEC),
  //   //                           ),
  //   //                           child: Center(
  //   //                             child: Row(
  //   //                               children: [
  //   //                                 Icon(
  //   //                                   Icons.star,
  //   //                                   size: 14.sp,
  //   //                                   color: const Color(0xff008080),
  //   //                                 ),
  //   //                                 SizedBox(width: 5.w),
  //   //                                 Text(
  //   //                                   "${collage.rating ?? 0} (${collage.totalReviews ?? 0} Reviews)",
  //   //                                   style: GoogleFonts.roboto(
  //   //                                     fontSize: 12.sp,
  //   //                                     fontWeight: FontWeight.w600,
  //   //                                     color: Colors.black,
  //   //                                   ),
  //   //                                 ),
  //   //                               ],
  //   //                             ),
  //   //                           ),
  //   //                         ),
  //   //                       ],
  //   //                     ),
  //   //                   ),
  //   //                   SizedBox(height: 10.h),
  //   //                   const Divider(),
  //   //                   // Reviews Section
  //   //                   Container(
  //   //                     margin: EdgeInsets.only(left: 10.w, right: 10.w),
  //   //                     child: Row(
  //   //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //   //                       children: [
  //   //                         Text(
  //   //                           "Reviews & Testimonials",
  //   //                           style: GoogleFonts.roboto(
  //   //                             fontSize: 12.sp,
  //   //                             fontWeight: FontWeight.w600,
  //   //                             color: const Color(0xff666666),
  //   //                           ),
  //   //                         ),
  //   //                         GestureDetector(
  //   //                           onTap: () {
  //   //                             Navigator.push(
  //   //                                 context,
  //   //                                 MaterialPageRoute(
  //   //                                     builder: (context) => AllReviewPage(
  //   //                                           id: collage.id!,
  //   //                                         )));
  //   //                           },
  //   //                           child: Text(
  //   //                             "View All",
  //   //                             style: GoogleFonts.roboto(
  //   //                               fontSize: 12.sp,
  //   //                               fontWeight: FontWeight.w600,
  //   //                               color: const Color(0xff008080),
  //   //                             ),
  //   //                           ),
  //   //                         ),
  //   //                       ],
  //   //                     ),
  //   //                   ),
  //   //                   SizedBox(height: 10.h),
  //   //                   // Reviews List
  //   //                   Expanded(
  //   //                     child: ListView.builder(
  //   //                       padding: EdgeInsets.symmetric(horizontal: 10.w),
  //   //                       itemCount: propertyDetail.reviews?.length ?? 0,
  //   //                       itemBuilder: (context, index) {
  //   //                         final review = propertyDetail.reviews![index];
  //   //                         return Card(
  //   //                           margin: EdgeInsets.only(bottom: 10.h),
  //   //                           child: Padding(
  //   //                             padding: EdgeInsets.all(10.w),
  //   //                             child: Column(
  //   //                               crossAxisAlignment: CrossAxisAlignment.start,
  //   //                               children: [
  //   //                                 Row(
  //   //                                   children: [
  //   //                                     Icon(
  //   //                                       Icons.star,
  //   //                                       color: const Color(0xff008080),
  //   //                                       size: 16.sp,
  //   //                                     ),
  //   //                                     SizedBox(width: 5.w),
  //   //                                     Text(
  //   //                                       "${review.rating}/5",
  //   //                                       style: GoogleFonts.roboto(
  //   //                                         fontSize: 12.sp,
  //   //                                         fontWeight: FontWeight.w600,
  //   //                                       ),
  //   //                                     ),
  //   //                                   ],
  //   //                                 ),
  //   //                                 SizedBox(height: 5.h),
  //   //                                 Text(
  //   //                                   review.description ?? '',
  //   //                                   style: GoogleFonts.roboto(
  //   //                                     fontSize: 12.sp,
  //   //                                     color: const Color(0xff666666),
  //   //                                   ),
  //   //                                 ),
  //   //                                 SizedBox(height: 5.h),
  //   //                                 Text(
  //   //                                   "Posted on ${review.createdAt?.toString().split(' ')[0] ?? ''}",
  //   //                                   style: GoogleFonts.roboto(
  //   //                                     fontSize: 10.sp,
  //   //                                     color: Colors.grey,
  //   //                                   ),
  //   //                                 ),
  //   //                               ],
  //   //                             ),
  //   //                           ),
  //   //                         );
  //   //                       },
  //   //                     ),
  //   //                   ),
  //   //                 ],
  //   //               ),
  //   //             ),
  //   //           ),
  //   //         ),
  //   //       ],
  //   //     ),

  //   //     Positioned(
  //   //       top: 60.h,
  //   //       left: 20.w,
  //   //       right: 20.w,
  //   //       child: Row(
  //   //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //   //         children: [
  //   //           // Left circle
  //   //           GestureDetector(
  //   //             onTap: () {
  //   //               Navigator.pop(context);
  //   //             },
  //   //             child: Container(
  //   //               height: 50.h,
  //   //               width: 50.w,
  //   //               decoration: BoxDecoration(
  //   //                 borderRadius: BorderRadius.circular(30),
  //   //                 color: Colors.white,
  //   //               ),
  //   //               child: const Icon(Icons.arrow_back_ios_new),
  //   //             ),
  //   //           ),
  //   //           // Title
  //   //           Text(
  //   //             "College Review",
  //   //             style: GoogleFonts.roboto(
  //   //               fontSize: 16.sp,
  //   //               fontWeight: FontWeight.w600,
  //   //               color: Colors.white,
  //   //             ),
  //   //           ),
  //   //           // Right circle
  //   //           Container(
  //   //             height: 50.h,
  //   //             width: 50.w,
  //   //             decoration: BoxDecoration(
  //   //               borderRadius: BorderRadius.circular(30),
  //   //               color: Colors.white,
  //   //             ),
  //   //             child: const Icon(Icons.search),
  //   //           ),
  //   //         ],
  //   //       ),
  //   //     ),
  //   //     // College Image
  //   //     Positioned(
  //   //       left: 0,
  //   //       right: 0,
  //   //       top: 140.h,
  //   //       child: Container(
  //   //         height: 182.h,
  //   //         width: 182.w,
  //   //         decoration: BoxDecoration(
  //   //           borderRadius: BorderRadius.circular(30),
  //   //           color: Colors.white,
  //   //         ),
  //   //         child: ClipRRect(
  //   //           borderRadius: BorderRadius.circular(30),
  //   //           child: Image.network(
  //   //             fullImageUrl,
  //   //             fit: BoxFit.cover,
  //   //             errorBuilder: (context, error, stackTrace) =>
  //   //                 Image.asset("assets/girlpic.png"),
  //   //           ),
  //   //         ),
  //   //       ),
  //   //     ),
  //   //   ],
  //   // );
  //   // return Scaffold(
  //   //   body: Stack(
  //   //     children: [
  //   //       Column(
  //   //         children: [
  //   //           Container(
  //   //             height: 220.h,
  //   //             width: double.infinity,
  //   //             color: const Color(0xff008080),
  //   //           ),
  //   //           Expanded(
  //   //             child: Container(
  //   //               color: Colors.white,
  //   //               child: Container(
  //   //                 width: double.infinity,
  //   //                 margin: EdgeInsets.only(top: 100.h),
  //   //                 child: SingleChildScrollView(
  //   //                   child: Column(children: [
  //   //                     SizedBox(
  //   //                       height: 10.h,
  //   //                     ),
  //   //                     Text(
  //   //                       "userProfile.data.fullName",
  //   //                       style: GoogleFonts.roboto(
  //   //                         fontSize: 24.sp,
  //   //                         fontWeight: FontWeight.w600,
  //   //                         color: Colors.black,
  //   //                       ),
  //   //                     ),
  //   //                     Text(
  //   //                       // profile.totalExperience ?? 'No experience listed',
  //   //                       "Total Experience ",
  //   //                       style: GoogleFonts.roboto(
  //   //                         fontSize: 15.sp,
  //   //                         fontWeight: FontWeight.w600,
  //   //                         color: const Color(0xff666666),
  //   //                       ),
  //   //                     ),
  //   //                     Padding(
  //   //                       padding: EdgeInsets.only(left: 15.w, right: 15.w),
  //   //                       child: Text(
  //   //                         textAlign: TextAlign.center,
  //   //                         'College: {profile.usersField} - Company: {profile.companiesWorked?.toString()',
  //   //                         style: GoogleFonts.roboto(
  //   //                           fontSize: 15.sp,
  //   //                           fontWeight: FontWeight.w600,
  //   //                           color: const Color(0xff666666),
  //   //                         ),
  //   //                       ),
  //   //                     ),
  //   //                     SizedBox(
  //   //                       height: 15.h,
  //   //                     ),
  //   //                     Container(
  //   //                       margin: EdgeInsets.only(left: 10.w, right: 10.w),
  //   //                       child: Row(
  //   //                         mainAxisAlignment: MainAxisAlignment.center,
  //   //                         children: [
  //   //                           Container(
  //   //                             padding: EdgeInsets.only(
  //   //                                 left: 12.w,
  //   //                                 right: 12.w,
  //   //                                 top: 8.h,
  //   //                                 bottom: 8.h),
  //   //                             decoration: BoxDecoration(
  //   //                               borderRadius: BorderRadius.circular(20.r),
  //   //                               color: Color(0xffDEDDEC),
  //   //                             ),
  //   //                             child: Text(
  //   //                               "Placement Expert",
  //   //                               style: GoogleFonts.roboto(
  //   //                                 fontSize: 14.sp,
  //   //                                 fontWeight: FontWeight.w600,
  //   //                                 color: Colors.black,
  //   //                               ),
  //   //                             ),
  //   //                           ),
  //   //                           SizedBox(width: 15.w),
  //   //                           Container(
  //   //                             padding: EdgeInsets.only(
  //   //                                 left: 12.w,
  //   //                                 right: 12.w,
  //   //                                 top: 8.h,
  //   //                                 bottom: 8.h),
  //   //                             decoration: BoxDecoration(
  //   //                               borderRadius: BorderRadius.circular(20.r),
  //   //                               color: const Color(0xffDEDDEC),
  //   //                             ),
  //   //                             child: Text(
  //   //                               "Career Coach",
  //   //                               style: GoogleFonts.roboto(
  //   //                                 fontSize: 14.sp,
  //   //                                 fontWeight: FontWeight.w600,
  //   //                                 color: Colors.black,
  //   //                               ),
  //   //                             ),
  //   //                           ),
  //   //                           SizedBox(width: 15.w),
  //   //                           Container(
  //   //                             padding: EdgeInsets.only(
  //   //                                 left: 12.w,
  //   //                                 right: 12.w,
  //   //                                 top: 8.h,
  //   //                                 bottom: 8.h),
  //   //                             decoration: BoxDecoration(
  //   //                               borderRadius: BorderRadius.circular(20.r),
  //   //                               color: const Color(0xffDEDDEC),
  //   //                             ),
  //   //                             child: Row(
  //   //                               children: [
  //   //                                 Icon(
  //   //                                   Icons.star,
  //   //                                   size: 16.sp,
  //   //                                   color: const Color(0xff008080),
  //   //                                 ),
  //   //                                 SizedBox(width: 5.w),
  //   //                                 Text(
  //   //                                   "4.5 Review",
  //   //                                   style: GoogleFonts.roboto(
  //   //                                     fontSize: 14.sp,
  //   //                                     fontWeight: FontWeight.w600,
  //   //                                     color: Colors.black,
  //   //                                   ),
  //   //                                 ),
  //   //                               ],
  //   //                             ),
  //   //                           ),
  //   //                         ],
  //   //                       ),
  //   //                     ),
  //   //                     Container(
  //   //                       margin: EdgeInsets.only(
  //   //                           left: 10.w, top: 20.h, right: 10.w),
  //   //                       child: Row(
  //   //                         mainAxisAlignment: MainAxisAlignment.center,
  //   //                         children: [
  //   //                           Container(
  //   //                             padding: EdgeInsets.only(
  //   //                                 left: 15.w,
  //   //                                 right: 15.w,
  //   //                                 top: 15.h,
  //   //                                 bottom: 15.h),
  //   //                             decoration: BoxDecoration(
  //   //                               borderRadius: BorderRadius.circular(20.r),
  //   //                               color: Color(0xffA8E6CF),
  //   //                             ),
  //   //                             child: Text(
  //   //                               "Placement Expert",
  //   //                               style: GoogleFonts.roboto(
  //   //                                 fontSize: 14.sp,
  //   //                                 fontWeight: FontWeight.w600,
  //   //                                 color: Colors.black,
  //   //                               ),
  //   //                             ),
  //   //                           ),
  //   //                           SizedBox(width: 20.w),
  //   //                           GestureDetector(
  //   //                             onTap: () {},
  //   //                             child: Container(
  //   //                               height: 50.h,
  //   //                               width: 140.w,
  //   //                               decoration: BoxDecoration(
  //   //                                 borderRadius: BorderRadius.circular(20.r),
  //   //                                 color: Colors.white,
  //   //                                 border:
  //   //                                     Border.all(color: Color(0xff008080)),
  //   //                               ),
  //   //                               child: Center(
  //   //                                 child: Text(
  //   //                                   "Message",
  //   //                                   style: GoogleFonts.roboto(
  //   //                                     fontSize: 14.sp,
  //   //                                     fontWeight: FontWeight.w600,
  //   //                                     color: const Color(0xff008080),
  //   //                                   ),
  //   //                                 ),
  //   //                               ),
  //   //                             ),
  //   //                           ),
  //   //                         ],
  //   //                       ),
  //   //                     ),
  //   //                     SizedBox(
  //   //                       height: 30.h,
  //   //                     ),
  //   //                     Divider(),
  //   //                     Container(
  //   //                       margin: EdgeInsets.only(left: 20.w, top: 15.h),
  //   //                       child: Row(
  //   //                         mainAxisAlignment: MainAxisAlignment.start,
  //   //                         children: [
  //   //                           Column(
  //   //                             crossAxisAlignment: CrossAxisAlignment.start,
  //   //                             children: [
  //   //                               Text(
  //   //                                 "About {userProfile.data.fullName}",
  //   //                                 style: GoogleFonts.roboto(
  //   //                                   fontSize: 20.sp,
  //   //                                   fontWeight: FontWeight.w600,
  //   //                                   color: Colors.black,
  //   //                                 ),
  //   //                               ),
  //   //                               SizedBox(height: 3.h),
  //   //                               Text(
  //   //                                 " userProfile.data.description",
  //   //                                 style: GoogleFonts.roboto(
  //   //                                   fontSize: 16.sp,
  //   //                                   fontWeight: FontWeight.w600,
  //   //                                   color: const Color(0xff666666),
  //   //                                 ),
  //   //                               ),
  //   //                               SizedBox(height: 3.h),
  //   //                               SizedBox(
  //   //                                 width: 400.w,
  //   //                                 child: Text(
  //   //                                   '{userProfile.data.usersField ?? '
  //   //                                   '} - Company: {userProfile.data.serviceType?.toString() ?? }',
  //   //                                   style: GoogleFonts.roboto(
  //   //                                     fontSize: 15.sp,
  //   //                                     fontWeight: FontWeight.w600,
  //   //                                     color: Color(0xff666666),
  //   //                                   ),
  //   //                                 ),
  //   //                               ),
  //   //                               SizedBox(height: 3.h),
  //   //                               SizedBox(
  //   //                                 width: 400.w,
  //   //                                 child: Text(
  //   //                                   "userProfile.data.serviceType,",
  //   //                                   style: GoogleFonts.roboto(
  //   //                                     fontSize: 15.sp,
  //   //                                     fontWeight: FontWeight.w600,
  //   //                                     color: Color(0xff666666),
  //   //                                   ),
  //   //                                 ),
  //   //                               ),
  //   //                             ],
  //   //                           ),
  //   //                         ],
  //   //                       ),
  //   //                     ),
  //   //                     SizedBox(
  //   //                       height: 10.h,
  //   //                     ),
  //   //                     Divider(),
  //   //                     // Educations section
  //   //                     Container(
  //   //                         margin: EdgeInsets.only(left: 20.w, top: 15.h),
  //   //                         child: Row(
  //   //                             mainAxisAlignment: MainAxisAlignment.start,
  //   //                             children: [
  //   //                               Column(
  //   //                                 crossAxisAlignment:
  //   //                                     CrossAxisAlignment.start,
  //   //                                 children: [
  //   //                                   Text(
  //   //                                     "Educations",
  //   //                                     style: GoogleFonts.roboto(
  //   //                                       fontSize: 20.sp,
  //   //                                       fontWeight: FontWeight.w600,
  //   //                                       color: Colors.black,
  //   //                                     ),
  //   //                                   ),
  //   //                                   SizedBox(height: 5.h),
  //   //                                   Text(
  //   //                                     "userProfile.data.totalExperience",
  //   //                                     style: GoogleFonts.roboto(
  //   //                                       fontSize: 12.sp,
  //   //                                       fontWeight: FontWeight.w600,
  //   //                                       color: const Color(0xff666666),
  //   //                                     ),
  //   //                                   ),
  //   //                                   Text(
  //   //                                     "  userProfile.data.serviceType,",
  //   //                                     style: GoogleFonts.roboto(
  //   //                                       fontSize: 12.sp,
  //   //                                       fontWeight: FontWeight.w600,
  //   //                                       color: const Color(0xff666666),
  //   //                                     ),
  //   //                                   ),
  //   //                                 ],
  //   //                               ),
  //   //                             ])),
  //   //                     SizedBox(
  //   //                       height: 10.h,
  //   //                     ),
  //   //                     Divider(),
  //   //                     Container(
  //   //                       margin: EdgeInsets.only(left: 20.w, top: 15.h),
  //   //                       child: Row(
  //   //                           mainAxisAlignment: MainAxisAlignment.start,
  //   //                           children: [
  //   //                             Column(
  //   //                               crossAxisAlignment: CrossAxisAlignment.start,
  //   //                               children: [
  //   //                                 Text(
  //   //                                   "Skills",
  //   //                                   style: GoogleFonts.roboto(
  //   //                                     fontSize: 20.sp,
  //   //                                     fontWeight: FontWeight.w600,
  //   //                                     color: Colors.black,
  //   //                                   ),
  //   //                                 ),
  //   //                                 SizedBox(height: 10.h),
  //   //                                 // if (userProfile.data.skills != null &&
  //   //                                 //     userProfile.data.skills.isNotEmpty)
  //   //                                 // Wrap(
  //   //                                 //   spacing: 10.w,
  //   //                                 //   runSpacing: 5.h,
  //   //                                 //   children: userProfile.data.skills
  //   //                                 //       .map<Widget>((skill) => Container(
  //   //                                 //             padding: EdgeInsets.symmetric(
  //   //                                 //                 horizontal: 12.w,
  //   //                                 //                 vertical: 8.h),
  //   //                                 //             decoration: BoxDecoration(
  //   //                                 //               borderRadius:
  //   //                                 //                   BorderRadius.circular(20.r),
  //   //                                 //               color: const Color(0xffDEDDEC),
  //   //                                 //             ),
  //   //                                 //             child: Center(
  //   //                                 //               child: Text(
  //   //                                 //                 skill.toString(),
  //   //                                 //                 style: GoogleFonts.roboto(
  //   //                                 //                   fontSize: 14.sp,
  //   //                                 //                   fontWeight: FontWeight.w600,
  //   //                                 //                   color: Colors.black,
  //   //                                 //                 ),
  //   //                                 //               ),
  //   //                                 //             ),
  //   //                                 //           ))
  //   //                                 //       .toList(),
  //   //                                 // )
  //   //                                 // else
  //   //                                 //   Text(
  //   //                                 //     'No skills listed',
  //   //                                 //     style: GoogleFonts.roboto(
  //   //                                 //       fontSize: 15.sp,
  //   //                                 //       fontWeight: FontWeight.w600,
  //   //                                 //       color: const Color(0xff666666),
  //   //                                 //     ),
  //   //                                 //   ),
  //   //                               ],
  //   //                             ),
  //   //                           ]),
  //   //                     ),
  //   //                     SizedBox(height: 20.h),
  //   //                   ]),
  //   //                 ),
  //   //               ),
  //   //             ),
  //   //           ),
  //   //         ],
  //   //       ),
  //   //       Positioned(
  //   //         top: 60.h,
  //   //         left: 20.w,
  //   //         right: 20.w,
  //   //         child: Row(
  //   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //   //           children: [
  //   //             GestureDetector(
  //   //               onTap: () {},
  //   //               child: Container(
  //   //                   height: 50.h,
  //   //                   width: 45.w,
  //   //                   decoration: BoxDecoration(
  //   //                     shape: BoxShape.circle,
  //   //                     color: Colors.white,
  //   //                   ),
  //   //                   child: Padding(
  //   //                     padding: EdgeInsets.all(8.0),
  //   //                     child: Icon(Icons.arrow_back_ios),
  //   //                   )),
  //   //             ),
  //   //             Text(
  //   //               "Collage Details",
  //   //               style: GoogleFonts.roboto(
  //   //                 fontSize: 20.sp,
  //   //                 fontWeight: FontWeight.w600,
  //   //                 color: Colors.white,
  //   //               ),
  //   //             ),
  //   //             Container(
  //   //               height: 50.h,
  //   //               width: 50.w,
  //   //               decoration: BoxDecoration(
  //   //                 borderRadius: BorderRadius.circular(30),
  //   //                 color: Colors.white,
  //   //               ),
  //   //               child: const Icon(Icons.search),
  //   //             ),
  //   //           ],
  //   //         ),
  //   //       ),
  //   //       // Positioned(
  //   //       //   left: 0,
  //   //       //   right: 0,
  //   //       //   top: 140.h,
  //   //       //   child: Center(
  //   //       //     child: ClipOval(
  //   //       //       child: userProfile.data.profilePic != null
  //   //       //           ? Image.network(
  //   //       //               userProfile.data.profilePic!,
  //   //       //               height: 182.h,
  //   //       //               width: 182.w,
  //   //       //               fit: BoxFit.cover,
  //   //       //               errorBuilder: (context, error, stackTrace) =>
  //   //       //                   Image.asset("assets/girlpic.png",
  //   //       //                       height: 182.h, width: 182.w, fit: BoxFit.cover),
  //   //       //             )
  //   //       //           : Image.asset("assets/girlpic.png",
  //   //       //               height: 182.h, width: 182.w, fit: BoxFit.cover),
  //   //       //     ),
  //   //       //   ),
  //   //       // ),
  //   //     ],
  //   //   ),
  //   // );
  // }
}
