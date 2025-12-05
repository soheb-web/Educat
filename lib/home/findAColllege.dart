import 'dart:async';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/CollegeDetail.dart';
import 'package:educationapp/home/findmentor.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dropDown/dropDownController.dart';
import '../coreFolder/Controller/searchController.dart';
import '../coreFolder/Model/CollegeSearchModel.dart';

final queryParamsProvider = StateProvider<Map<String, String>>((ref) => {});

final searchCollegeProvider = FutureProvider.autoDispose<SearchCollegeModel>(
  (ref) async {
    final client = await ref.watch(apiClientProvider.future);
    final params = ref.watch(queryParamsProvider);
    return await ApiController.searchCollege(client, params);
  },
);

class FindCollegePage extends ConsumerStatefulWidget {
  const FindCollegePage({super.key});
  @override
  ConsumerState<FindCollegePage> createState() => _FindCollegePageState();
}

class _FindCollegePageState extends ConsumerState<FindCollegePage> {
  String? selectedLocation;
  String? selectedCollegeName;
  String? selectedCourse;
  String _searchText = '';
  bool _showSearchBar = false;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  Map<String, String> _buildQueryParams() {
    final params = <String, String>{};
    if (selectedLocation != null &&
        selectedLocation != "All" &&
        selectedLocation!.isNotEmpty) {
      params['location'] = selectedLocation!;
    }
    if (selectedCollegeName != null &&
        selectedCollegeName != "All" &&
        selectedCollegeName!.isNotEmpty) {
      params['college_name'] = selectedCollegeName!;
    }
    if (selectedCourse != null &&
        selectedCourse != "All" &&
        selectedCourse!.isNotEmpty) {
      params['course'] = selectedCourse!;
    }
    if (_searchText.isNotEmpty) {
      params['search'] = _searchText;
    }
    return params;
  }

