import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

class DecoderHelper {
  static const utf8Decoder = Utf8Decoder();
  static const jsonDecoder = JsonDecoder();

  static Utf8Decoder getUtf8Decoder() => utf8Decoder;

  static JsonDecoder getJsonDecoder() => jsonDecoder;
}

class Gateway {
  HttpClient _createHttpClient() => HttpClient();

  Uri _createUri() => Uri.http("rest-service.guides.spring.io", "/greeting");

  Future<HttpClientRequest> _createRequest() =>
      _createHttpClient().getUrl(_createUri());

  Future<HttpClientResponse> _getResponse(HttpClientRequest request) {
    Future<HttpClientResponse> response = request.close();
    return response;
  }

  Future<String> run() async {
    //launch or async in coroutines
    var req = await _createRequest(); // suspend function
    var res = await _getResponse(req); // suspend function
    var ret = await res
        .transform(DecoderHelper.getUtf8Decoder())
        .join(); // understand utf-8
    return ret;
  }
}

class Feeds {
  final num id;
  final String content;

  Feeds(this.id, this.content);

  Feeds.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
      };
}

void main() {
  var gateway = Gateway();
  var result = gateway.run();
  result.then((s) {
    var feedsMap = DecoderHelper.getJsonDecoder().convert(s);
    var feeds = new Feeds.fromJson(feedsMap);
    print("Get id: ${feeds.id}");
    print("Get content: ${feeds.content}");
  }).catchError((e) {
    print("Error: $e");
  });
}
