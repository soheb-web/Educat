import 'package:educationapp/login/login.page.dart';
import 'package:educationapp/splash/getstart.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B1B1B),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 350.h,
            width: 350.w,
            decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(image: AssetImage("assets/cuate.png"))),
          ),
          SizedBox(
            height: 30.h,
          ),
          Container(
            height: 270.h,
            width: 462.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Your Journey to",
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontSize: 40.w,
                      color: Colors.white,
                      letterSpacing: -3.w),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Success ",
                      style: GoogleFonts.roboto(
                          color: Color(0xff008080),
                          fontSize: 40.w,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -2.w),
                    ),
                    Text(
                      "Starts Here",
                      style: GoogleFonts.roboto(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 40.w,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -2.w),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: Text(
                    "Mentorship, skill development, and career guidance —all in one app.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 16.w,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => GetStartPAge()));
            },
            child: Container(
              height: 52.h,
              width: 400.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  color: Color(0xFFDA8E6CF)),
              child: Center(
                child: Text(
                  "Get Started",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.4,
                      fontSize: 14.4.w),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => LoginPage()));
            },
            child: Container(
              height: 52.h,
              width: 400.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  color: Color(0xFF262626)),
              child: Center(
                child: Text(
                  "Login to your account",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      // letterSpacing: -0.4,
                      fontSize: 14.4.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
