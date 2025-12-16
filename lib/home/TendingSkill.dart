// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../dropDown/dropDownController.dart';
// import '../coreFolder/Controller/searchController.dart';
// import '../coreFolder/Model/GetSkillModel.dart';

// final queryParamsProvider = StateProvider<Map<String, String>>((ref) => {});

// final searchSkillProvider = FutureProvider.autoDispose<SkillGetModel>(
//   (ref) async {
//     final client = await ref.watch(apiClientProvider.future);
//     final params = ref.watch(queryParamsProvider);
//     return await ApiController.getSkill(client, params);
//   },
// );

// class FindSkillPage extends ConsumerStatefulWidget {
//   const FindSkillPage({super.key});
//   @override
//   ConsumerState<FindSkillPage> createState() => _FindSkillPageState();
// }

// class _FindSkillPageState extends ConsumerState<FindSkillPage> {
//   String? selectedLevel;
//   String? selectedIndustry;

//   Timer? _debounce;
//   Map<String, String> _buildQueryParams() {
//     final params = <String, String>{};
//     if (selectedLevel != null &&
//         selectedLevel != "All" &&
//         selectedLevel!.isNotEmpty) {
//       params['level'] = selectedLevel!;
//     }
//     if (selectedIndustry != null &&
//         selectedIndustry != "All" &&
//         selectedIndustry!.isNotEmpty) {
//       params['industry'] = selectedIndustry!;
//     }

//     return params;
//   }

//   void _updateQueryParams() {
//     // Cancel any existing debounce timer
//     _debounce?.cancel();
//     // Start a new timer to delay the API call
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       final params = _buildQueryParams();
//       if (params.isNotEmpty) {
//         ref.read(queryParamsProvider.notifier).state = params;
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dropDownData = ref.watch(getDropDownProvider);
//     final queryParams = ref.watch(queryParamsProvider);
//     final skillProvider =
//         queryParams.isNotEmpty ? ref.watch(searchSkillProvider) : null;

//     return Scaffold(
//       backgroundColor: const Color(0xFF1B1B1B),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 70.h),
//           _appBar(),
//           SizedBox(height: 30.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//             child: dropDownData.when(
//               data: (dropdown) {
//                 final locations = ["All", ...(dropdown.skills!.levels ?? [])];
//                 final collegeNames = [
//                   "All",
//                   ...(dropdown.skills!.industry ?? [])
//                 ];

