import 'package:flutter/material.dart';
import 'package:mobile/model/slot_model.dart';
import 'package:mobile/util/styles.dart';

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
        color: widget.slot.avalibility ? appColorgreen : appColorred,
        boxShadow: [
          BoxShadow(
              color: widget.slot.avalibility ? appColorgreen : appColorred,
              spreadRadius: 1,
              blurRadius: 4),
        ],
      ),
      child: Center(
        child: Text(
          widget.slot.avalibility
              ? "Parking Slot is Avalible"
              : "Parking Slot is Allocated",
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
