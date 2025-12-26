/*
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../coreFolder/Controller/buyCoinProvider.dart';
import '../coreFolder/Controller/getCoinProvider.dart';
import '../coreFolder/Controller/transactionGetProvider.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});
  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final TextEditingController _amountController = TextEditingController();
  int? _userId;



  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
  void _handleBuyCoins(Map<String, dynamic> payload) {
    // Trigger API without watching (avoids extra rebuilds)
    setState(() => _isLoading = true);

    ref.read(buyCoinProvider(payload).future).then((_) {
      // On success, refresh balance and transactions
      ref.invalidate(getCoinProvider);
      if (_userId != null) {
        ref.invalidate(transactionProvider(_userId!));
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Coins added successfully!')),
        );
      }

      setState(() => _isLoading = false);
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
      setState(() => _isLoading = false);
    });
  }
  bool _isLoading = false;
  String? addCoins;
  List<String> coinsList = ["50", "100", "150", "200"];
  int? selectCoins;

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    final userIdRaw = box.get('userid');
    final themeMode = ref.watch(themeProvider);
    final userId =
        userIdRaw != null ? int.tryParse(userIdRaw.toString()) : null;
    if (userId == null) {
      // Optionally navigate to login here if not handled globally
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login'); // Adjust route
        }
      });
      return const Scaffold(
        body: Center(child: Text('User ID not found. Please log in again.')),
      );
    }
    _userId = userId;
    final coinState = ref.watch(getCoinProvider);
    final balance = coinState.when<int>(
      data: (value) => value.data?.first.coins ?? 0,
      loading: () => 0,
      error: (_, __) => 0,
    );

    final transactionState = ref.watch(transactionProvider(userId));
    return Scaffold(
      // backgroundColor: const Color(0xFF1B1B1B),
      backgroundColor:
          themeMode == ThemeMode.dark ? Color(0xFF1B1B1B) : Color(0xFF008080),
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 44.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(39, 255, 255, 255),
                      borderRadius: BorderRadius.circular(500.r)),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromARGB(255, 248, 248, 248),
                      size: 15,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "Wallet",
                style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: themeMode == ThemeMode.dark
                        ? Color(0xff008080)
                        : Colors.white),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      final plansState =
                          ref.watch(getCoinProvider); // Use correct provider
                      return Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40))),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.7,
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
                                    "Coin Plans",
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.sp),
                                  )
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Expanded(
                                child: plansState.when(
                                  data: (plans) => ListView.builder(
                                    itemCount: plans.data!
                                        .length, // Assume plans is List<CoinPlan>
                                    itemBuilder: (context, index) {
                                      final plan = plans.data![index];
                                      return GestureDetector(
                                        onTap: () {
                                          final Map<String, dynamic> payload = {
                                            'coins': plan.coins, // Use plan_id
                                            'payment_id':
                                                '1', // Verify this is valid
                                          };
                                          Navigator.pop(context);
                                          _handleBuyCoins(
                                              payload); // Use handler for error handling
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 10.h),
                                          padding: EdgeInsets.all(15.w),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 241, 242, 246),
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    plan.planName.toString(),
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    "${plan.coins} Coins",
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "\$${plan.price}",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  loading: () => const Center(
                                      child: CircularProgressIndicator()),
                                  error: (error, stack) => Center(
                                      child:
                                          Text('Error loading plans: $error')),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: 44.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(39, 255, 255, 255),
                    borderRadius: BorderRadius.circular(500.r),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
            ],
          ),
          SizedBox(height: 25.h),
          Container(
            margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Balance",
                      style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "$balance Coins",
                      style: GoogleFonts.roboto(
                          fontSize: 24.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                              // color: Colors.white,
                              color: themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.7,
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
                                          fontSize: 18.sp),
                                    )
                                  ],
                                ),
                                // SizedBox(height: 8.h),
                                // DropdownButtonFormField(
                                //   hint: Text("Select coin type",
                                //       style:
                                //           GoogleFonts.inter(fontSize: 14.sp)),
                                //   decoration: InputDecoration(
                                //     focusedBorder: OutlineInputBorder(
                                //       borderSide:
                                //           const BorderSide(color: Colors.grey),
                                //       borderRadius: BorderRadius.circular(10.r),
                                //     ),
                                //     border: OutlineInputBorder(
                                //       borderSide:
                                //           const BorderSide(color: Colors.grey),
                                //       borderRadius: BorderRadius.circular(10.r),
                                //     ),
                                //     enabledBorder: OutlineInputBorder(
                                //       borderSide:
                                //           const BorderSide(color: Colors.grey),
                                //       borderRadius: BorderRadius.circular(10.r),
                                //     ),
                                //   ),
                                //   items: coinsList
                                //       .map(
                                //         (e) => DropdownMenuItem(
                                //           value: e,
                                //           child: Text(
                                //             e,
                                //             style: GoogleFonts.inter(
                                //                 fontSize: 15.sp,
                                //                 fontWeight: FontWeight.w400,
                                //                 color: Colors.black),
                                //           ),
                                //         ),
                                //       )
                                //       .toList(),
                                //   onChanged: (value) {
                                //     setState(() {
                                //       setState(() {
                                //         addCoins = value;
                                //       });
                                //     });
                                //   },
                                // ),
                                SizedBox(height: 10.h),
                                TextFormField(
                                  style: TextStyle(
                                      color: themeMode == ThemeMode.dark
                                          ? Colors.black
                                          : Colors.white),
                                  onChanged: (value) {
                                    // When user types manually, unselect the buttons
                                    setState(() {
                                      selectCoins = int.tryParse(value);
                                    });
                                  },
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Enter amount of coins",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [50, 100, 150, 200].map((amount) {
                                    final bool isSelected =
                                        selectCoins == amount;

                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectCoins = amount;
                                          _amountController.text =
                                              amount.toString();
                                        });
                                      },
                                      child: Container(
                                        height: 50.h,
                                        width: 80.w,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.white,
                                                blurRadius: 4,
                                                offset: Offset(1, 2),
                                                spreadRadius: 0),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            "$amount",
                                            style: GoogleFonts.inter(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),

                                SizedBox(height: 25.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Choose Payment Method",
                                      style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  width: double.infinity,
                                  height: 70.h,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 241, 242, 246),
                                      borderRadius:
                                          BorderRadius.circular(20.r)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 16.w),
                                      Container(
                                        height: 35.h,
                                        width: 35.w,
                                        decoration: BoxDecoration(
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    "assets/logos_mastercard.png"),
                                                fit: BoxFit.contain)),
                                      ),
                                      const SizedBox(width: 15),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Your Payment Method",
                                            style: GoogleFonts.roboto(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            "8799 4566 XXXX",
                                            style: GoogleFonts.roboto(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 44.h,
                                        width: 44.w,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              30, 38, 50, 56),
                                          borderRadius:
                                              BorderRadius.circular(500.r),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 40.h),
                                GestureDetector(
                                  onTap: _isLoading
                                      ? null // disable tap while loading
                                      : () {
                                       */
