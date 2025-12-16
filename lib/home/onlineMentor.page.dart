import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/MentorDetail.dart';
import 'package:educationapp/home/findmentor.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnlineMentorPage extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> onlineMentors;
  const OnlineMentorPage({
    super.key,
    required this.onlineMentors,
  });

  @override
  ConsumerState<OnlineMentorPage> createState() => _OnlineMentorPageState();
}

class _OnlineMentorPageState extends ConsumerState<OnlineMentorPage> {
  final _searchController = TextEditingController();
  String query = "";
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final filteredMentors = widget.onlineMentors.where((mentor) {
      final name = mentor['full_name']?.toString().toLowerCase() ?? '';
      final services = mentor['service_type']?.toString().toLowerCase() ?? '';

      return name.contains(query.toLowerCase()) ||
          services.contains(query.toLowerCase());
    }).toList();
    return Scaffold(
      backgroundColor: themeMode == ThemeMode.dark
          ? const Color(0xFF1B1B1B)
          : Color(0xFF008080),
      appBar: AppBar(
        backgroundColor: themeMode == ThemeMode.dark
            ? const Color(0xFF1B1B1B)
            : Color(0xFF008080),
        title: Text(
          "Online Mentors",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.sp),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(
                      left: 10.w, right: 10.w, top: 6.h, bottom: 6.h),
                  hintText: "Search mentors...",
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
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
              )),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(top: 10.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r)),
                  color: Colors.white),
              child: filteredMentors.isEmpty
                  ? Center(
                      child: Text(
                        "No Mentors Found",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredMentors.length,
                      itemBuilder: (context, index) {
                        final item = filteredMentors[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => MentorDetailPage(
                                            id: item['id'] ?? 0,
                                          )));
                            },
                            child: UserTabs(
                              image: item['profile_pic'],
                              id: item['id'],
                              fullname: item['full_name'],
                              dec: item['description'],
                              servicetype: item['service_type'] == null
                                  ? []
                                  : item['service_type']
                                      .toString()
                                      .split(',')
                                      .map((e) => e.trim())
                                      .toList(),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }
}
