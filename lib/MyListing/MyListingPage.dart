import 'package:educationapp/MyListing/listingDetails.page.dart';
import 'package:educationapp/coreFolder/Controller/myListingController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/listingBodyModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/home/home.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';
import 'package:hive/hive.dart';

class MyListing extends ConsumerStatefulWidget {
  const MyListing({super.key});

  @override
  ConsumerState<MyListing> createState() => _MyListingState();
}

class _MyListingState extends ConsumerState<MyListing> {
  int voletId = 0;
  int currentBalance = 0;
  final searchController = TextEditingController();
  bool isShow = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(myListingController);
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box("userdata");
    final type = box.get("userType");
    log("userType listing page : $type");
    final myListingProvider = ref.watch(myListingController);
    final themeMode = ref.watch(themeProvider);
    final isMentorOrProfessional = type == "Mentor" || type == "Professional";

    return Scaffold(
      // backgroundColor: Color(0xFF1B1B1B),
      backgroundColor:
          themeMode == ThemeMode.dark ? Color(0xFF1B1B1B) : Color(0xFF008080),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 25.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 30.w,
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              //   child: Container(
              //     height: 44.h,
              //     width: 44.w,
              //     decoration: BoxDecoration(
              //         color: Color(0xFF1B1B1B),
              //         borderRadius: BorderRadius.circular(500.r)),
              //     child: Center(
              //       child: Icon(
              //         Icons.arrow_back_ios,
              //         color: Color(0xFF1B1B1B),
              //         size: 15.w,
              //       ),
              //     ),
              //   ),
              // ),
              Spacer(),
              Text(
                "My Listing",
                style: GoogleFonts.roboto(
                  fontSize: 18.w,
                  fontWeight: FontWeight.w600,
                  color: themeMode == ThemeMode.dark
                      ? Color(0xff008080)
                      : Colors.white,
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    isShow = !isShow;
                    if (!isShow) searchController.clear();
                  });
                },
                child: Container(
                  height: 44.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(39, 255, 255, 255),
                    borderRadius: BorderRadius.circular(500.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.search,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30.w,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: TextField(
              onChanged: (_) => setState(() {}),
              controller: searchController,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.sp),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(
                    left: 10.w, right: 10.w, top: 6.h, bottom: 6.h),
                hintText: "Search collage...",
                hintStyle:
                    GoogleFonts.roboto(color: Colors.white70, fontSize: 18.sp),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.r),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.r),
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon:
                    const Icon(Icons.search, color: Colors.white, size: 20),
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  // color: Colors.white,
                  color:
                      themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.r),
                      topRight: Radius.circular(40.r))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    type != "Student"
                        ? myListingProvider.when(
                            data: (listData) {
                              final query = searchController.text.toLowerCase();
                              final filteredList = query.isEmpty
                                  ? listData.data!
                                  : listData.data!.where((item) {
                                      final education =
                                          item.education?.toLowerCase() ?? '';
                                      final experience =
                                          item.experience?.toString() ?? '';
                                      final stName = item.student!.fullName
                                              ?.toLowerCase() ??
                                          '';
                                      final subjects = item.subjects!
                                          .map((e) => e.toLowerCase() ?? '')
                                          .join(' ');

                                      return education.contains(query) ||
                                          experience.contains(query) ||
                                          stName.contains(query) ||
                                          subjects.contains(query);
                                    }).toList();

                              if (filteredList.isEmpty) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      "No List Available",
                                      style: GoogleFonts.inter(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                    ),
                                  ],
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.h, horizontal: 16.w),
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final item = filteredList[index];
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12.h),
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// STUDENT INFO
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40.r),
                                              child: Image.network(
                                                item.student!.profilePic ??
                                                    "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                                height: 60.h,
                                                width: 60.w,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.network(
                                                    "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                                    height: 60.h,
                                                    width: 60.w,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.student?.fullName ??
                                                      "Student",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  "Looking for Mentor",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 15.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),

                                        SizedBox(height: 14.h),

                                        /// EDUCATION
                                        Row(
                                          children: [
                                            Icon(Icons.school,
                                                size: 18.sp,
                                                color: Colors.blue),
                                            SizedBox(width: 6.w),
                                            Expanded(
                                              child: Text(
                                                item.education ?? '',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 15.sp,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 8.h),

                                        /// EXPERIENCE
                                        Row(
                                          children: [
                                            Icon(Icons.work_outline,
                                                size: 18.sp,
                                                color: Colors.orange),
                                            SizedBox(width: 6.w),
                                            Text(
                                              "${item.experience}+ Years Experience",
                                              style: GoogleFonts.roboto(
                                                fontSize: 15.sp,
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 10.h),

                                        /// SUBJECTS
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: item.subjects!
                                              .map(
                                                (subject) => Chip(
                                                  label: Text(
                                                    subject,
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          225, 222, 221, 236),
                                                  side: BorderSide.none,
                                                ),
                                              )
                                              .toList(),
                                        ),

                                        SizedBox(height: 10.h),

                                        /// BUTTON
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (_) =>
                                                      ListingDetailsPage(item),
                                                ),
                                              ).then((_) {
                                                ref.invalidate(
                                                    myListingController);
                                              });

                                              /*  Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (_) =>
                                                      ListingDetailsPage(item),
                                                ),
                                              );*/
                                            },
                                            child: Text(
                                              "View Details",
                                              style: GoogleFonts.roboto(
                                                fontSize: 15.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            error: (error, stackTrace) {
                              log(stackTrace.toString());

                              // Non-Dio errors
                              return Center(
                                child: Text(
                                  error.toString(),
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            },
                            loading: () => Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : CreateListPage(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CreateListPage extends ConsumerStatefulWidget {
  const CreateListPage({super.key});

  @override
  ConsumerState<CreateListPage> createState() => _CreateListPageState();
}

class _CreateListPageState extends ConsumerState<CreateListPage> {
  final educationCotnroller = TextEditingController();
  final exprienceController = TextEditingController();
  final subjectConroller = TextEditingController();
  final feesController = TextEditingController();
  final descController = TextEditingController();
  final durationController = TextEditingController();
  final locationController = TextEditingController();

  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? mode;

  List<String> modeList = [
    "online",
    "offline",
  ];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.h,
          ),
          CreateList(label: "Education", controller: educationCotnroller),
          CreateList(label: "Experience", controller: exprienceController),
          CreateList(label: "Subjects", controller: subjectConroller),
          CreateList(label: "Location", controller: locationController),
          CreateList(label: "Duration", controller: durationController),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
            child: DropdownButtonFormField(
              dropdownColor:
                  themeMode == ThemeMode.dark ? Colors.white : Colors.black,
              value: mode,
              decoration: InputDecoration(
                labelText: 'Teaching Mode',
                labelStyle: GoogleFonts.roboto(
                  fontSize: 13.w,
                  fontWeight: FontWeight.w400,
                  //color: const Color(0xFF4D4D4D),
                  color:
                      themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.sp),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.sp),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.sp),
                  borderSide: BorderSide(
                    color: themeMode == ThemeMode.dark
                        ? const Color(0xFF4D4D4D)
                        : Colors.white,
                  ),
                ),
              ),
              items: modeList
                  .map((mode) => DropdownMenuItem(
                        value: mode,
                        child: Text(
                          mode,
                          style: GoogleFonts.roboto(
                            fontSize: 14.w,
                            color: themeMode == ThemeMode.dark
                                ? Color(0xFF4D4D4D)
                                : Colors.white,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  mode = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Teaching Mode is required' : null,
            ),
          ),
          CreateList(label: "Budget", controller: feesController),
          CreateList(label: "Description", controller: descController),
          SizedBox(
            height: 20.h,
          ),
          Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(380.w, 50.h),
                      padding: EdgeInsets.symmetric(vertical: 18.h)),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final body = CreatelistBodyModel(
                        education: educationCotnroller.text,
                        experience: exprienceController.text,
                        //  subjects: [subjectConroller.text],
                        subjects: subjectConroller.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList(),
                        fee: feesController.text,
                        description: descController.text,
                        duration: durationController.text,
                        location: locationController.text,
                        teachingMode: mode.toString(),
                      );

                      final service = APIStateNetwork(createDio());
                      final response = await service.createList(body);
                      if (response.response.statusCode == 201) {
                        Fluttertoast.showToast(
                            msg: response.response.data['message']);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(0)));
                        setState(() {
                          isLoading = false;
                        });
                      }
                    } catch (e, st) {
                      setState(() {
                        isLoading = false;
                      });
                      log("${e.toString()} /n ${st.toString()}");
                      Fluttertoast.showToast(msg: "APi Error : $e");
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: isLoading
                      ? Center(
                          child: SizedBox(
                            width: 30.w,
                            height: 30.h,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Text("Create List"))),
          SizedBox(
            height: 30.h,
          )
        ],
      ),
    );
  }
}

class CreateList extends ConsumerStatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? type;

  final int? maxLine;
  final String? Function(String?)? validator;

  const CreateList({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.maxLine,
    this.type,
  });

  @override
  ConsumerState<CreateList> createState() => _CreateListState();
}

class _CreateListState extends ConsumerState<CreateList> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    return Padding(
      padding: EdgeInsets.only(top: 10.h, right: 28.w, left: 28.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.roboto(
                  fontSize: 13.w,
                  fontWeight: FontWeight.w400,
                  // color: const Color(0xFF4D4D4D),
                  color: themeMode == ThemeMode.dark
                      ? Color(0xFF4D4D4D)
                      : Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          TextFormField(
            style: TextStyle(
              color: themeMode == ThemeMode.dark
                  ? Color(0xFF4D4D4D)
                  : Colors.white,
            ),
            controller: widget.controller,
            maxLines: widget.maxLine,
            keyboardType: widget.type,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  // color: Colors.black,
                  color: themeMode == ThemeMode.dark
                      ? const Color(0xFF4D4D4D)
                      : Colors.white,
                ),
                borderRadius: BorderRadius.circular(40.r),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(40.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  //color: Colors.grey
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${widget.label} is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