/*   final amount =
                                              _amountController.text.trim();
                                          if (amount.isEmpty ||
                                              int.tryParse(amount) == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Enter a valid coin amount')),
                                            );
                                            return;
                                          }
                                          final Map<String, dynamic> payload = {
                                            'coins': amount,
                                            'payment_id':
                                                '1', // Verify this is valid
                                          };

                                          _handleBuyCoins(
                                              payload); // Use handler for error handling
                                          Navigator.pop(context);*/ /*







                                        },
                                  child: Container(
                                    height: 52.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 220, 248, 129),
                                        borderRadius:
                                            BorderRadius.circular(40.r)),
                                    child: Center(
                                      child: _isLoading
                                          ? SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.w,
                                                color: Colors.black,
                                              ),
                                            )
                                          : Text(
                                              "Continue",
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 44.h,
                    width: 106.w,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 220, 248, 129),
                        borderRadius: BorderRadius.circular(40.r)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 16.sp,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            "Add Coin",
                            style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          Container(
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            width: double.infinity,
            height: 70.h,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 38, 38, 38),
                borderRadius: BorderRadius.circular(20.r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 16.w),
                Container(
                  height: 35.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage("assets/logos_mastercard.png"),
                          fit: BoxFit.contain)),
                ),
                const SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Payment Method",
                      style: GoogleFonts.roboto(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    Text(
                      "8799 4566 XXXX",
                      style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
                const Spacer(),
                Container(
                  height: 44.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(39, 255, 255, 255),
                    borderRadius: BorderRadius.circular(500.r),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  // color: Colors.white,
                  color: themeMode == ThemeMode.dark
                      ? Colors.white
                      : Color(0xFF1B1B1B),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Padding(
                padding: EdgeInsets.all(19.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Payment Transaction",
                          style: GoogleFonts.roboto(
                              color: themeMode == ThemeMode.dark
                                  ? Color(0xFF1B1B1B)
                                  : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp),
                        )
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: transactionState.when(
                        data: (transactions) {
                          if (transactions.data!.isEmpty) {
                            return Center(
                              child: Text(
                                "No payment transaction",
                                style: GoogleFonts.roboto(
                                    color: Color(0xFF666666),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp),
                              ),
                            );
                          }
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: transactions.data!.length,
                            itemBuilder: (context, index) {
                              final trans = transactions.data![index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                padding: EdgeInsets.all(15.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  //color: Color(0xffF1F2F6),
                                  color: themeMode == ThemeMode.dark
                                      ? Color(0xffF1F2F6)
                                      : Color(0xFF008080),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_sharp,
                                      size: 25.sp,
                                      color: themeMode == ThemeMode.dark
                                          ? Color(0xffF1F2F6)
                                          : Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trans.type?.toString() ?? 'Unknown',
                                          style: GoogleFonts.inter(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            // color: Color(0xFF1B1B1B,),
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xFF1B1B1B)
                                                : Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 235.w,
                                          child: Text(
                                            trans.description?.toString() ?? '',
                                            style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              //color: Color(0xFF666666),
                                              color: themeMode == ThemeMode.dark
                                                  ? Color(0xFF1B1B1B)
                                                  : Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      trans.coins ?? "",
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: (trans.coins != null &&
                                                trans.coins!
                                                    .trim()
                                                    .startsWith('-'))
                                            ? Colors.red
                                            : themeMode == ThemeMode.dark
                                                ? Color(0xFF008080)
                                                : Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) =>
                            Center(child: Text('Error: $error')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


}
*/

