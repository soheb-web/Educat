import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/reviewCategoryController.dart';
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
  final String collageCategoryId;
  SaveReviewPage({
    super.key,
    required this.id,
    required this.collageCategoryId,
  });

  @override
  ConsumerState<SaveReviewPage> createState() => _SaveReviewPageState();
}

class _SaveReviewPageState extends ConsumerState<SaveReviewPage> {
  int selectedRating = 0;
  final TextEditingController _descriptionController = TextEditingController();
  final reviewTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Jab page khule, pehli baar latest reviews fetch kar lo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(reviewProvider(widget.id)); // Force fresh fetch
      ref.read(reviewProvider(widget.id).future); // Optional: trigger load
    });
  }

  // Ya phir didChangeDependencies bhi use kar sakte ho (better for Riverpod)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Page open hone par fresh data fetch karne ke liye
    ref.invalidate(reviewCategoryController(widget.collageCategoryId));
    ref.invalidate(reviewProvider(widget.id));
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    reviewTitleController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    var userId = box.get("userid");

    // final reviewAsync = ref.watch(reviewProvider(widget.id));
    // final reviewCategory =
    //     ref.watch(reviewCategoryController(widget.collageCategoryId));

    final reviewAsync = ref.watch(reviewProvider(widget.id));
    final reviewCategory =
        ref.watch(reviewCategoryController(widget.collageCategoryId));
    return Scaffold(
      backgroundColor: Color(0xff1B1B1B),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30.h,
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
                                ref.invalidate(reviewCategoryController(
                                    widget.collageCategoryId));
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
                    SizedBox(
                      height: 20.h,
                    ),
                    reviewCategory.when(
                      data: (data) {
                        if (data.reviews!.isEmpty) {
                          return Center(
                            child: Text(
                              "No reviews yet",
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                color: const Color(0xff666666),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: data.reviews!.length,
                          itemBuilder: (context, index) {
                            final int rating =
                                data.reviews![index].count?.clamp(0, 5) ?? 0;

                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Row(
                                children: [
                                  Text(
                                    data.reviews![index].fullName ?? "N/A",
                                    style: GoogleFonts.inter(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                  Spacer(),

                                  // 3. Filled Stars (Full Icons)
                                  ...List.generate(
                                    rating, // Number of filled stars
                                    (i) => const Icon(
                                      Icons.star, // Filled star icon
                                      color: Colors.amber,
                                      size: 20.0,
                                    ),
                                  ),
                                  // 4. Outlined Stars (Empty Icons)
                                  ...List.generate(
                                    5 - rating, // Remaining stars (5 - filled stars)
                                    (i) => const Icon(
                                      Icons.star_border, // Outlined star icon
                                      color: Colors
                                          .amber, // Use the same color for visual consistency
                                      size: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        log("${error.toString()} /n ${stackTrace.toString()}");
                        return Center(
                          child: Text(error.toString()),
                        );
                      },
                      loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
