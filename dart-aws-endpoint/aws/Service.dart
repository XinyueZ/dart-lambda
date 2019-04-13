import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'DecoderHelper.dart';
import 'model/Vehicle.dart';

/**
    Define pool info and login user info in config.dart
    const userPoolId = "eu-west-1_xxxxx";
    const userClientId = "xxxxxxxx";
    const username = "xyz";
    const password = "some one pwd";
 */
import 'config.dart';

class Gateway {
  String _token;
  String _area;

  Gateway(this._token, this._area);

  HttpClient _createHttpClient() => HttpClient();

  Uri _createUri(String endpoint, String data) => Uri.https(endpoint, data);

  Future<HttpClientRequest> _createRequest(String endpoint, String data) =>
      _createHttpClient().postUrl(_createUri(endpoint, data));

  Future<HttpClientResponse> _getResponse(HttpClientRequest request) {
    request.headers.add("Authorization", _token);
    request.headers.add("Accept", "application/json");
    request.headers.add("Content-Type", "application/json");
    request.write('{"serviceAreaId":"$_area"}');
    Future<HttpClientResponse> response = request.close();
    return response;
  }

  /**
   * Define APIs
   */
  Future<List<Vehicle>> getCars() async {
    final req = await _createRequest(endpoint, data);
    final res = await _getResponse(req);
    final ret = await res
        .transform(DecoderHelper.getUtf8Decoder())
        .join(); // understand utf-8

    final feedsMap = DecoderHelper.getJsonDecoder().convert(ret);

    final List<Vehicle> carsList = List<Vehicle>();

    final List<dynamic> list = feedsMap["vehicles"];
    list?.forEach((vehicle) {
      final LinkedHashMap<String, dynamic> location = vehicle["location"];
      final List<dynamic> coordinates = location["coordinates"];
      num lat = 0;
      num lng = 0;
      if (coordinates != null) {
        lat = coordinates[0];
        lng = coordinates[1];
      }
      Vehicle car = Vehicle(vehicle["id"], lat, lng);

      List<dynamic> waypointsMap = vehicle["waypoints"];
      waypointsMap?.forEach((waypoint) {
        Map<String, dynamic> stopList = waypoint["stop"];
        stopList?.values?.forEach((stop) {
          List<dynamic> locationList = stop["coordinates"];
          car.addStop(Stop(locationList[0], locationList[1]));
        });
      });

      carsList?.add(car);
    });

    return Future.value(carsList);
  }
}
