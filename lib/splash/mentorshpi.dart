/*
import 'dart:developer';
import 'package:educationapp/main.dart';
import 'package:educationapp/coreFolder/Model/service.model.dart';
import 'package:educationapp/splash/getstart.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../coreFolder/Controller/ServiceController.dart';
import '../register/register.page.dart';

class MentorShipPage extends StatefulWidget {
  const MentorShipPage({super.key});

  @override
  State<MentorShipPage> createState() => _MentorShipPageState();
}

class _MentorShipPageState extends State<MentorShipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 956,
        width: 440,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            BackGroundImage(),
            MentorshipBody(),
          ],
        ),
      ),
    );
  }
}

class MentorshipBody extends ConsumerStatefulWidget {
  const MentorshipBody({super.key});

  @override
  _MentorshipBodyState createState() => _MentorshipBodyState();
}

class _MentorshipBodyState extends ConsumerState<MentorshipBody> {
  final selectColor = Color(0xFFA8E6CF);
  final deselectColor = Color(0xFFF1F2F6);
  int selectIndex = 0;
  Set<Datum> selectedOptions = {};
  Set<String> selectedOptions2 = {};
  List<String> options = [
    "🎓 Placements",
    "🧑‍🎓 Career Guidance",
    "📚 Skills Selection",
    "🤔 General Advice"
  ];

  void sendToNextPage() {
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => RegisterPage()));
  }




  @override
  Widget build(BuildContext context) {
    final serviceDataProvider = ref.watch(getServiceProvider);
    final formData = ref.watch(formDataProvider);
    return serviceDataProvider.when(
        data: (snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                formData.userType == "Student"
                    ? "what are you looking for ?"
                    : "what do u offer as a mentor",
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 26.w,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1.2.h),
              ),
              SizedBox(
                height: 20.h,
              ),
              if (formData.userType == "Student") ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Wrap(
                    spacing: 8.0, // Space between chips
                    runSpacing: 8,
                    children: options.map((option) {
                      return FilterChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50), // Makes the chip fully circular
                          side: const BorderSide(
                              color: Colors
                                  .transparent), // Optional: Add border color
                        ),

                        label: Text(
                          option,
                          style: GoogleFonts.glory(
                              color: Colors.black, fontSize: 18.w),
                        ),

                        backgroundColor:
                            deselectColor, // Color when chip is not selected

                        selectedColor:
                            Color(0xFFA8E6CF), // Color when chip is selected

                        disabledColor: deselectColor,

                        selected: selectedOptions2.contains(option),

                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              selectedOptions2.add(option);
                            } else {
                              selectedOptions2.remove(option);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                )
              ] else ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Wrap(
                    spacing: 8.0, // Space between chips
                    runSpacing: 8,
                    children: snapshot.data.map((option) {
                      return FilterChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50), // Makes the chip fully circular
                          side: const BorderSide(
                              color: Colors
                                  .transparent), // Optional: Add border color
                        ),

                        label: Text(
                          option.title,
                          style: GoogleFonts.glory(
                              color: Colors.black, fontSize: 18.w),
                        ),

                        backgroundColor:
                            deselectColor, // Color when chip is not selected

                        selectedColor:
                            Color(0xFFA8E6CF), // Color when chip is selected

                        disabledColor: deselectColor,

                        selected: selectedOptions.contains(option),

                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              selectedOptions.add(option);
                            } else {
                              selectedOptions.remove(option);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                )
              ],
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Your action here
                  String serviceValue = "";
                  if (formData.userType == "Student") {
                    List<String> selectList = selectedOptions2.toList();
                    for (int i = 0; i < selectList.length; i++) {
                      setState(() {
                        serviceValue = serviceValue == ""
                            ? selectList[i]
                            : "$serviceValue, ${selectList[i]}";
                      });
                    }
                  } else {
                    List<Datum> selectedList = selectedOptions.toList();
                    for (int i = 0; i < selectedOptions.length; i++) {
                      setState(() {
                        serviceValue = serviceValue == ""
                            ? selectedList[i].title
                            : "$serviceValue, ${selectedList[i].title}";
                      });
                    }
                  }

                  log(serviceValue);

                  setState(() {
                    UserRegisterDataHold.usertype =
                        UserRegisterDataHold.usertype;
                    UserRegisterDataHold.serviceType = serviceValue;
                    ref
                        .read(formDataProvider.notifier)
                        .updateServiceType(serviceValue);
                  });

                  sendToNextPage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFA8E6CF), // Same background color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(40.r), // Same rounded border
                  ),
                  fixedSize: Size(400.w, 52.h), // Same width and height
                  elevation: 0, // Remove shadow if needed
                ),
                child: Text(
                  "Continue",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.4,
                    fontSize: 14.4.w,
                  ),
                ),
              ),
              SizedBox(
                height: 80.h,
              ),
            ],
          );
        },
        error: (err, stack) {
          return SizedBox();
        },
        loading: () => Center(
              child: CircularProgressIndicator(),
            ));
  }
}
*/

import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/id.page.dart';
import 'package:educationapp/main.dart';
import 'package:educationapp/coreFolder/Model/service.model.dart';
import 'package:educationapp/splash/getstart.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../coreFolder/Controller/ServiceController.dart';
import '../register/register.page.dart';

class MentorShipPage extends ConsumerStatefulWidget {
  const MentorShipPage({super.key});

  @override
  ConsumerState<MentorShipPage> createState() => _MentorShipPageState();
}

