import 'dart:async';
import 'package:educationapp/home/MentorDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../dropDown/dropDownController.dart';
import '../coreFolder/Controller/searchController.dart';
import '../coreFolder/Model/searchMentorModel.dart';

final mentorQueryParamsProvider =
    StateProvider<Map<String, String>>((ref) => {});
final searchMentorProvider = FutureProvider.autoDispose<SearchMentorModel>(
  (ref) async {
    final client = await ref.watch(apiClientProvider.future);
    final params = ref.watch(mentorQueryParamsProvider);
    return await ApiController.searchMentor(client, params);
  },
);

class FindMentorPage extends ConsumerStatefulWidget {
  const FindMentorPage({super.key});
  @override
  ConsumerState<FindMentorPage> createState() => _FindMentorPageState();
}

class _FindMentorPageState extends ConsumerState<FindMentorPage> {
  String? selectedSkill;
  String? selectedIndustry;
  String? selectedExperience;
  String _searchText = '';
  bool _showSearchBar = false;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  Map<String, String> _buildQueryParams() {
    final params = <String, String>{};
    if (selectedSkill != null &&
        selectedSkill != "All" &&
        selectedSkill!.isNotEmpty) {
      params['skills_id'] = selectedSkill!;
    }
    if (selectedIndustry != null &&
        selectedIndustry != "All" &&
        selectedIndustry!.isNotEmpty) {
      params['users_field'] = selectedIndustry!;
    }
    if (selectedExperience != null &&
        selectedExperience != "All" &&
        selectedExperience!.isNotEmpty) {
      params['total_experience'] = selectedExperience!;
    }
    if (_searchText.isNotEmpty) {
      params['search'] = _searchText;
    }
    return params;
  }