/*

import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../coreFolder/Controller/buyCoinProvider.dart';
import '../coreFolder/Controller/getCoinProvider.dart';
import '../coreFolder/Controller/transactionGetProvider.dart';
import '../coreFolder/Controller/userProfileController.dart';
import '../coreFolder/Model/PaymentCreateModel.dart';
import '../coreFolder/Model/PaymentVerifyModel.dart';
import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});
  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final TextEditingController _amountController = TextEditingController();
  int? _userId;
  late Razorpay _razorpay;
  bool _isLoading = false;
  int? selectCoins;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  // Coins -> Rupees mapping (change as per your requirement)
  double _getAmountInRupees(int coins) {
    Map<int, double> priceMap = {
      50: 5.0,
      100: 10.0,
      150: 15.0,
      200: 20.0,
    };
    return priceMap[coins] ?? 5.0;
  }


  void _openRazorpayCheckout(int coins) async {
    double amountInRupees = _getAmountInRupees(coins);

    setState(() => _isLoading = true); // Loading start

    try {
      // Backend se order create karo (yeh function Future<String> return karega)
      final String? orderId = await paymentCreateApi(
        amountInRupees.toString(),
        "INR",
        "$coins Coins Pack",
        context,
      );

      if (orderId == null || orderId.isEmpty) {
        throw Exception("Failed to create order on server");
      }

      var options = {
        'key': 'rzp_test_RuYzRso83l5DsK', // Test key
        'amount': (amountInRupees * 100).toInt(), // Paise mein
        'name': 'Education App',
        'description': '$coins Coins Pack',
        'order_id': orderId, // ← Yeh critical hai
        'timeout': 300, // 5 minutes
        'prefill': {
          // Optional: user details daal sakte ho
          // 'contact': '9999999999',
          // 'email': 'user@example.com',
        },
        'theme': {'color': '#008080'},
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Checkout Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment error: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }


  // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     final dio = await createDio();
  //     final service = APIStateNetwork(dio);
  //
  //     // Call verify endpoint
  //     final verifyResponse = await service.razorpayOrderVerify(
  //       PaymentVerifyModel(
  //         razorpay_payment_id: response.paymentId!,
  //         razorpay_order_id: response.orderId!,
  //         razorpay_signature: response.signature!,
  //       ),
  //     );
  //
  //     // Validate response
  //     if (verifyResponse.success != true || verifyResponse.payment?.status != "paid") {
  //       throw Exception(verifyResponse.message ?? "Payment verification failed on server");
  //     }
  //
  //     // Critical: Use backend payment ID (your DB id, e.g., 10), NOT Razorpay's pay_XXX
  //     final int backendPaymentId = verifyResponse.payment!.id!;
  //
  //     // Now add coins using your internal payment ID
  //     final payload = {
  //       'coins': selectCoins.toString(),
  //       'payment_id': backendPaymentId.toString(), // ← This is what you wanted
  //     };
  //
  //     _handleBuyCoins(payload);
  //
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Payment Successful! ${selectCoins ?? ''} Coins added.'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //       // Navigator.pop(context); // Close bottom sheet
  //     }
  //   } catch (e) {
  //     debugPrint('Payment Verification Error: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: const Text('Payment failed or verification issue. Contact support.'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }


  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() => _isLoading = true);

    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final verifyResponse = await service.razorpayOrderVerify(
        PaymentVerifyModel(
          razorpay_payment_id: response.paymentId!,
          razorpay_order_id: response.orderId!,
          razorpay_signature: response.signature!,
        ),
      );

      if (verifyResponse.success != true || verifyResponse.payment?.status != "paid") {
        throw Exception(verifyResponse.message ?? "Payment verification failed");
      }

      final int backendPaymentId = verifyResponse.payment!.id!;

      final payload = {
        'coins': selectCoins.toString(),
        'payment_id': backendPaymentId.toString(),
      };

      _handleBuyCoins(payload);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Successful! ${selectCoins ?? ''} Coins added.'),
            backgroundColor: Colors.green,
          ),
        );
        // Optional: You can pop here too, but better to let _handleBuyCoins do it
      }
    } catch (e) {
      debugPrint('Payment Verification Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment failed. Please contact support.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.message ?? 'Unknown error'}')),
    );
    setState(() => _isLoading = false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet Selected: ${response.walletName}')),
    );
  }

  // void _handleBuyCoins(Map<String, dynamic> payload) {
  //   setState(() => _isLoading = true);
  //
  //   ref.read(buyCoinProvider(payload).future).then((_) {
  //     ref.invalidate(getCoinProvider);
  //     if (_userId != null) {
  //       ref.invalidate(transactionProvider(_userId!));
  //     }
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Coins added successfully!')),
  //       );
  //       Navigator.pop(context); // Close bottom sheet
  //     }
  //   }).catchError((error) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: $error')),
  //       );
  //     }
  //   }).whenComplete(() {
  //     setState(() => _isLoading = false);
  //   });
  // }



  void _handleBuyCoins(Map<String, dynamic> payload) {
    setState(() => _isLoading = true);

    ref.read(buyCoinProvider(payload).future).then((_) {
      // Invalidate ALL related providers to refresh UI
      ref.invalidate(userProfileController);        // ← THIS IS CRITICAL FOR balanceText UPDATE
      ref.invalidate(getCoinProvider);              // Optional if still using it elsewhere
      if (_userId != null) {
        ref.invalidate(transactionProvider(_userId!)); // Refresh transaction history
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coins added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Close the Add Coins bottom sheet
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding coins: $error')),
        );
      }
    }).whenComplete(() {
      setState(() => _isLoading = false);
    });
  }
  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    final userIdRaw = box.get('userid');
    final themeMode = ref.watch(themeProvider);
    final userId = userIdRaw != null ? int.tryParse(userIdRaw.toString()) : null;

    if (userId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
      return const Scaffold(
        body: Center(child: Text('User ID not found. Please log in again.')),
      );
    }
    _userId = userId;

    final coinState = ref.watch(getCoinProvider);
    final userProfileProvider = ref.watch(userProfileController);

    final String balanceText = userProfileProvider.when<String>(
      data: (profileRes) {
        final String? coinsStr = profileRes.data?.coins;
        // If coins is null or empty, show 0
        if (coinsStr == null || coinsStr.isEmpty) return "0";
        return coinsStr;
      },
      loading: () => "0", // Or show a shimmer/loading text
      error: (_, __) => "0",
    );

    final transactionState = ref.watch(transactionProvider(userId));

    return Scaffold(
      backgroundColor: themeMode == ThemeMode.dark ? const Color(0xFF1B1B1B) : const Color(0xFF008080),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 44.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(39, 255, 255, 255),
                      borderRadius: BorderRadius.circular(500.r)),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromARGB(255, 248, 248, 248),
                      size: 15,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "Wallet",
                style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: themeMode == ThemeMode.dark ? const Color(0xff008080) : Colors.white),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Your existing coin plans bottom sheet code here if needed
                },
                child: Container(
                  height: 44.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(39, 255, 255, 255),
                    borderRadius: BorderRadius.circular(500.r),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
            ],
          ),
          SizedBox(height: 25.h),
          Container(
            margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Balance",
                      style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "$balanceText Coins",
                      style: GoogleFonts.roboto(
                          fontSize: 24.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                              color: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.7,
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
                                SizedBox(height: 15.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Add Coins",
                                      style: GoogleFonts.roboto(
                                          color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                TextFormField(
                                  style: TextStyle(
                                      color: themeMode == ThemeMode.dark ? Colors.black : Colors.white),
                                  onChanged: (value) {
                                    setState(() {
                                      selectCoins = int.tryParse(value);
                                    });
                                  },
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Enter amount of coins",
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
                                SizedBox(height: 20.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [50, 100, 150, 200].map((amount) {
                                    final bool isSelected = selectCoins == amount;
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectCoins = amount;
                                          _amountController.text = amount.toString();
                                        });
                                      },
                                      child: Container(
                                        height: 50.h,
                                        width: 80.w,
                                        decoration: BoxDecoration(
                                          color: isSelected ? const Color(0xFF008080) : Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "$amount",
                                            style: GoogleFonts.inter(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500,
                                                color: isSelected ? Colors.white : Colors.black),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                // SizedBox(height: 25.h),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     Text(
                                //       "Choose Payment Method",
                                //       style: GoogleFonts.roboto(
                                //           color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                //           fontSize: 16.sp,
                                //           fontWeight: FontWeight.w600),
                                //     )
                                //   ],
                                // ),
                                // SizedBox(height: 10.h),
                                // Container(
                                //   width: double.infinity,
                                //   height: 70.h,
                                //   decoration: BoxDecoration(
                                //       color: const Color.fromARGB(255, 241, 242, 246),
                                //       borderRadius: BorderRadius.circular(20.r)),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       SizedBox(width: 16.w),
                                //       Container(
                                //         height: 35.h,
                                //         width: 35.w,
                                //         decoration: const BoxDecoration(
                                //             image: DecorationImage(
                                //                 image: AssetImage("assets/logos_mastercard.png"),
                                //                 fit: BoxFit.contain)),
                                //       ),
                                //       const SizedBox(width: 15),
                                //       Column(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           Text(
                                //             "Your Payment Method",
                                //             style: GoogleFonts.roboto(
                                //                 fontSize: 11.sp,
                                //                 fontWeight: FontWeight.w400,
                                //                 color: Colors.black),
                                //           ),
                                //           Text(
                                //             "8799 4566 XXXX",
                                //             style: GoogleFonts.roboto(
                                //                 fontSize: 18.sp,
                                //                 fontWeight: FontWeight.w600,
                                //                 color: Colors.black),
                                //           )
                                //         ],
                                //       ),
                                //       const Spacer(),
                                //       Container(
                                //         height: 44.h,
                                //         width: 44.w,
                                //         decoration: BoxDecoration(
                                //           color: const Color.fromARGB(30, 38, 50, 56),
                                //           borderRadius: BorderRadius.circular(500.r),
                                //         ),
                                //         child: const Center(
                                //           child: Icon(
                                //             Icons.arrow_forward_ios_rounded,
                                //             color: Colors.black,
                                //           ),
                                //         ),
                                //       ),
                                //       SizedBox(width: 16.w),
                                //     ],
                                //   ),
                                // ),
                                SizedBox(height: 40.h),
                                GestureDetector(
                                  onTap: _isLoading
                                      ? null
                                      : () {
                                    final coinsText = _amountController.text.trim();
                                    if (coinsText.isEmpty ||
                                        int.tryParse(coinsText) == null ||
                                        int.parse(coinsText) <= 0) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Enter a valid coin amount')),
                                      );
                                      return;
                                    }

                                    final coins = int.parse(coinsText);
                                    setState(() {
                                      selectCoins = coins;
                                      _isLoading = true;
                                    });

                                    _openRazorpayCheckout(coins);
                                  },
                                  child: Container(
                                    height: 52.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 220, 248, 129),
                                        borderRadius: BorderRadius.circular(40.r)),
                                    child: Center(
                                      child: _isLoading
                                          ? const CircularProgressIndicator(color: Colors.black)
                                          : Text(
                                        "Continue",
                                        style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 44.h,
                    width: 106.w,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 220, 248, 129),
                        borderRadius: BorderRadius.circular(40.r)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.black, size: 16.sp),
                          SizedBox(width: 3.w),
                          Text(
                            "Add Coin",
                            style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          // Container(
          //   margin: EdgeInsets.only(left: 20.w, right: 20.w),
          //   width: double.infinity,
          //   height: 70.h,
          //   decoration: BoxDecoration(
          //       color: const Color.fromARGB(255, 38, 38, 38),
          //       borderRadius: BorderRadius.circular(20.r)),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       SizedBox(width: 16.w),
          //       Container(
          //         height: 35.h,
          //         width: 35.w,
          //         decoration: const BoxDecoration(
          //             image: DecorationImage(
          //                 image: AssetImage("assets/logos_mastercard.png"),
          //                 fit: BoxFit.contain)),
          //       ),
          //       const SizedBox(width: 15),
          //       Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "Your Payment Method",
          //             style: GoogleFonts.roboto(
          //                 fontSize: 11.sp,
          //                 fontWeight: FontWeight.w400,
          //                 color: Colors.white),
          //           ),
          //           Text(
          //             "8799 4566 XXXX",
          //             style: GoogleFonts.roboto(
          //                 fontSize: 18.sp,
          //                 fontWeight: FontWeight.w600,
          //                 color: Colors.white),
          //           )
          //         ],
          //       ),
          //       const Spacer(),
          //       Container(
          //         height: 44.h,
          //         width: 44.w,
          //         decoration: BoxDecoration(
          //           color: const Color.fromARGB(39, 255, 255, 255),
          //           borderRadius: BorderRadius.circular(500.r),
          //         ),
          //         child: const Center(
          //           child: Icon(
          //             Icons.arrow_forward_ios_rounded,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 16.w),
          //     ],
          //   ),
          // ),
          SizedBox(height: 30.h),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: themeMode == ThemeMode.dark ? Colors.white : const Color(0xFF1B1B1B),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Padding(
                padding: EdgeInsets.all(19.0.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Transaction",
                          style: GoogleFonts.roboto(
                              color: themeMode == ThemeMode.dark ? const Color(0xFF1B1B1B) : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp),
                        )
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: transactionState.when(
                        data: (transactions) {
                          if (transactions.data!.isEmpty) {
                            return Center(
                              child: Text(
                                "No payment transaction",
                                style: GoogleFonts.roboto(
                                    color: const Color(0xFF666666),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp),
                              ),
                            );
                          }
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: transactions.data!.length,
                            itemBuilder: (context, index) {
                              final trans = transactions.data![index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                padding: EdgeInsets.all(15.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  color: themeMode == ThemeMode.dark
                                      ? const Color(0xffF1F2F6)
                                      : const Color(0xFF008080),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_sharp,
                                      size: 25.sp,
                                      color: themeMode == ThemeMode.dark
                                          ? const Color(0xffF1F2F6)
                                          : Colors.white,
                                    ),
                                    SizedBox(width: 10.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trans.type?.toString() ?? 'Unknown',
                                          style: GoogleFonts.inter(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color: themeMode == ThemeMode.dark
                                                ? const Color(0xFF1B1B1B)
                                                : Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 235.w,
                                          child: Text(
                                            trans.description?.toString() ?? '',
                                            style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: themeMode == ThemeMode.dark
                                                  ? const Color(0xFF1B1B1B)
                                                  : Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      trans.coins ?? "",
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: (trans.coins != null &&
                                            trans.coins!.trim().startsWith('-'))
                                            ? Colors.red
                                            : themeMode == ThemeMode.dark
                                            ? const Color(0xFF008080)
                                            : Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(child: Text('Error: $error')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }



  static Future<String> paymentCreateApi(
      String amount,
      String currency,
      String description,
      BuildContext context,
      ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.razorpayOrder(

        PaymentCreateModel(
          currency: currency,
          description: description,
          amount: amount,

      ));

      // Check if response is successful
      if (response.data['success'] == true) {
        // Your backend returns order_id inside "payment" object
        final String orderId = response.data['payment']['order_id'].toString();
        return orderId;
      } else {
        throw Exception(response.data['message'] ?? "Failed to create order");
      }
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');

      // if (context.mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text(errorMessage),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // }

      throw Exception(errorMessage); // Ya phir custom PaymentException
    }
  }


*/
/*
  static Future<bool> paymentVerifyApi(
      String razorpay_payment_id,
      String razorpay_order_id,
      String razorpay_signature, {
        required BuildContext context,
      }) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.razorpayOrderVerify(PaymentVerifyModel(
        razorpay_payment_id: razorpay_payment_id,
        razorpay_order_id: razorpay_order_id,
        razorpay_signature: razorpay_signature,
      ));

      return response.payment.status;
    } catch (e) {
      debugPrint("Payment Verify Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verification failed: $e")));
      }
      return false;
    }
  }*/ /*



  static Future<bool> paymentVerifyApi(
      String razorpay_payment_id,
      String razorpay_order_id,
      String razorpay_signature, {
        required BuildContext context,
      }) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.razorpayOrderVerify(
        PaymentVerifyModel(
          razorpay_payment_id: razorpay_payment_id,
          razorpay_order_id: razorpay_order_id,
          razorpay_signature: razorpay_signature,
        ),
      );

      // Check if backend says success AND payment status is paid
      if (response.success == true && response.payment?.status == "paid") {
        return true;
      } else {
        throw Exception(response.message ?? "Payment not marked as paid");
      }
    } catch (e) {
      debugPrint("Payment Verify Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verification failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }
}

*/

