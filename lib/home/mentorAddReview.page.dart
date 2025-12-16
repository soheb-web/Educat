import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/getMentorReveiwController.dart';
import 'package:educationapp/coreFolder/Controller/saveReviewController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/mentorReviewResModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class MentoraddReviewPage extends ConsumerStatefulWidget {
  final String id;
  const MentoraddReviewPage({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<MentoraddReviewPage> createState() =>
      _MentoraddReviewPageState();
}

class _MentoraddReviewPageState extends ConsumerState<MentoraddReviewPage> {
  int selectedRating = 0;
  final descriptionController = TextEditingController();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    var userId = box.get("userid");
    final getMentorReviewProvider =
        ref.watch(getMentorReviewController(widget.id.toString()));
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor:
          themeMode == ThemeMode.dark ? Color(0xff1B1B1B) : Color(0xFF008080),
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
                //  color: Colors.white,
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : Color(0xff1B1B1B),
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
                        color: themeMode == ThemeMode.dark
                            ? Color(0xff1B1B1B)
                            : Colors.white,
                      ),
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
                        color: themeMode == ThemeMode.dark
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextField(
                      maxLines: 4,
                      controller: descriptionController,
                      style: TextStyle(
                        color: themeMode == ThemeMode.dark
                            ? Color(0xFF4D4D4D)
                            : Colors.white,
                      ),
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
                              borderSide: BorderSide(
                                color: themeMode == ThemeMode.dark
                                    ? Color(0xFF4D4D4D)
                                    : Colors.white,
                              ))),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(double.infinity, 60.h)),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (states) {
                            // When button is disabled
                            if (states.contains(MaterialState.disabled)) {
                              return themeMode == ThemeMode.dark
                                  ? const Color(0xffA8E6CF).withOpacity(0.4)
                                  : Colors.white.withOpacity(0.4);
                            }

                            // When button is enabled
                            return themeMode == ThemeMode.dark
                                ? const Color(0xffA8E6CF)
                                : Colors.white;
                          },
                        ),
                      ),
                      onPressed: selectedRating == 0 || _isLoading
                          ? null
                          : () async {
                              log(widget.id);

                              setState(() {
                                _isLoading = true;
                              });

                              final body = MentorReviewBodyModel(
                                mentorId: widget.id,
                                description: descriptionController.text.trim(),
                                rating: selectedRating,
                              );

                              try {
                                final service = APIStateNetwork(createDio());
                                final response =
                                    await service.mentorReview(body);

                                if (response.status == true) {
                                  ref.invalidate(getMentorReviewController(
                                      widget.id.toString()));
                                  Fluttertoast.showToast(
                                      msg: response.message.toString());

                                  // Reset only after success
                                  setState(() {
                                    selectedRating = 0;
                                    descriptionController.clear();
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Something went wrong");
                                }
                              } catch (e, st) {
                                log("${e.toString()} /n ${st.toString()}");
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
                                color: themeMode == ThemeMode.dark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            )
                          : Text(
                              "Submit Review",
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: themeMode == ThemeMode.dark
                                    ? Colors.black
                                    : Colors.black,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 20.h,
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
                        return ListView.builder(
                          reverse: true,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snp.reviews!.length,
                          itemBuilder: (context, index) {
                            final review = snp.reviews![index];

                            final double avg = double.tryParse(
                                    review.rating.toString() ?? "") ??
                                0.0;
                            final int rating = avg.clamp(0, 5).toInt();

                            return Container(
                              padding: EdgeInsets.only(
                                  left: 16.w,
                                  right: 16.w,
                                  top: 16.h,
                                  bottom: 16.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                // color: Color(0xFFF1F2F6),
                                color: themeMode == ThemeMode.dark
                                    ? Color(0xffF1F2F6)
                                    : Color(0xFF008080),
                              ),
                              margin: EdgeInsets.only(
                                  bottom: 20.h, left: 10.w, right: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color: themeMode == ThemeMode.light
                                          ? Color(0xffDEDDEC)
                                          : Color(0xFF666666),
                                    ),
                                  ),
                                  Text(
                                    review.userName ?? "N/A",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.sp,
                                      color: themeMode == ThemeMode.light
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
                    )
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
