import 'dart:async';
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

  Gateway(this._token);

  HttpClient _createHttpClient() => HttpClient();

  Uri _createUri(String endpoint, String data) => Uri.https(endpoint, data);

  Future<HttpClientRequest> _createRequest(String endpoint, String data) =>
      _createHttpClient().getUrl(_createUri(endpoint, data));

  Future<HttpClientResponse> _getResponse(HttpClientRequest request) {
    request.headers.add("Authorization", _token);
    request.headers.add("Content-Type", "application/json");
    Future<HttpClientResponse> response = request.close();
    return response;
  }

  /**
   * Define APIs
   */
  Future<List<Vehicle>> getVehicles() async {
    final req = await _createRequest(endpoint, data);
    final res = await _getResponse(req);
    final ret = await res
        .transform(DecoderHelper.getUtf8Decoder())
        .join(); // understand utf-8

    final itor = json.decode(ret);
    final list = itor.map((i) => Vehicle.fromJson(i)).toList();
    return Future.value(list);
  }
}