/*



import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../coreFolder/Controller/buyCoinProvider.dart';
import '../coreFolder/Controller/getCoinProvider.dart';
import '../coreFolder/Controller/transactionGetProvider.dart';
import '../coreFolder/Controller/userProfileController.dart';
import '../coreFolder/Model/PaymentCreateModel.dart';
import '../coreFolder/Model/PaymentVerifyModel.dart';
import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final TextEditingController _amountController = TextEditingController();
  int? _userId;
  late Razorpay _razorpay;
  bool _isLoading = false;
  int? selectCoins;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  // Updated: Supports any coin amount (manual entry included)
  // Pricing: ₹0.1 per coin (consistent across all packs and custom amounts)
  double _getAmountInRupees(int coins) {
    return (coins * 0.1); // ₹0.1 per coin → 100 coins = ₹10, 500 coins = ₹50, etc.
  }

  void _openRazorpayCheckout(int coins) async {
    double amountInRupees = _getAmountInRupees(coins);

    setState(() => _isLoading = true);

    try {
      final String? orderId = await paymentCreateApi(
        amountInRupees.toStringAsFixed(2),
        "INR",
        "$coins Coins Pack",
        context,
      );

      if (orderId == null || orderId.isEmpty) {
        throw Exception("Failed to create order on server");
      }

      var options = {
        'key': 'rzp_test_RuYzRso83l5DsK', // Replace with live key in production
        'amount': (amountInRupees * 100).toInt(), // in paise
        'name': 'Education App',
        'description': '$coins Coins Pack',
        'order_id': orderId,
        'timeout': 300,
        'theme': {'color': '#008080'},
        'prefill': {},
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Checkout Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment initiation failed: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() => _isLoading = true);

    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final verifyResponse = await service.razorpayOrderVerify(
        PaymentVerifyModel(
          razorpay_payment_id: response.paymentId!,
          razorpay_order_id: response.orderId!,
          razorpay_signature: response.signature!,
        ),
      );

      if (verifyResponse.success != true || verifyResponse.payment?.status != "paid") {
        throw Exception(verifyResponse.message ?? "Payment verification failed");
      }

      final int backendPaymentId = verifyResponse.payment!.id!;

      final payload = {
        'coins': selectCoins.toString(),
        'payment_id': backendPaymentId.toString(),
      };

      _handleBuyCoins(payload);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Successful! ${selectCoins ?? ''} Coins added.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Payment Verification Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment failed. Please contact support.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment Failed: ${response.message ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('External Wallet: ${response.walletName}')),
      );
    }
  }

  void _handleBuyCoins(Map<String, dynamic> payload) {
    setState(() => _isLoading = true);

    ref.read(buyCoinProvider(payload).future).then((_) {
      // Refresh all relevant data
      ref.invalidate(userProfileController);        // Critical: Updates balanceText
      ref.invalidate(getCoinProvider);
      if (_userId != null) {
        ref.invalidate(transactionProvider(_userId!));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coins added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Close bottom sheet
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding coins: $error')),
        );
      }
    }).whenComplete(() {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    final userIdRaw = box.get('userid');
    final themeMode = ref.watch(themeProvider);
    final userId = userIdRaw != null ? int.tryParse(userIdRaw.toString()) : null;

    if (userId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
      return const Scaffold(
        body: Center(child: Text('User ID not found. Please log in again.')),
      );
    }
    _userId = userId;

    final userProfileProvider = ref.watch(userProfileController);

    final String balanceText = userProfileProvider.when<String>(
      data: (profileRes) => profileRes.data?.coins ?? "0",
      loading: () => "0",
      error: (_, __) => "0",
    );

    final transactionState = ref.watch(transactionProvider(userId));

    return Scaffold(
      backgroundColor: themeMode == ThemeMode.dark ? const Color(0xFF1B1B1B) : const Color(0xFF008080),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(39, 255, 255, 255),
                      borderRadius: BorderRadius.circular(500.r),
                    ),
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 15),
                  ),
                ),
                const Spacer(),
                Text(
                  "Wallet",
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: themeMode == ThemeMode.dark ? const Color(0xff008080) : Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  height: 44.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(39, 255, 255, 255),
                    borderRadius: BorderRadius.circular(500.r),
                  ),
                  child: const Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Balance", style: GoogleFonts.roboto(fontSize: 14.sp, color: Colors.white)),
                    SizedBox(height: 5.h),
                    Text(
                      "$balanceText Coins",
                      style: GoogleFonts.roboto(fontSize: 24.sp, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => _buildAddCoinsBottomSheet(themeMode),
                    );
                  },
                  child: Container(
                    height: 44.h,
                    width: 106.w,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 220, 248, 129),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.black, size: 16.sp),
                        SizedBox(width: 3.w),
                        Text("Add Coin", style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: themeMode == ThemeMode.dark ? Colors.white : const Color(0xFF1B1B1B),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
              child: Padding(
                padding: EdgeInsets.all(19.w),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Payment Transaction",
                        style: GoogleFonts.roboto(
                          color: themeMode == ThemeMode.dark ? const Color(0xFF1B1B1B) : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: transactionState.when(
                        data: (transactions) {
                          if (transactions.data!.isEmpty) {
                            return Center(
                              child: Text(
                                "No payment transaction",
                                style: GoogleFonts.roboto(color: const Color(0xFF666666), fontSize: 16.sp),
                              ),
                            );
                          }
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: transactions.data!.length,
                            itemBuilder: (context, index) {
                              final trans = transactions.data![index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                padding: EdgeInsets.all(15.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  color: themeMode == ThemeMode.dark ? const Color(0xffF1F2F6) : const Color(0xFF008080),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.person_sharp, size: 25.sp, color: themeMode == ThemeMode.dark ? const Color(0xffF1F2F6) : Colors.white),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trans.type ?? 'Unknown',
                                            style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w600, color: themeMode == ThemeMode.dark ? const Color(0xFF1B1B1B) : Colors.white),
                                          ),
                                          Text(
                                            trans.description ?? '',
                                            style: GoogleFonts.inter(fontSize: 14.sp, color: themeMode == ThemeMode.dark ? const Color(0xFF1B1B1B) : Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      trans.coins ?? "",
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: (trans.coins?.startsWith('-') == true) ? Colors.red : (themeMode == ThemeMode.dark ? const Color(0xFF008080) : Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, _) => Center(child: Text('Error: $error')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildAddCoinsBottomSheet(ThemeMode themeMode) {
  //   final double amountToPay = selectCoins != null ? _getAmountInRupees(selectCoins!) : 0.0;
  //
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
  //       borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
  //     ),
  //     height: MediaQuery.of(context).size.height * 0.7,
  //     padding: EdgeInsets.all(15.w),
  //     child: Column(
  //       children: [
  //         Container(height: 5.h, width: 50.w, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
  //         SizedBox(height: 15.h),
  //         Align(
  //           alignment: Alignment.centerLeft,
  //           child: Text("Add Coins", style: GoogleFonts.roboto(color: themeMode == ThemeMode.dark ? Colors.black : Colors.white, fontWeight: FontWeight.w600, fontSize: 18.sp)),
  //         ),
  //         SizedBox(height: 10.h),
  //         TextFormField(
  //           controller: _amountController,
  //           keyboardType: TextInputType.number,
  //           style: TextStyle(color: themeMode == ThemeMode.dark ? Colors.black : Colors.white),
  //           onChanged: (value) => setState(() => selectCoins = int.tryParse(value)),
  //           decoration: InputDecoration(
  //             labelText: "Enter amount of coins",
  //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
  //             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: Colors.grey)),
  //             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: Colors.grey)),
  //           ),
  //         ),
  //         SizedBox(height: 20.h),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [50, 100, 150, 200].map((amount) {
  //             final isSelected = selectCoins == amount;
  //             return InkWell(
  //               onTap: () {
  //                 setState(() {
  //                   selectCoins = amount;
  //                   _amountController.text = amount.toString();
  //                 });
  //               },
  //               child: Container(
  //                 height: 50.h,
  //                 width: 80.w,
  //                 decoration: BoxDecoration(
  //                   color: isSelected ? const Color(0xFF008080) : Colors.grey.shade200,
  //                   borderRadius: BorderRadius.circular(20.r),
  //                 ),
  //                 child: Center(
  //                   child: Text("$amount", style: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : Colors.black)),
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //         SizedBox(height: 20.h),
  //         // Show amount user will pay
  //         Align(
  //           alignment: Alignment.centerLeft,
  //           child: Text(
  //             "Amount to pay: ₹${amountToPay.toStringAsFixed(2)}",
  //             style: GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.w600, color: themeMode == ThemeMode.dark ? Colors.black : Colors.white),
  //           ),
  //         ),
  //         SizedBox(height: 40.h),
  //         GestureDetector(
  //           onTap: _isLoading
  //               ? null
  //               : () {
  //             final coinsText = _amountController.text.trim();
  //             if (coinsText.isEmpty || int.tryParse(coinsText) == null || int.parse(coinsText) <= 0) {
  //               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid coin amount')));
  //               return;
  //             }
  //             final coins = int.parse(coinsText);
  //             setState(() => selectCoins = coins);
  //             _openRazorpayCheckout(coins);
  //           },
  //           child: Container(
  //             height: 52.h,
  //             width: double.infinity,
  //             decoration: BoxDecoration(color: const Color.fromARGB(255, 220, 248, 129), borderRadius: BorderRadius.circular(40.r)),
  //             child: Center(
  //               child: _isLoading
  //                   ? const CircularProgressIndicator(color: Colors.black)
  //                   : Text("Continue", style: GoogleFonts.roboto(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.w500)),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAddCoinsBottomSheet(ThemeMode themeMode) {
    // This will rebuild whenever selectCoins changes (from button or text field)
    final int coinsToUse = selectCoins ?? 0;
    final double amountToPay = _getAmountInRupees(coinsToUse);

    return Container(
      decoration: BoxDecoration(
        color: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      ),
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(15.w),
      child: Column(
        children: [
          Container(height: 5.h, width: 50.w, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
          SizedBox(height: 15.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Add Coins",
              style: GoogleFonts.roboto(
                color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: themeMode == ThemeMode.dark ? Colors.black : Colors.white),
            onChanged: (value) {
              final parsed = int.tryParse(value);
              setState(() {
                selectCoins = parsed; // Triggers rebuild → amountToPay updates
              });
            },
            decoration: InputDecoration(
              labelText: "Enter amount of coins",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: Colors.grey)),
            ),
          ),
          SizedBox(height: 20.h),
          // Predefined coin buttons with highlight
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [50, 100, 150, 200].map((amount) {
              final bool isSelected = selectCoins == amount;
              return GestureDetector( // Changed from InkWell to GestureDetector for better feedback
                onTap: () {
                  setState(() {
                    selectCoins = amount;
                    _amountController.text = amount.toString(); // Sync text field
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 60.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF008080) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: isSelected
                        ? [BoxShadow(color: const Color(0xFF008080).withOpacity(0.5), blurRadius: 10, spreadRadius: 2)]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      "$amount",
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 30.h),
          // Live Amount to Pay Display
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF008080).withOpacity(0.1),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: const Color(0xFF008080), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "You will pay",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: themeMode == ThemeMode.dark ? Colors.black87 : Colors.white,
                  ),
                ),
                Text(
                  "₹${amountToPay.toStringAsFixed(2)}",
                  style: GoogleFonts.roboto(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF008080),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          GestureDetector(
            onTap: _isLoading || coinsToUse <= 0
                ? null
                : () {
              if (coinsToUse <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid coin amount')),
                );
                return;
              }
              _openRazorpayCheckout(coinsToUse);
            },
            child: Container(
              height: 52.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _isLoading || coinsToUse <= 0
                    ? Colors.grey
                    : const Color.fromARGB(255, 220, 248, 129),
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text(
                  "Continue to Pay ₹${amountToPay.toStringAsFixed(2)}",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<String?> paymentCreateApi(String amount, String currency, String description, BuildContext context) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.razorpayOrder(PaymentCreateModel(currency: currency, description: description, amount: amount));

      if (response.data['success'] == true) {
        return response.data['payment']['order_id'].toString();
      } else {
        throw Exception(response.data['message'] ?? "Order creation failed");
      }
    } catch (e) {
      debugPrint("Payment Create Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order failed: $e")));
      }
      return null;
    }
  }

  static Future<bool> paymentVerifyApi(
      String razorpay_payment_id,
      String razorpay_order_id,
      String razorpay_signature, {
        required BuildContext context,
      }) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.razorpayOrderVerify(
        PaymentVerifyModel(
          razorpay_payment_id: razorpay_payment_id,
          razorpay_order_id: razorpay_order_id,
          razorpay_signature: razorpay_signature,
        ),
      );

      return response.success == true && response.payment?.status == "paid";
    } catch (e) {
      debugPrint("Payment Verify Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verification failed: $e"), backgroundColor: Colors.red));
      }
      return false;
    }
  }
}*/

