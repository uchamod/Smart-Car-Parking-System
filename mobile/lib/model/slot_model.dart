class ParkingSlot {
  final int id;
  final bool avalibility;
  final Map<String, double> coordinates;

  ParkingSlot(
      {required this.id, required this.avalibility, required this.coordinates});

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    return ParkingSlot(
      id: json['id'],
      avalibility: json['avalibility'],
      coordinates: Map<String, double>.from(json['coordinates']),
    );
  }
}
