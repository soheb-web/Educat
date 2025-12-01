import 'dart:convert';
import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/blockListController.dart';
import 'package:educationapp/coreFolder/Controller/chatController.dart';
import 'package:educationapp/coreFolder/Model/blockBodyModel.dart';
import 'package:educationapp/coreFolder/Model/blockListModel.dart';
import 'package:educationapp/coreFolder/Model/chatHistoryResMdel.dart';
import 'package:educationapp/coreFolder/Model/reportResModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatingPage extends ConsumerStatefulWidget {
  final String name;
  final String id;
  final String otherUesrid;
  const ChatingPage({
    super.key,
    required this.name,
    required this.id,
    required this.otherUesrid,
  });

  @override
  ConsumerState<ChatingPage> createState() => _ChatingPageState();
}

class _ChatingPageState extends ConsumerState<ChatingPage>
    with WidgetsBindingObserver {
  late WebSocketChannel channel;
  final messController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Chat> _messages = [];
  String? _lastRawMessage; // To prevent duplicate processing
  bool _isKeyboardVisible = false;
  bool isBlocked = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final box = Hive.box("userdata");
    final userid = box.get("userid");

    channel = WebSocketChannel.connect(
      Uri.parse("wss://websocket.educatservicesindia.com/chat/ws/$userid"),
    );

    log("WebSocket Connected: User ID = $userid", name: "WEBSOCKET");

    Future.microtask(() {
      ref.invalidate(chatHistoryController(widget.otherUesrid));
    });

    // Listen to incoming messages from start
    channel.stream.listen(
      (data) {
        if (data is String) {
          _handleIncomingMessage(data);
        }
      },
      onError: (error) {
        log("WebSocket Stream Error: $error", name: "WEBSOCKET_ERROR");
      },
      onDone: () {
        log("WebSocket Closed. Reconnecting...", name: "WEBSOCKET");
        _reconnectWebSocket();
      },
    );
  }

  void _handleIncomingMessage(String raw) {
    // PREVENT DUPLICATE
    if (raw == _lastRawMessage) return;
    _lastRawMessage = raw;

    // PRINT RAW INCOMING
    log("INCOMING (RAW): $raw", name: "CHAT_RECV");

    try {
      final jsonMap = jsonDecode(raw);
      final prettyJson = JsonEncoder.withIndent('  ').convert(jsonMap);
      log("INCOMING (PARSED):\n$prettyJson", name: "CHAT_RECV");

      final senderId = int.tryParse(jsonMap["sender_id"].toString()) ?? 0;
      final message = jsonMap["message"]?.toString() ?? "";
      final timestamp =
          jsonMap["timestamp"]?.toString() ?? DateTime.now().toIso8601String();

      // Avoid duplicate message
      final exists = _messages.any((m) =>
          m.message == message &&
          m.timestamp == timestamp &&
          m.sender == senderId);

      if (!exists && message.isNotEmpty) {
        setState(() {
          _messages.add(Chat(
            sender: senderId,
            message: message,
            timestamp: timestamp,
          ));
        });
        _scrollToBottom();
      }
    } catch (e, st) {
      log("Failed to parse incoming message: $e\n$st", name: "PARSE_ERROR");
    }
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    final box = Hive.box("userdata");
    final userid = box.get("userid");

    final outgoingData = {
      "receiver_id": widget.otherUesrid,
      "message": message.trim(),
    };

    final rawJson = jsonEncode(outgoingData);
    // PRINT OUTGOING MESSAGE
    log("OUTGOING (RAW): $rawJson", name: "CHAT_SEND");
    log("OUTGOING (PRETTY):\n${JsonEncoder.withIndent('  ').convert(outgoingData)}",
        name: "CHAT_SEND");
    // Send to server
    channel.sink.add(rawJson);
    // Instantly show in UI
    setState(() {
      _messages.add(Chat(
        sender: int.parse(userid.toString()),
        message: message.trim(),
        timestamp: DateTime.now().toIso8601String(),
      ));
    });

    messController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _reconnectWebSocket() {
    final box = Hive.box("userdata");
    final userid = box.get("userid");

    try {
      channel.sink.close();
    } catch (_) {}
    channel = WebSocketChannel.connect(
      Uri.parse("wss://websocket.educatservicesindia.com/chat/ws/$userid"),
    );
    log("WebSocket Reconnected!", name: "WEBSOCKET");
    _lastRawMessage = null;
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final isVisible = bottomInset > 0;
    if (isVisible != _isKeyboardVisible) {
      _isKeyboardVisible = isVisible;
      if (isVisible) _scrollToBottom();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    channel.sink.close();
    messController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDateHeader(DateTime dateTime, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final difference = today.difference(messageDate).inDays;
    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  Future<void> showReportDialog(BuildContext context) async {
    final reportController = TextEditingController();
    bool isReport = false;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r)),
              title: Text("Report",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              content: TextField(
                controller: reportController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write your report reason...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                ElevatedButton(
                  onPressed: isReport
                      ? null
                      : () async {
                          if (reportController.text.trim().isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please enter a reason");
                            return;
                          }
                          setStateDialog(() => isReport = true);
                          try {
                            final body = ReportBodyModel(
                              reportedId: widget.otherUesrid,
                              reason: reportController.text,
                            );
                            final service = APIStateNetwork(createDio());
                            final response = await service.report(body);
                            Fluttertoast.showToast(
                                msg: response.message ??
                                    "Report submitted successfully");
                            if (response.data != null) Navigator.pop(context);
                          } catch (e, st) {
                            Fluttertoast.showToast(
                                msg: "API Error: ${e.toString()}");
                            log("Report Error: $e\n$st");
                          } finally {
                            setStateDialog(() => isReport = false);
                          }
                        },
                  child: isReport
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyData = ref.watch(chatHistoryController(widget.otherUesrid));
    final box = Hive.box("userdata");
    final userid = box.get("userid");

    // Update local messages when history loads
    historyData.whenData((snap) {
      if (snap.chat != null && snap.chat!.length > _messages.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _messages = List<Chat>.from(snap.chat!));
            _scrollToBottom();
          }
        });
      }
    });

    // Block status
    final blockListAsync = ref.watch(blockListController);
    if (blockListAsync is AsyncData<BlockListModel>) {
      isBlocked = blockListAsync.value.data!.any(
        (block) =>
            block.blockedId.toString() == widget.otherUesrid &&
            block.status == true,
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF1B1B1B),
      body: historyData.when(
        data: (snap) {
          // Compute status text based on last message from the other user
          String statusText = "online";
          final myId = int.parse(userid.toString());
          final otherMessages =
              _messages.where((m) => m.sender != myId).toList();
          if (otherMessages.isNotEmpty) {
            try {
              final sortedOther = List<Chat>.from(otherMessages)
                ..sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
              final lastOtherTime = sortedOther.last.timestamp!;
              final lastTime = DateTime.parse(lastOtherTime);
              final diff = DateTime.now().difference(lastTime);
              if (diff.inMinutes < 5) {
                statusText = "online";
              } else {
                statusText =
                    "Last seen ${DateFormat('MMM d, h:mm a').format(lastTime)}";
              }
            } catch (e) {
              statusText = "online";
            }
          }

          final sortedMessages = List<Chat>.from(_messages)
            ..sort((a, b) => a.timestamp!.compareTo(b.timestamp!));

          return Column(
            children: [
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48.w,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(25, 255, 255, 255),
                          borderRadius: BorderRadius.circular(500.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 6.w),
                          child: Icon(Icons.arrow_back_ios,
                              color: Colors.white, size: 22.w),
                        ),
                      ),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Text(widget.name,
                            style: GoogleFonts.roboto(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        Text(statusText,
                            style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFA8E6CF))),
                      ],
                    ),
                    Spacer(),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == "report") showReportDialog(context);
                        if (value == "block") {
                          setState(() => isLoading = true);
                          try {
                            final service = APIStateNetwork(createDio());
                            final body =
                                BlockbodyModel(blockedId: widget.otherUesrid);

                            if (!isBlocked) {
                              final res = await service.block(body);
                              Fluttertoast.showToast(
                                  msg: res.message ?? "User Blocked");
                            } else {
                              final res = await service.unblock(body);
                              Fluttertoast.showToast(
                                  msg: res.message ?? "User Unblocked");
                            }
                            ref.invalidate(blockListController);
                          } catch (e) {
                            Fluttertoast.showToast(msg: "Error: $e");
                          } finally {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: "report", child: Text("Report")),
                        PopupMenuItem(
                          value: "block",
                          child: isLoading
                              ? Row(children: [
                                  CircularProgressIndicator(strokeWidth: 2),
                                  SizedBox(width: 10),
                                  Text("Please wait...")
                                ])
                              : Text(isBlocked ? "Unblock" : "Block"),
                        ),
                      ],
                      child: Container(
                        height: 48.w,
                        width: 50.w,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(25, 255, 255, 255),
                            borderRadius: BorderRadius.circular(500.r)),
                        child: Icon(Icons.more_horiz,
                            color: Colors.white, size: 22.w),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r)),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await ref.refresh(
                                chatHistoryController(widget.otherUesrid)
                                    .future);
                            ref.invalidate(blockListController);
                            _reconnectWebSocket();
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.only(
                                left: 20.w, right: 20.w, top: 20.h),
                            itemCount: sortedMessages.length,
                            itemBuilder: (context, index) {
                              final msg = sortedMessages[index];
                              final date = DateTime.parse(msg.timestamp!);
                              final prevDate = index > 0
                                  ? DateTime.parse(
                                      sortedMessages[index - 1].timestamp!)
                                  : null;
                              final showHeader = prevDate == null ||
                                  DateFormat('yyyy-MM-dd').format(prevDate) !=
                                      DateFormat('yyyy-MM-dd').format(date);

                              return Column(
                                children: [
                                  if (showHeader)
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: Text(
                                          _formatDateHeader(
                                              date, DateTime.now()),
                                          style: GoogleFonts.dmSans(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey)),
                                    ),
                                  ChatBubble(
                                    message: msg.message!,
                                    isSender: msg.sender.toString() ==
                                        userid.toString(),
                                    dateTime: msg.timestamp!,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      if (isBlocked)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 14.h, horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.10),
                            border: Border(
                              top: BorderSide(
                                  color: Colors.red.withOpacity(0.3)),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.block, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "You cannot send messages to this user",
                                style: GoogleFonts.dmSans(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        MessageInput(
                          controller: messController,
                          onSend: () => _sendMessage(messController.text),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        error: (err, st) => Center(
            child: Text("Error: $err", style: TextStyle(color: Colors.red))),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const MessageInput(
      {super.key, required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding:
          EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h, top: 10.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                filled: true,
                fillColor: Color(0xFFF1F2F6),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide: BorderSide(color: Color(0xFF008080))),
                hintText: "Type a message ...",
                hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC8C8C8)),
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
                  shape: BoxShape.circle, color: Color(0xFF008080)),
              child: Icon(Icons.send_sharp, color: Colors.white, size: 28),
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
  const ChatBubble(
      {super.key,
      required this.message,
      required this.isSender,
      required this.dateTime});

  String _formatTime(String dt) {
    try {
      return DateFormat('h:mm a').format(DateTime.parse(dt).toLocal());
    } catch (_) {
      return '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatTime(dateTime);

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isSender ? Color(0xFF008080) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 16.r : 0),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(isSender ? 0 : 16.r),
          ),
          border: isSender ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message,
                style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: isSender ? Colors.white : Color(0xFF2B2B2B))),
            SizedBox(height: 4.h),
            Text(formattedTime,
                style: GoogleFonts.dmSans(
                    fontSize: 10.sp,
                    color: isSender ? Colors.white70 : Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
