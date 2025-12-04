// import 'dart:developer';
// import 'dart:io';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:educationapp/coreFolder/Controller/getProfileUserProvider.dart';
// import 'package:educationapp/coreFolder/Controller/getSkillProvider.dart';
// import 'package:educationapp/coreFolder/Controller/userProfileController.dart';
// import 'package:educationapp/coreFolder/Model/getProfileUserModel.dart';
// import 'package:educationapp/coreFolder/auth/login.auth.dart';
// import 'package:educationapp/home/home.page.dart';
// import 'package:educationapp/main.dart';
// import 'package:educationapp/splash/getstart.page.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive/hive.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';

// // import '../coreFolder/Model/profileGetModel.dart'; // Removed old import

// import '../login/login.page.dart'; // Assuming this is the new model file

// class ProfileCompletionWidget extends ConsumerStatefulWidget {
//   bool data;
//   ProfileCompletionWidget(
//     this.data, {
//     super.key,
//   });
//   @override
//   ConsumerState<ProfileCompletionWidget> createState() =>
//       _ProfileCompletionWidgetState();
// }

// class _ProfileCompletionWidgetState
//     extends ConsumerState<ProfileCompletionWidget> {
//   final _formKey = GlobalKey<FormState>();
//   final fullNameController = TextEditingController();
//   // final emailController = TextEditingController(); // Removed as it's not used
//   final totalExperienceController = TextEditingController();
//   final optionsController = TextEditingController();
//   // final skillController = TextEditingController(); // Removed
//   final languagesController = TextEditingController();
//   final linkedinController = TextEditingController();
//   final aboutController = TextEditingController();
//   File? resumeFile;
//   bool buttonLoder = false;
//   int? selectedSkill; // Added for dropdown selection
//   GetUserProfileModel? _profile;
//   Data? _profileData;
//   bool _profileLoaded = false;

//   @override
//   void dispose() {
//     fullNameController.dispose();
//     // emailController.dispose(); // Removed
//     totalExperienceController.dispose();
//     optionsController.dispose();
//     // skillController.dispose(); // Removed
//     languagesController.dispose();
//     linkedinController.dispose();
//     aboutController.dispose();
//     super.dispose();
//   }

//   Future<void> showFilePicker() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx'],
//     );
//     if (result != null) {
//       setState(() {
//         resumeFile = File(result.files.single.path!);
//       });
//     }
//   }

//   DateTime? selectedDate;
//   final dateController = TextEditingController();

//   Future<void> pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime(2000),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );

//     if (picked != null) {
//       final formatted = DateFormat('yyyy-MM-dd').format(picked);
//       dateController.text = formatted;
//     }
//   }

//   File? _image;
//   final picker = ImagePicker();

//   // Future pickImageFromGallery() async {
//   //   var status = await Permission.camera.request();
//   //   if (status.isGranted) {
//   //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//   //     if (pickedFile != null) {
//   //       setState(() {
//   //         _image = File(pickedFile.path);
//   //       });
//   //     }
//   //   } else {
//   //     Fluttertoast.showToast(msg: "Gallery permission denied");
//   //   }
//   // }

//   Future pickImageFromGallery() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       final compressed = await FlutterImageCompress.compressAndGetFile(
//         pickedFile.path,
//         '${pickedFile.path}_compressed.jpg',
//         quality: 60,
//       );

//       setState(() {
//         _image =
//             compressed != null ? File(compressed.path) : File(pickedFile.path);
//       });
//     }
//   }

//   // Future pickImageFromCamera() async {
//   //   var status = await Permission.camera.request();
//   //   if (status.isGranted) {
//   //     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//   //     if (pickedFile != null) {
//   //       setState(() {
//   //         _image = File(pickedFile.path);
//   //       });
//   //     }
//   //   } else {
//   //     Fluttertoast.showToast(msg: "Camera permission denied");
//   //   }
//   // }
//   Future pickImageFromCamera() async {
//     var status = await Permission.camera.request();
//     if (status.isGranted) {
//       final pickedFile = await picker.pickImage(source: ImageSource.camera);

