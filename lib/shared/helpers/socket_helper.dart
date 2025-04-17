import 'dart:developer';
import 'dart:io';

import 'package:zero_waste_iot_app/modules/result_screen/logic.dart';

class SocketHelper {
  static late final Socket socket;

  static late final int receivedWight;
  static Future<void> init() async {
    socket = await Socket.connect("192.168.246.83", 80);
    log('Connected to ESP32');
    void handleSocketData(List<int> data) {
      print('Received data: ${String.fromCharCodes(data)}');
      // SocketHelper.receivedWight = int.parse(String.fromCharCodes(data));
      throwTrash(
        binId: listenPrediction!,
        newWeight: (double.parse(String.fromCharCodes(data)).round()) ,
        // newWeight: 15,
        type: listenPrediction! == 1
            ? 'paper'
            : listenPrediction! == 2
                ? 'plastic'
                : listenPrediction! == 5
                    ? 'metal'
                    : '',
      );
      //  throwTrash(
      //   binId: 2,
      //   newWeight: 15,
      //   type: 'plastic'
      // );
      // Additional logic can be added here if needed
    }

    SocketHelper.socket.listen(
      handleSocketData,
      onDone: () {},
    );
  }
}