/*

import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../coreFolder/Controller/buyCoinProvider.dart';
import '../coreFolder/Controller/getCoinProvider.dart';
import '../coreFolder/Controller/transactionGetProvider.dart';
import '../coreFolder/Controller/userProfileController.dart';
import '../coreFolder/Model/PaymentCreateModel.dart';
import '../coreFolder/Model/PaymentVerifyModel.dart';
import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final TextEditingController _amountController = TextEditingController();
  int? _userId;
  late Razorpay _razorpay;
  bool _isLoading = false;
  int? selectCoins;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  // ₹0.1 per coin for all amounts (including manual entry)
  double _getAmountInRupees(int coins) {
    return (coins * 0.1);
  }

  void _openRazorpayCheckout(int coins) async {
    double amountInRupees = _getAmountInRupees(coins);

    setState(() => _isLoading = true);

    try {
      final String? orderId = await paymentCreateApi(
        amountInRupees.toStringAsFixed(2),
        "INR",
        "$coins Coins Pack",
        context,
      );

      if (orderId == null || orderId.isEmpty) {
        throw Exception("Failed to create order on server");
      }

      var options = {
        'key': 'rzp_test_RuYzRso83l5DsK',
        'amount': (amountInRupees * 100).toInt(),
        'name': 'Education App',
        'description': '$coins Coins Pack',
        'order_id': orderId,
        'timeout': 300,
        'theme': {'color': '#008080'},
        'prefill': {},
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Checkout Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment initiation failed: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() => _isLoading = true);

    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final verifyResponse = await service.razorpayOrderVerify(
        PaymentVerifyModel(
          razorpay_payment_id: response.paymentId!,
          razorpay_order_id: response.orderId!,
          razorpay_signature: response.signature!,
        ),
      );

      if (verifyResponse.success != true || verifyResponse.payment?.status != "paid") {
        throw Exception(verifyResponse.message ?? "Payment verification failed");
      }

      final int backendPaymentId = verifyResponse.payment!.id!;

      final payload = {
        'coins': selectCoins.toString(),
        'payment_id': backendPaymentId.toString(),
      };

      _handleBuyCoins(payload);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Successful! ${selectCoins ?? ''} Coins added.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Payment Verification Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment failed. Please contact support.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment Failed: ${response.message ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('External Wallet: ${response.walletName}')),
      );
    }
  }

  void _handleBuyCoins(Map<String, dynamic> payload) {
    setState(() => _isLoading = true);

    ref.read(buyCoinProvider(payload).future).then((_) {
      ref.invalidate(userProfileController);
      ref.invalidate(getCoinProvider);
      if (_userId != null) {
        ref.invalidate(transactionProvider(_userId!));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coins added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding coins: $error')),
        );
      }
    }).whenComplete(() {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    final userIdRaw = box.get('userid');
    final themeMode = ref.watch(themeProvider);
    final userId = userIdRaw != null ? int.tryParse(userIdRaw.toString()) : null;

    if (userId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
      return const Scaffold(
        body: Center(child: Text('User ID not found. Please log in again.')),
      );
    }
    _userId = userId;

    final userProfileProvider = ref.watch(userProfileController);

    final String balanceText = userProfileProvider.when<String>(
      data: (profileRes) => profileRes.data?.coins ?? "0",
      loading: () => "0",
      error: (_, __) => "0",
    );

    final transactionState = ref.watch(transactionProvider(userId));

    return Scaffold(
      backgroundColor: themeMode == ThemeMode.dark ? const Color(0xFF1B1B1B) : const Color(0xFF008080),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(39, 255, 255, 255),
                      borderRadius: BorderRadius.circular(500.r),
                    ),
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 15),
                  ),
                ),
                const Spacer(),
                Text(
                  "Wallet",
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: themeMode == ThemeMode.dark ? const Color(0xff008080) : Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  height: 44.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(39, 255, 255, 255),
                    borderRadius: BorderRadius.circular(500.r),
                  ),
                  child: const Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Balance", style: GoogleFonts.roboto(fontSize: 14.sp, color: Colors.white)),
                    SizedBox(height: 5.h),
                    Text(
                      "$balanceText Coins",
                      style: GoogleFonts.roboto(fontSize: 24.sp, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setModalState) {
                            final int coinsToUse = selectCoins ?? 0;
                            final double amountToPay = _getAmountInRupees(coinsToUse);

                            return Container(
                              decoration: BoxDecoration(
                                color: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                              ),
                              height: MediaQuery.of(context).size.height * 0.7,
                              padding: EdgeInsets.all(15.w),
                              child: Column(
                                children: [
                                  Container(height: 5.h, width: 50.w, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
                                  SizedBox(height: 15.h),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Add Coins",
                                      style: GoogleFonts.roboto(
                                        color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  TextFormField(
                                    controller: _amountController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: themeMode == ThemeMode.dark ? Colors.black : Colors.white),
                                    onChanged: (value) {
                                      final parsed = int.tryParse(value) ?? 0;
                                      setState(() => selectCoins = parsed);
                                      setModalState(() {}); // Instant rebuild
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Enter amount of coins",
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: Colors.grey)),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [50, 100, 150, 200].map((amount) {
                                      final bool isSelected = selectCoins == amount;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectCoins = amount;
                                            _amountController.text = amount.toString();
                                          });
                                          setModalState(() {});
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 250),
                                          height: 60.h,
                                          width: 80.w,
                                          decoration: BoxDecoration(
                                            color: isSelected ? const Color(0xFF008080) : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(20.r),
                                            boxShadow: isSelected
                                                ? [BoxShadow(color: const Color(0xFF008080).withOpacity(0.6), blurRadius: 12, spreadRadius: 3)]
                                                : null,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "$amount",
                                              style: GoogleFonts.inter(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w700,
                                                color: isSelected ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(height: 30.h),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF008080).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15.r),
                                      border: Border.all(color: const Color(0xFF008080), width: 1.5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "You will pay",
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: themeMode == ThemeMode.dark ? Colors.black87 : Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "₹${amountToPay.toStringAsFixed(2)}",
                                          style: GoogleFonts.roboto(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF008080),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 40.h),
                                  GestureDetector(
                                    onTap: _isLoading || coinsToUse <= 0
                                        ? null
                                        : () {
                                      if (coinsToUse <= 0) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Please enter a valid coin amount')),
                                        );
                                        return;
                                      }
                                      _openRazorpayCheckout(coinsToUse);
                                    },
                                    child: Container(
                                      height: 56.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: (_isLoading || coinsToUse <= 0)
                                            ? Colors.grey
                                            : const Color.fromARGB(255, 220, 248, 129),
                                        borderRadius: BorderRadius.circular(40.r),
                                      ),
                                      child: Center(
                                        child: _isLoading
                                            ? const CircularProgressIndicator(color: Colors.black)
                                            : Text(
                                          "Continue to Pay ₹${amountToPay.toStringAsFixed(2)}",
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 44.h,
                    width: 106.w,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 220, 248, 129),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.black, size: 16.sp),
                        SizedBox(width: 3.w),
                        Text("Add Coin", style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: themeMode == ThemeMode.dark ? Colors.white : const Color(0xFF1B1B1B),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
              child: Padding(
                padding: EdgeInsets.all(19.w),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Payment Transaction",
                        style: GoogleFonts.roboto(
                          color: themeMode == ThemeMode.dark ? const Color(0xFF1B1B1B) : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: transactionState.when(
                        data: (transactions) {
                          if (transactions.data!.isEmpty) {
                            return Center(
                              child: Text(
                                "No payment transaction",
                                style: GoogleFonts.roboto(color: const Color(0xFF666666), fontSize: 16.sp),
                              ),
                            );
                          }
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: transactions.data!.length,
                            itemBuilder: (context, index) {
                              final trans = transactions.data![index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                padding: EdgeInsets.all(15.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  color: themeMode == ThemeMode.dark ? const Color(0xffF1F2F6) : const Color(0xFF008080),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.person_sharp, size: 25.sp, color: themeMode == ThemeMode.dark ? const Color(0xffF1F2F6) : Colors.white),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trans.type ?? 'Unknown',
                                            style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w600, color: themeMode == ThemeMode.dark ? const Color(0xFF1B1B1B) : Colors.white),
                                          ),
                                          Text(
                                            trans.description ?? '',
                                            style: GoogleFonts.inter(fontSize: 14.sp, color: themeMode == ThemeMode.dark ? const Color(0xFF1B1B1B) : Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      trans.coins ?? "",
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: (trans.coins?.startsWith('-') == true) ? Colors.red : (themeMode == ThemeMode.dark ? const Color(0xFF008080) : Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, _) => Center(child: Text('Error: $error')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<String?> paymentCreateApi(String amount, String currency, String description, BuildContext context) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.razorpayOrder(PaymentCreateModel(currency: currency, description: description, amount: amount));

      if (response.data['success'] == true) {
        return response.data['payment']['order_id'].toString();
      } else {
        throw Exception(response.data['message'] ?? "Order creation failed");
      }
    } catch (e) {
      debugPrint("Payment Create Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order failed: $e")));
      }
      return null;
    }
  }

  static Future<bool> paymentVerifyApi(
      String razorpay_payment_id,
      String razorpay_order_id,
      String razorpay_signature, {
        required BuildContext context,
      }) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.razorpayOrderVerify(
        PaymentVerifyModel(
          razorpay_payment_id: razorpay_payment_id,
          razorpay_order_id: razorpay_order_id,
          razorpay_signature: razorpay_signature,
        ),
      );

      return response.success == true && response.payment?.status == "paid";
    } catch (e) {
      debugPrint("Payment Verify Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verification failed: $e"), backgroundColor: Colors.red));
      }
      return false;
    }
  }
}*/