//       if (pickedFile != null) {
//         final compressed = await FlutterImageCompress.compressAndGetFile(
//           pickedFile.path,
//           '${pickedFile.path}_compressed.jpg',
//           quality: 50, // Reduce size
//         );

//         setState(() {
//           _image = compressed != null
//               ? File(compressed.path)
//               : File(pickedFile.path);
//         });
//       }
//     } else {
//       Fluttertoast.showToast(msg: "Camera permission denied");
//     }
//   }

//   Future showImage() async {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (context) {
//         return CupertinoActionSheet(
//           actions: [
//             CupertinoActionSheetAction(
//               onPressed: () {
//                 Navigator.pop(context);
//                 pickImageFromGallery();
//               },
//               child: const Text("Gallery"),
//             ),
//             CupertinoActionSheetAction(
//               onPressed: () {
//                 Navigator.pop(context);
//                 pickImageFromCamera();
//               },
//               child: const Text("Camera"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String formatDate(String dob) {
//     try {
//       // Try parsing ISO formats (2024-12-05)
//       final parsed = DateTime.tryParse(dob);
//       if (parsed != null) {
//         return "${parsed.day.toString().padLeft(2, '0')}/"
//             "${parsed.month.toString().padLeft(2, '0')}/"
//             "${parsed.year}";
//       }

//       // Replace '-' with '/'
//       if (dob.contains('-')) {
//         return dob.replaceAll('-', '/');
//       }

//       return dob;
//     } catch (e) {
//       return dob;
//     }
//   }

//   Future<void> updateProfile() async {
//     final formData = ref.watch(formDataProvider);
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//     if (resumeFile == null && _profileData?.resumeUpload == null) {
//       Fluttertoast.showToast(
//         msg: "Please upload a resume file (.pdf, .doc, or .docx)",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.TOP,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 12.0,
//       );
//       return;
//     }
//     setState(() {
//       buttonLoder = true;
//     });
//     try {
//       var box = Hive.box('userdata');
//       String userType = box.get('userType', defaultValue: 'Student');
//       await Auth.updateUserProfile(
//         userType: userType,
//         resumeFile: resumeFile,
//         totalExperience: totalExperienceController.text,
//         usersField: optionsController.text,
//         skillsId: selectedSkill.toString(),
//         languageKnown: languagesController.text,
//         linkedinUser: linkedinController.text,
//         description: aboutController.text,
//         fullName: fullNameController.text,
//         profileImage: _image,
//         dob: formatDate(dateController.text),
//       );
//       if (mounted) {
//         ref.invalidate(userProfileController);
//         Navigator.pop(context);
//       }
//     } catch (e, st) {
//       log('Registration error: $e');
//       log(st.toString());
//       // Fluttertoast.showToast(
//       //   msg: "Registration failed: $e",
//       //   toastLength: Toast.LENGTH_SHORT,
//       //   gravity: ToastGravity.TOP,
//       //   backgroundColor: Colors.red,
//       //   textColor: Colors.white,
//       //   fontSize: 12.0,
//       // );
//     } finally {
//       if (mounted) {
//         setState(() {
//           buttonLoder = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var box = Hive.box('userdata');

//     final profileAsync = ref.watch(getProfileUserProvider);

//     if (widget.data && !_profileLoaded && profileAsync.hasValue) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         setState(() {
//           // _profile = profileAsync.value.data.!;
//           // _profileData =  profileAsync.value.data;
//           fullNameController.text = profileAsync.value!.data!.fullName ?? '';
//           totalExperienceController.text =
//               profileAsync.value!.data!.totalExperience ?? '';
//           optionsController.text = profileAsync.value!.data!.usersField ?? '';
//           selectedSkill = profileAsync.value!.data!.skillsId;
//           languagesController.text =
//               profileAsync.value!.data!.languageKnown ?? '';
//           linkedinController.text =
//               profileAsync.value!.data!.linkedinUser ?? '';
//           aboutController.text = profileAsync.value!.data!.description ?? '';
//           dateController.text = profileAsync.value!.data!.dob ?? "";
//           _profileLoaded = true;
//         });
//       });
//     }

