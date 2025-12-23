import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/getNotificationController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(mentorSideNotificationController);
      ref.invalidate(getNotificationController);
    });
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    var useuType = box.get("userType");
    final themeMode = ref.watch(themeProvider);
    final notificationProvider = ref.watch(getNotificationController);
    final mentorSideNotification = ref.watch(mentorSideNotificationController);
    return Scaffold(
      backgroundColor:
          themeMode == ThemeMode.dark ? Colors.white : Color(0xFF008080),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back,
                color:
                    themeMode == ThemeMode.dark ? Colors.black : Colors.white)),
        backgroundColor:
            themeMode == ThemeMode.dark ? Colors.white : Color(0xFF008080),
        title: Text(
          "Noification",
          style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: themeMode == ThemeMode.dark ? Colors.black : Colors.white),
        ),
      ),
      body: Column(
        children: [
          if (useuType == "Mentor" || useuType == "Professional")
            notificationProvider.when(
              data: (response) {
                final notifications = response.data; // List
                if (notifications!.isEmpty) {
                  return Center(
                      child: Text(
                    "No notifications",
                    style: TextStyle(
                        color: themeMode == ThemeMode.dark
                            ? Colors.black
                            : Colors.white),
                  ));
                }
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),

                          /// 👤 Avatar
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              item.fullName![0].toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                          ),

                          /// 📝 Title + Body
                          title: Text(
                            item.title ?? "N/A",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              item.body ?? "N/A",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) {
                log("${error.toString()} \n ${stackTrace.toString()}");
                return Center(child: Text(error.toString()));
              },
              loading: () => const Center(child: CircularProgressIndicator()),
            )
          else
            mentorSideNotification.when(
              data: (mentorNotification) {
                final notificationsMentor = mentorNotification.data; // List
                if (notificationsMentor!.isEmpty) {
                  return Center(
                      child: Text(
                    "No notifications",
                    style: TextStyle(
                        color: themeMode == ThemeMode.dark
                            ? Colors.black
                            : Colors.white),
                  ));
                }
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: mentorNotification.data!.length,
                    itemBuilder: (context, index) {
                      final item = mentorNotification.data![index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),

                          /// 👤 Avatar
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              item.fullName![0].toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                          ),

                          /// 📝 Title + Body
                          title: Text(
                            item.title ?? "N/A",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              item.body ?? "N/A",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
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
    );
  }
}