  void _updateQueryParams() {
    // Cancel any existing debounce timer
    _debounce?.cancel();
    // Start a new timer to delay the API call
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final params = _buildQueryParams();
      ref.read(mentorQueryParamsProvider.notifier).state = params;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchText = value;
    });
    _updateQueryParams();
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
        setState(() {
          _searchText = '';
        });
        _updateQueryParams(); // Clear search param
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Trigger initial load with empty params
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mentorQueryParamsProvider.notifier).state = {};
    });
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Clean up the timer
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropDownData = ref.watch(getDropDownProvider);
    final queryParams = ref.watch(mentorQueryParamsProvider);
    final mentorProvider = ref.watch(searchMentorProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 70.h),
          _appBar(),
          SizedBox(height: 20.h),
          if (_showSearchBar) ...[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: TextField(
                  controller: _searchController,
                  style:
                      GoogleFonts.roboto(color: Colors.white, fontSize: 20.sp),
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
                    suffixIcon: _searchText.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchText = '';
                              });
                              _updateQueryParams();
                            },
                          )
                        : null,
                  ),
                  onChanged: _onSearchChanged,
                )),
          ],
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: dropDownData.when(
              data: (dropdown) {
                final skills = [
                  "All",
                  ...(dropdown.mentors?.skills?.keys.toList() ?? [])
                ];
                final industries = [
                  "All",
                  ...(dropdown.mentors?.industry ?? [])
                ];
                final experiences = [
                  "All",
                  ...(dropdown.mentors?.totalExperience?.keys.toList() ?? [])
                ];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40.h,
                        padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        // padding: EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 4.0.sp),
                        child: DropdownButton<String>(
                          padding: EdgeInsets.zero,
                          value: selectedSkill,
                          hint: Text(
                            "Skill",
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 12.sp),
                          ),
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1B1B1B),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.white),
                          underline: const SizedBox(),
                          items: skills.map((skill) {
                            return DropdownMenuItem<String>(
                              value: skill,
                              child: Text(
                                dropdown.mentors?.skills?[skill] ?? skill,
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 10.sp),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSkill = value;
                              _updateQueryParams();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        height: 40.h,
                        padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: DropdownButton<String>(
                          padding: EdgeInsets.zero,
                          value: selectedIndustry,
                          hint: Text(
                            "Industry",
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 12.sp),
                          ),
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1B1B1B),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.white),
                          underline: const SizedBox(),
                          items: industries.map((industry) {
                            return DropdownMenuItem<String>(
                              value: industry,
                              child: Text(
                                industry,
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 10.sp),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedIndustry = value;
                              _updateQueryParams(); // Trigger API call with debounce
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        height: 40.h,
                        padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: DropdownButton<String>(
                          padding: EdgeInsets.zero,
                          value: selectedExperience,
                          hint: Text(
                            "Experience",
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 12.sp),
                          ),
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1B1B1B),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.white),
                          underline: const SizedBox(),
                          items: experiences.map((experience) {
                            return DropdownMenuItem<String>(
                              value: experience,
                              child: Text(
                                dropdown.mentors
                                        ?.totalExperience?[experience] ??
                                    experience,
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 12.sp),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedExperience = value;
                              _updateQueryParams(); // Trigger API call with debounce
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) => Center(
                child: Text(
                  "Failed to load filters: $error",
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
              ),
              loading: () {
                return DropDownLoading();
              },
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: mentorProvider.when(
                data: (mentors) => mentors.data?.isNotEmpty ?? false
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        // shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemCount: mentors.data!.length,
                        itemBuilder: (context, index) {
                          final mentor = mentors.data![index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => MentorDetailPage(
                                              id: mentors.data![index].id ?? 0,
                                            )));
                              },
                              child: UserTabs(
                                image: mentor.profilePic ?? '',
                                id: mentor.id!,
                                fullname: mentor.fullName ?? 'Unknown',
                                dec: mentor.description ?? 'No description',
                                servicetype:
                                    mentor.serviceType?.split(', ') ?? [],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: Text("No mentors found")),
                error: (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Failed to load mentors: $error",
                        style: GoogleFonts.roboto(color: Colors.black),
                      ),
                      ElevatedButton(
                        onPressed: () => ref.refresh(searchMentorProvider),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
                loading: () {
                  return DataLoading();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Container(
      margin: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(width: 30.w),

          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 46.h,
              width: 44.w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(25, 255, 255, 255),
                borderRadius: BorderRadius.circular(500.r),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "Find a ",
                style: GoogleFonts.roboto(
                    fontSize: 24.sp, color: const Color(0xff008080)),
              ),
              Text(
                "Mentor",
                style: GoogleFonts.roboto(
                    fontSize: 24.sp, color: const Color(0xffA8E6CF)),
              ),
            ],
          ),
          GestureDetector(
            onTap: _toggleSearchBar,
            child: Container(
              height: 44.h,
              width: 44.w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(25, 255, 255, 255),
                borderRadius: BorderRadius.circular(500.r),
              ),
              child: Center(
                child: Icon(
                  _showSearchBar ? Icons.close : Icons.search,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          // ,        const Spacer(),
          //         SizedBox(width: 30.w),
        ],
      ),
    );
  }
}

class UserTabs extends StatelessWidget {
  final String image;
  final int id;
  final String fullname;
  final String dec;
  final List<String> servicetype;

  const UserTabs({
    super.key,
    required this.image,
    required this.id,
    required this.fullname,
    required this.dec,
    required this.servicetype,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 127.h,
      width: 400.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color.fromARGB(25, 0, 0, 0), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Container(
              height: 111.h,
              width: 112.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                  image: image.isNotEmpty
                      ? NetworkImage(image)
                      : const AssetImage('assets/images/default_profile.png')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  fullname,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  dec,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 5.h),
                Container(
                  height: 0.5.h,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 30.h,
                  child: ListView.builder(
                    // scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    // physics: const/ NeverScrollableScrollPhysics(),
                    itemCount: servicetype.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Container(
                          height: 26.h,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(225, 222, 221, 236),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Center(
                              child: Text(
                                servicetype[index],
                                style: GoogleFonts.roboto(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.30,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DropDownLoading extends StatelessWidget {
  const DropDownLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[800]!, // darker base
              highlightColor: Colors.grey[600]!, // soft highlight for black bg
              child: Container(
                width: 100.w,
                height: 30.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: const Color(0xFF2C2C2C), // dark grey container
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1), // subtle border
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DataLoading extends StatelessWidget {
  const DataLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 15.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!, // base shimmer color for white theme
            highlightColor: Colors.grey[100]!, // light moving shine
            child: Container(
              height: 127.h,
              width: 400.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: const Color.fromARGB(25, 0, 0, 0),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // IMAGE PLACEHOLDER
                  Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Container(
                      height: 111.h,
                      width: 112.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // TEXT PLACEHOLDERS
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Fullname Placeholder
                          Container(
                            width: 180.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // Description Placeholder
                          Container(
                            width: 150.w,
                            height: 14.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // Divider Line
                          Container(
                            height: 0.5.h,
                            width: double.infinity,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 10.h),

                          // Service Type Pills (Horizontal shimmer chips)
                          SizedBox(
                            height: 26.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: Container(
                                  width: 60.w,
                                  height: 26.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
