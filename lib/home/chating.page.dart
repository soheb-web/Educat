import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatingPage extends StatefulWidget {
  final String? name;
  const ChatingPage({
    super.key,
    this.name,
  });

  @override
  State<ChatingPage> createState() => _ChatingPageState();
}

class _ChatingPageState extends State<ChatingPage> {
  final messafeController = TextEditingController();
  final userIdController = TextEditingController();
  final callIdController = TextEditingController();

  // ✅ Add message list
  final List<Map<String, dynamic>> _messages = [];

  void _handleSendMessage() {
    final text = messafeController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({'text': text, 'isSender': true});
      });
      messafeController.clear();
    }
  }

  @override
  void initState() {
    super.initState();

    // ✅ Optional: preload some messages
    // _messages.addAll([
    //   {'text': "Hey there! 👋", 'isSender': false},
    //   {'text': "Sunday at 10 AM does this work for you", 'isSender': false},
    //   {'text': "Hi!", 'isSender': true},
    //   {'text': "Awesome, thanks for letting me know!", 'isSender': true},
    //   {
    //     'text': "No problem at all! I'll be there in about 15 minutes.",
    //     'isSender': false,
    //   },
    //   {'text': "I'll text you when I arrive.", 'isSender': false},
    //   {'text': "Great! 😊", 'isSender': true},
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B1B1B),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 48.w,
                    width: 50.w,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(25, 255, 255, 255),
                        borderRadius: BorderRadius.circular(500.r)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: const Color(0xFFFFFFFF),
                        size: 22.w,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    Text(
                      // "Sajiv",
                      widget.name ?? "No Name",
                      style: GoogleFonts.roboto(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Text(
                      "Online",
                      style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA8E6CF)),
                    )
                  ],
                ),
                Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "report") {
                      print("Report clicked");
                    } else if (value == "block") {
                      print("Block clicked");
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "report",
                      child: Text("Report"),
                    ),
                    PopupMenuItem(
                      value: "block",
                      child: Text("Block"),
                    ),
                  ],
                  child: Container(
                    height: 48.w,
                    width: 50.w,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(25, 255, 255, 255),
                        borderRadius: BorderRadius.circular(500.r)),
                    child: Icon(
                      Icons.more_horiz,
                      color: const Color(0xFFFFFFFF),
                      size: 22.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25.h,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r)),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                child: ListView.builder(
                  itemCount: _messages.length,
                  reverse: false,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: ChatBubble(
                        message: message['text'],
                        isSender: message['isSender'],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 70.h,
          )
        ],
      ),
      bottomSheet: MessageInput(
        controller: messafeController,
        onSend: _handleSendMessage,
      ),
    );
  }
}

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 12.h,
                    bottom: 12.h,
                  ),
                  filled: true,
                  fillColor: Color(0xFFF1F2F6),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide:
                        BorderSide(color: Color(0xFF008080), width: 1.w),
                  ),
                  hintText: "Type a message ...",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC8C8C8),
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 53.w,
              height: 53.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF008080),
              ),
              child: Center(
                child: Icon(
                  Icons.send_sharp,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 15.w,
          )
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  const ChatBubble({super.key, required this.message, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
            color: isSender ? Color(0xFF008080) : Color(0xFFFFFFFF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomLeft: Radius.circular(isSender ? 16.r : 0),
              bottomRight: Radius.circular(isSender ? 0 : 16.r),
            ),
            border: Border.all(
                color: isSender ? Colors.transparent : Colors.black)),
        child: Text(
          message,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: isSender ? Colors.white : Color(0xFF2B2B2B),
            letterSpacing: -0.55,
          ),
        ),
      ),
    );
  }
}