  void _updateQueryParams() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final params = _buildQueryParams();
      ref.read(queryParamsProvider.notifier).state = params;
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
      ref.read(queryParamsProvider.notifier).state = {};
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropDownData = ref.watch(getDropDownProvider);
    final collegeProvider = ref.watch(searchCollegeProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      // backgroundColor: const Color(0xFF1B1B1B),
      backgroundColor: themeMode == ThemeMode.dark
          ? const Color(0xFF1B1B1B)
          : Color(0xFF008080),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          _appBar(),
          SizedBox(height: 20.h),
          if (_showSearchBar) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.sp),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(
                      left: 10.w, right: 10.w, top: 6.h, bottom: 6.h),
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
              ),
            ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            child: dropDownData.when(
              data: (dropdown) {
                final locations = [
                  "All",
                  ...(dropdown.colleges?.locations ?? [])
                ];
                final collegeNames = [
                  "All",
                  ...(dropdown.colleges?.collageName ?? [])
                ];
                final courses = ["All", ...(dropdown.colleges?.branches ?? [])];

                return Container(
                  margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                  child: Row(
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
                            borderRadius: BorderRadius.circular(30),
                          ),
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: 8.0.sp, vertical: 4.0.sp),
                          child: DropdownButton<String>(
                            padding: EdgeInsets.zero,
                            value: selectedLocation,
                            hint: Text(
                              "Location",
                              style: GoogleFonts.roboto(
                                  color: Colors.white, fontSize: 12.sp),
                            ),
                            isExpanded: true,
                            dropdownColor: const Color(0xFF1B1B1B),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Colors.white),
                            underline: const SizedBox(),
                            items: locations.map((location) {
                              return DropdownMenuItem<String>(
                                value: location,
                                child: Text(
                                  location,
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontSize: 12.sp),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedLocation = value;
                                _updateQueryParams(); // Trigger API call with debounce
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Container(
                          height: 40.h,
                          padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: 8.0.sp, vertical: 4.0.sp),
                          child: DropdownButton<String>(
                            padding: EdgeInsets.zero,
                            value: selectedCollegeName,
                            hint: Text(
                              "College",
                              style: GoogleFonts.roboto(
                                  color: Colors.white, fontSize: 12.sp),
                            ),
                            isExpanded: true,
                            dropdownColor: const Color(0xFF1B1B1B),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Colors.white),
                            underline: const SizedBox(),
                            items: collegeNames.map((college) {
                              return DropdownMenuItem<String>(
                                value: college,
                                child: Text(
                                  college,
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontSize: 12.sp),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCollegeName = value;
                                _updateQueryParams(); // Trigger API call with debounce
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Container(
                          height: 40.h,
                          padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          // padding: EdgeInsets.symmetric(
                          //     horizontal: 8.0.sp, vertical: 4.0.sp),
                          child: DropdownButton<String>(
                            padding: EdgeInsets.zero,
                            value: selectedCourse,
                            hint: Text(
                              "Course",
                              style: GoogleFonts.roboto(
                                  color: Colors.white, fontSize: 12.sp),
                            ),
                            isExpanded: true,
                            dropdownColor: const Color(0xFF1B1B1B),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Colors.white),
                            underline: const SizedBox(),
                            items: courses.map((course) {
                              return DropdownMenuItem<String>(
                                value: course,
                                child: Text(
                                  course,
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontSize: 12.sp),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCourse = value;
                                _updateQueryParams(); // Trigger API call with debounce
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => Center(
                child: Text(
                  "Error loading dropdowns: $error",
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
              ),
              loading: () => DropDownLoading(),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : const Color(0xFF1B1B1B),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r)),
              ),
              child: collegeProvider.when(
                data: (colleges) => colleges.data?.isNotEmpty ?? false
                    ? ListView.builder(
                        itemCount: colleges.data!.length,
                        itemBuilder: (context, index) {
                          final college = colleges.data![index];
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 10.w,
                                right: 10.w,
                                bottom: 20.h,
                                top: 10.h),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CollegeDetailPage(college.id!),
                                  ),
                                );
                              },
                              child: CollegeTab(
                                image: college.image!,
                                id: college.id!,
                                name: college.name ?? 'Unknown College',
                                desc: college.description ?? 'No location',
                                course: college.city ?? 'No course',
                                city: college.city!,
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: Text("No colleges found")),
                error: (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Error: $error",
                          style: GoogleFonts.roboto(color: Colors.black)),
                      ElevatedButton(
                        onPressed: () => ref.refresh(searchCollegeProvider),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
                loading: () => DataLoading(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    final themeMode = ref.watch(themeProvider);
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                  fontSize: 24.sp,
                  color: themeMode == ThemeMode.dark
                      ? Color(0xff008080)
                      : Colors.white,
                ),
              ),
              Text(
                "College",
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
        ],
      ),
    );
  }
}

class CollegeTab extends StatelessWidget {
  final int id;
  final String name;
  final String desc;
  final String course;
  final String image;
  final String city;

  const CollegeTab({
    super.key,
    required this.id,
    required this.name,
    required this.desc,
    required this.course,
    required this.image,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Color(0xFFFFFFFF),
          border: Border.all(
            color: Color.fromARGB(25, 0, 0, 0),
          )),
      margin: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.network(
              image,
              width: 115.w,
              height: 110.h,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  "https://t4.ftcdn.net/jpg/06/71/92/37/360_F_671923740_x0zOL3OIuUAnSF6sr7PuznCI5bQFKhI0.jpg",
                  width: 115.w,
                  height: 110.h,
                  fit: BoxFit.fill,
                );
              },
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 245.w,
                // color: Colors.amber,
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  name,
                  style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1B1B)),
                ),
              ),
              Container(
                width: 245.w,
                //color: Colors.amber,
                child: Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    desc,
                    style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF666666),
                        height: 1.1)),
              ),
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 220.w,
                height: 2.h,
                color: Color.fromARGB(25, 0, 0, 0),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 10.w, right: 10.w, top: 6.h, bottom: 6.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Color(0xFFDEDDEC)),
                    child: Text(
                      city,
                      style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2E2E2E)),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
