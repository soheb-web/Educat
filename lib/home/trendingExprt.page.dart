import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/expertTrendingSkillController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/MentorDetail.dart';
import 'package:educationapp/home/expertTrendingDetails.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TrendingExprtPage extends ConsumerStatefulWidget {
  final int id;
  const TrendingExprtPage({super.key, required this.id});

  @override
  ConsumerState<TrendingExprtPage> createState() => _TrendingExprtPageState();
}

class _TrendingExprtPageState extends ConsumerState<TrendingExprtPage> {
  final searchController = TextEditingController();
  String searchQuery = "";
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final expertTrendingProvider =
        ref.watch(expertTrendingSkillController(widget.id.toString()));
    return Scaffold(
        // backgroundColor: Color(0xFF1B1B1B),
        backgroundColor: themeMode == ThemeMode.dark
            ? const Color(0xFF1B1B1B)
            : Color(0xFF008080),
        body: expertTrendingProvider.when(
          data: (snap) {
            final filteredExperts = snap.experts.where((expert) {
              final query = searchQuery.toLowerCase();
              return expert.name.toLowerCase().contains(query) ||
                  expert.description.toLowerCase().contains(query) ||
                  expert.tags.any((tag) => tag.toLowerCase().contains(query));
            }).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
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
                                color: Color(0xFF262626)),
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
                          width: 60.w,
                        ),
                        Text(
                          "Trending Skills",
                          style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      controller: searchController,
                      cursorColor: Colors.white,
                      style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
                          hint: Text(
                            "Search",
                            style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: Color(0xFF262626),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ))),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.w, right: 20.w),
                    padding: EdgeInsets.only(
                        left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Color(0xFF262626),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              snap.skill!.image ??
                                  'https://via.placeholder.com/50',
                              width: 50.w,
                              height: 48.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  "https://png.pngtree.com/png-vector/20210604/ourmid/pngtree-gray-network-placeholder-png-image_3416659.jpg",
                                  width: 50.w,
                                  height: 48.h,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snap.skill!.level ?? "",
                                  style: GoogleFonts.inter(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF008080)),
                                ),
                                Text(
                                  snap.skill!.title ?? "",
                                  style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFFFFFF)),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          snap.skill!.description ?? "",
                          style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFCCCCCC)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25.h),
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                      // color: Colors.white,
                      color: themeMode == ThemeMode.dark
                          ? Colors.white
                          : const Color(0xFF1B1B1B),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            Text(
                              snap.skill?.title?.isNotEmpty == true
                                  ? "Expert in ${snap.skill!.title}"
                                  : "Experts",
                              style: GoogleFonts.inter(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                // color: Colors.black,
                                color: themeMode == ThemeMode.dark
                                    ? const Color(0xFF1B1B1B)
                                    : Colors.white,
                              ),
                            ),
                            if (filteredExperts.isEmpty)
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40.h),
                                  child: Text(
                                    "No experts found.",
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      color: themeMode == ThemeMode.dark
                                          ? const Color(0xFF1B1B1B)
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            else
                              ListView.builder(
                                padding: EdgeInsets.only(top: 20.h),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredExperts.length,
                                itemBuilder: (context, index) {
                                  final expert = filteredExperts[index];
                                  final tags = expert.tags;
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                ExpertTrendingDetailsPage(
                                                    id: filteredExperts[index]
                                                        .id),
                                          ));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20.h),
                                      padding: EdgeInsets.all(10.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        border: Border.all(
                                          color:
                                              const Color.fromARGB(25, 0, 0, 0),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // ✅ Profile Image
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            child: Image.network(
                                              expert.profilePic.isNotEmpty
                                                  ? expert.profilePic
                                                  : "https://png.pngtree.com/png-vector/20210604/ourmid/pngtree-gray-network-placeholder-png-image_3416659.jpg",
                                              height: 100.h,
                                              width: 100.w,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.network(
                                                  "https://t4.ftcdn.net/jpg/05/07/58/41/360_F_507584110_KNIfe7d3hUAEpraq10J7MCPmtny8EH7A.jpg",
                                                  height: 100.h,
                                                  width: 100.w,
                                                  fit: BoxFit.contain,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  expert.name,
                                                  style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(height: 5.h),
                                                Text(
                                                  expert.description,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(height: 10.h),
                                                Container(
                                                  height: 0.5.h,
                                                  color: Colors.grey.shade400,
                                                ),
                                                SizedBox(height: 10.h),
                                                Wrap(
                                                  spacing: 8.w,
                                                  runSpacing: 8.h,
                                                  children: List.generate(
                                                      tags.length, (tagIndex) {
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 5.h),
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromARGB(
                                                            225, 222, 221, 236),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.r),
                                                      ),
                                                      child: Text(
                                                        tags[tagIndex],
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) {
            log("$error /n $stackTrace");
            return Center(
              child: Text(
                error.toString(),
                style: GoogleFonts.inter(color: Colors.white),
              ),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
