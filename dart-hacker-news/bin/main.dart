import 'package:dart_hacker_news/config.dart';
import 'package:dart_hacker_news/decoder_helper.dart';
import 'package:dart_hacker_news/domain/hn_item.dart';
import 'package:dio/dio.dart';
import 'package:sprintf/sprintf.dart';

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
   * Read list of elements (id)
   */
  List<HNElement> elements = List();
  response = await dio.get(STORIES);
  final List<dynamic> feedsMap =
      DecoderHelper.getJsonDecoder().convert(response.toString());
  feedsMap.forEach((elementId) {
    elements.add(HNElement(elementId));
  });
  elements.forEach((element) {
    print("Element id: ${element.toString()}");
  });

  /**
   * Build story-list
   */
  List<HNStory> stories = List();
  await Future.forEach(elements, (element) async {
    final String getPath = sprintf(STORY, [element.toString()]);
    final Response response = await dio.get(getPath);
    if (response != null) {
      final Map<String, dynamic> feedsMap =
          DecoderHelper.getJsonDecoder().convert(response.toString());

      if (feedsMap != null) {
        final HNStory story = HNStory.from(feedsMap);
        stories.add(story);
        print("Story: ${story.toString()}");
      }
    }
  });
  print("========> ${stories.length} stories");
}
