import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/id.page.dart';
import 'package:educationapp/login/login.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:permission_handler/permission_handler.dart';
import '../coreFolder/auth/login.auth.dart';
import '../main.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});
  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: const Color(0xff008080),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200.h,
                      width: 323.w,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/resisterBack.png"),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 250.h,
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
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : Color(0xFF1B1B1B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: const RegisterForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});
  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool buttonLoader = false;
  final _formKey = GlobalKey<FormState>();
  bool register = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // DateTime? selectedDate;
  // final dateController = TextEditingController();

  // Future<void> pickDate() async {
  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime(2000),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );

  //   if (picked != null) {
  //     final formatted = DateFormat('yyyy-MM-dd').format(picked);
  //     dateController.text = formatted;
  //     ref.read(myFormDataProvider.notifier).setDOB(formatted);
  //   }
  // }

  // File? _image;
  // final picker = ImagePicker();
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
  // Future showImage() async {
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (context) {
  //       return CupertinoActionSheet(
  //         actions: [
  //           CupertinoActionSheetAction(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               pickImageFromGallery();
  //             },
  //             child: const Text("Gallery"),
  //           ),
  //           CupertinoActionSheetAction(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               pickImageFromCamera();
  //             },
  //             child: const Text("Camera"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  bool isShow = false;
  bool conShow = false;
  @override
  Widget build(BuildContext context) {
    final formData = ref.watch(formDataProvider);
    final themeMode = ref.watch(themeProvider);
    final registerProviderData = ref.read(myFormDataProvider.notifier);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          Text(
            "Create Your Account",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 26.w,
              letterSpacing: -0.95,
              color: themeMode == ThemeMode.dark
                  ? Color(0xFF1B1B1B)
                  : Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.w,
                  letterSpacing: -0.50,
                  color: themeMode == ThemeMode.dark
                      ? Color(0xFF1B1B1B)
                      : Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text(
                  "Login",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.w,
                    letterSpacing: -0.50,
                    color: const Color(0xff008080),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: const Divider(height: 1),
          ),
          SizedBox(height: 10.h),
          RegisterField(
            onChange: (value) {
              registerProviderData.setName(value);
            },
            controller: fullNameController,
            label: 'Full Name',
            validator: (value) =>
                value!.isEmpty ? "Full Name is required" : null,
          ),
          RegisterField(
            onChange: (value) {
              registerProviderData.setEmail(value);
            },
            controller: emailController,
            label: 'Email Address',
            validator: (value) {
              if (value!.isEmpty) return "Email is required";
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
          SizedBox(height: 18.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 30.w),
              Text(
                "Phone Number",
                style: GoogleFonts.roboto(
                  fontSize: 13.w,
                  fontWeight: FontWeight.w400,
                  color: themeMode == ThemeMode.dark
                      ? Color(0xFF1B1B1B)
                      : Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 28.w, right: 28.w, top: 10.h),
            child: IntlPhoneField(
              style: TextStyle(
                color: themeMode == ThemeMode.dark
                    ? Color(0xFF1B1B1B)
                    : Colors.white,
              ),
              controller: phoneController,
              decoration: InputDecoration(
                counterText: "",
                hintText: "XXXXXXXXXXX",
                hintStyle: TextStyle(
                  color: themeMode == ThemeMode.dark
                      ? Color(0xFF1B1B1B)
                      : Colors.white,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: themeMode == ThemeMode.dark
                        ? Color(0xFF4D4D4D)
                        : Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(40.r),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(40.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(40.r),
                ),
              ),
              initialCountryCode: 'IN',
              invalidNumberMessage: "Invalid phone number",
              // 🔥 COUNTRY CODE STYLE 🔥
              dropdownTextStyle: TextStyle(
                color: themeMode == ThemeMode.dark
                    ? const Color(0xFF1B1B1B)
                    : Colors.white,
                fontWeight: FontWeight.w500,
              ),

              // 🔥 COUNTRY CODE ICON COLOR 🔥
              dropdownIcon: Icon(
                Icons.arrow_drop_down,
                color: themeMode == ThemeMode.dark
                    ? const Color(0xFF1B1B1B)
                    : Colors.white,
              ),

              // 🔥 +91 TEXT STYLE 🔥

              onChanged: (phone) {
                log("Phone Number: ${phone.completeNumber}");
                registerProviderData.setPhone(phone.toString());
              },
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 28.w, right: 28.w, top: 10.h),
          //   child: TextFormField(
          //     onTap: () {
          //       pickDate();
          //     },
          //     controller: dateController,
          //     readOnly: true,
          //     decoration: InputDecoration(
          //       contentPadding:
          //           EdgeInsets.only(left: 10.w, top: 20.h, bottom: 20.h),
          //       focusedBorder: OutlineInputBorder(
          //         borderSide: const BorderSide(color: Colors.grey),
          //         borderRadius: BorderRadius.circular(40.r),
          //       ),
          //       border: OutlineInputBorder(
          //         borderSide: const BorderSide(color: Colors.grey),
          //         borderRadius: BorderRadius.circular(40.r),
          //       ),
          //       enabledBorder: OutlineInputBorder(
          //         borderSide: const BorderSide(color: Colors.grey),
          //         borderRadius: BorderRadius.circular(40.r),
          //       ),
          //       prefixIcon: Icon(
          //         Icons.date_range_outlined,
          //         color: Color(0xFFC8C8C8),
          //       ),
          //       hintText: "Date of Birth",
          //       hintStyle: GoogleFonts.inter(
          //         fontSize: 15.sp,
          //         fontWeight: FontWeight.w600,
          //         color: Color(0xFFC8C8C8),
          //       ),
          //     ),
          //     validator: (value) {
          //       if (value == null || value.isEmpty) {
          //         return 'Please select your date of birth';
          //       }
          //       return null;
          //     },
          //   ),
          // ),

          // RegisterField(
          //   onChange: (value) {
          //     registerProviderData.setPassword(value);
          //   },
          //   controller: passwordController,
          //   label: 'Password',
          //   obscureText: true,
          //   validator: (value) {
          //     if (value!.isEmpty) return "Password is required";
          //     if (value.length < 6)
          //       return "Password must be at least 6 characters";
          //     return null;
          //   },
          // ),

          Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Password",
                  style: GoogleFonts.roboto(
                    fontSize: 13.w,
                    fontWeight: FontWeight.w400,
                    color: themeMode == ThemeMode.dark
                        ? Color(0xFF1B1B1B)
                        : Colors.white,
                  ),
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  style: TextStyle(
                    color: themeMode == ThemeMode.dark
                        ? Color(0xFF1B1B1B)
                        : Colors.white,
                  ),
                  onChanged: (value) {
                    registerProviderData.setPassword(value);
                  },
                  controller: passwordController,
                  obscureText: isShow ? false : true,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeMode == ThemeMode.dark
                              ? Color(0xFF4D4D4D)
                              : Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isShow = !isShow;
                            });
                          },
                          child: Icon(
                            isShow ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ))),
                  validator: (value) {
                    if (value!.isEmpty) return "Password is required";
                    if (value.length < 6)
                      return "Password must be at least 6 characters";
                    return null;
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Confirm Password",
                  style: GoogleFonts.roboto(
                    fontSize: 13.w,
                    fontWeight: FontWeight.w400,
                    color: themeMode == ThemeMode.dark
                        ? Color(0xFF1B1B1B)
                        : Colors.white,
                  ),
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  style: TextStyle(
                    color: themeMode == ThemeMode.dark
                        ? Color(0xFF1B1B1B)
                        : Colors.white,
                  ),
                  onChanged: (value) {
                    registerProviderData.setConfriPassword(value);
                  },
                  controller: confirmPasswordController,
                  obscureText: conShow ? false : true,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeMode == ThemeMode.dark
                              ? Color(0xFF4D4D4D)
                              : Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              conShow = !conShow;
                            });
                          },
                          child: Icon(
                            conShow ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ))),
                  validator: (value) {
                    if (value!.isEmpty) return "Confirm Password is required";
                    if (value.length < 6)
                      return "Confirm Password must be at least 6 characters";
                    return null;
                  },
                ),
              ],
            ),
          ),
          // RegisterField(
          //   onChange: (value) {
          //     registerProviderData.setConfriPassword(value);
          //   },
          //   controller: confirmPasswordController,
          //   label: 'Confirm Password',
          //   obscureText: true,
          //   validator: (value) {
          //     if (value!.isEmpty) return "Confirm Password is required";
          //     if (value != passwordController.text) {
          //       return "Passwords do not match";
          //     }
          //     return null;
          //   },
          // ),

          // SizedBox(
          //   height: 20.h,
          // ),
          // InkWell(
          //   onTap: () {
          //     showImage();
          //   },
          //   child: Center(
          //     child: Container(
          //       width: 380.w,
          //       height: 220.h,
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(20.r),
          //           border: Border.all(color: Colors.grey)),
          //       child: _image == null
          //           ? Column(
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Icon(
          //                   Icons.upload_sharp,
          //                   color: Color(0xFF008080),
          //                   size: 30.sp,
          //                 ),
          //                 SizedBox(
          //                   height: 10.h,
          //                 ),
          //                 Text(
          //                   "Upload picture",
          //                   style: GoogleFonts.inter(
          //                       fontSize: 15.sp,
          //                       fontWeight: FontWeight.w400,
          //                       color: Color(0xFF4D4D4D)),
          //                 )
          //               ],
          //             )
          //           : ClipRRect(
          //               borderRadius: BorderRadius.circular(20.r),
          //               child: Image.file(
          //                 _image!,
          //                 fit: BoxFit.cover,
          //                 width: 400.w,
          //                 height: 220.h,
          //               ),
          //             ),
          //     ),
          //   ),
          // ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: buttonLoader
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        buttonLoader = true; // show loader
                      });
                      try {
                        // await Auth.register(
                        //     emailController.text,
                        //     passwordController.text,
                        //     fullNameController.text,
                        //     phoneController.text,
                        //     formData.serviceType ?? "Opportunities",
                        //     formData.userType ?? "Professional",
                        //     context);
                        // if (_image == null || _image!.path.isEmpty) {
                        //   Fluttertoast.showToast(msg: "Please Select Picture");
                        //   return;
                        // }

                        final Notifier = ref.read(myFormDataProvider.notifier);
                        Notifier.setName(fullNameController.text);
                        Notifier.setEmail(emailController.text);
                        Notifier.setPhone(phoneController.text);
                        Notifier.setPassword(passwordController.text);
                        Notifier.setConfriPassword(
                            confirmPasswordController.text);
                        Notifier.setSerType(
                            formData.serviceType ?? "Opportunities");
                        Notifier.setUserType(
                            formData.userType ?? "Professional");

                        //Notifier.setProfilePicture(_image!.path);

                        await ref.read(myFormDataProvider.notifier).register();

                        Fluttertoast.showToast(msg: "Register Successfull");

                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                          (route) => false,
                        );
                      } catch (e, st) {
                        setState(() {
                          buttonLoader = false;
                        });
                        // Fluttertoast.showToast(msg: e.toString());
                        log("Register Error $e");
                        log(st.toString());
                      } finally {
                        setState(() => buttonLoader = false);
                      }
                    }
                  },
            child: Container(
              height: 52.h,
              width: 400.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.r),
                color: const Color(0xFFA8E6CF),
              ),
              child: Center(
                child: buttonLoader
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        "Register Now",
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
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class RegisterField extends ConsumerWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function(String)? onChange;
  const RegisterField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.onChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                label,
                style: GoogleFonts.roboto(
                  fontSize: 13.w,
                  fontWeight: FontWeight.w400,
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
                  ? Color(0xFF1B1B1B)
                  : Colors.white,
            ),
            onChanged: onChange,
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  //color: Colors.grey,
                  color: themeMode == ThemeMode.dark
                      ? Color(0xFF4D4D4D)
                      : Colors.white,
                ),
                borderRadius: BorderRadius.circular(40.r),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(40.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
            validator: validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return "$label field required";
                  }
                  return null;
                },
          ),
        ],
      ),
    );
  }
}
