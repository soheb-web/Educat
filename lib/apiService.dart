import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:educationapp/coreFolder/Model/sendNotifcationBodyModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ApiService {
  final Dio dio = Dio();

  Future<void> sendNotification({
    required String token,
    required String title,
    required String b,
  }) async {
    // await dio.post(
    //   "https://educatservicesindia.com/admin/api/send",
    //   data: {
    //     "device_token": token,
    //     "title": title,
    //     "body": body,
    //   },
    // );
    try {
      final body =
          SendNotifcationBodyModel(deviceToken: token, title: title, body: b);
      final service = APIStateNetwork(createDio());
      final respons = await service.sendNotifcation(body);
      if (respons.response.statusCode == 200 ||
          respons.response.statusCode == 200) {
        Fluttertoast.showToast(msg: "send Notification");
      }
    } catch (e, st) {
      log(e.toString());
    }
  }
}
