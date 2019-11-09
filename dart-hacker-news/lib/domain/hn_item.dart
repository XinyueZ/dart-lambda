import 'package:sprintf/sprintf.dart';

import '../config.dart';
import 'hn_type.dart';

class HNElement {
  final num _id;

  HNElement(this._id);

  @override
  String toString() => "$_id";
}

class HNItem extends HNElement {
  final String by;
  final num time;
  final HNType type;
  final String text;

  HNItem(id, this.by, this.time, this.type, this.text) : super(id);
}

class HNStory extends HNItem {
  final String title;
  final Uri uri;
  final num score;
  final List kids;
  final num descendants;

  HNStory(id, by, time, type, text, this.title, this.uri, this.score, this.kids,
      this.descendants)
      : super(id, by, time, type, text);

  factory HNStory.from(Map<String, dynamic> map) => HNStory(
      map["id"],
      map["by"],
      map["time"],
      from(map["type"]),
      map["text"],
      map["title"],
      map["url"] != null ? Uri.parse(map["url"]) : Uri.parse(NULL_URI),
      map["score"],
      map["kids"] ?? List(),
      map["descendants"] ?? NULL_NUM);

  @override
  String toString() {
    final String string = sprintf("[%s]: %s", [_id, title]);
    return string;
  }
}

class HNComment extends HNItem {
  final num parentId;

  HNComment(id, by, time, type, text, this.parentId)
      : super(id, by, time, type, text);
}
