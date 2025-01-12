import 'dart:convert';

import 'package:mobile/model/slot_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Connection {
  static final Connection _instance = Connection._internal();
  factory Connection() => _instance;
  Connection._internal();

  WebSocketChannel? _channel;
  List<ParkingSlot> parkingSlots = [];

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://your-server-url:3000'),
    );

    // Register as mobile client
    _channel?.sink
        .add(jsonEncode({'type': 'CLIENT_REGISTER', 'clientType': 'mobile'}));

    // Listen for messages
    _channel?.stream.listen(
      (message) {
        final data = jsonDecode(message);

        switch (data['type']) {
          case 'REGISTRATION_SUCCESS':
            _updateParkingSlots(data['slots']);
            break;

          case 'SLOT_UPDATE':
            _updateParkingSlots(data['slots']);
            break;

          case 'SLOT_ASSIGNED':
            // Handle slot assignment
            // _showSlotAssignmentNotification(data['slotId']);
            break;
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        reconnect();
      },
      onDone: () {
        print('WebSocket connection closed');
        reconnect();
      },
    );
  }

  void reconnect() {
    Future.delayed(Duration(seconds: 5), () {
      connect();
    });
  }

  void _updateParkingSlots(Map<String, dynamic> slotsData) {
    // Update local parking slots data
    parkingSlots = (slotsData['slots'] as List)
        .map((slot) => ParkingSlot.fromJson(slot))
        .toList();
    // Notify UI to rebuild
    // notifyListeners();
  }

  void dispose() {
    _channel?.sink.close();
  }
}
