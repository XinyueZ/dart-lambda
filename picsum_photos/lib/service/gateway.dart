import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:picsum_photos/config.dart';
import 'package:picsum_photos/domain/photo.dart';
import 'package:picsum_photos/domain/photo_list.dart';
import 'package:sprintf/sprintf.dart';

import 'decoder_helper.dart';
import 'http_client_provider.dart';

abstract class Gateway {
  IHttpClientProvider _clientProvider;

  Gateway(this._clientProvider);

  IHttpClientProvider get httpClient => _clientProvider;

  @visibleForTesting
  Future<HttpClientResponse> getResponse(HttpClientRequest request) {
    Future<HttpClientResponse> response = request.close();
    return response;
  }

  @visibleForTesting
  Future<String> getResponseString(HttpClientRequest req) async {
    final HttpClientResponse res = await getResponse(req);
    final String ret = await res
        .transform(DecoderHelper.getUtf8Decoder())
        .join(); // understand utf-8
    return Future.value(ret);
  }
}

class Service extends Gateway {
  Service(IHttpClientProvider clientProvider) : super(clientProvider);

  Future<PhotoList> getPhotoList(int page, int limit,
      {String host = API_HOST,
      String endpoint = API_END_POINT,
      String method = "GET"}) async {
    final String endpointPageLimit = sprintf(endpoint, [page, limit]);
    final HttpClientRequest req =
        await httpClient.createRequest(host, endpointPageLimit, method);
    final String res = await getResponseString(req);

    final PhotoList returnValue = PhotoList();
    //When response is totally empty without data.
    if (res.trim().isEmpty) return Future.value(returnValue);

    final List<dynamic> feedsMap = DecoderHelper.getJsonDecoder().convert(res);
    feedsMap.forEach((p) {
      returnValue.data.add(Photo.from(p));
    });

    return Future.value(returnValue);
  }
}
