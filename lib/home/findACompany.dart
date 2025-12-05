import 'dart:async';
import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/CompanyDetail.dart';
import 'package:educationapp/home/findmentor.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dropDown/dropDownController.dart';
import '../coreFolder/Controller/searchController.dart';
import '../coreFolder/Model/SearchCompanyModel.dart';

final companyQueryParamsProvider =
    StateProvider<Map<String, String>>((ref) => {});
final searchCompanyProvider = FutureProvider.autoDispose<SearchCompanyModel>(
  (ref) async {
    final client = await ref.watch(apiClientProvider.future);
    final params = ref.watch(companyQueryParamsProvider);
    return await ApiController.searchCompany(client, params);
  },
);

class FindCompanyPage extends ConsumerStatefulWidget {
  const FindCompanyPage({super.key});
  @override
  ConsumerState<FindCompanyPage> createState() => _FindCompanyPageState();
}

class _FindCompanyPageState extends ConsumerState<FindCompanyPage> {
  String? selectedSkill;
  String? selectedIndustry;
  String? selectedLocation;
  String _searchText = '';
  bool _showSearchBar = false;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  Map<String, String> _buildQueryParams() {
    final params = <String, String>{};
    if (selectedSkill != null &&
        selectedSkill != "All" &&
        selectedSkill!.isNotEmpty) {
      params['skills'] = selectedSkill!;
    }
    if (selectedIndustry != null &&
        selectedIndustry != "All" &&
        selectedIndustry!.isNotEmpty) {
      params['industry'] = selectedIndustry!;
    }
    if (selectedLocation != null &&
        selectedLocation != "All" &&
        selectedLocation!.isNotEmpty) {
      params['location'] = selectedLocation!;
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
      ref.read(companyQueryParamsProvider.notifier).state = params;
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
      ref.read(companyQueryParamsProvider.notifier).state = {};
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
    final queryParams = ref.watch(companyQueryParamsProvider);
    final companyProvider = ref.watch(searchCompanyProvider);
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
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
                  hintText: "Search company...",
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
                final skills = ["All", ...(dropdown.companies?.skills ?? [])];
                final industries = [
                  "All",
                  ...(dropdown.companies?.industry ?? [])
                ];
                final locations = [
                  "All",
                  ...(dropdown.companies?.locations ?? [])
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
                                skill,
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 10.sp),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSkill = value;
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
                                    color: Colors.white, fontSize: 10.sp),
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
                  ],
                );
              },
              error: (error, stackTrace) => Center(
                child: Text(
                  "Failed to load filters: $error",
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
              ),
              loading: () => DropDownLoading(),
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // color: Colors.white,
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : const Color(0xFF1B1B1B),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r)),
              ),
              child: companyProvider.when(
                data: (companies) => companies.data?.isNotEmpty ?? false
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: companies.data!.length,
                        itemBuilder: (context, index) {
                          final company = companies.data![index];
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CompanyDetailPage(
                                              company.id!,
                                            )));
                              },
                              child: CompanyTab(
                                // id: company.id!,
                                // name: company.collageName ?? 'Unknown',
                                // location: company.location ?? 'Unknown',
                                // industry: company.industry ?? 'Unknown',
                                image: company.image.toString(),
                                id: company.id!,
                                fullname: company.collageName ?? "Unknown",
                                dec: company.collageDescription ??
                                    "No description",
                                facility: [company.facilities![index]],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                        "No companies found",
                        style: TextStyle(
                            color: themeMode == ThemeMode.dark
                                ? const Color(0xFF1B1B1B)
                                : Colors.white),
                      )),
                error: (error, stackTrace) {
                  log(error.toString());
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Failed to load companies: $error",
                          style: GoogleFonts.roboto(color: Colors.black),
                        ),
                        ElevatedButton(
                          onPressed: () => ref.refresh(searchCompanyProvider),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                },
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
                  // color: const Color(0xff008080),
                  color: themeMode == ThemeMode.dark
                      ? Color(0xff008080)
                      : Colors.white,
                ),
              ),
              Text(
                "Company",
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

class CompanyTab extends StatelessWidget {
  // final int id;
  // final String name;
  // final String location;
  // final String industry;
  final String image;
  final int id;
  final String fullname;
  final String dec;
  final List<String> facility;

  const CompanyTab(
      {super.key,
      required this.image,
      required this.id,
      required this.fullname,
      required this.dec,
      required this.facility
      // required this.id,
      // required this.name,
      // required this.location,
      // required this.industry,
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
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      // child: ListTile(
      //   title: Text(
      //     name,
      //     style:
      //         GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.bold),
      //   ),
      //   subtitle: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text("Location: $location",
      //           style: GoogleFonts.roboto(fontSize: 14.sp)),
      //       Text("Industry: $industry",
      //           style: GoogleFonts.roboto(fontSize: 14.sp)),
      //     ],
      //   ),
      // ),
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
                color: Colors.black,
                borderRadius: BorderRadius.circular(12.r),
                // image: DecorationImage(
                //   image: image.isNotEmpty
                //       ? NetworkImage(image)
                //       : const AssetImage('assets/images/default_profile.png')
                //           as ImageProvider,
                //   fit: BoxFit.cover,
                // ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  image,
                  height: 111.h,
                  width: 112.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      "https://media.istockphoto.com/id/1472933890/vector/no-image-vector-symbol-missing-available-icon-no-gallery-for-this-moment-placeholder.jpg?s=612x612&w=0&k=20&c=Rdn-lecwAj8ciQEccm0Ep2RX50FCuUJOaEM8qQjiLL0=",
                      height: 111.h,
                      width: 112.w,
                      fit: BoxFit.cover,
                    );
                  },
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
                SizedBox(height: 10.h),
                Container(
                  height: 0.5.h,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: List.generate(facility.length, (index) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(225, 222, 221, 236),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Text(
                        facility[index],
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }),
                ),
                // SizedBox(
                //   height: 30.h,
                //   child: ListView.builder(
                //     // scrollDirection: Axis.vertical,
                //     shrinkWrap: true,
                //     // physics: const/ NeverScrollableScrollPhysics(),
                //     itemCount: servicetype.length,
                //     itemBuilder: (context, index) {
                //       return Padding(
                //         padding: EdgeInsets.only(right: 8.w),
                //         child: Container(
                //           height: 26.h,
                //           decoration: BoxDecoration(
                //             color: const Color.fromARGB(225, 222, 221, 236),
                //             borderRadius: BorderRadius.circular(50.r),
                //           ),
                //           child: Padding(
                //             padding: EdgeInsets.symmetric(horizontal: 10.w),
                //             child: Center(
                //               child: Text(
                //                 servicetype[index],
                //                 style: GoogleFonts.roboto(
                //                   fontSize: 12.sp,
                //                   fontWeight: FontWeight.w400,
                //                   letterSpacing: -0.30,
                //                   color: Colors.black,
                //                 ),
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
        ],
      ),
    );
  }
}