class _MentorShipPageState extends ConsumerState<MentorShipPage> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      body: Container(
        height: 956,
        width: 440,
        decoration: BoxDecoration(
            color:
                themeMode == ThemeMode.dark ? Colors.white : Color(0xFF1B1B1B)),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            BackGroundImage(),
            MentorshipBody(),
          ],
        ),
      ),
    );
  }
}

class MentorshipBody extends ConsumerStatefulWidget {
  const MentorshipBody({super.key});

  @override
  _MentorshipBodyState createState() => _MentorshipBodyState();
}

class _MentorshipBodyState extends ConsumerState<MentorshipBody> {
  final selectColor = Color(0xFFA8E6CF);
  final deselectColor = Color(0xFFF1F2F6);
  int selectIndex = 0;
  Set<Datum> selectedOptions = {};
  Set<String> selectedOptions2 = {
    "Placements"
  }; // Default selection for students
  List<String> options = [
    "Placements",
    "Career Guidance",
    "Skills Selection",
    "General Advice"
  ];

  void sendToNextPage() {
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => RegisterPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final serviceDataProvider = ref.watch(getServiceProvider);
    final formData = ref.watch(formDataProvider);
    final themeMode = ref.watch(themeProvider);
    return serviceDataProvider.when(
        data: (snapshot) {
          // Default selection for mentors if none selected
          if (formData.userType != "Student" &&
              selectedOptions.isEmpty &&
              snapshot.data.isNotEmpty) {
            setState(() {
              selectedOptions.add(snapshot.data[0]);
            });
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20.w),
                  height: 37.h,
                  width: 37.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.r),
                      color: Color(0xFFECEDF4)),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      size: 16.41.h,
                      color: themeMode == ThemeMode.dark
                          ? Color(0xFF1B1B1B)
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Center(
                child: Text(
                  formData.userType == "Student"
                      ? "what are you looking for ?"
                      : "what do u offer as a Professional",
                  style: GoogleFonts.roboto(
                      color: themeMode == ThemeMode.dark
                          ? Color(0xFF1B1B1B)
                          : Colors.white,
                      fontSize: 26.w,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1.2.h),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              if (formData.userType == "Student") ...[
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Wrap(
                      spacing: 8.0, // Space between chips
                      runSpacing: 8,
                      children: options.map((option) {
                        return FilterChip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50), // Makes the chip fully circular
                            side: const BorderSide(
                                color: Colors
                                    .transparent), // Optional: Add border color
                          ),

                          label: Text(
                            option,
                            style: GoogleFonts.glory(
                                color: Colors.black, fontSize: 18.w),
                          ),

                          backgroundColor:
                              deselectColor, // Color when chip is not selected

                          selectedColor:
                              Color(0xFFA8E6CF), // Color when chip is selected

                          disabledColor: deselectColor,

                          selected: selectedOptions2.contains(option),

                          onSelected: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                selectedOptions2.add(option);
                              } else {
                                selectedOptions2.remove(option);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                )
              ] else ...[
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Wrap(
                      spacing: 8.0, // Space between chips
                      runSpacing: 8,
                      children: snapshot.data.map((option) {
                        return FilterChip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50), // Makes the chip fully circular
                            side: const BorderSide(
                                color: Colors
                                    .transparent), // Optional: Add border color
                          ),

                          label: Text(
                            option.title,
                            style: GoogleFonts.glory(
                                color: Colors.black, fontSize: 18.w),
                          ),

                          backgroundColor:
                              deselectColor, // Color when chip is not selected

                          selectedColor:
                              Color(0xFFA8E6CF), // Color when chip is selected

                          disabledColor: deselectColor,

                          selected: selectedOptions.contains(option),

                          onSelected: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                selectedOptions.add(option);
                              } else {
                                selectedOptions.remove(option);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Check if at least one option is selected
                    bool hasSelection = formData.userType == "Student"
                        ? selectedOptions2.isNotEmpty
                        : selectedOptions.isNotEmpty;

                    if (!hasSelection) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select at least one option."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Your action here
                    String serviceValue = "";
                    if (formData.userType == "Student") {
                      List<String> selectList = selectedOptions2.toList();
                      for (int i = 0; i < selectList.length; i++) {
                        serviceValue = serviceValue == ""
                            ? selectList[i]
                            : "$serviceValue, ${selectList[i]}";
                      }
                    } else {
                      List<Datum> selectedList = selectedOptions.toList();
                      for (int i = 0; i < selectedList.length; i++) {
                        serviceValue = serviceValue == ""
                            ? selectedList[i].title
                            : "$serviceValue, ${selectedList[i].title}";
                      }
                    }

                    log(serviceValue);

                    setState(() {
                      UserRegisterDataHold.usertype =
                          UserRegisterDataHold.usertype;
                      UserRegisterDataHold.serviceType = serviceValue;
                      ref
                          .read(formDataProvider.notifier)
                          .updateServiceType(serviceValue);
                    });

                    sendToNextPage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFA8E6CF), // Same background color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(40.r), // Same rounded border
                    ),
                    fixedSize: Size(400.w, 52.h), // Same width and height
                    elevation: 0, // Remove shadow if needed
                  ),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.4,
                      fontSize: 14.4.w,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80.h,
              ),
            ],
          );
        },
        error: (err, stack) {
          return SizedBox();
        },
        loading: () => Center(
              child: CircularProgressIndicator(),
            ));
  }
}
