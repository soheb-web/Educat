import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

import '../coreFolder/Controller/reviewController.dart';
import '../coreFolder/Controller/saveReviewController.dart';
import '../coreFolder/Model/ReviewGetModel.dart';

class SaveReviewPage extends ConsumerStatefulWidget {
  int id;
  SaveReviewPage({super.key, required this.id});

  @override
  ConsumerState<SaveReviewPage> createState() => _SaveReviewPageState();
}

class _SaveReviewPageState extends ConsumerState<SaveReviewPage> {
  int selectedRating = 0;
  final TextEditingController _descriptionController = TextEditingController();
  final reviewTitleController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  // New: Build the modal bottom sheet for adding a review
  // void _showAddReviewModal() {
  //   var box = Hive.box('userdata');
  //   final userId = box.get('userid');
  //   if (userId == null) {
  //     Fluttertoast.showToast(
  //       msg: "Please log in to add a review",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.TOP,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 12.0,
  //     );
  //     return;
  //   }
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) => DraggableScrollableSheet(
  //       initialChildSize: 0.6,
  //       minChildSize: 0.4,
  //       maxChildSize: 0.9,
  //       builder: (context, scrollController) => Container(
  //         padding: EdgeInsets.all(20.w),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               "Add Your Review",
  //               style: GoogleFonts.roboto(
  //                 fontSize: 18.sp,
  //                 fontWeight: FontWeight.w600,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             SizedBox(height: 20.h),
  //             // Rating selector: Row of stars
  //             Text(
  //               "Rating:",
  //               style: GoogleFonts.roboto(
  //                 fontSize: 14.sp,
  //                 fontWeight: FontWeight.w500,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             SizedBox(height: 10.h),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: List.generate(5, (index) {
  //                 final starIndex = index + 1;
  //                 return GestureDetector(
  //                   onTap: () => setState(() => selectedRating = starIndex),
  //                   child: Icon(
  //                     starIndex <= selectedRating
  //                         ? Icons.star
  //                         : Icons.star_border,
  //                     color: const Color(0xffF3CA12),
  //                     size: 30.sp,
  //                   ),
  //                 );
  //               }),
  //             ),
  //             SizedBox(height: 20.h),
  //             // Description text field
  //             Text(
  //               "Description:",
  //               style: GoogleFonts.roboto(
  //                 fontSize: 14.sp,
  //                 fontWeight: FontWeight.w500,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             SizedBox(height: 10.h),
  //             TextField(
  //               controller: _descriptionController,
  //               maxLines: 4,
  //               decoration: InputDecoration(
  //                 hintText: "Share your experience...",
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(10.r),
  //                 ),
  //               ),
  //               style: GoogleFonts.roboto(fontSize: 14.sp),
  //             ),
  //             SizedBox(height: 30.h),
  //             // Submit button
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 onPressed: selectedRating == 0
  //                     ? null
  //                     : () async {
  //                         final Map<String, dynamic> reviewPayload = {
  //                           "user_id": userId,
  //                           "collage_id": widget.id,
  //                           "count": selectedRating.toString(),
  //                           "description": _descriptionController.text.trim(),
  //                         };
  //                         if (reviewPayload["description"]!.isEmpty) {
  //                           Fluttertoast.showToast(
  //                             msg: "Please add a description",
  //                             toastLength: Toast.LENGTH_SHORT,
  //                             gravity: ToastGravity.TOP,
  //                             backgroundColor: Colors.orange,
  //                             textColor: Colors.white,
  //                             fontSize: 12.0,
  //                           );
  //                           return;
  //                         }
  //                         try {
  //                           await ref
  //                               .read(saveReviewProvider(reviewPayload).future);
  //                           // Refresh the reviews list
  //                           ref.invalidate(reviewProvider(widget.id));
  //                           // Reset form
  //                           setState(() => selectedRating = 0);
  //                           _descriptionController.clear();
  //                           Navigator.pop(context);
  //                         } catch (e) {
  //                           Fluttertoast.showToast(
  //                             msg: "Failed to save review: $e",
  //                             toastLength: Toast.LENGTH_SHORT,
  //                             gravity: ToastGravity.TOP,
  //                             backgroundColor: Colors.red,
  //                             textColor: Colors.white,
  //                             fontSize: 12.0,
  //                           );
  //                         }
  //                       },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: const Color(0xffA8E6CF),
  //                   padding: EdgeInsets.symmetric(vertical: 12.h),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10.r),
  //                   ),
  //                 ),
  //                 child: Text(
  //                   "Submit Review",
  //                   style: GoogleFonts.roboto(
  //                     fontSize: 14.sp,
  //                     fontWeight: FontWeight.w600,
  //                     color: const Color(0xff1B1B1B),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    var userId = box.get("userid");

    final reviewAsync = ref.watch(reviewProvider(widget.id));

    return Scaffold(
      backgroundColor: Color(0xff1B1B1B),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white10,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50.w,
                ),
                Text(
                  "Add Review",
                  style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                )
              ],
            ),
          ),
          SizedBox(
            height: 35.h,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 20.w,
                top: 20.h,
                bottom: 20.h,
                right: 20.w,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.r),
                  topLeft: Radius.circular(30.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fill out the details",
                      style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedRating = starIndex),
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: Icon(
                              starIndex <= selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: const Color(0xffF3CA12),
                              size: 30.sp,
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // Text(
                    //   "Review Title",
                    //   style: GoogleFonts.roboto(
                    //       fontSize: 15.sp,
                    //       fontWeight: FontWeight.w500,
                    //       color: Colors.black),
                    // ),
                    // SizedBox(
                    //   height: 10.h,
                    // ),
                    // TextField(
                    //   controller: reviewTitleController,
                    //   decoration: InputDecoration(
                    //       contentPadding: EdgeInsets.only(
                    //           left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
                    //       enabledBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(20.r),
                    //           borderSide: BorderSide(
                    //             color: Colors.grey,
                    //           )),
                    //       focusedBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(20.r),
                    //           borderSide: BorderSide(color: Colors.black))),
                    // ),
                    // SizedBox(
                    //   height: 20.h,
                    // ),
                    Text(
                      "Description",
                      style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextField(
                      maxLines: 5,
                      controller: _descriptionController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60.h),
                        backgroundColor: const Color(0xffA8E6CF),
                      ),
                      onPressed: selectedRating == 0 || _isLoading
                          ? null
                          : () async {
                              final Map<String, dynamic> reviewPayload = {
                                "user_id": userId,
                                "collage_id": widget.id,
                                "count": selectedRating.toString(),
                                "description":
                                    _descriptionController.text.trim(),
                              };
                              if (reviewPayload["description"]!.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Please add a description",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: Colors.orange,
                                  textColor: Colors.white,
                                  fontSize: 12.0,
                                );
                                return;
                              }
                              setState(() => _isLoading = true);
                              try {
                                await ref.read(
                                    saveReviewProvider(reviewPayload).future);
                                // Refresh the reviews list
                                ref.invalidate(reviewProvider(widget.id));
                                // Reset form
                                setState(() => selectedRating = 0);
                                _descriptionController.clear();
                                Navigator.pop(context);
                              } catch (e) {
                                Fluttertoast.showToast(
                                  msg: "Failed to save review: $e",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 12.0,
                                );
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            },
                      child: _isLoading
                          ? SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              "Submit Review",
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff1B1B1B),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // body: reviewAsync.when(
      //   data: (reviewData) => _buildBody(context, reviewData),
      //   loading: () => const Center(child: CircularProgressIndicator()),
      //   error: (error, stack) {
      //     Fluttertoast.showToast(msg: "Error loading reviews: $error");
      //     return const Center(child: Text("Failed to load reviews"));
      //   },
      // ),
    );
  }

  // Widget _buildBody(BuildContext context, ReviewGetModel reviewData) {
  //   final collage = reviewData.collage!;
  //   final totalReviews = collage.totalReviews ?? 0;
  //   final distribution = collage.distribution ?? {};
  //   final averageRating = collage.rating?.toDouble() ?? 0.0;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(
  //         height: 60.h,
  //       ),
  //       Padding(
  //         padding: EdgeInsets.only(left: 20.w, right: 20.w),
  //         child: Row(
  //           children: [
  //             InkWell(
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Container(
  //                 width: 50.w,
  //                 height: 48.h,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   color: Colors.white10,
  //                 ),
  //                 child: Padding(
  //                   padding: EdgeInsets.only(left: 10.w),
  //                   child: Icon(
  //                     Icons.arrow_back_ios,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 50.w,
  //             ),
  //             Text(
  //               "Add Review",
  //               style: GoogleFonts.inter(
  //                   fontSize: 18.sp,
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.white),
  //             )
  //           ],
  //         ),
  //       ),
  //       SizedBox(
  //         height: 35.h,
  //       ),
  //       Expanded(
  //         child: Container(
  //           padding: EdgeInsets.only(
  //             left: 20.w,
  //             top: 20.h,
  //             bottom: 20.h,
  //             right: 20.w,
  //           ),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.only(
  //               topRight: Radius.circular(30.r),
  //               topLeft: Radius.circular(30.r),
  //             ),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Fill out the details",
  //                 style: GoogleFonts.inter(
  //                     fontSize: 20.sp,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black),
  //               ),
  //               SizedBox(
  //                 height: 10.h,
  //               ),
  //               Row(
  //                 children: List.generate(5, (index) {
  //                   final starIndex = index + 1;
  //                   return GestureDetector(
  //                     onTap: () => setState(() => selectedRating = starIndex),
  //                     child: Padding(
  //                       padding: EdgeInsets.only(left: 8.w),
  //                       child: Icon(
  //                         starIndex <= selectedRating
  //                             ? Icons.star
  //                             : Icons.star_border,
  //                         color: const Color(0xffF3CA12),
  //                         size: 30.sp,
  //                       ),
  //                     ),
  //                   );
  //                 }),
  //               ),
  //               SizedBox(
  //                 height: 20.h,
  //               ),
  //               Text(
  //                 "Review Title",
  //                 style: GoogleFonts.roboto(
  //                     fontSize: 15.sp,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.black),
  //               ),
  //               SizedBox(
  //                 height: 10.h,
  //               ),
  //               TextField(
  //                 decoration: InputDecoration(
  //                     contentPadding: EdgeInsets.only(
  //                         left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
  //                     enabledBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(20.r),
  //                         borderSide: BorderSide(
  //                           color: Colors.black,
  //                         )),
  //                     focusedBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(20.r),
  //                         borderSide: BorderSide(color: Color(0xFFA8E6CF)))),
  //               ),
  //               SizedBox(
  //                 height: 20.h,
  //               ),
  //               Text(
  //                 "Description",
  //                 style: GoogleFonts.roboto(
  //                     fontSize: 15.sp,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.black),
  //               ),
  //               SizedBox(
  //                 height: 10.h,
  //               ),
  //               TextField(
  //                 maxLines: 5,
  //                 decoration: InputDecoration(
  //                     contentPadding: EdgeInsets.only(
  //                         left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
  //                     enabledBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(20.r),
  //                         borderSide: BorderSide(
  //                           color: Colors.black,
  //                         )),
  //                     focusedBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(20.r),
  //                         borderSide: BorderSide(color: Color(0xFFA8E6CF)))),
  //               ),
  //               SizedBox(
  //                 height: 20.h,
  //               ),
  //               ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   minimumSize: Size(double.infinity, 60.h),
  //                   backgroundColor: const Color(0xffA8E6CF),
  //                 ),
  //                 onPressed: () {},
  //                 child: Text(
  //                   "Submit Review",
  //                   style: GoogleFonts.roboto(
  //                     fontSize: 14.sp,
  //                     fontWeight: FontWeight.w600,
  //                     color: const Color(0xff1B1B1B),
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: reviewData.reviews?.isEmpty ?? true
  //                     ? Center(
  //                         child: Text(
  //                           "No reviews yet",
  //                           style: GoogleFonts.roboto(
  //                             fontSize: 14.sp,
  //                             color: const Color(0xff666666),
  //                           ),
  //                         ),
  //                       )
  //                     : ListView.builder(
  //                         padding: EdgeInsets.symmetric(
  //                             horizontal: 20.w, vertical: 10.h),
  //                         itemCount: reviewData.reviews?.length ?? 0,
  //                         itemBuilder: (context, index) {
  //                           final review = reviewData.reviews![index];
  //                           return Card(
  //                             margin: EdgeInsets.only(bottom: 10.h),
  //                             child: Padding(
  //                               padding: EdgeInsets.all(16.w),
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
  //                                           fontSize: 14.sp,
  //                                           fontWeight: FontWeight.w600,
  //                                           color: Colors.black,
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                   SizedBox(height: 8.h),
  //                                   Text(
  //                                     review.description ?? '',
  //                                     style: GoogleFonts.roboto(
  //                                       fontSize: 12.sp,
  //                                       color: const Color(0xff666666),
  //                                     ),
  //                                   ),
  //                                   SizedBox(height: 8.h),
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
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