//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Expanded(
//                       child: Container(
//                         padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 1.0,
//                           ),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         // padding: EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 4.0.sp),
//                         child: DropdownButton<String>(
//                           padding: EdgeInsets.zero,
//                           value: selectedLevel,
//                           hint: Text(
//                             "Select Level",
//                             style: GoogleFonts.roboto(
//                                 color: Colors.white, fontSize: 12.sp),
//                           ),
//                           isExpanded: true,
//                           dropdownColor: const Color(0xFF1B1B1B),
//                           icon: const Icon(Icons.keyboard_arrow_down_rounded,
//                               color: Colors.white),
//                           underline: const SizedBox(),
//                           items: locations.map((location) {
//                             return DropdownMenuItem<String>(
//                               value: location,
//                               child: Text(
//                                 location,
//                                 style: GoogleFonts.roboto(
//                                     color: Colors.white, fontSize: 12.sp),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               selectedLevel = value;
//                               _updateQueryParams(); // Trigger API call with debounce
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10.w),
//                     Expanded(
//                       child: Container(
//                         padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 1.0,
//                           ),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         // padding: EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 4.0.sp),
//                         child: DropdownButton<String>(
//                           padding: EdgeInsets.zero,
//                           value: selectedIndustry,
//                           hint: Text(
//                             "Select Industry",
//                             style: GoogleFonts.roboto(
//                                 color: Colors.white, fontSize: 12.sp),
//                           ),
//                           isExpanded: true,
//                           dropdownColor: const Color(0xFF1B1B1B),
//                           icon: const Icon(Icons.keyboard_arrow_down_rounded,
//                               color: Colors.white),
//                           underline: const SizedBox(),
//                           items: collegeNames.map((college) {
//                             return DropdownMenuItem<String>(
//                               value: college,
//                               child: Text(
//                                 college,
//                                 style: GoogleFonts.roboto(
//                                     color: Colors.white, fontSize: 12.sp),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               selectedIndustry = value;
//                               _updateQueryParams(); // Trigger API call with debounce
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10.w),
//                   ],
//                 );
//               },
//               error: (error, stackTrace) => Center(
//                 child: Text(
//                   "Error loading dropdowns: $error",
//                   style: GoogleFonts.roboto(color: Colors.white),
//                 ),
//               ),
//               loading: () => const Center(child: CircularProgressIndicator()),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30.r),
//               ),
//               child: queryParams.isEmpty
//                   ? const Center(
//                       child: Text("Please select at least one filter"))
//                   : skillProvider!.when(
//                       data: (skill) => skill.data?.isNotEmpty ?? false
//                           ? GridView.count(
//                               // shrinkWrap: true,
//                               // physics: const NeverScrollableScrollPhysics(),
//                               crossAxisCount:
//                                   2, // Adjust the number of columns as needed
//                               crossAxisSpacing: 8.0,
//                               mainAxisSpacing: 8.0,
//                               children:
//                                   skill.data!.asMap().entries.map((entry) {
//                                 final index = entry.key;
//                                 final skill = entry.value;
//                                 return Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: GestureDetector(
//                                     onTap: () {},
//                                     child: SkillTab(
//                                       id: skill.id!,
//                                       level: skill.level!,
//                                       image: skill.image!,
//                                       name: skill.title ?? 'Unknown College',
//                                       description:
//                                           skill.description ?? 'Unknown',
//                                       location:
//                                           skill.description ?? 'No location',
//                                       course: skill.subTitle ?? 'No course',
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             )
//                           : const Center(child: Text("No colleges found")),
//                       error: (error, stackTrace) => Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text("Error: $error",
//                                 style: GoogleFonts.roboto(color: Colors.black)),
//                             ElevatedButton(
//                               onPressed: () => ref.refresh(searchSkillProvider),
//                               child: const Text("Retry"),
//                             ),
//                           ],
//                         ),
//                       ),
//                       loading: () =>
//                           const Center(child: CircularProgressIndicator()),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _appBar() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(width: 30.w),
//         GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Container(
//             height: 44.h,
//             width: 44.w,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(25, 255, 255, 255),
//               borderRadius: BorderRadius.circular(500.r),
//             ),
//             child: const Center(
//               child: Icon(
//                 Icons.arrow_back_ios,
//                 color: Colors.white,
//                 size: 15,
//               ),
//             ),
//           ),
//         ),
//         const Spacer(),
//         Row(
//           children: [
//             Text(
//               "Trending ",
//               style: GoogleFonts.roboto(
//                   fontSize: 24.sp, color: const Color(0xff008080)),
//             ),
//             Text(
//               "Skills",
//               style: GoogleFonts.roboto(
//                   fontSize: 24.sp, color: const Color(0xffA8E6CF)),
//             ),
//           ],
//         ),
//         const Spacer(),
//         SizedBox(width: 30.w),
//       ],
//     );
//   }
// }

// class SkillTab extends StatelessWidget {
//   final int id;
//   final String name;
//   final String level;
//   final String image;
//   final String description;
//   final String location;
//   final String course;

