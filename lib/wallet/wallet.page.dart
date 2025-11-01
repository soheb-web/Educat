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

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    final userIdRaw = box.get('userid');
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
      backgroundColor: const Color(0xFF1B1B1B),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 70.h),
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
                    color: const Color(0xff008080)),
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
                      builder: (context) {
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
                                      "Add Coins",
                                      style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                TextFormField(
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
                                          final amount =
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
                                          Navigator.pop(context);
                                          _handleBuyCoins(
                                              payload); // Use handler for error handling
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
                                fontSize: 12.sp, fontWeight: FontWeight.w500),
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
              decoration: const BoxDecoration(
                  color: Colors.white,
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
                              color: Colors.black,
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
                                  color: Color(0xffF1F2F6),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_sharp,
                                      size: 25.sp,
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
                                              color: Color(0xFF1B1B1B)),
                                        ),
                                        Text(
                                          trans.description?.toString() ?? '',
                                          style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF666666)),
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
                                            : const Color(0xFF008080),
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
