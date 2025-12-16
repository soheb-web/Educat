import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/listingBodyModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';

class CreateListPage extends StatefulWidget {
  const CreateListPage({super.key});

  @override
  State<CreateListPage> createState() => _CreateListPageState();
}

class _CreateListPageState extends State<CreateListPage> {
  final educationCotnroller = TextEditingController();
  final exprienceController = TextEditingController();
  final subjectConroller = TextEditingController();
  final feesController = TextEditingController();
  final descController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create List"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            CreateList(label: "Education", controller: educationCotnroller),
            CreateList(label: "Experience", controller: exprienceController),
            CreateList(label: "Subjects", controller: subjectConroller),
            CreateList(label: "Fee", controller: feesController),
            CreateList(label: "Description", controller: descController),
            SizedBox(
              height: 20.h,
            ),
            Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(380.w, 50.h),
                        padding: EdgeInsets.symmetric(vertical: 18.h)),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        final body = CreatelistBodyModel(
                            education: educationCotnroller.text,
                            experience: exprienceController.text,
                            subjects: [subjectConroller.text],
                            fee: feesController.text,
                            description: descController.text);

                        final service = APIStateNetwork(createDio());
                        final response = await service.createList(body);
                        if (response.response.statusCode == 201) {
                          Fluttertoast.showToast(
                              msg: response.response.data['message']);
                          Navigator.pop(context);
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } catch (e, st) {
                        setState(() {
                          isLoading = false;
                        });
                        log("${e.toString()} /n ${st.toString()}");
                        Fluttertoast.showToast(msg: "APi Error : $e");
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: isLoading
                        ? Center(
                            child: SizedBox(
                              width: 30.w,
                              height: 30.h,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Text("Create List"))),
          ],
        ),
      ),
    );
  }
}

class CreateList extends ConsumerStatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? type;
  final bool obscureText;
  final int? maxLine;
  final String? Function(String?)? validator;

  const CreateList({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.maxLine,
    this.type,
  });

  @override
  ConsumerState<CreateList> createState() => _CreateListState();
}

class _CreateListState extends ConsumerState<CreateList> {
  @override
  Widget build(BuildContext context) {
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
                widget.label,
                style: GoogleFonts.roboto(
                  fontSize: 13.w,
                  fontWeight: FontWeight.w400,
                  // color: const Color(0xFF4D4D4D),
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
                  ? Color(0xFF4D4D4D)
                  : Colors.white,
            ),
            controller: widget.controller,
            obscureText: widget.obscureText,
            maxLines: widget.maxLine,
            keyboardType: widget.type,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  // color: Colors.black,
                  color: themeMode == ThemeMode.dark
                      ? const Color(0xFF4D4D4D)
                      : Colors.white,
                ),
                borderRadius: BorderRadius.circular(40.r),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(40.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  //color: Colors.grey
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
