class Vehicle {
  final String location;
  final DateTime timestamps;

  Vehicle(this.location, this.timestamps);

  Vehicle.fromJson(Map<String, dynamic> json)
      : location = json['location.coordinates'],
        timestamps = json['location.timestamps'];

  Map<String, dynamic> toJson() => {
        'location': location,
        'timestamps': timestamps,
      };
}
