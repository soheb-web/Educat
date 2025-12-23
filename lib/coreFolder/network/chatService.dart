import 'package:dio/dio.dart';
import 'package:educationapp/coreFolder/Model/chatHistoryResMdel.dart';
import 'package:educationapp/coreFolder/Model/inboxListResModel.dart';
import 'package:retrofit/retrofit.dart';

part 'chatService.g.dart';

@RestApi(baseUrl: "https://websocket.educatservicesindia.com")
//@RestApi(baseUrl: "http://192.168.1.39:8000")
abstract class ChatService {
  factory ChatService(Dio dio, {String baseUrl}) = _ChatService;

  @GET("/chats/inbox/{id}")
  Future<InboxListResponse> getInboxs(@Path('id') String id);

  @GET("/chats/history/{userid1}/{userid2}")
  Future<chatHistoryResModel> chatHistory(
      @Path('userid1') String userid1, @Path('userid2') String userid2);

  @POST("/chats/mark_seen/{conversation_id}/{user_id}")
  Future<HttpResponse<dynamic>> markSeen(
    @Path('conversation_id') String conversationId,
    @Path('user_id') String userId,
  );
}
