import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/main.dart';
import 'package:educationapp/register/register.page.dart';
import 'package:educationapp/splash/getstart.page.dart';
import 'package:educationapp/splash/mentorshpi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class IdPage extends StatefulWidget {
  const IdPage({super.key});

  @override
  State<IdPage> createState() => _IdPageState();
}

class _IdPageState extends State<IdPage> {
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
          alignment: AlignmentDirectional.topStart,
          children: [
            BackGroundImage(),
            IdBody(),
          ],
        ),
      ),
    );
  }
}

class IdBody extends ConsumerStatefulWidget {
  const IdBody({super.key});

  @override
  ConsumerState<IdBody> createState() => _IdBodyState();
}

class _IdBodyState extends ConsumerState<IdBody> {
  File? _image;
  final picker = ImagePicker();

  Future pickImageFromGallery() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Gallery permission denied");
    }
  }

  Future pickImageFromCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
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

  @override
  Widget build(BuildContext context) {
    final formData = ref.watch(formDataProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(top: 60.h, left: 20),
            width: 50.w,
            height: 50.h,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFFA8E6CF)),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 50.h,
        ),
        Center(
          child: Text(
            formData.userType == "Student" ? "Student ID" : "Professional ID",
            style: GoogleFonts.inter(
                fontSize: 25.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        InkWell(
          onTap: () {
            showImage();
          },
          child: Center(
            child: DottedBorder(
                dashPattern: [8, 8],
                radius: Radius.circular(20.r),
                borderType: BorderType.RRect,
                color: Color(0xFF008080),
                strokeWidth: 2.w,
                child: Container(
                  width: 400.w,
                  height: 220.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: _image == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_sharp,
                              color: Color(0xFF008080),
                              size: 30.sp,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              formData.userType == "Student"
                                  ? "Student ID"
                                  : "Professional ID",
                              style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF4D4D4D)),
                            )
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: 400.w,
                            height: 220.h,
                          ),
                        ),
                )),
          ),
        ),
        SizedBox(
          height: 50.h,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              ref.read(myFormDataProvider.notifier).setIdCarPic(_image!.path);
              Fluttertoast.showToast(msg: "upload id Card sucess");
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => RegisterPage()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA8E6CF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.r),
              ),
              fixedSize: Size(400.w, 60.h),
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
        )
      ],
    );
  }
}

class FromDataMode {
  String? email;
  String? password;
  String? confirmPass;
  String? fullName;
  String? phoneNumber;
  String? dob;
  String? userType;
  String? serviceType;
  String? profileImage;
  String? idCardImage;

  FromDataMode({
    this.email,
    this.password,
    this.confirmPass,
    this.fullName,
    this.dob,
    this.phoneNumber,
    this.userType,
    this.serviceType,
    this.profileImage,
    this.idCardImage,
  });

  FromDataMode copyWith({
    String? email,
    String? passwprd,
    String? confirmPass,
    String? fullName,
    String? dob,
    String? phoneNumber,
    String? userType,
    String? serviceType,
    String? profileImage,
    String? idCardImage,
  }) {
    return FromDataMode(
      email: email ?? this.email,
      password: passwprd ?? this.password,
      confirmPass: confirmPass ?? this.confirmPass,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      userType: userType ?? this.userType,
      serviceType: serviceType ?? this.serviceType,
      profileImage: profileImage ?? this.profileImage,
      idCardImage: idCardImage ?? this.idCardImage,
    );
  }
}

class FormDataNotifier extends StateNotifier<FromDataMode> {
  final APIStateNetwork api;
  FormDataNotifier(this.api) : super(FromDataMode());

  void setName(String name) => state = state.copyWith(fullName: name);

  void setEmail(String email) => state = state.copyWith(email: email);

  void setPassword(String password) =>
      state = state.copyWith(passwprd: password);

  void setConfriPassword(String password) =>
      state = state.copyWith(passwprd: password);

  void setPhone(String phone) {
    state = state.copyWith(phoneNumber: phone);
  }

  void setDOB(String dob) => state = state.copyWith(dob: dob);

  void setUserType(String type) => state = state.copyWith(userType: type);

  void setSerType(String type) => state = state.copyWith(serviceType: type);

  void setProfilePicture(String path) =>
      state = state.copyWith(profileImage: path);

  void setIdCarPic(String path) => state = state.copyWith(idCardImage: path);

  Future<void> register() async {
    try {
      File? profileFile;
      File? idCardFile;

      if (state.profileImage != null && state.profileImage!.isNotEmpty) {
        profileFile = File(state.profileImage!);
      }
      if (state.idCardImage != null && state.idCardImage!.isNotEmpty) {
        idCardFile = File(state.idCardImage!);
      }

      final response = await api.registerUser(
        state.fullName ?? "",
        state.email ?? "",
        state.phoneNumber ?? "",
        state.password ?? "",
        state.confirmPass ?? "",
        state.dob ?? "",
        state.userType ?? "",
        state.serviceType ?? "",
        profileFile,
        idCardFile,
      );

      log("✅ Registered successfully: $response");
    } catch (e, st) {
      log("❌ Registration failed: $e");
      log(st.toString());
      rethrow;
    }
  }
}

final myFormDataProvider =
    StateNotifierProvider<FormDataNotifier, FromDataMode>((ref) {
  return FormDataNotifier(APIStateNetwork(createDio()));
});
