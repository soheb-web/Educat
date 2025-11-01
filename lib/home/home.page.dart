import 'dart:developer';
import 'package:educationapp/MyListing/MyListingPage.dart';
import 'package:educationapp/Profile/profileScreen.dart';
import 'package:educationapp/complete/complete.page.dart';
import 'package:educationapp/home/CollegeDetail.dart';
import 'package:educationapp/home/CompanyDetail.dart';
import 'package:educationapp/home/MentorDetail.dart';
import 'package:educationapp/home/chatInbox.dart';
import 'package:educationapp/home/expertTrendingDetails.page.dart';
import 'package:educationapp/home/findmentor.page.dart';
import 'package:educationapp/home/settingProfile.page.dart';
import 'package:educationapp/home/trendingExprt.page.dart';
import 'package:educationapp/login/login.page.dart';
import 'package:educationapp/splash/splash.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../wallet/wallet.page.dart';
import 'TendingSkill.dart';
import 'findAColllege.dart';
import 'findACompany.dart';
import '../coreFolder/Controller/homeDataController.dart';

class HomePage extends ConsumerStatefulWidget {
  int index;
  HomePage(this.index, {super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String filterQuery = "";
  int _currentIndex = 0; // Track the selected tab index

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  final List<Widget> _pages = [
    const HomePageContent(), // Home page content (extracted below)
    const Chatinbox(),
    const MyListing(),
    ProfilePage(),
  ];

  String limitString(String text, int limit) {
    if (text.length <= limit) return text;
    return '${text.substring(0, limit)}..';
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFF1B1B1B),
        drawer: drawerWidget(box),
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1B1B1B),
          selectedItemColor: const Color(0xff008080),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: GoogleFonts.roboto(fontSize: 12.sp),
          unselectedLabelStyle: GoogleFonts.roboto(fontSize: 12.sp),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat, size: 24.sp),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search, size: 24.sp),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list, size: 24.sp),
              label: 'My Listings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 24.sp),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerWidget(Box box) {
    final userType = box.get('userType');
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: 280.w,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
        child: Column(
          children: [
            Container(
              height: 250.h,
              width: 280.w,
              decoration: BoxDecoration(
                color: const Color(0xff008080),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10.w, top: 20.h),
                      width: 40.w,
                      height: 40.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50.h,
                          width: 46.w,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(25, 255, 255, 255),
                            borderRadius: BorderRadius.circular(500.r),
                          ),
                          child: Image.network(
                            box.get("pic").toString(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return ClipOval(
                                child: Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      ProfileCompletionWidget(true),
                                ));
                          },
                          child: Container(
                            height: 38.h,
                            decoration: BoxDecoration(
                                color: const Color(0xFFA8E6CF),
                                borderRadius: BorderRadius.circular(40.r)),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Text(
                                  "Edit Profile",
                                  style: GoogleFonts.roboto(
                                      color: const Color(0xFF1B1B1B),
                                      fontSize: 12.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Text(
                          "${box.get('full_name') ?? 'User'}",
                          style: GoogleFonts.roboto(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Text(
                          "${box.get('email') ?? 'N/A'}",
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            if (userType != "Mentor")
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FindMentorPage(),
                      ));
                },
                leading: Image.asset("assets/drawer1.png"),
                title: Text(
                  "Find a Mentor",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 27, 27, 27),
                  ),
                ),
              ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FindSkillPage(),
                    ));
              },
              leading: Image.asset("assets/drawer2.png"),
              title: Text(
                "Trending Skills",
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 27, 27, 27),
                ),
              ),
            ),
            if (userType != "Mentor")
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FindCollegePage(),
                      ));
                },
                leading: Image.asset("assets/drawer3.png"),
                title: Text(
                  "Explore Colleges",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 27, 27, 27),
                  ),
                ),
              ),
            if (userType != "Mentor")
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FindCompanyPage(),
                      ));
                },
                leading: Image.asset("assets/drawer4.png"),
                title: Text(
                  "Explore Companies",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 27, 27, 27),
                  ),
                ),
              ),
            if (userType == "Mentor")
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WalletPage(),
                      ));
                },
                leading: Image.asset("assets/drawer5.png"),
                title: Text(
                  "Wallet",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 27, 27, 27),
                  ),
                ),
              ),
            ListTile(
              onTap: () {
                Fluttertoast.showToast(msg: "Dark Mode toggle not implemented");
              },
              leading: Image.asset("assets/drawer6.png"),
              title: Text(
                "Dark Mode",
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 27, 27, 27),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SettingProfilePage(),
                    ));
              },
              leading: Image.asset("assets/drawer7.png"),
              title: Text(
                "Settings",
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 27, 27, 27),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Image.asset("assets/logoutIcon.png"),
              title: Text(
                "Logout",
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 27, 27, 27),
                ),
              ),
              onTap: () async {
                box.clear();
                log("Clearing data...");
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
                Fluttertoast.showToast(msg: "Logout Successfully");
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Extracted HomePage content into a separate widget
class HomePageContent extends ConsumerStatefulWidget {
  const HomePageContent({super.key});
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends ConsumerState<HomePageContent> {
  String filterQuery = "";

  String limitString(String text, int limit) {
    if (text.length <= limit) return text;
    return '${text.substring(0, limit)}..';
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    final getHomeStudentData = ref.watch(getHomeStudentDataProvider);
    final getHomeMentorData = ref.watch(getHomeMentorDataProvider);
    final userType = box.get('userType');

    final profileCompletion = box.get('profileCompletion')?.toDouble() ?? 0.45;
    final isLoading =
        getHomeMentorData.isLoading || getHomeStudentData.isLoading;

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
    if (getHomeMentorData.hasError || getHomeStudentData.hasError) {
      final errorMessage = getHomeMentorData.error?.toString() ??
          getHomeStudentData.error?.toString() ??
          "Something went wrong";

      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            errorMessage,
            style: GoogleFonts.inter(fontSize: 20.sp, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20.w),
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    height: 50.w,
                    width: 50.w,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(25, 255, 255, 255),
                        borderRadius: BorderRadius.circular(500.r)),
                    child: Center(
                      child: Icon(
                        Icons.dashboard_outlined,
                        color: const Color(0xff008080),
                        size: 18.w,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Image.asset(
                  "assets/mentorLogo.png",
                  width: 100.w,
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _HomePageState()._currentIndex = 4; // Navigate to Chat
                      });
                    },
                    icon: Icon(
                      Icons.notifications_active_outlined,
                      color: Colors.white,
                      size: 19.w,
                    )),
                SizedBox(width: 3.w),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => HomePage(3)));
                  },
                  child: Container(
                    height: 46.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(25, 255, 255, 255),
                      borderRadius: BorderRadius.circular(500.r),
                    ),
                    child: Image.network(
                      box.get("pic").toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return ClipOval(
                          child: Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
              ],
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Welcome, ",
                            style: GoogleFonts.roboto(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          Text(
                            "${box.get("full_name") ?? "User"}!",
                            style: GoogleFonts.roboto(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xffA8E6CF)),
                          ),
                        ],
                      ),
                      Text(
                        "Let’s plan your bright future.",
                        style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 204, 204, 204)),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 130.h,
                      decoration: BoxDecoration(
                        color: const Color(0xff008080),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 15.h),
                            Padding(
                              padding: EdgeInsets.only(left: 15.w),
                              child: Container(
                                width: 50.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/mask1.png",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.only(left: 15.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mentors Available",
                                    style: GoogleFonts.roboto(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                  getHomeStudentData.when(
                                    data: (data) => Text(
                                      "${data.mentors?.values.fold(0, (sum, list) => sum + list.length) ?? 0}",
                                      style: GoogleFonts.roboto(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    loading: () => SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: const CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    ),
                                    error: (error, stack) => Text(
                                      "N/A",
                                      style: GoogleFonts.roboto(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Container(
                      height: 130.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffA8E6CF),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 15.h),
                          Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: Container(
                              width: 50.w,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/mask1.png",
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "New Requests",
                                  style: GoogleFonts.roboto(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                                Text(
                                  "20",
                                  style: GoogleFonts.roboto(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Container(
                      height: 130.h,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 38, 38, 38),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 15.h),
                          Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: Container(
                              width: 50.w,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/mask1.png",
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Skills Available",
                                  style: GoogleFonts.roboto(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                                getHomeStudentData.when(
                                  data: (data) => Text(
                                    "${data.skills?.length ?? 0}",
                                    style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  loading: () => SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: const CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  ),
                                  error: (error, stack) => Text(
                                    "N/A",
                                    style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            userType == "Mentor"
                ? Container(
                    height: 500.h,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          Container(
                            width: 400.w.clamp(0, 400.w),
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Color(0x26008080),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10.sp),
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: LinearProgressIndicator(
                                      value: profileCompletion.clamp(0.0, 1.0),
                                      backgroundColor: Colors.transparent,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.blue[600] ?? Colors.blue),
                                      minHeight: 20.h,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  margin: EdgeInsets.only(right: 10.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        child: Text(
                                          "Profile Completed",
                                          style: GoogleFonts.roboto(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${(profileCompletion * 100).toInt()}%",
                                        style: GoogleFonts.roboto(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10.sp),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: Image.asset(
                                          "assets/pic.png",
                                          height: 50.h,
                                          width: 50.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Mike Pena",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "Placement | Interview",
                                            style: GoogleFonts.roboto(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10.sp),
                                  child: Text(
                                    "With over 5 years of experience, "
                                    "I've guided 300+ students to land jobs "
                                    "in top companies like Google, TCS, and Deloitte. "
                                    "My sessions focus on mock interviews, resume building, "
                                    "and effective communication",
                                    style: GoogleFonts.roboto(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20.w, top: 10.h),
                            child: Row(
                              children: [
                                Text(
                                  "Your Bids",
                                  style: GoogleFonts.roboto(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: () {},
                            child: MyContainer(
                              image:
                                  "https://flutter.github.io/assets-for-api-docs/assets/widgets/puffin.jpg",
                              title: "Jennifer Johns",
                              subtitle:
                                  "Helping students land their dream jobs with 5+ years of placement coaching experience",
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20.w, top: 10.h),
                            child: Row(
                              children: [
                                Text(
                                  "New Messages",
                                  style: GoogleFonts.roboto(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: NewContainer(
                              image:
                                  "https://flutter.github.io/assets-for-api-docs/assets/widgets/puffin.jpg",
                              title: "Jennifer Johns",
                              subtitle:
                                  "Helping students land their dream jobs with 5+ years of placement coaching experience",
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 380.h,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              HomePageBody(
                                callBack: (String category) {
                                  setState(() {
                                    filterQuery = category;
                                  });
                                },
                              ),
                              SizedBox(height: 10.h),
                              getHomeStudentData.when(
                                data: (data) {
                                  final mentors = filterQuery == "All" ||
                                          filterQuery.isEmpty
                                      ? data.mentors?.values
                                              .expand((list) => list)
                                              .toList() ??
                                          []
                                      : data.mentors?[filterQuery]?.toList() ??
                                          [];
                                  if (mentors.isEmpty) {
                                    return Center(
                                      child: Text(
                                        "No mentors available",
                                        style: GoogleFonts.roboto(
                                            fontSize: 14.sp,
                                            color: Colors.white),
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    height: 260.h,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      itemCount: mentors.length,
                                      itemBuilder: (context, index) {
                                        final mentor = mentors[index];
                                        return UserTabs(
                                          callBack: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      MentorDetailPage(
                                                          id: mentor.id ?? 0),
                                                ));
                                          },
                                          id: mentor.id ?? 0,
                                          fullname:
                                              mentor.fullName ?? "Unknown",
                                          dec: mentor.description ??
                                              "No description",
                                          servicetype: [
                                            mentor.serviceType ?? "N/A"
                                          ],
                                          image: mentor.profilePic ?? "",
                                        );
                                      },
                                    ),
                                  );
                                },
                                loading: () => const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xff008080)),
                                ),
                                error: (error, stack) {
                                  log("Mentors Error: $error");
                                  log("StackTrace: $stack");
                                  return Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Error loading mentors: $error",
                                          style: GoogleFonts.roboto(
                                              fontSize: 14.sp,
                                              color: Colors.white),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => ref.refresh(
                                              getHomeStudentDataProvider),
                                          child: const Text("Retry"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Text(
                                  "Explore Trending Skills",
                                  style: GoogleFonts.roboto(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ]),
                        SizedBox(height: 20.h),
                        getHomeStudentData.when(
                          data: (data) {
                            final skills = data.skills ?? [];
                            if (skills.isEmpty) {
                              return Center(
                                child: Text(
                                  "No skills available",
                                  style: GoogleFonts.roboto(
                                      fontSize: 14.sp, color: Colors.white),
                                ),
                              );
                            }
                            return SizedBox(
                              height: 145.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                itemCount: skills.length,
                                itemBuilder: (context, index) {
                                  final skill = skills[index];
                                  return Padding(
                                    padding: EdgeInsets.only(right: 15.w),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  TrendingExprtPage(
                                                id: skill.id ?? 0,
                                              ),
                                            ));
                                      },
                                      child: Container(
                                        width: 120.w,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2A2A2A),
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 50.w,
                                              height: 50.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      skill.image ?? ""),
                                                  fit: BoxFit.cover,
                                                  onError: (exception,
                                                          stackTrace) =>
                                                      const AssetImage(
                                                          "assets/placeholder.png"),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              limitString(
                                                  skill.title ?? "Unknown", 18),
                                              style: GoogleFonts.roboto(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              skill.level
                                                      ?.toString()
                                                      .split('.')
                                                      .last ??
                                                  "N/A",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      const Color(0xFFA8E6CF)),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xff008080)),
                          ),
                          error: (error, stack) => Center(
                            child: Text(
                              "Error loading skills",
                              style: GoogleFonts.roboto(
                                  fontSize: 14.sp, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          height: 350.h,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20.w, top: 20.h),
                                    child: Text(
                                      "Explore College Review",
                                      style: GoogleFonts.roboto(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              getHomeStudentData.when(
                                data: (data) {
                                  final colleges = data.colleges ?? [];
                                  if (colleges.isEmpty) {
                                    return Center(
                                      child: Text(
                                        "No colleges available",
                                        style: GoogleFonts.roboto(
                                            fontSize: 14.sp,
                                            color: Colors.white),
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    height: 260.h,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      itemCount: colleges.length,
                                      itemBuilder: (context, index) {
                                        final college = colleges[index];
                                        return Padding(
                                          padding: EdgeInsets.only(right: 15.w),
                                          child: Container(
                                            width: 195.w,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.1)),
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (context) =>
                                                              CollegeDetailPage(
                                                                  college.id!),
                                                        ));
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8.h,
                                                        left: 8.w,
                                                        right: 8.w),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.r),
                                                      child: Image.network(
                                                        college.image ?? "",
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 111.h,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(8.w),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.w,
                                                                right: 10.w,
                                                                top: 5.h,
                                                                bottom: 5.h),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40.r),
                                                            color: Color(
                                                                0xFFDEDDEC)),
                                                        child: Text(
                                                          college.city ?? "N/A",
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8.h,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 8.w,
                                                                      right:
                                                                          8.w,
                                                                      top: 5.h,
                                                                      bottom:
                                                                          5.h),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(40
                                                                              .r),
                                                                  color: Color(
                                                                      0xFFDEDDEC)),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.star,
                                                                    color: Color(
                                                                        0xFF008080),
                                                                    size: 14.sp,
                                                                  ),
                                                                  Text(
                                                                    "${college.avgRating!.toStringAsFixed(1)} Rating",
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.inter(
                                                                        fontSize: 12
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Color(
                                                                            0xFF2E2E2E)),
                                                                  )
                                                                ],
                                                              )),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 8.w,
                                                                      right:
                                                                          8.w,
                                                                      top: 5.h,
                                                                      bottom:
                                                                          5.h),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(40
                                                                              .r),
                                                                  color: Color(
                                                                      0xFFDEDDEC)),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "${college.totalReviews!} Review",
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.inter(
                                                                        fontSize: 12
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Color(
                                                                            0xFF2E2E2E)),
                                                                  )
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                      Divider(
                                                          color:
                                                              Colors.black12),
                                                      Text(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        college.collegeName ??
                                                            "Unknown",
                                                        style:
                                                            GoogleFonts.roboto(
                                                                fontSize: 15.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    -0.5),
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
                                  );
                                },
                                loading: () => const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xff008080)),
                                ),
                                error: (error, stack) => Center(
                                  child: Text(
                                    "Error loading colleges",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14.sp, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              Text(
                                "Top Companies",
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25.h),
                        getHomeStudentData.when(
                          data: (data) {
                            final companies = data.companies ?? [];
                            if (companies.isEmpty) {
                              return Center(
                                child: Text(
                                  "No companies available",
                                  style: GoogleFonts.roboto(
                                      fontSize: 14.sp, color: Colors.white),
                                ),
                              );
                            }
                            return SizedBox(
                              height: 270.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                itemCount: companies.length,
                                itemBuilder: (context, index) {
                                  final company = companies[index];
                                  return Padding(
                                    padding: EdgeInsets.only(right: 15.w),
                                    child: Container(
                                      width: 195.w,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A2A2A),
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        CompanyDetailPage(
                                                            company.id!),
                                                  ));
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8.h,
                                                  left: 8.w,
                                                  right: 8.w),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                child: Image.network(
                                                  company.image ?? "",
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 111.h,
                                                  fit: BoxFit.contain,
                                                  //color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.w),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10.w,
                                                      right: 10.w,
                                                      top: 5.h,
                                                      bottom: 5.h),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40.r),
                                                      color: Color.fromARGB(
                                                          25, 222, 221, 236)),
                                                  child: Text(
                                                    company.city ?? "Unknown",
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFFFFFFFF)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10.w,
                                                          right: 10.w,
                                                          top: 5.h,
                                                          bottom: 5.h),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      40.r),
                                                          color: Color.fromARGB(
                                                              25,
                                                              222,
                                                              221,
                                                              236)),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xFF008080),
                                                            size: 14.sp,
                                                          ),
                                                          Text(
                                                            "${company.avgRating ?? "Unknown"} Rating",
                                                            style: GoogleFonts.roboto(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                    0xFFFFFFFF)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            left: 8.w),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8.w,
                                                                right: 8.w,
                                                                top: 5.h,
                                                                bottom: 5.h),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40.r),
                                                            color:
                                                                Color.fromARGB(
                                                                    25,
                                                                    222,
                                                                    221,
                                                                    236)),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "${company.totalReviews!} Review",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts.inter(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color(
                                                                      0xFFFFFFFF)),
                                                            )
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Divider(color: Colors.white12),
                                                Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  company.companyName ??
                                                      "Unknown",
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                      letterSpacing: -0.5),
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
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xff008080)),
                          ),
                          error: (error, stack) => Center(
                            child: Text(
                              "Error loading companies",
                              style: GoogleFonts.roboto(
                                  fontSize: 14.sp, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// Rest of the code (HomePageBody, UserTabs, Upertabs, MyContainer, NewContainer) remains unchanged
class HomePageBody extends ConsumerStatefulWidget {
  final Function callBack;
  const HomePageBody({super.key, required this.callBack});
  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends ConsumerState<HomePageBody> {
  int currentTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    final getHomeStudentData = ref.watch(getHomeStudentDataProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Find Mentors",
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Text(
                    "Filters",
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4.w),
                  Image.asset("assets/filter.png"),
                  SizedBox(width: 4.w),
                  Image.asset("assets/search.png"),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        getHomeStudentData.when(
          data: (data) {
            final categories = data.mentors?.keys.toList() ?? [];
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20.w),
                SizedBox(
                  height: 30.h,
                  width: MediaQuery.of(context).size.width - 40.w,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      Upertabs(
                        title: "All",
                        callBack: () {
                          setState(() {
                            currentTabIndex = 0;
                          });
                          widget.callBack("All");
                        },
                        currentIndex: currentTabIndex,
                        index: 0,
                      ),
                      ...categories.asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final category = entry.value;
                        return Upertabs(
                          title: category,
                          callBack: () {
                            setState(() {
                              currentTabIndex = index;
                            });
                            widget.callBack(category);
                          },
                          currentIndex: currentTabIndex,
                          index: index,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xff008080)),
          ),
          error: (error, stack) => Center(
            child: Text(
              "Error loading categories",
              style: GoogleFonts.roboto(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class UserTabs extends StatefulWidget {
  final int id;
  final String fullname;
  final String dec;
  final List<String> servicetype;
  final String image;
  final Function callBack;

  const UserTabs({
    super.key,
    required this.id,
    required this.fullname,
    required this.dec,
    required this.servicetype,
    required this.image,
    required this.callBack,
  });

  @override
  State<UserTabs> createState() => _UserTabsState();
}

class _UserTabsState extends State<UserTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.sp),
      height: 300.h,
      width: 200.w,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border:
              Border.all(color: const Color.fromARGB(25, 0, 0, 0), width: 1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              widget.callBack();
            },
            child: Container(
              margin: EdgeInsets.all(10.sp),
              height: 112.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(
                      image: NetworkImage(widget.image),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) =>
                          const AssetImage("assets/placeholder.png"))),
            ),
          ),
          // Expanded(
          //   child:
          Container(
            // margin: EdgeInsets.all(10.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 10.h),
                Container(
                  margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                  child: Text(
                    widget.fullname,
                    style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 5.h),
                Container(
                  margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                  child: Text(
                    widget.dec,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),

                SizedBox(height: 5.h),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    height: 30.h,
                    width: 170.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff008080)),
                    child: Center(
                      child: Text(
                        "Contact me",
                        style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.30,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ])

                // Container(
                //   height: 0.5.h,
                //   decoration: BoxDecoration(
                //     color: Colors.grey.shade400,
                //   ),
                // ),
                // SizedBox(height: 10.h),
                // SizedBox(
                //   height: 30.h,
                //   child: ListView.builder(
                //     itemCount: widget.servicetype.length,
                //     physics: const NeverScrollableScrollPhysics(),
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemBuilder: (context, index) {
                //       return Padding(
                //         padding: EdgeInsets.only(left: 0.w, right: 8.w),
                //         child: Container(
                //           height: 26.h,
                //           decoration: BoxDecoration(
                //               color: const Color.fromARGB(225, 222, 221, 236),
                //               borderRadius: BorderRadius.circular(50.r)),
                //           child: Padding(
                //             padding: EdgeInsets.symmetric(horizontal: 10.w),
                //             child: Center(
                //               child: Text(
                //                 widget.servicetype[index],
                //                 style: GoogleFonts.roboto(
                //                     fontSize: 12.sp,
                //                     fontWeight: FontWeight.w400,
                //                     letterSpacing: -0.30,
                //                     color: Colors.black),
                //               ),
                //             ),
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          // ),
        ],
      ),
    );
  }
}

class Upertabs extends StatelessWidget {
  final String title;
  final Function callBack;
  final int currentIndex;
  final int index;

  const Upertabs({
    super.key,
    required this.title,
    required this.callBack,
    required this.currentIndex,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 8.w),
      child: GestureDetector(
        onTap: () => callBack(),
        child: Container(
          height: 30.h,
          decoration: BoxDecoration(
              color: currentIndex == index
                  ? const Color(0xff008080)
                  : const Color.fromARGB(225, 222, 221, 236),
              borderRadius: BorderRadius.circular(50.r)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.30,
                    color: currentIndex == index ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyContainer extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  const MyContainer({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  State<MyContainer> createState() => _MyContainerState();
}

class _MyContainerState extends State<MyContainer> {
  @override
  Widget build(BuildContext context) {
    log(widget.image.replaceAll('/public/', ''));
    return Padding(
      padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
      child: Container(
        padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
        // width: 400.w,
        // height: 140.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  widget.image,
                  width: 60.w,
                  height: 60.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.title,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.subtitle,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 102, 102, 102),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 10.w, right: 10.w, top: 8.h, bottom: 8.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffDEDDEC)),
                        child: Text(
                          "Mock Interviews",
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 102, 102, 102),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Container(
                        padding: EdgeInsets.all(5.sp),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffDEDDEC)),
                        child: Text(
                          "Aptitude Training",
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 102, 102, 102),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewContainer extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  const NewContainer({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  State<NewContainer> createState() => _NewContainerState();
}

class _NewContainerState extends State<NewContainer> {
  @override
  Widget build(BuildContext context) {
    log(widget.image.replaceAll('/public/', ''));
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
          child: Container(
            padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    widget.image,
                    width: 60.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          widget.title,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          widget.subtitle,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 102, 102, 102),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.w, right: 10.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff008080)),
                  height: 30.h,
                  width: 30.w,
                  child: Center(
                    child: Text(
                      "2",
                      style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
          child: Container(
            padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            // width: 400.w,
            // height: 120.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.image,
                    width: 60.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          widget.title,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          widget.subtitle,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 102, 102, 102),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5.sp),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff008080)),
                  height: 30.h,
                  width: 30.w,
                  child: Center(
                    child: Text(
                      "2",
                      style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        )
      ],
    );
  }
}
