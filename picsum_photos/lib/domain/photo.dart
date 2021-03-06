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

const THUMBNAIL_SIZE = 200;

class Photo {
  final String id;
  final String author;
  final int width;
  final int height;
  final String url;
  final String downloadUrl;
  Uri _thumbnail;
  Uri _webLocation;
  Uri _downloadLocation;
  Uri _grayscale;

  Photo(this.id, this.author, this.width, this.height, this.url,
      this.downloadUrl) {
    _thumbnail = thumbnail;
    _webLocation = webLocation;
    _downloadLocation = downloadLocation;
    _grayscale = grayscale;
  }

  factory Photo.from(Map<String, dynamic> map) => Photo(
      map["id"] ?? NULL_PLACEHOLDER,
      map["author"] ?? NULL_PLACEHOLDER,
      map["width"] ?? -1,
      map["height"] ?? -1,
      map["url"] ?? NULL_URI,
      map["download_url"] ?? NULL_URI);

  Uri get webLocation {
    if (_webLocation != null) return _webLocation;
    return Uri.parse(url);
  }

  Uri get downloadLocation {
    if (_downloadLocation != null) return _downloadLocation;
    return Uri.parse(downloadUrl);
  }

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
    final thumbnailUrl =
        "$removeWidthSlashToEnd/$THUMBNAIL_SIZE/$THUMBNAIL_SIZE";

    return Uri.parse(thumbnailUrl);
  }

  Uri get grayscale {
    if (_grayscale != null) return _grayscale;
    return Uri.parse("$downloadUrl?grayscale");
  }

  Uri getBlur(int blur) {
    blur = _adjustBlur(blur);
    return Uri.parse("$downloadUrl?blur=$blur");
  }

  Uri getGrayscaleBlur(int blur) {
    blur = _adjustBlur(blur);
    return Uri.parse("$downloadUrl?grayscale&blur=$blur");
  }

  int _adjustBlur(int blur) {
    if (blur > 10)
      blur = 10;
    else if (blur < 1) blur = 1;
    return blur;
  }

  int get originWidth => width;

  int get originHeight => height;

  @override
  String toString() => sprintf(
          "id:%s, author:%s, width:%d, height:%d, url:%s, downloadUrl:%s, thumbnail:%s, grayscale:%s",
          [
            id,
            author,
            width,
            height,
            url,
            downloadUrl,
            thumbnail.toString(),
            grayscale.toString()
          ]);
}
