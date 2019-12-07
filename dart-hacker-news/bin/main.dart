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
   * Read list of hnObjects (id) for jobs
   */
  List<HNElement> hnObjects = List();
  Response response = await dio.get(JOB_STORIES_ID_LIST);
  List<dynamic> feedsMap =
      DecoderHelper.getJsonDecoder().convert(response.toString());
  feedsMap.forEach((objId) {
    hnObjects.add(HNObject(objId));
  });
  hnObjects.forEach((obj) {
    print("Job object id: ${obj.toString()}");
  });
  final List<HNJob> jobs = await hnObjects.buildJobs(dio);
  print("========> ${jobs.length} jobs");

  /**
   * Read max element (id)
   */
  response = await dio.get(MAX_ITEM);
  final String maxItemId = response.toString();
  print("Max HN object: $maxItemId");

  /**
   *  Read list of hnObjects (id) for stories
   */
  hnObjects = List();
  response = await dio.get(TOP_STORIES_ID_LIST);
  feedsMap = DecoderHelper.getJsonDecoder().convert(response.toString());
  feedsMap.forEach((objId) {
    hnObjects.add(HNObject(objId));
  });
  hnObjects.forEach((obj) {
    print("Story object id: ${obj.toString()}");
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
