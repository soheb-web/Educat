import 'package:educationapp/coreFolder/Model/inboxListResModel.dart';
import 'package:educationapp/coreFolder/network/chatService.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final inboxProvider = FutureProvider.family
    .autoDispose<InboxListResponse, String>((ref, id) async {
  final api = ChatService(createDio());
  return await api.getInboxs(id);
});

final chatHistoryController = FutureProvider.family((ref, userid) async {
  var box = Hive.box("userdata");
  final id = box.get('userid').toString();   // logged-in user
  final api = ChatService(createDio());
  return await api.chatHistory(id, userid.toString()); // receiver user
});


final markSeenController = FutureProvider.family((ref, conversationId) async {
  var box = Hive.box("userdata");
  final userId = box.get('userid').toString();

  final api = ChatService(createDio());

  // ✔ Correct order: first conversationId then userId
  return await api.markSeen(conversationId.toString(), userId);
});
