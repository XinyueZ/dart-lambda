import 'package:dart_hacker_news/config.dart';
import 'package:dart_hacker_news/decoder_helper.dart';
import 'package:dart_hacker_news/domain/hn_item.dart';
import 'package:dio/dio.dart';
import 'package:sprintf/sprintf.dart';
import 'package:dart_hacker_news/domain/extensions.dart';

void main() async {
  final BaseOptions options = BaseOptions(
    baseUrl: API_HOST,
    connectTimeout: 3000,
    receiveTimeout: 3000,
    responseType: ResponseType.json,
  );
  final Dio dio = Dio(options);

  /**
   * Read max element (id)
   */
  Response response = await dio.get(MAX_ITEM);
  final String maxItemId = response.toString();
  print("Max: $maxItemId");

  /**
   * Read list of hnObjects (id)
   */
  final List<HNElement> hnObjects = List();
  response = await dio.get(TOP_STORIES_ID_LIST);
  final List<dynamic> feedsMap =
      DecoderHelper.getJsonDecoder().convert(response.toString());
  feedsMap.forEach((objId) {
    hnObjects.add(HNObject(objId));
  });
  hnObjects.forEach((obj) {
    print("Element id: ${obj.toString()}");
  });

  /**
   * Build story-list
   */
  final List<HNStory> stories = await hnObjects.buildStories(dio);
  print("========> ${stories.length} stories");

  /**
   * Build comments for stories
   */
  final List<HNComment> comments = await stories.buildComments(dio);
  print("========> ${comments.length} comments");
}
