import 'package:flutter/material.dart';
import 'package:mobile/model/slot_model.dart';
import 'package:mobile/service/connection.dart';
import 'package:mobile/widgets/slot.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Connection _connection = Connection();

  Future<void> stablishConnection() async {
    _connection.connect();
  }

  @override
  void initState() {
    super.initState();
    stablishConnection();
  }

  //demo data
  List slotdata = [
    {
      "id": 1,
      "avalibility": true,
      "coordinates": {"x": 1, "y": 1}
    },
    {
      "id": 2,
      "avalibility": false,
      "coordinates": {"x": 1, "y": 2}
    },
    {
      "id": 3,
      "avalibility": true,
      "coordinates": {"x": 2, "y": 1}
    },
    {
      "id": 4,
      "avalibility": false,
      "coordinates": {"x": 2, "y": 2}
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Parking System",
          style: TextStyle(color: Colors.blueAccent, fontSize: 14),
        ),
        actions: [
          Icon(
            Icons.notifications,
            size: 24,
            color: Colors.blueAccent,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemCount: slotdata.length,
              itemBuilder: (context, index) {
                ParkingSlot slot = ParkingSlot.fromJson(slotdata[index]);
                return Slot(slot: slot);
              },
            )),
      ),
    );
  }
}
