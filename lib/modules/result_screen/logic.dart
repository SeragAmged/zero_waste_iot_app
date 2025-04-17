import 'package:zero_waste_iot_app/shared/data/dio_helper.dart';
import 'package:zero_waste_iot_app/shared/variabels.dart';

Future<Map<String, dynamic>> getBinData(
    {required int binId, required String type}) async {
  var response = await DioHelper.putData(
      url: "/bins/$binId",
      data: {"type": type, "isFull": "No", "bin_group_id": 1});
  return response.data["bins"];
}

Future<void> updateBinData({
  required Map<String, dynamic> binData,
  required int binId,
  required int newWeight,
}) async {
  binData["current_trash_weight"] = newWeight;

  binData["isFull"] =
      binData["current_trash_weight"] == binData["trash_weight"] ? 'yes' : 'no';
  var response = await DioHelper.putData(
    url: "/bins/$binId",
    data: binData,
  );
  // print(response.data["bins"]);
}

Future<void> throwTrash({
  required int binId,
  required int newWeight,
  required String type,
}) async {
  var data = await getBinData(binId: binId, type: type);
  // print(data.toString());
  // final int singleWight = newWeight - (data['current_trash_weight']) as int;
  // final int score = calculateScore(type: type, weight: singleWight);
  await updateBinData(binData: data, binId: binId, newWeight: newWeight);
  var response = await DioHelper.postData(
    url: "throwns/",
    data: {
      "user_id": myId??1,
      "bin_id": binId,
      "score": 5,
    },
  );
  print(response.data);
}

int calculateScore({required int weight, required String type}) {
  double scorePerGram = 0;

  switch (type.toLowerCase()) {
    case 'plastic':
      scorePerGram = 50 / 300;
      break;
    case 'metal':
      scorePerGram = 50 / 100;
      break;
    case 'paper':
      scorePerGram = 50 / 500;
      break;
    case 'glass':
      scorePerGram = 50 / 1000;
      break;
    default:
      break;
  }

  return (weight * scorePerGram).round() ;
}

int? listenPrediction;
