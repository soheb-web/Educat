import 'package:dio/dio.dart';
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
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';
import 'package:hive/hive.dart';

import '../coreFolder/Controller/getSkillProvider.dart';

class MyListing extends ConsumerStatefulWidget {
  const MyListing({super.key});

  @override
  ConsumerState<MyListing> createState() => _MyListingState();
}

class _MyListingState extends ConsumerState<MyListing> {
  int voletId = 0;
  int currentBalance = 0;
  final searchController = TextEditingController();

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
            ],
          ),
          SizedBox(
            width: 20.w,
          ),
          if (type == "Mentor" || type == "Professional")
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: TextField(
                onChanged: (_) => setState(() {}),
                controller: searchController,
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.sp),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                  hintText: "Search collage...",
                  hintStyle: GoogleFonts.roboto(
                      color: Colors.white70, fontSize: 18.sp),
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

                                      final stName = item.student!.fullName
                                              ?.toLowerCase() ??
                                          '';
                                      final subjects = item.subjects!
                                          .map((e) => e.toLowerCase() ?? '')
                                          .join(' ');

                                      return education.contains(query) ||
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
                                                "Leval : ${item.education ?? ''}",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 15.sp,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          children: [
                                            Icon(Icons.timer,
                                                size: 18.sp, color: Colors.red),
                                            SizedBox(width: 6.w),
                                            Expanded(
                                              child: Text(
                                                "Duration : ${item.duration ?? ''}",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 15.sp,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          children: [
                                            Icon(Icons.wifi,
                                                size: 18.sp,
                                                color: Colors.black),
                                            SizedBox(width: 6.w),
                                            Expanded(
                                              child: Text(
                                                "Available : ${item.teachingMode ?? ''}",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 15.sp,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w700,
                                                ),
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
  final phoneController = TextEditingController();
  final durationController = TextEditingController();
  final localAddressController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  //TextEditingController timeController = TextEditingController();

  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? mode, qualification, budget, requires;

  List<String> modeList = [
    "online",
    "offline",
  ];

  // ✅ selected skills
  final List<String> selectedSubject = [];

  List<String> qualificationList = [
    "10th",
    "12th",
    "Diploma",
    "graduate",
    "Postgraduate"
  ];

  List<String> requireList = [
    "Part Time",
    "Full Time",
  ];

  String? gender;
  String? communicate;

  List<String> genderList = [
    "male",
    "female",
    "other",
  ];

  List<String> communicateList = [
    "English",
    "Hindi",
    "English , Hindi",
  ];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final subjectKeyword = ref.watch(getSkillProvider);
    final budgetProvider = ref.watch(budgetController);
    return Form(
      key: _formKey,
      child: Padding(
          padding: EdgeInsets.only(right: 28.w, left: 28.w),
          child: subjectKeyword.when(
            data: (subjects) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25.h,
                  ),
                  Text(
                    "Subject / Keyword",
                    style: GoogleFonts.roboto(
                      fontSize: 13.w,
                      fontWeight: FontWeight.w400,
                      // color: const Color(0xFF4D4D4D),
                      color: themeMode == ThemeMode.dark
                          ? Color(0xFF4D4D4D)
                          : Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),

                  /// 🔹 TypeAhead
                  FormField<String>(
                    validator: (value) {
                      if (selectedSubject.isEmpty) {
                        return "Please select at least one subject";
                      }
                      return null;
                    },
                    builder: (FormFieldState<String> field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TypeAheadField<String>(
                            hideOnEmpty: false, // 🔥 important
                            hideOnLoading: false,
                            hideOnError: false,
                            builder: (context, controller, focusNode) {
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                style: TextStyle(
                                  color: themeMode == ThemeMode.dark
                                      ? const Color(0xFF4D4D4D)
                                      : Colors.white,
                                ),
                                decoration: InputDecoration(
                                  errorText: field.errorText,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                    borderSide: BorderSide(
                                      color: themeMode == ThemeMode.dark
                                          ? const Color(0xFF4D4D4D)
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },

                            decorationBuilder: (context, child) {
                              return Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(12.r),
                                child: child,
                              );
                            },

                            offset: const Offset(0, 12),
                            constraints: const BoxConstraints(maxHeight: 300),

                            /// ✅ FIXED SUGGESTIONS
                            suggestionsCallback: (pattern) {
                              final query = pattern.trim().toLowerCase();

                              return subjects.data
                                  .where((s) => s.title
                                      .trim()
                                      .toLowerCase()
                                      .contains(query))
                                  .map((e) => e.title)
                                  .toList();
                            },

                            itemBuilder: (context, skill) {
                              return ListTile(
                                title: Text(skill),
                              );
                            },

                            onSelected: (skill) {
                              if (!selectedSubject.contains(skill)) {
                                setState(() => selectedSubject.add(skill));
                                field.didChange(skill);
                              }
                            },
                          ),
                          SizedBox(height: 10.h),

                          /// 🔹 Selected Chips
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: selectedSubject.map((skill) {
                              return Chip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                label: Text(
                                  skill,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onDeleted: () {
                                  setState(() {
                                    selectedSubject.remove(skill);
                                  });
                                  field.validate();
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    "Education / Level",
                    style: GoogleFonts.roboto(
                      fontSize: 13.w,
                      fontWeight: FontWeight.w400,
                      // color: const Color(0xFF4D4D4D),
                      color: themeMode == ThemeMode.dark
                          ? Color(0xFF4D4D4D)
                          : Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  DropdownButtonFormField(
                    dropdownColor: themeMode == ThemeMode.light
                        ? Colors.black
                        : Colors.white,
                    value: qualification == null
                        ? null
                        : (qualificationList
                                .where((item) =>
                                    item.toLowerCase() ==
                                    qualification!.toLowerCase())
                                .isNotEmpty
                            ? qualification
                            : null),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
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
                    items: qualificationList
                        .map((qualification) => DropdownMenuItem(
                              value: qualification,
                              child: Text(
                                qualification,
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
                        qualification = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Education Level is required' : null,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CreateList(
                      label: "Local Address",
                      controller: localAddressController,
                      type: TextInputType.streetAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Local Address is required';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 10.h,
                  ),
                  CreateList(
                      label: "State",
                      controller: stateController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'State is required';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 10.h,
                  ),
                  CreateList(
                      label: "Pin Code",
                      controller: pincodeController,
                      type: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Pin Code is required';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 10.h,
                  ),
                  CreateList(
                      label: "Duration",
                      controller: durationController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Duration is required';
                        }
                        return null;
                      }),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // Text(
                  //   "Select Time",
                  //   style: GoogleFonts.roboto(
                  //     fontSize: 13.w,
                  //     fontWeight: FontWeight.w400,
                  //     // color: const Color(0xFF4D4D4D),
                  //     color: themeMode == ThemeMode.dark
                  //         ? Color(0xFF4D4D4D)
                  //         : Colors.white,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // TextFormField(
                  //   controller: timeController,
                  //   readOnly: true,
                  //   style: TextStyle(
                  //     color: themeMode == ThemeMode.dark
                  //         ? Color(0xFF4D4D4D)
                  //         : Colors.white,
                  //   ),
                  //   decoration: InputDecoration(
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         // color: Colors.black,
                  //         color: themeMode == ThemeMode.dark
                  //             ? const Color(0xFF4D4D4D)
                  //             : Colors.white,
                  //       ),
                  //       borderRadius: BorderRadius.circular(40.r),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.grey,
                  //       ),
                  //       borderRadius: BorderRadius.circular(40.r),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         //color: Colors.grey
                  //         color: Colors.grey,
                  //       ),
                  //       borderRadius: BorderRadius.circular(40.r),
                  //     ),
                  //   ),
                  //   onTap: () async {
                  //     TimeOfDay? picked = await showTimePicker(
                  //       context: context,
                  //       initialTime: TimeOfDay.now(),
                  //     );
                  //     if (picked != null) {
                  //       timeController.text = picked.format(context);
                  //     }
                  //   },
                  // ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Gender Preference",
                    style: GoogleFonts.roboto(
                      fontSize: 13.w,
                      fontWeight: FontWeight.w400,
                      // color: const Color(0xFF4D4D4D),
                      color: themeMode == ThemeMode.dark
                          ? Color(0xFF4D4D4D)
                          : Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  DropdownButtonFormField(
                    dropdownColor: themeMode == ThemeMode.light
                        ? Colors.black
                        : Colors.white,
                    // value: gender,
                    // ⭐ UPDATED VALUE FIX HERE
                    value: gender,
                    decoration: InputDecoration(
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
                    items: genderList
                        .map((data) => DropdownMenuItem(
                              value: data,
                              child: Text(
                                data,
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
                        gender = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Communicate in",
                    style: GoogleFonts.roboto(
                      fontSize: 13.w,
                      fontWeight: FontWeight.w400,
                      // color: const Color(0xFF4D4D4D),
                      color: themeMode == ThemeMode.dark
                          ? Color(0xFF4D4D4D)
                          : Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  DropdownButtonFormField(
                    dropdownColor: themeMode == ThemeMode.light
                        ? Colors.black
                        : Colors.white,

                    // ⭐ UPDATED VALUE FIX HERE
                    value: communicate,
                    decoration: InputDecoration(
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
                    items: communicateList
                        .map((communi) => DropdownMenuItem(
                              value: communi,
                              child: Text(
                                communi,
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
                        communicate = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Communicate is required' : null,
                  ),

                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'Teaching Mode',
                    style: GoogleFonts.roboto(
                      fontSize: 13.w,
                      fontWeight: FontWeight.w400,
                      // color: const Color(0xFF4D4D4D),
                      color: themeMode == ThemeMode.dark
                          ? Color(0xFF4D4D4D)
                          : Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  DropdownButtonFormField(
                    dropdownColor: themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    value: mode,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
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
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'Requires',
                    style: GoogleFonts.roboto(
                      fontSize: 13.w,
                      fontWeight: FontWeight.w400,
                      // color: const Color(0xFF4D4D4D),
                      color: themeMode == ThemeMode.dark
                          ? Color(0xFF4D4D4D)
                          : Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  DropdownButtonFormField(
                    dropdownColor: themeMode == ThemeMode.light
                        ? Colors.black
                        : Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: requires,
                    decoration: InputDecoration(
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
                    items: requireList
                        .map((requires) => DropdownMenuItem(
                              value: requires,
                              child: Text(
                                requires,
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
                        requires = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Teaching mode is required' : null,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Budget",
                    style: GoogleFonts.roboto(
                      fontSize: 13.w,
                      fontWeight: FontWeight.w400,
                      // color: const Color(0xFF4D4D4D),
                      color: themeMode == ThemeMode.dark
                          ? Color(0xFF4D4D4D)
                          : Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  budgetProvider.when(
                    data: (snap) {
                      return DropdownButtonFormField(
                        dropdownColor: themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        value: budget,
                        decoration: InputDecoration(
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
                        items: snap.data!
                            .map((item) => DropdownMenuItem(
                                  value: item.price,
                                  child: Text(
                                    // item.price.toString(),
                                    "₹${(double.tryParse(item.price ?? '0') ?? 0).toInt()}",
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
                            budget = value.toString();
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Budget is required' : null,
                      );
                    },
                    error: (error, stackTrace) {
                      return Center(
                        child: Text(error.toString()),
                      );
                    },
                    loading: () => SizedBox(),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CreateList(
                      label: "Mobile Number", controller: phoneController),
                  SizedBox(
                    height: 25.h,
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(380.w, 50.h),
                            padding: EdgeInsets.symmetric(
                                vertical: 20.h, horizontal: 15.w)),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final body = CreatelistBodyModel(
                                education: qualification.toString(),
                                subjects: selectedSubject,
                                teachingMode: mode.toString(),
                                duration: durationController.text,
                                requires: requires.toString(),
                                budget: budget.toString(),
                                mobileNumber: phoneController.text,
                                // time: timeController.text,
                                gender: gender ?? "",
                                communicate: communicate ?? "",
                                state: stateController.text,
                                localAddress: localAddressController.text,
                                pincode: pincodeController.text);

                            final service = APIStateNetwork(createDio());
                            final response = await service.createList(body);
                            if (response.response.statusCode == 201) {
                              Fluttertoast.showToast(
                                  msg: response.response.data['message']);
                              qualification = null;
                              selectedSubject.clear();
                              mode = null;
                              durationController.clear();
                              requires = null;
                              budget = null;
                              phoneController.clear();
                              //timeController.clear();
                              gender = null;
                              communicate = null;
                              stateController.clear();
                              localAddressController.clear();
                              pincodeController.clear();

                              setState(() {
                                isLoading = false;
                              });
                            }
                          } on DioException catch (e) {
                            if (e.response?.data != null) {
                              final errors = e.response!.data['errors'];

                              errors.forEach((key, value) {
                                log("❌ $key : ${value[0]}");
                              });

                              final message = errors.values.first[0];

                              Fluttertoast.showToast(
                                  msg: message,
                                  backgroundColor: Colors.red,
                                  toastLength: Toast.LENGTH_LONG);
                            }
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
                            : Text("Create List")),
                  ),
                  SizedBox(
                    height: 30.h,
                  )
                ],
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
          )),
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
    return Column(
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
            color:
                themeMode == ThemeMode.dark ? Color(0xFF4D4D4D) : Colors.white,
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
          validator: widget.validator,
          // validator: (value) {
          //   if (value == null || value.trim().isEmpty) {
          //     return '${widget.label} is required';
          //   }
          //   return null;
          // },
        ),
      ],
    );
  }
}
