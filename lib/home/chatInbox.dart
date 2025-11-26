import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/chatController.dart';
import 'package:educationapp/home/chating.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Chatinbox extends ConsumerStatefulWidget {
  const Chatinbox({super.key});
  @override
  ConsumerState<Chatinbox> createState() => _ChatinboxState();
}

class _ChatinboxState extends ConsumerState<Chatinbox> {
  final searchController = TextEditingController();
  String searchQuery = "";
  bool isShow = false;
  int voletId = 0;
  int currentBalance = 0;
  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    var id = box.get("userid");
    final inboxData = ref.watch(inboxProvider(id.toString()));
    return Scaffold(
      backgroundColor: Color(0xFF1B1B1B),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.refresh(inboxProvider(id.toString()));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 55.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30.w,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                        color: Color(0xFF1B1B1B),
                        borderRadius: BorderRadius.circular(500.r)),
                    // child: Center(
                    //   child: Icon(
                    //     Icons.arrow_back_ios,
                    //     color: Color.fromARGB(255, 248, 248, 248),
                    //     size: 15.w,
                    //   ),
                    // ),
                  ),
                ),
                Spacer(),
                Text(
                  "Chat History",
                  style: GoogleFonts.roboto(
                      fontSize: 18.w,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff008080)),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    setState(() {
                      isShow = !isShow;
                    });
                  },
                  child: Container(
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(39, 255, 255, 255),
                      borderRadius: BorderRadius.circular(500.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.search,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30.w,
                ),
              ],
            ),
            if (isShow)
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  controller: searchController,
                  cursorColor: Colors.white,
                  style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
                      hint: Text(
                        "Search",
                        style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            isShow = false;
                          });
                        },
                        child: Icon(
                          isShow ? Icons.close : Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFF262626),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ))),
                ),
              ),
            SizedBox(
              height: 25.h,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    inboxData.when(
                      data: (data) {
                        final filterData = data.inbox!.where(
                          (chat) {
                            final name = chat.otherUser!.name.toString();
                            return name.contains(searchQuery);
                          },
                        ).toList();

                        if (filterData.isEmpty) {
                          return Center(
                            child: Text(
                              searchQuery.isEmpty
                                  ? "No recent messages"
                                  : "No chats found for '$searchQuery'",
                              style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black),
                            ),
                          );
                        }
                        return Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: filterData.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => ChatingPage(
                                          otherUesrid: data
                                              .inbox![index].otherUser!.id
                                              .toString(),
                                          id: data.egedUser!.id.toString(),
                                          name: data.inbox![index].otherUser!
                                                  .name ??
                                              "N/A",
                                        ),
                                      ));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 6.w,
                                      top: 10.h,
                                      right: 10.w,
                                      bottom: 10.h),
                                  margin: EdgeInsets.only(
                                      left: 20.w,
                                      right: 20.w,
                                      bottom: 15.h,
                                      top: 10.h),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFFFFFFF),
                                      border: Border.all(color: Colors.grey),
                                      borderRadius:
                                          BorderRadius.circular(20.r)),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Container(
                                        height: 65.h,
                                        width: 60.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.r)),
                                        child: Image.asset(
                                          //"assets/girlpic.png"
                                          filterData[index]
                                              .otherUser!
                                              .profilePick
                                              .toString(),
                                          height: 65.h,
                                          width: 60.w,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return ClipOval(
                                              child: Image.network(
                                                "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                                height: 65.h,
                                                width: 60.w,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              filterData[index]
                                                      .otherUser!
                                                      .name ??
                                                  "no name",
                                              //  "Mike Pena",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 17.w,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff1B1B1B)),
                                            ),
                                            Text(
                                              //"You need to go to Tempa University",
                                              filterData[index].lastMessage ??
                                                  "",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 15.w,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff666666)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 13.w),
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                            color: Color(0xff008080)
                                                .withOpacity(0.2),
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 10.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      error: (error, stackTrace) {
                        log(stackTrace.toString());
                        return Center(
                          child: Text(error.toString()),
                        );
                      },
                      loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DraggableBottomSheetContent extends ConsumerStatefulWidget {
  final int currentBalance;
  final String voletid;
  final Function callback;
  DraggableBottomSheetContent(
      {super.key,
      required this.callback,
      required this.voletid,
      required this.currentBalance});
  @override
  ConsumerState<DraggableBottomSheetContent> createState() =>
      _DraggableBottomSheetContentState();
}

class _DraggableBottomSheetContentState
    extends ConsumerState<DraggableBottomSheetContent> {
  final coinsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r))),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7, // Customize height
      child: Padding(
        padding: EdgeInsets.all(15.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Add Coins",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.w),
                )
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            TextFormField(
              controller: coinsController,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Choose Payment Method",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 16.w,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              width: 400.w,
              height: 70.h,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 241, 242, 246),
                  borderRadius: BorderRadius.circular(20.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16.w,
                  ),
                  Container(
                    height: 35.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/logos_mastercard.png"),
                            fit: BoxFit.contain)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Payment Method",
                        style: GoogleFonts.roboto(
                            fontSize: 11.w,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      Text(
                        "8799 4566 XXXX",
                        style: GoogleFonts.roboto(
                            fontSize: 18.w,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      )
                    ],
                  ),
                  Spacer(),
                  Container(
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(30, 38, 50, 56),
                      borderRadius: BorderRadius.circular(500.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 52.h,
                width: 400.w,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 220, 248, 129),
                    borderRadius: BorderRadius.circular(40.r)),
                child: Center(
                  child: Text(
                    "Continue",
                    style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 16.w,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
