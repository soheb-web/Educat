import 'package:educationapp/coreFolder/Model/blockListModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final blockListController = FutureProvider<BlockListModel>(
  (ref) async {
    final service = APIStateNetwork(createDio());
    return await service.getBlockList();
  },
);
