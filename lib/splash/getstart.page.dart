import 'package:educationapp/main.dart';
import 'package:educationapp/splash/mentorshpi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStartPAge extends StatefulWidget {
  const GetStartPAge({super.key});

  @override
  State<GetStartPAge> createState() => _GetStartPAgeState();
}

class _GetStartPAgeState extends State<GetStartPAge> {
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
            GetstartBody(),
          ],
        ),
      ),
    );
  }
}

class GetstartBody extends ConsumerStatefulWidget {
  const GetstartBody({super.key});

  @override
  _GetstartBodyState createState() => _GetstartBodyState();
}

class _GetstartBodyState extends ConsumerState<GetstartBody> {
  @override
  Widget build(BuildContext context) {
    final formData = ref.watch(formDataProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 80.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 37.h,
                width: 37.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.r),
                    color: Color(0xFFECEDF4)),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    size: 16.41.h,
                  ),
                ),
              ),
            ),
            Spacer(),
            Container(
              height: 37.h,
              width: 86.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  color: Color(0xFFECEDF4)),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                    child: Text(
                  "Skip",
                  style: GoogleFonts.roboto(
                      color: Colors.transparent,
                      fontSize: 14.w,
                      fontWeight: FontWeight.w500),
                )),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
          ],
        ),
        Spacer(),
        Text(
          "You are a ?",
          style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 26.w,
              fontWeight: FontWeight.w600,
              letterSpacing: -1.2.h),
        ),
        SizedBox(
          height: 30.h,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              UserRegisterDataHold.usertype = "Student";
              ref.read(formDataProvider.notifier).updateUserType("Student");
            });
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => MentorShipPage()));
          },
          child: Container(
            height: 204.h,
            width: 400.w,
            decoration: BoxDecoration(
                color: Color(0xFFA8E6CF),
                borderRadius: BorderRadius.circular(25.w)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 58.h,
                    width: 58.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(500.w)),
                    child: Center(
                      child: Image.asset(
                        'assets/fluent-emoji-flat_student.jpg',
                        scale: 1.w,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "I’m Student",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 20.w,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.95),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50.w, right: 50.w),
                  child: Text(
                    "Looking to ace placements, explore colleges, or learn trending skills? We’ve got your back!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 13.w,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.85),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              UserRegisterDataHold.usertype = "Mentor";
              ref.read(formDataProvider.notifier).updateUserType("Mentor");
            });
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => MentorShipPage()));
          },
          child: Container(
            height: 204.h,
            width: 400.w,
            decoration: BoxDecoration(
                color: Color(0xFFF1F2F6),
                borderRadius: BorderRadius.circular(25.w)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 58.h,
                  width: 58.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(500.w)),
                  child: Center(
                    child: Image.asset(
                      'assets/fluent-emoji_man-teacher.png',
                      scale: 1.w,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "I’m Professional",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 20.w,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.95),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50.w, right: 50.w),
                  child: Text(
                    "Ready to take your career to the next level with mentorship, referrals, and global opportunities? Let’s grow together!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 13.w,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.85),
                  ),
                )
              ],
            ),
          ),
        ),
        Spacer(
          flex: 2,
        )
      ],
    );
  }
}

class BackGroundImage extends StatelessWidget {
  const BackGroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Image.asset("assets/Vector 2.png")],
        )),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [Image.asset("assets/Vector3.png")],
        ))
      ],
    );
  }
}

class UserRegisterDataHold {
  static String usertype = "";
  static String serviceType = "";
  static int skillId = 0;
}