//     final skillsProvider = ref.watch(getSkillProvider);
//     return Scaffold(
//       body: Form(
//         key: _formKey,
//         child: Container(
//           decoration: BoxDecoration(color: Color(0xff008080)),
//           child: Column(
//             children: [
//               Stack(
//                 alignment: AlignmentDirectional.topCenter,
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         height: 103.h,
//                         width: 392.w,
//                         decoration: BoxDecoration(
//                           color: Color(0xff008080),
//                           // image: DecorationImage(
//                           //   image: AssetImage("assets/loginBack.png"),
//                           // ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(top: 10.h),
//                         height: 70.h,
//                         width: 250.w,
//                         decoration: const BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage("assets/whitevector.png"),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 25.h,
//                     left: 20.w,
//                     child: Row(
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                               width: 40.w,
//                               height: 40.h,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color.fromARGB(25, 0, 0, 0),
//                               ),
//                               child: Icon(
//                                 Icons.arrow_back,
//                                 color: Colors.white,
//                               )),
//                         ),
//                         SizedBox(
//                           width: 20.w,
//                         ),
//                         Text(
//                           "Complete your Profile",
//                           style: GoogleFonts.roboto(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 25.w,
//                               letterSpacing: -0.95,
//                               color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               // SizedBox(height: 20.h),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(30.sp),
//                             topRight: Radius.circular(30.sp))),
//                     child: skillsProvider.when(
//                       data: (snapshot) {
//                         return Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(height: 10.h),
//                             RegisterField(
//                               type: TextInputType.name,
//                               controller: fullNameController,
//                               label: 'Full Name',
//                               validator: (value) => value!.isEmpty
//                                   ? 'Full Name is required'
//                                   : null,
//                             ),
//                             SizedBox(height: 20.h),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 SizedBox(width: 30.w),
//                                 Text(
//                                   "Upload Resume/CV",
//                                   style: GoogleFonts.roboto(
//                                     fontSize: 13.w,
//                                     fontWeight: FontWeight.w400,
//                                     color: const Color(0xFF4D4D4D),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(left: 25.w, right: 25.w),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(40.sp),
//                                 border: Border.all(color: Colors.grey),
//                               ),
//                               child: Row(
//                                 children: [
//                                   InkWell(
//                                     onTap: showFilePicker,
//                                     child: Container(
//                                       padding: EdgeInsets.all(10.sp),
//                                       margin: EdgeInsets.all(10.sp),
//                                       height: 50.h,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(30),
//                                         color: Color(0xff008080),
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           'Choose File',
//                                           style: GoogleFonts.roboto(
//                                               color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: resumeFile != null
//                                         ? Padding(
//                                             padding: EdgeInsets.all(8.w),
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 const Icon(
//                                                   Icons.description,
//                                                   size: 40,
//                                                   color: Colors.blue,
//                                                 ),
//                                                 SizedBox(height: 8.h),
//                                                 Text(
//                                                   resumeFile!.path
//                                                       .split('/')
//                                                       .last,
//                                                   style: GoogleFonts.roboto(
//                                                     fontSize: 12.w,
//                                                     color: Colors.black,
//                                                     fontWeight: FontWeight.w500,
//                                                   ),
//                                                   textAlign: TextAlign.center,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ],
//                                             ),
//                                           )
//                                         : _profileData?.resumeUpload != null
//                                             ? Padding(
//                                                 padding: EdgeInsets.all(8.w),
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     const Icon(
//                                                       Icons.description,
//                                                       size: 40,
//                                                       color: Colors.blue,
//                                                     ),
//                                                     SizedBox(height: 8.h),
//                                                     Text(
//                                                       _profileData!
//                                                           .resumeUpload!
//                                                           .split('/')
//                                                           .last,
//                                                       style: GoogleFonts.roboto(
//                                                         fontSize: 12.w,
//                                                         color: Colors.black,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ),
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               )
//                                             : Padding(
//                                                 padding: EdgeInsets.all(8.w),
//                                                 child: Text(
//                                                   'Upload Resume +',
//                                                   style: TextStyle(
//                                                       color: Colors.black),
//                                                 ),
//                                               ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             RegisterField(
//                               type: TextInputType.number,
//                               controller: totalExperienceController,
//                               label: 'Total Experience',
//                               validator: (value) => value!.isEmpty
//                                   ? 'Total Experience is required'
//                                   : null,
//                             ),
//                             // RegisterField(
//                             //   controller: optionsController,
//                             //   label: 'Options Should be Given',
//                             //   validator: (value) => value!.isEmpty
//                             //       ? 'Options are required'
//                             //       : null,
//                             // ),
//                             Padding(
//                               padding: EdgeInsets.only(
//                                   left: 28.w, right: 28.w, top: 20.h),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Date of birth",
//                                     style: GoogleFonts.roboto(
//                                       fontSize: 13.w,
//                                       fontWeight: FontWeight.w400,
//                                       color: const Color(0xFF4D4D4D),
//                                     ),
//                                   ),
//                                   SizedBox(height: 10.h),
//                                   TextFormField(
//                                     onTap: () {
//                                       pickDate();
//                                     },
//                                     controller: dateController,
//                                     readOnly: true,
//                                     decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.only(
//                                           left: 10.w, top: 20.h, bottom: 20.h),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.grey),
//                                         borderRadius:
//                                             BorderRadius.circular(40.r),
//                                       ),
//                                       border: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.grey),
//                                         borderRadius:
//                                             BorderRadius.circular(40.r),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.grey),
//                                         borderRadius:
//                                             BorderRadius.circular(40.r),
//                                       ),
//                                       prefixIcon: Icon(
//                                         Icons.date_range_outlined,
//                                         color: Color(0xFFC8C8C8),
//                                       ),
//                                       hintText: "Date of Birth",
//                                       hintStyle: GoogleFonts.inter(
//                                         fontSize: 15.sp,
//                                         fontWeight: FontWeight.w600,
//                                         color: Color(0xFFC8C8C8),
//                                       ),
//                                     ),
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please select your date of birth';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: 25.h),
//                             Container(
//                               margin: EdgeInsets.symmetric(horizontal: 28.w),
//                               child: DropdownButtonFormField<int>(
//                                 value: selectedSkill,
//                                 decoration: InputDecoration(
//                                   labelText: 'Skill',
//                                   labelStyle: GoogleFonts.roboto(
//                                     fontSize: 13.w,
//                                     fontWeight: FontWeight.w400,
//                                     color: const Color(0xFF4D4D4D),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30.sp),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30.sp),
//                                     borderSide:
//                                         const BorderSide(color: Colors.grey),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30.sp),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xff008080)),
//                                   ),
//                                 ),
//                                 items: snapshot.data!
//                                     .map((skill) => DropdownMenuItem<int>(
//                                           value: skill.id,
//                                           child: Text(
//                                             skill.title,
//                                             style: GoogleFonts.roboto(
//                                               fontSize: 14.w,
//                                             ),
//                                           ),
//                                         ))
//                                     .toList(),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedSkill = value;
//                                   });
//                                 },
//                                 validator: (value) =>
//                                     value == null ? 'Skill is required' : null,
//                               ),
//                             ),
//                             SizedBox(height: 20.h),
//                             RegisterField(
//                               controller: languagesController,
//                               label: 'Languages known',
//                               validator: (value) => value!.isEmpty
//                                   ? 'Languages known is required'
//                                   : null,
//                             ),
//                             RegisterField(
//                               controller: linkedinController,
//                               label: 'LinkedIn URL',
//                               validator: (value) {
//                                 if (value!.isEmpty)
//                                   return 'LinkedIn URL is required';
//                                 return null;
//                               },
//                             ),
//                             RegisterField(
//                               controller: aboutController,
//                               maxLine: 2,
//                               label: 'About',
//                               validator: (value) =>
//                                   value!.isEmpty ? 'About is required' : null,
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 showImage();
//                               },
//                               child: Center(
//                                 child: Container(
//                                   margin: EdgeInsets.only(top: 20.h),
//                                   width: 380.w,
//                                   height: 220.h,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(20.r),
//                                       border: Border.all(color: Colors.grey)),
//                                   child: _image != null
//                                       ? ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(20.r),
//                                           child: Image.file(
//                                             _image!,
//                                             fit: BoxFit.cover,
//                                             width: 400.w,
//                                             height: 220.h,
//                                           ),
//                                         )
//                                       : (_profileData?.profilePic != null
//                                           ? ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(20.r),
//                                               child: Image.network(
//                                                 _profileData!.profilePic!,
//                                                 fit: BoxFit.cover,
//                                                 width: 400.w,
//                                                 height: 220.h,
//                                                 errorBuilder: (context, error,
//                                                         stackTrace) =>
//                                                     Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Icon(
//                                                       Icons.upload_sharp,
//                                                       color: Color(0xFF008080),
//                                                       size: 30.sp,
//                                                     ),
//                                                     SizedBox(
//                                                       height: 10.h,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             )
//                                           : Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Icon(
//                                                   Icons.upload_sharp,
//                                                   color: Color(0xFF008080),
//                                                   size: 30.sp,
//                                                 ),
//                                                 SizedBox(
//                                                   height: 10.h,
//                                                 ),
//                                               ],
//                                             )),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 10.h),
//                             GestureDetector(
//                               onTap: updateProfile,
//                               child: Container(
//                                 margin: EdgeInsets.only(
//                                     left: 28.w, right: 28.w, top: 10.h),
//                                 height: 52.h,
//                                 width: double
//                                     .infinity, // Better to use double.infinity for responsiveness
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(40.r),
//                                   color: const Color(0xFFA8E6CF),
//                                 ),
//                                 child: Center(
//                                   child: buttonLoder
//                                       ? const CircularProgressIndicator()
//                                       : Text(
//                                           "Submit Now",
//                                           style: GoogleFonts.roboto(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.w500,
//                                             letterSpacing: -0.4,
//                                             fontSize: 14.4.w,
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 10.h),
//                           ],
//                         );
//                       },
//                       error: (error, stackTrace) {
//                         return Center(
//                           child: Text(error.toString()),
//                         );
//                       },
//                       loading: () => SizedBox(
//                         width: MediaQuery.of(context).size.width,
//                         height: MediaQuery.of(context).size.height,
//                         child: Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:educationapp/coreFolder/Controller/getProfileUserProvider.dart';
import 'package:educationapp/coreFolder/Controller/getSkillProvider.dart';
import 'package:educationapp/coreFolder/Controller/userProfileController.dart';
import 'package:educationapp/coreFolder/Model/getProfileUserModel.dart';
import 'package:educationapp/coreFolder/auth/login.auth.dart';
import 'package:educationapp/home/home.page.dart';
import 'package:educationapp/main.dart';
import 'package:educationapp/splash/getstart.page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