import 'package:educationapp/coreFolder/Controller/getSkillProvider.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../coreFolder/Controller/buyCoinProvider.dart';
import '../coreFolder/Controller/getCoinProvider.dart';
import '../coreFolder/Controller/transactionGetProvider.dart';
import '../coreFolder/Controller/userProfileController.dart';
import '../coreFolder/Model/PaymentCreateModel.dart';
import '../coreFolder/Model/PaymentVerifyModel.dart';
import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _searchController =
      TextEditingController(); // New
  int? _userId;
  late Razorpay _razorpay;
  bool _isLoading = false;
  int? selectCoins;
  bool _isSearching = false; // New
  String _searchQuery = ''; // New
  String? selectedBudget;
  double selectedPrice = 0; // actual price
  double selectedDiscount = 0; // discount %
  double finalAmount = 0; // price - discount

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _searchController.dispose(); // Added
    _razorpay.clear();
    super.dispose();
  }

  // ₹0.1 per coin
  double _getAmountInRupees(int coins) {
    // return (coins * 0.1);
    return (coins.toDouble());
  }

  void _openRazorpayCheckout(int coins) async {
    double amountInRupees = _getAmountInRupees(coins);

    setState(() => _isLoading = true);

    try {
      final String? orderId = await paymentCreateApi(
        amountInRupees.toStringAsFixed(2),
        "INR",
        "$coins Coins Pack",
        context,
      );

      if (orderId == null || orderId.isEmpty) {
        throw Exception("Failed to create order on server");
      }

      var options = {
        'key': 'rzp_test_RuYzRso83l5DsK',
        'amount': (amountInRupees * 100).toInt(),
        'name': 'Education App',
        'description': '$coins Coins Pack',
        'order_id': orderId,
        'timeout': 300,
        'theme': {'color': '#008080'},
        'prefill': {},
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Checkout Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment initiation failed: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() => _isLoading = true);

    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final verifyResponse = await service.razorpayOrderVerify(
        PaymentVerifyModel(
          razorpay_payment_id: response.paymentId!,
          razorpay_order_id: response.orderId!,
          razorpay_signature: response.signature!,
        ),
      );

      if (verifyResponse.success != true ||
          verifyResponse.payment?.status != "paid") {
        throw Exception(
            verifyResponse.message ?? "Payment verification failed");
      }

      final int backendPaymentId = verifyResponse.payment!.id!;

      final payload = {
        'coins': selectCoins.toString(),
        'payment_id': backendPaymentId.toString(),
      };

      _handleBuyCoins(payload);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Payment Successful! ${selectCoins ?? ''} Coins added.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Payment Verification Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment failed. Please contact support.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Payment Failed: ${response.message ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('External Wallet: ${response.walletName}')),
      );
    }
  }

  void _handleBuyCoins(Map<String, dynamic> payload) {
    setState(() => _isLoading = true);

    ref.read(buyCoinProvider(payload).future).then((_) {
      ref.invalidate(userProfileController);
      ref.invalidate(getCoinProvider);
      if (_userId != null) {
        ref.invalidate(transactionProvider(_userId!));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coins added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding coins: $error')),
        );
      }
    }).whenComplete(() {
      setState(() => _isLoading = false);
    });
  }

  String finalammount = "";
  int desi = 0;

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    final userIdRaw = box.get('userid');
    final themeMode = ref.watch(themeProvider);
    final userId =
        userIdRaw != null ? int.tryParse(userIdRaw.toString()) : null;

    if (userId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
      return const Scaffold(
        body: Center(child: Text('User ID not found. Please log in again.')),
      );
    }
    _userId = userId;

    final userProfileProvider = ref.watch(userProfileController);

    final String balanceText = userProfileProvider.when<String>(
      data: (profileRes) => profileRes.data?.coins ?? "0",
      loading: () => "0",
      error: (_, __) => "0",
    );

    final transactionState = ref.watch(transactionProvider(userId));

    final budgetProvider = ref.watch(budgetController);

    return Scaffold(
      backgroundColor: themeMode == ThemeMode.dark
          ? const Color(0xFF1B1B1B)
          : const Color(0xFF008080),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(39, 255, 255, 255),
                      borderRadius: BorderRadius.circular(500.r),
                    ),
                    child: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 15),
                  ),
                ),
                const Spacer(),
                Text(
                  "Wallet",
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: themeMode == ThemeMode.dark
                        ? const Color(0xff008080)
                        : Colors.white,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSearching = true;
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                  child: Container(
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(39, 255, 255, 255),
                      borderRadius: BorderRadius.circular(500.r),
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Balance",
                        style: GoogleFonts.roboto(
                            fontSize: 14.sp, color: Colors.white)),
                    SizedBox(height: 5.h),
                    Text(
                      "$balanceText Coins",
                      style: GoogleFonts.roboto(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
///////////////////////////////////////////////////////////

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setModalState) {
                            final int coinsToUse = selectCoins ?? 0;
                            final double amountToPay =
                                _getAmountInRupees(coinsToUse);

                            return budgetProvider.when(
                              data: (snp) {
                                String price = snp.data!.first.price.toString();

                                String disc =
                                    snp.data!.first.discount.toString();

                                return Container(
                                  decoration: BoxDecoration(
                                    color: themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        topRight: Radius.circular(40)),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  padding: EdgeInsets.all(15.w),
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 5.h,
                                          width: 50.w,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      SizedBox(height: 15.h),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Add Coins",
                                          style: GoogleFonts.roboto(
                                            color: themeMode == ThemeMode.dark
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        padding: EdgeInsets.zero,
                                        hint: Center(
                                          child: Text(
                                            "--- Select ---",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        value: selectedBudget,
                                        dropdownColor:
                                            themeMode == ThemeMode.dark
                                                ? Colors.black
                                                : Colors.white,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                            borderSide: BorderSide(
                                              color: themeMode == ThemeMode.dark
                                                  ? const Color(0xFF4D4D4D)
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        items: snp.data!
                                            .where((e) =>
                                                e.price != null) // safety
                                            .map(
                                              (item) =>
                                                  DropdownMenuItem<String>(
                                                value: item.price,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "₹ ${(double.tryParse(item.price ?? '0') ?? 0).toInt()}",
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 14.w,
                                                        color: themeMode ==
                                                                ThemeMode.dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                    if (item.discount != null)
                                                      Text(
                                                        "${(double.tryParse(item.discount ?? '0') ?? 0).toInt()}%",
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontSize: 14.w,
                                                          color: themeMode ==
                                                                  ThemeMode.dark
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),

                                        /// 🔹 SELECTED ITEM UI (closed state)
                                        selectedItemBuilder: (context) {
                                          return snp.data!
                                              .where((e) => e.price != null)
                                              .map((item) {
                                            return Row(
                                              children: [
                                                /// LEFT - Amount
                                                Text(
                                                  "₹ ${(double.tryParse(item.price ?? '0') ?? 0).toInt()}",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 16.w,
                                                    color: themeMode ==
                                                            ThemeMode.dark
                                                        ? const Color(
                                                            0xFF4D4D4D)
                                                        : Colors.white,
                                                  ),
                                                ),
                                                Spacer(),

                                                /// RIGHT - Discount
                                                if (item.discount != null)
                                                  Text(
                                                    "${(double.tryParse(item.discount ?? '0') ?? 0).toInt()}%",
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 16.w,
                                                      color: themeMode ==
                                                              ThemeMode.dark
                                                          ? const Color(
                                                              0xFF4D4D4D)
                                                          : Colors.white,
                                                    ),
                                                  ),
                                              ],
                                            );
                                          }).toList();
                                        },
                                        onChanged: (String? value) {
                                          setModalState(() {
                                            selectedBudget = value;

                                            final selectedItem = snp.data!
                                                .firstWhere(
                                                    (e) => e.price == value);

                                            selectedPrice = double.tryParse(
                                                    selectedItem.price ??
                                                        '0') ??
                                                0;

                                            selectedDiscount = double.tryParse(
                                                    selectedItem.discount ??
                                                        '0') ??
                                                0;

                                            // 🔥 FINAL CALCULATION
                                            finalAmount = selectedPrice -
                                                (selectedPrice *
                                                    selectedDiscount /
                                                    100);

                                            // Coins ke liye (agar coins == price)
                                            selectCoins = selectedPrice.toInt();
                                          });
                                        },
                                        validator: (value) => value == null
                                            ? 'Budget is required'
                                            : null,
                                      ),

                                      // SizedBox(height: 10.h),
                                      // TextFormField(
                                      //   controller: _amountController,
                                      //   keyboardType: TextInputType.number,
                                      //   style: TextStyle(
                                      //       color: themeMode == ThemeMode.dark
                                      //           ? Colors.black
                                      //           : Colors.white),
                                      //   onChanged: (value) {
                                      //     final parsed =
                                      //         int.tryParse(value) ?? 0;
                                      //     setState(() => selectCoins = parsed);
                                      //     setModalState(() {});
                                      //   },
                                      //   decoration: InputDecoration(
                                      //     labelText: "Enter amount of coins",
                                      //     border: OutlineInputBorder(
                                      //         borderRadius:
                                      //             BorderRadius.circular(10.r)),
                                      //     enabledBorder: OutlineInputBorder(
                                      //         borderRadius:
                                      //             BorderRadius.circular(10.r),
                                      //         borderSide: const BorderSide(
                                      //             color: Colors.grey)),
                                      //     focusedBorder: OutlineInputBorder(
                                      //         borderRadius:
                                      //             BorderRadius.circular(10.r),
                                      //         borderSide: const BorderSide(
                                      //             color: Colors.grey)),
                                      //   ),
                                      // ),
                                      // SizedBox(height: 20.h),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceEvenly,
                                      //   children:
                                      //       [50, 100, 150, 200].map((amount) {
                                      //     final bool isSelected =
                                      //         selectCoins == amount;
                                      //     return GestureDetector(
                                      //       onTap: () {
                                      //         setState(() {
                                      //           selectCoins = amount;
                                      //           _amountController.text =
                                      //               amount.toString();
                                      //         });
                                      //         setModalState(() {});
                                      //       },
                                      //       child: AnimatedContainer(
                                      //         duration: const Duration(
                                      //             milliseconds: 250),
                                      //         height: 60.h,
                                      //         width: 80.w,
                                      //         decoration: BoxDecoration(
                                      //           color: isSelected
                                      //               ? const Color(0xFF008080)
                                      //               : Colors.grey.shade200,
                                      //           borderRadius:
                                      //               BorderRadius.circular(20.r),
                                      //           boxShadow: isSelected
                                      //               ? [
                                      //                   BoxShadow(
                                      //                       color: const Color(
                                      //                               0xFF008080)
                                      //                           .withOpacity(
                                      //                               0.6),
                                      //                       blurRadius: 12,
                                      //                       spreadRadius: 3)
                                      //                 ]
                                      //               : null,
                                      //         ),
                                      //         child: Center(
                                      //           child: Text(
                                      //             "$amount",
                                      //             style: GoogleFonts.inter(
                                      //               fontSize: 18.sp,
                                      //               fontWeight: FontWeight.w700,
                                      //               color: isSelected
                                      //                   ? Colors.white
                                      //                   : Colors.black,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     );
                                      //   }).toList(),
                                      // ),

                                      SizedBox(height: 30.h),
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.h, horizontal: 20.w),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF008080)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          border: Border.all(
                                              color: const Color(0xFF008080),
                                              width: 1.5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "You will pay",
                                              style: GoogleFonts.roboto(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Colors.black87
                                                        : Colors.white,
                                              ),
                                            ),
                                            Text(
                                              //  "₹${amountToPay.toStringAsFixed(2)}",
                                              "₹${finalAmount.toStringAsFixed(2)}",
                                              style: GoogleFonts.roboto(
                                                fontSize: 24.sp,
                                                fontWeight: FontWeight.w800,
                                                color: const Color(0xFF008080),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 40.h),
                                      GestureDetector(
                                        // onTap: _isLoading || coinsToUse <= 0
                                        //     ? null
                                        //     : () {
                                        //         if (coinsToUse <= 0) {
                                        //           ScaffoldMessenger.of(context)
                                        //               .showSnackBar(
                                        //             const SnackBar(
                                        //                 content: Text(
                                        //                     'Please enter a valid coin amount')),
                                        //           );
                                        //           return;
                                        //         }
                                        //         _openRazorpayCheckout(
                                        //             coinsToUse);
                                        //       },
                                        onTap: _isLoading || finalAmount <= 0
                                            ? null
                                            : () {
                                                _openRazorpayCheckout(
                                                    finalAmount.toInt());
                                              },
                                        child: Container(
                                          height: 56.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color:
                                                (_isLoading || coinsToUse <= 0)
                                                    ? Colors.grey
                                                    : const Color.fromARGB(
                                                        255, 220, 248, 129),
                                            borderRadius:
                                                BorderRadius.circular(40.r),
                                          ),
                                          child: Center(
                                            child: _isLoading
                                                ? const CircularProgressIndicator(
                                                    color: Colors.black)
                                                : Text(
                                                    // "Continue to Pay ₹${amountToPay.toStringAsFixed(2)}",
                                                    "Continue to Pay ₹${finalAmount.toStringAsFixed(2)}",
                                                    style: GoogleFonts.roboto(
                                                      color: Colors.black,
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              error: (error, stackTrace) {
                                return Center(
                                  child: Text(error.toString()),
                                );
                              },
                              loading: () => Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 44.h,
                    width: 106.w,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 220, 248, 129),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.black, size: 16.sp),
                        SizedBox(width: 3.w),
                        Text("Add Coin",
                            style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : const Color(0xFF1B1B1B),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: Padding(
                padding: EdgeInsets.all(19.w),
                child: Column(
                  children: [
                    // Search Bar or Title
                    _isSearching
                        ? Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 16.w),
                                const Icon(Icons.search, color: Colors.grey),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    autofocus: true,
                                    style: TextStyle(
                                        color: themeMode == ThemeMode.dark
                                            ? Colors.black
                                            : Colors.white),
                                    decoration: InputDecoration(
                                      hintText: "Search transactions...",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _searchQuery = value.toLowerCase();
                                      });
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isSearching = false;
                                      _searchQuery = '';
                                      _searchController.clear();
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 16.w),
                                    child: const Icon(Icons.close,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Payment Transaction",
                              style: GoogleFonts.roboto(
                                color: themeMode == ThemeMode.dark
                                    ? const Color(0xFF1B1B1B)
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                    SizedBox(height: _isSearching ? 15.h : 20.h),
                    Expanded(
                      child: transactionState.when(
                        data: (transactions) {
                          // Filter logic
                          final filteredList =
                              transactions.data!.where((trans) {
                            final query = _searchQuery;
                            if (query.isEmpty) return true;
                            return (trans.description
                                        ?.toLowerCase()
                                        .contains(query) ??
                                    false) ||
                                (trans.type?.toLowerCase().contains(query) ??
                                    false) ||
                                (trans.coins?.toLowerCase().contains(query) ??
                                    false);
                          }).toList();

                          if (filteredList.isEmpty) {
                            return Center(
                              child: Text(
                                _searchQuery.isEmpty
                                    ? "No payment transaction"
                                    : "No matching transactions found",
                                style: GoogleFonts.roboto(
                                    color: const Color(0xFF666666),
                                    fontSize: 16.sp),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final trans = filteredList[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                padding: EdgeInsets.all(15.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  color: themeMode == ThemeMode.dark
                                      ? const Color(0xffF1F2F6)
                                      : const Color(0xFF008080),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.person_sharp,
                                        size: 25.sp,
                                        color: themeMode == ThemeMode.dark
                                            ? const Color(0xffF1F2F6)
                                            : Colors.white),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trans.type ?? 'Unknown',
                                            style: GoogleFonts.inter(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600,
                                                color: themeMode ==
                                                        ThemeMode.dark
                                                    ? const Color(0xFF1B1B1B)
                                                    : Colors.white),
                                          ),
                                          Text(
                                            trans.description ?? '',
                                            style: GoogleFonts.inter(
                                                fontSize: 14.sp,
                                                color: themeMode ==
                                                        ThemeMode.dark
                                                    ? const Color(0xFF1B1B1B)
                                                    : Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      trans.coins ?? "",
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: (trans.coins?.startsWith('-') ==
                                                true)
                                            ? Colors.red
                                            : (themeMode == ThemeMode.dark
                                                ? const Color(0xFF008080)
                                                : Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, _) =>
                            Center(child: Text('Error: $error')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<String?> paymentCreateApi(String amount, String currency,
      String description, BuildContext context) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.razorpayOrder(PaymentCreateModel(
          currency: currency, description: description, amount: amount));

      if (response.data['success'] == true) {
        return response.data['payment']['order_id'].toString();
      } else {
        throw Exception(response.data['message'] ?? "Order creation failed");
      }
    } catch (e) {
      debugPrint("Payment Create Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Order failed: $e")));
      }
      return null;
    }
  }

  static Future<bool> paymentVerifyApi(
    String razorpay_payment_id,
    String razorpay_order_id,
    String razorpay_signature, {
    required BuildContext context,
  }) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.razorpayOrderVerify(
        PaymentVerifyModel(
          razorpay_payment_id: razorpay_payment_id,
          razorpay_order_id: razorpay_order_id,
          razorpay_signature: razorpay_signature,
        ),
      );

      return response.success == true && response.payment?.status == "paid";
    } catch (e) {
      debugPrint("Payment Verify Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Verification failed: $e"),
            backgroundColor: Colors.red));
      }
      return false;
    }
  }
}
