import 'dart:convert';
import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/chatController.dart';
import 'package:educationapp/coreFolder/Model/chatHistoryResMdel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatingPage extends ConsumerStatefulWidget {
  final String name;
  final String id;
  final String otherUesrid;
  const ChatingPage(
      {super.key, required this.name, required this.id, required this.otherUesrid});

  @override
  ConsumerState<ChatingPage> createState() => _ChatingPageState();
}

class _ChatingPageState extends ConsumerState<ChatingPage>
    with WidgetsBindingObserver {
  late WebSocketChannel channel;
  final messController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Chat> _messages = [];
  String? _lastRawMessage; // ← YE CLASS LEVEL PE ADD KIYA: Infinite loop fix!

  // Track if the keyboard is visible
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    final box = Hive.box("userdata");
    final userid = box.get("userid");

    channel = WebSocketChannel.connect(
      //Uri.parse("ws://192.168.1.33:8000/chat/ws/$userid"),
      Uri.parse("ws://websocket.educatservicesindia.com/chat/ws/$userid"),
    );

    Future.microtask(() {
      ref.invalidate(chatHistoryController(widget.otherUesrid));
    });
  }

  // 2. Implementation of WidgetsBindingObserver to detect keyboard changes
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final isVisible = bottomInset > 0;

    // Trigger scroll when the keyboard becomes visible
    if (isVisible && !_isKeyboardVisible) {
      _scrollToBottom();
    }
    _isKeyboardVisible = isVisible;
  }

  void _scrollToBottom() {
    // Scroll only if the controller is attached
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void didPopNext() {
    Future.microtask(() {
      // Refreshing history data might not be necessary here, focus on reconnect
      // ref.invalidate(chatHistoryController(widget.otherUesrid));
      _reconnectWebSocket();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    channel.sink.close();
    messController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _reconnectWebSocket() {
    final box = Hive.box("userdata");
    final userid = box.get("userid");

    channel.sink.close();

    channel = WebSocketChannel.connect(
      Uri.parse("ws://websocket.educatservicesindia.com/chat/ws/$userid"),
    );

    setState(() {});
    _lastRawMessage = null; // Reset on reconnect for clean state
  }

  String _formatDateHeader(DateTime dateTime, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final difference = today.difference(messageDate).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Yesterday";
    } else {
      // Use full date for messages older than yesterday
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hsitoryData = ref.watch(chatHistoryController(widget.otherUesrid));
    log("otherUserId: ${widget.otherUesrid}");
    log("Id : ${widget.id}");
    final box = Hive.box("userdata");
    final userid = box.get("userid");

    // Handle initial load/sync from history
    hsitoryData.whenData((snap) {
      if (snap.chat != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && snap.chat!.length > _messages.length) {
            // Only update if the fetched history is longer than the current local list
            setState(() {
              _messages = List<Chat>.from(snap.chat!);
            });
            _scrollToBottom();
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: Color(0xFF1B1B1B),
      body: hsitoryData.when(
        data: (snap) {
          return Column(
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
                          widget.name ?? "No Name",
                          style: GoogleFonts.roboto(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r)),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            final newSnap = await ref.refresh(
                                chatHistoryController(widget.otherUesrid)
                                    .future);

                            if (mounted && newSnap.chat != null) {
                              setState(() {
                                _messages = List<Chat>.from(newSnap.chat!);
                              });
                            }

                            _reconnectWebSocket();
                            _scrollToBottom();
                          },
                          child: StreamBuilder(
                            stream: channel.stream,
                            builder: (context, snapshot) {
                              // YE LOCAL DECLARATION HATAYA: String? _lastRawMessage;

                              if (snapshot.hasError) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          "WebSocket Error: ${snapshot.error}"),
                                      ElevatedButton(
                                        onPressed: _reconnectWebSocket,
                                        child: Text("Reconnect"),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              if (snapshot.hasData && snapshot.data != null) {
                                final raw = snapshot.data as String;

                                // PREVENT DUPLICATE PROCESSING: Class level var use kar
                                if (raw != _lastRawMessage) {
                                  _lastRawMessage = raw;

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    try {
                                      final jsonMap = jsonDecode(raw);

                                      final senderId = int.tryParse(
                                              jsonMap["sender_id"]
                                                  .toString()) ??
                                          0;

                                      final message =
                                          jsonMap["message"]?.toString() ?? "";
                                      final timestamp =
                                          jsonMap["timestamp"]?.toString() ??
                                              DateTime.now().toIso8601String();

                                      // ADD MESSAGE ONLY IF NOT EXISTS: Full combo check
                                      final exists = _messages.any((m) =>
                                          m.message == message &&
                                          m.timestamp == timestamp &&
                                          m.sender == senderId);

                                      if (!exists) {
                                        setState(() {
                                          _messages.add(
                                            Chat(
                                              sender: senderId,
                                              message: message,
                                              timestamp: timestamp,
                                            ),
                                          );
                                        });
                                      }

                                      _scrollToBottom();
                                    } catch (e) {
                                      log("Error parsing websocket: $e");
                                    }
                                  });
                                }
                              }

                              // Sort messages before showing
                              final sorted = List<Chat>.from(_messages);
                              sorted.sort((a, b) =>
                                  a.timestamp!.compareTo(b.timestamp!));

                              return ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                itemCount: sorted.length,
                                itemBuilder: (context, index) {
                                  final e = sorted[index];
                                  final date = DateTime.parse(e.timestamp!);

                                  final prev = index > 0
                                      ? DateTime.parse(
                                          sorted[index - 1].timestamp!)
                                      : null;
                                  final showHeader = prev == null ||
                                      DateFormat('yyyy-MM-dd').format(prev) !=
                                          DateFormat('yyyy-MM-dd').format(date);

                                  return Column(
                                    children: [
                                      if (showHeader)
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.r),
                                          child: Text(
                                            _formatDateHeader(
                                                date, DateTime.now()),
                                            style: GoogleFonts.dmSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ChatBubble(
                                        message: e.message!,
                                        isSender: e.sender.toString() ==
                                            userid.toString(),
                                        dateTime: e.timestamp!,
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      MessageInput(
                        controller: messController,
                        onSend: () {
                          if (messController.text.trim().isEmpty) return;

                          final msg = messController.text.trim();

                          // Send via socket
                          channel.sink.add(jsonEncode({
                            "receiver_id": widget.otherUesrid,
                            "message": msg,
                          }));

                          // Add instantly in UI
                          setState(() {
                            _messages.add(
                              Chat(
                                sender: int.parse(userid.toString()),
                                message: msg,
                                timestamp: DateTime.now().toIso8601String(),
                              ),
                            );
                          });

                          messController.clear();
                          _scrollToBottom();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          log(stackTrace.toString());
          log(error.toString());
          return Center(
            child: Text(
              error.toString(),
              style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.amber),
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
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
              padding: EdgeInsets.only(
                  left: 10.w,
                  bottom: 10.h,
                  top: 10.h), // Added top padding for better spacing
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
                  fillColor: const Color(0xFFF1F2F6),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide:
                        const BorderSide(color: Color(0xFF008080), width: 1),
                  ),
                  hintText: "Type a message ...",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFC8C8C8),
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: onSend,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
              child: Container(
                width: 53.w,
                height: 53.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF008080),
                ),
                child: const Center(
                  child: Icon(
                    Icons.send_sharp,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final String dateTime;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.dateTime,
  });

  // Show ONLY time (e.g., 6:42 PM)
  String _formatRelativeTime(String dateTime) {
    try {
      final parsedDate = DateTime.parse(dateTime);
      // Use local time for display
      return DateFormat('h:mm a').format(parsedDate.toLocal());
    } catch (e) {
      return '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatRelativeTime(dateTime);
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isSender ? const Color(0xFF008080) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 16.r : 0.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(isSender ? 0.r : 16.r),
          ),
          border: isSender
              ? null
              : Border.all(color: Colors.grey.shade300, width: 1.w),
          boxShadow: isSender
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: isSender ? Colors.white : const Color(0xFF2B2B2B),
                letterSpacing: -0.55,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              formattedTime,
              style: GoogleFonts.dmSans(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: isSender
                    ? Colors.white.withOpacity(0.8)
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