// import '../coreFolder/Model/profileGetModel.dart'; // Removed old import

import '../login/login.page.dart'; // Assuming this is the new model file

class ProfileCompletionWidget extends ConsumerStatefulWidget {
  bool data;
  ProfileCompletionWidget(
    this.data, {
    super.key,
  });
  @override
  ConsumerState<ProfileCompletionWidget> createState() =>
      _ProfileCompletionWidgetState();
}

class _ProfileCompletionWidgetState
    extends ConsumerState<ProfileCompletionWidget> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  // final emailController = TextEditingController(); // Removed as it's not used
  final totalExperienceController = TextEditingController();
  final optionsController = TextEditingController();
  // final skillController = TextEditingController(); // Removed
  final languagesController = TextEditingController();
  final linkedinController = TextEditingController();
  final aboutController = TextEditingController();
  File? resumeFile;
  bool buttonLoder = false;
  int? selectedSkill; // Added for dropdown selection
  GetUserProfileModel? _profile;
  Data? _profileData;
  bool _profileLoaded = false;

  @override
  void dispose() {
    fullNameController.dispose();
    // emailController.dispose(); // Removed
    totalExperienceController.dispose();
    optionsController.dispose();
    // skillController.dispose(); // Removed
    languagesController.dispose();
    linkedinController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  Future<void> showFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        resumeFile = File(result.files.single.path!);
      });
    }
  }

  DateTime? selectedDate;
  final dateController = TextEditingController();

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final formatted = DateFormat('dd/MM/yyyy').format(picked);
      dateController.text = formatted;
    }
  }

  File? _image;
  final picker = ImagePicker();

  // Future pickImageFromGallery() async {
  //   var status = await Permission.camera.request();
  //   if (status.isGranted) {
  //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //     if (pickedFile != null) {
  //       setState(() {
  //         _image = File(pickedFile.path);
  //       });
  //     }
  //   } else {
  //     Fluttertoast.showToast(msg: "Gallery permission denied");
  //   }
  // }

  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final compressed = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        '${pickedFile.path}_compressed.jpg',
        quality: 60,
      );

      setState(() {
        _image =
            compressed != null ? File(compressed.path) : File(pickedFile.path);
      });
    }
  }

  // Future pickImageFromCamera() async {
  //   var status = await Permission.camera.request();
  //   if (status.isGranted) {
  //     final pickedFile = await picker.pickImage(source: ImageSource.camera);
  //     if (pickedFile != null) {
  //       setState(() {
  //         _image = File(pickedFile.path);
  //       });
  //     }
  //   } else {
  //     Fluttertoast.showToast(msg: "Camera permission denied");
  //   }
  // }
  Future pickImageFromCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        final compressed = await FlutterImageCompress.compressAndGetFile(
          pickedFile.path,
          '${pickedFile.path}_compressed.jpg',
          quality: 50, // Reduce size
        );

        setState(() {
          _image = compressed != null
              ? File(compressed.path)
              : File(pickedFile.path);
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Camera permission denied");
    }
  }

  Future showImage() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                pickImageFromGallery();
              },
              child: const Text("Gallery"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                pickImageFromCamera();
              },
              child: const Text("Camera"),
            ),
          ],
        );
      },
    );
  }

  String formatDate(String dob) {
    try {
      // Try parsing ISO formats (2024-12-05)
      final parsed = DateTime.tryParse(dob);
      if (parsed != null) {
        return "${parsed.day.toString().padLeft(2, '0')}/"
            "${parsed.month.toString().padLeft(2, '0')}/"
            "${parsed.year}";
      }

      // Replace '-' with '/'
      if (dob.contains('-')) {
        return dob.replaceAll('-', '/');
      }

      return dob;
    } catch (e) {
      return dob;
    }
  }

  Future<void> updateProfile() async {
    final formData = ref.watch(formDataProvider);
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (resumeFile == null && _profileData?.resumeUpload == null) {
      Fluttertoast.showToast(
        msg: "Please upload a resume file (.pdf, .doc, or .docx)",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      return;
    }
    setState(() {
      buttonLoder = true;
    });
    try {
      var box = Hive.box('userdata');
      String userType = box.get('userType', defaultValue: 'Student');
      await Auth.updateUserProfile(
        userType: userType,
        resumeFile: resumeFile,
        totalExperience: totalExperienceController.text,
        usersField: optionsController.text,
        skillsId: selectedSkill.toString(),
        languageKnown: languagesController.text,
        linkedinUser: linkedinController.text,
        description: aboutController.text,
        fullName: fullNameController.text,
        profileImage: _image,
        dob: formatDate(dateController.text),
      );
      if (mounted) {
        ref.invalidate(userProfileController);
        Navigator.pop(context);
      }
    } catch (e, st) {
      log('Registration error: $e');
      log(st.toString());
      // Fluttertoast.showToast(
      //   msg: "Registration failed: $e",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.TOP,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 12.0,
      // );
    } finally {
      if (mounted) {
        setState(() {
          buttonLoder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');

    final profileAsync = ref.watch(getProfileUserProvider);

    if (widget.data && !_profileLoaded && profileAsync.hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // _profile = profileAsync.value.data.!;
          _profileData = profileAsync.value!.data;
          fullNameController.text = profileAsync.value!.data!.fullName ?? '';
          totalExperienceController.text =
              profileAsync.value!.data!.totalExperience ?? '';
          optionsController.text = profileAsync.value!.data!.usersField ?? '';
          selectedSkill = profileAsync.value!.data!.skillsId;
          languagesController.text =
              profileAsync.value!.data!.languageKnown ?? '';
          linkedinController.text =
              profileAsync.value!.data!.linkedinUser ?? '';
          aboutController.text = profileAsync.value!.data!.description ?? '';
          dateController.text = formatDate(profileAsync.value!.data!.dob ?? "");
          _profileLoaded = true;
        });
      });
    }

    final skillsProvider = ref.watch(getSkillProvider);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(color: Color(0xff008080)),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 103.h,
                        width: 392.w,
                        decoration: BoxDecoration(
                          color: Color(0xff008080),
                          // image: DecorationImage(
                          //   image: AssetImage("assets/loginBack.png"),
                          // ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.h),
                        height: 70.h,
                        width: 250.w,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/whitevector.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 25.h,
                    left: 20.w,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(25, 0, 0, 0),
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          "Complete your Profile",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 25.w,
                              letterSpacing: -0.95,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.sp),
                            topRight: Radius.circular(30.sp))),
                    child: skillsProvider.when(
                      data: (snapshot) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10.h),
                            RegisterField(
                              type: TextInputType.name,
                              controller: fullNameController,
                              label: 'Full Name',
                              validator: (value) => value!.isEmpty
                                  ? 'Full Name is required'
                                  : null,
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 30.w),
                                Text(
                                  "Upload Resume/CV",
                                  style: GoogleFonts.roboto(
                                    fontSize: 13.w,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF4D4D4D),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 25.w, right: 25.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.sp),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: showFilePicker,
                                    child: Container(
                                      padding: EdgeInsets.all(10.sp),
                                      margin: EdgeInsets.all(10.sp),
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xff008080),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Choose File',
                                          style: GoogleFonts.roboto(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: resumeFile != null
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.w,
                                                right: 16.w,
                                                top: 6.h,
                                                bottom: 6.h),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.description,
                                                  size: 35.sp,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(height: 8.h),
                                                Text(
                                                  resumeFile!.path
                                                      .split('/')
                                                      .last,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 12.w,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )
                                        : _profileData?.resumeUpload != null
                                            ? Padding(
                                                padding: EdgeInsets.all(8.w),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.description,
                                                      size: 35.sp,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Text(
                                                      _profileData!
                                                          .resumeUpload!
                                                          .split('/')
                                                          .last,
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 12.w,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.all(8.w),
                                                child: Text(
                                                  'Upload Resume +',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                  ),
                                ],
                              ),
                            ),
                            RegisterField(
                              type: TextInputType.number,
                              controller: totalExperienceController,
                              label: 'Total Experience',
                              validator: (value) => value!.isEmpty
                                  ? 'Total Experience is required'
                                  : null,
                            ),
                            // RegisterField(
                            //   controller: optionsController,
                            //   label: 'Options Should be Given',
                            //   validator: (value) => value!.isEmpty
                            //       ? 'Options are required'
                            //       : null,
                            // ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 28.w, right: 28.w, top: 20.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date of birth",
                                    style: GoogleFonts.roboto(
                                      fontSize: 13.w,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF4D4D4D),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  TextFormField(
                                    onTap: () {
                                      pickDate();
                                    },
                                    controller: dateController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 10.w, top: 20.h, bottom: 20.h),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(40.r),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(40.r),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(40.r),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.date_range_outlined,
                                        color: Color(0xFFC8C8C8),
                                      ),
                                      hintText: "Date of Birth",
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFC8C8C8),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select your date of birth';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 25.h),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 28.w),
                              child: DropdownButtonFormField<int>(
                                value: selectedSkill,
                                decoration: InputDecoration(
                                  labelText: 'Skill',
                                  labelStyle: GoogleFonts.roboto(
                                    fontSize: 13.w,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF4D4D4D),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.sp),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.sp),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.sp),
                                    borderSide: const BorderSide(
                                        color: Color(0xff008080)),
                                  ),
                                ),
                                items: snapshot.data!
                                    .map((skill) => DropdownMenuItem<int>(
                                          value: skill.id,
                                          child: Text(
                                            skill.title,
                                            style: GoogleFonts.roboto(
                                              fontSize: 14.w,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedSkill = value;
                                  });
                                },
                                validator: (value) =>
                                    value == null ? 'Skill is required' : null,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            RegisterField(
                              controller: languagesController,
                              label: 'Languages known',
                              validator: (value) => value!.isEmpty
                                  ? 'Languages known is required'
                                  : null,
                            ),
                            RegisterField(
                              controller: linkedinController,
                              label: 'LinkedIn URL',
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'LinkedIn URL is required';
                                return null;
                              },
                            ),
                            RegisterField(
                              controller: aboutController,
                              maxLine: 2,
                              label: 'About',
                              validator: (value) =>
                                  value!.isEmpty ? 'About is required' : null,
                            ),
                            InkWell(
                              onTap: () {
                                showImage();
                              },
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20.h),
                                  width: 380.w,
                                  height: 220.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(color: Colors.grey)),
                                  child: _image != null
                                      ? Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                              child: Image.file(
                                                _image!,
                                                fit: BoxFit.cover,
                                                width: 400.w,
                                                height: 220.h,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(
                                                  style: IconButton.styleFrom(
                                                      backgroundColor:
                                                          Color(0xFFA8E6CF)),
                                                  onPressed: () {
                                                    showImage();
                                                  },
                                                  icon: Icon(Icons.edit,
                                                      color: Colors.black)),
                                            )
                                          ],
                                        )
                                      : (_profileData?.profilePic != null
                                          ? Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.r),
                                                  child: Image.network(
                                                    _profileData!.profilePic!,
                                                    fit: BoxFit.cover,
                                                    width: 400.w,
                                                    height: 220.h,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.upload_sharp,
                                                          color:
                                                              Color(0xFF008080),
                                                          size: 30.sp,
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: IconButton(
                                                      style: IconButton.styleFrom(
                                                          backgroundColor:
                                                              Color(
                                                                  0xFFA8E6CF)),
                                                      onPressed: () {
                                                        showImage();
                                                      },
                                                      icon: Icon(Icons.edit,
                                                          color: Colors.black)),
                                                )
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.upload_sharp,
                                                  color: Color(0xFF008080),
                                                  size: 30.sp,
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                              ],
                                            )),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: updateProfile,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 28.w, right: 28.w, top: 10.h),
                                height: 52.h,
                                width: double
                                    .infinity, // Better to use double.infinity for responsiveness
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.r),
                                  color: const Color(0xFFA8E6CF),
                                ),
                                child: Center(
                                  child: buttonLoder
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          "Submit Now",
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.4,
                                            fontSize: 14.4.w,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        );
                      },
                      error: (error, stackTrace) {
                        return Center(
                          child: Text(error.toString()),
                        );
                      },
                      loading: () => SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