//   const SkillTab({
//     super.key,
//     required this.id,
//     required this.name,
//     required this.level,
//     required this.image,
//     required this.description,
//     required this.location,
//     required this.course,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         elevation: 2,
//         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: 46.h,
//               width: 46.w,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100.r),
//                 image: DecorationImage(
//                     image: NetworkImage(
//                         'http://education.globallywebsolutions.com/public/${image}')),
//               ),
//             ),
//             Text(
//               "${level}",
//               style: GoogleFonts.roboto(
//                   color: Color(0xff008080),
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16.w),
//             ),
//             Text(
//               "${name}",
//               style: GoogleFonts.roboto(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16.w),
//             ),
//             SizedBox(
//               height: 10.h,
//             ),
//             Container(
//               margin: EdgeInsets.only(left: 10.w, right: 10.w),
//               child: Text(
//                 maxLines: 3,
//                 "${description}",
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.roboto(
//                     fontSize: 11.w,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xff666666)),
//               ),
//             ),
//           ],
//         ));
//   }
// }

import 'dart:async';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/findmentor.page.dart';
import 'package:educationapp/home/trendingExprt.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../dropDown/dropDownController.dart';
import '../coreFolder/Controller/searchController.dart';
import '../coreFolder/Model/GetSkillModel.dart';

final queryParamsProvider = StateProvider<Map<String, String>>((ref) => {});

final searchSkillProvider = FutureProvider.autoDispose<SkillGetModel>(
  (ref) async {
    final client = await ref.watch(apiClientProvider.future);
    final params = ref.watch(queryParamsProvider);
    return await ApiController.getSkill(client, params);
  },
);

class FindSkillPage extends ConsumerStatefulWidget {
  const FindSkillPage({super.key});
  @override
  ConsumerState<FindSkillPage> createState() => _FindSkillPageState();
}

class _FindSkillPageState extends ConsumerState<FindSkillPage> {
  String? selectedLevel;
  String? selectedIndustry;
  String _searchText = '';
  bool _showSearchBar = false;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  Map<String, String> _buildQueryParams() {
    final params = <String, String>{};
    if (selectedLevel != null &&
        selectedLevel != "All" &&
        selectedLevel!.isNotEmpty) {
      params['level'] = selectedLevel!;
    }
    if (selectedIndustry != null &&
        selectedIndustry != "All" &&
        selectedIndustry!.isNotEmpty) {
      params['industry'] = selectedIndustry!;
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
        _updateQueryParams();
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
    _debounce?.cancel(); // Clean up the timer
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropDownData = ref.watch(getDropDownProvider);
    final queryParams = ref.watch(queryParamsProvider);
    final skillProvider = ref.watch(searchSkillProvider);
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.sp),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(
                    left: 10.w, right: 10.w, top: 6.h, bottom: 6.h),
                hintText: "Search skills...",
                hintStyle:
                    GoogleFonts.roboto(color: Colors.white70, fontSize: 18.sp),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            child: dropDownData.when(
              data: (dropdown) {
                final locations = ["All", ...(dropdown.skills?.levels ?? [])];
                final collegeNames = [
                  "All",
                  ...(dropdown.skills?.industry ?? [])
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
                        child: DropdownButton<String>(
                          padding: EdgeInsets.zero,
                          value: selectedLevel,
                          hint: Text(
                            "Level",
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
                                    color: Colors.white, fontSize: 10.sp),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedLevel = value;
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
                          items: collegeNames.map((college) {
                            return DropdownMenuItem<String>(
                              value: college,
                              child: Text(
                                college,
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
                  ],
                );
              },
              error: (error, stackTrace) => Center(
                child: Text(
                  "Error loading dropdowns: $error",
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
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : const Color(0xFF1B1B1B),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r)),
              ),
              child: skillProvider.when(
                data: (skill) {
                  final filteredData =
                      skill.data?.where((item) => item.id != null).toList() ??
                          [];
                  return filteredData.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            right: 20.w,
                          ),
                          // child: GridView.count(
                          //   padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                          //   crossAxisCount: 2,
                          //   crossAxisSpacing: 20,
                          //   mainAxisSpacing: 20,
                          //   children: filteredData.asMap().entries.map((entry) {
                          //     final index = entry.key;
                          //     final skillItem = entry.value;
                          //     return GestureDetector(
                          //       onTap: () {},
                          //       child: SkillTab(
                          //         id: skillItem.id!,
                          //         level: skillItem.level ?? '',
                          //         image: skillItem.image ?? '',
                          //         name: skillItem.title ?? 'Unknown',
                          //         description:
                          //             skillItem.description ?? 'Unknown',
                          //         location:
                          //             skillItem.description ?? 'No location',
                          //         course: skillItem.subTitle ?? 'No course',
                          //       ),
                          //     );
                          //   }).toList(),
                          // ),
                          child: GridView.builder(
                            padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                            itemCount: filteredData.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (context, index) {
                              final skillItem = filteredData[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => TrendingExprtPage(
                                          id: skill.data![index].id ?? 0,
                                        ),
                                      ));
                                },
                                child: SkillTab(
                                  image: skillItem.image ?? '',
                                  level: skillItem.level ?? '',
                                  name: skillItem.title ?? 'Unknown',
                                  description:
                                      skillItem.description ?? 'Unknown',
                                ),
                              );
                            },
                          ),
                        )
                      : const Center(child: Text("No skills found"));
                },
                error: (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Failed to load skills: $error",
                        style: GoogleFonts.roboto(color: Colors.black),
                      ),
                      ElevatedButton(
                        onPressed: () => ref.refresh(searchSkillProvider),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
                loading: () {
                  return GridView.builder(
                    padding: EdgeInsets.only(
                        top: 20.h, bottom: 10.h, left: 20.w, right: 20.w),
                    itemCount: 6, // number of shimmer items
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.w,
                      mainAxisSpacing: 20.h,
                    ),
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor:
                            Colors.grey[300]!, // white theme shimmer base
                        highlightColor: Colors.grey[100]!, // smooth shine
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // IMAGE PLACEHOLDER
                              Container(
                                height: 100.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.r),
                                    topRight: Radius.circular(16.r),
                                  ),
                                  color: Colors.grey[300],
                                ),
                              ),

                              // TEXT PLACEHOLDERS
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 8.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 12.h,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      height: 10.h,
                                      width: 70.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      height: 10.h,
                                      width: 90.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
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
                "Trending ",
                style: GoogleFonts.roboto(
                  fontSize: 24.sp,
                  color: themeMode == ThemeMode.dark
                      ? Color(0xff008080)
                      : Colors.white,
                ),
              ),
              Text(
                "Course",
                style: GoogleFonts.roboto(
                    fontSize: 24.sp, color: const Color(0xffA8E6CF)),
              ),
            ],
          ),
          SizedBox(
            width: 44.w,
          )
          // GestureDetector(
          //   onTap: _toggleSearchBar,
          //   child: Container(
          //     height: 44.h,
          //     width: 44.w,
          //     decoration: BoxDecoration(
          //       color: const Color.fromARGB(25, 255, 255, 255),
          //       borderRadius: BorderRadius.circular(500.r),
          //     ),
          //     child: Center(
          //       child: Icon(
          //         _showSearchBar ? Icons.close : Icons.search,
          //         color: Colors.white,
          //         size: 24,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class SkillTab extends StatelessWidget {
  final String image;
  final String level;
  final String name;
  final String description;

  const SkillTab({
    super.key,
    required this.image,
    required this.level,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r), color: Color(0xFFF1F2F6)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              image: DecorationImage(
                image: image.isNotEmpty
                    ? NetworkImage(
                        'http://education.globallywebsolutions.com/public/$image')
                    : const AssetImage('assets/images/default_profile.png')
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            level,
            style: GoogleFonts.roboto(
                color: Color(0xff008080),
                fontWeight: FontWeight.w600,
                fontSize: 16.w),
          ),
          Text(
            name,
            style: GoogleFonts.roboto(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16.w),
          ),
          SizedBox(
            height: 6.h,
          ),
          Container(
            margin: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Text(
              maxLines: 3,
              textAlign: TextAlign.center,
              description,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                  fontSize: 14.w,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff666666),
                  letterSpacing: -0.2),
            ),
          ),
        ],
      ),
    );
  }
}
