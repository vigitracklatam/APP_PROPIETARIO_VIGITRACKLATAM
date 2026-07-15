import 'dart:convert';

class Coordinate {
  double? lat;
  double? lng;

  Coordinate({
    this.lat,
    this.lng,
  });

  factory Coordinate.fromRawJson(String str) =>
      Coordinate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Coordinate.fromJson(Map<String, dynamic> json) => Coordinate(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
