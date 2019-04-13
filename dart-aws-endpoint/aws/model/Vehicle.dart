class VehicleLocation {
  final num lat;
  final num lng;

  VehicleLocation(this.lat, this.lng);

  @override
  String toString() => "[lat: $lat, lng: $lng]";
}

class Stop {
  final num lat;
  final num lng;

  Stop(this.lat, this.lng);

  VehicleLocation get vehicleLocation => VehicleLocation(lat, lng);

  @override
  String toString() => vehicleLocation.toString();
}

class Vehicle {
  final String id;
  final num lat;
  final num lng;
  final List<Stop> stops = List<Stop>();

  VehicleLocation get vehicleLocation => VehicleLocation(lat, lng);

  Vehicle(this.id, this.lat, this.lng);

  void addStop(Stop stop) {
    stops.add(stop);
  }

  @override
  String toString() {
    final List<String> stopsList = List<String>();
    stops.forEach((stop) {
      stopsList.add(stop.toString());
    });
    return "[id: $id, ${vehicleLocation.toString()}, stops(${stops.length}): ${stopsList.join("=>")}]";
  }
}
