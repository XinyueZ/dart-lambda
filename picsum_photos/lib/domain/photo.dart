import 'package:picsum_photos/config.dart';
/**
    {
    "id": "0",
    "author": "Alejandro Escamilla",
    "width": 5616,
    "height": 3744,
    "url": "https://unsplash.com/photos/yC-Yzbqy7PY",
    "download_url": "https://picsum.photos/id/0/5616/3744"
    }
 **/

import 'package:sprintf/sprintf.dart';

const thumbnailSize = 200;

class Photo {
  String id;
  String author;
  int width;
  int height;
  String url;
  String downloadUrl;
  Uri _thumbnail;

  Photo(this.id, this.author, this.width, this.height, this.url,
      this.downloadUrl) {
    _thumbnail = thumbnail;
  }

  Uri get webLocation => Uri.parse(url);

  Uri get downloadLocation => Uri.parse(downloadUrl);

  Uri get thumbnail {
    if (_thumbnail != null) return _thumbnail;
    //
    //Download is "https://picsum.photos/id/121/1600/1067"
    //Thumbnail shall be  "https://picsum.photos/id/121/$thumbnailSize/$thumbnailSize"
    //
    final heightSlash = downloadUrl.lastIndexOf("/"); //find: /1067
    final removeHeightSlashToEnd = downloadUrl.substring(0, heightSlash);
    final widthSlash = removeHeightSlashToEnd.lastIndexOf("/"); //find: /1600
    final removeWidthSlashToEnd =
        removeHeightSlashToEnd.substring(0, widthSlash);
    final thumbnailUrl = "$removeWidthSlashToEnd/$thumbnailSize/$thumbnailSize";

    return Uri.parse(thumbnailUrl);
  }

  int get originWidth => width;

  int get originHeight => height;

  @override
  String toString() => sprintf(
      "id:%s, author:%s, width:%d, height:%d, url:%s, downloadUrl:%s",
      [id, author, width, height, url, downloadUrl]);

  static Photo from(Map<String, dynamic> map) => Photo(
      map["id"] ?? nullPlaceholder,
      map["author"] ?? nullPlaceholder,
      map["width"] ?? -1,
      map["height"] ?? -1,
      map["url"] ?? nullPlaceholder,
      map["download_url"] ?? nullPlaceholder);
}
