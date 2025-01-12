import 'package:flutter/material.dart';
import 'package:mobile/model/slot_model.dart';

class Slot extends StatefulWidget {
  final ParkingSlot slot;
  const Slot({super.key, required this.slot});

  @override
  State<Slot> createState() => _SlotState();
}

class _SlotState extends State<Slot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: widget.slot.avalibility ? Colors.green : Colors.red,
        boxShadow: [
          BoxShadow(color: Colors.black54, offset: Offset(1, 2), blurRadius: 2),
        ],
      ),
      child: Text(
        widget.slot.avalibility
            ? "Parking Slot is Avalible"
            : "Parking Slot is Allocated",
        style: TextStyle(color: Colors.blueAccent, fontSize: 14),
      ),
    );
  }
}
