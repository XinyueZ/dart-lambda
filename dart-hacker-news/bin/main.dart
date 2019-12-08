import 'package:dart_hacker_news/config.dart';
import 'package:dart_hacker_news/decoder_helper.dart';
import 'package:dart_hacker_news/domain/extensions.dart';
import 'package:dart_hacker_news/domain/hn_item.dart';
import 'package:dio/dio.dart';

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
  Response response = await dio.get(JOB_STORIES_ID_LIST);
  List<dynamic> feedsMap =
      DecoderHelper.getJsonDecoder().convert(response.toString());
  Iterable<HNElement> hnObjects = feedsMap.map<HNElement>((objId) {
    final HNObject hnObject = HNObject(objId);
    print("Job id: ${hnObject.toString()}");
    return hnObject;
  });

  /**
   * Build job-list
   */
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
  response = await dio.get(TOP_STORIES_ID_LIST);
  feedsMap = DecoderHelper.getJsonDecoder().convert(response.toString());
  hnObjects = feedsMap.map<HNElement>((objId) {
    final HNObject hnObject = HNObject(objId);
    print("Story id: ${hnObject.toString()}");
    return hnObject;
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
