import 'package:picsum_photos/domain/photo.dart';
import 'package:test/test.dart';
import 'package:test_core/test_core.dart';

void main() {
  group("Photo functions and properties test-suit", () {
    final Photo photo = Photo("0", "author", 12, 13, "http://demo.io",
        "https://picsum.photos/id/121/1600/1067");
    test("should webLocation be url", () {
      expect(photo.webLocation, Uri.parse("http://demo.io"));
    });
    test("should downloadLocation be downloadUrl", () {
      expect(photo.downloadLocation,
          Uri.parse("https://picsum.photos/id/121/1600/1067"));
    });
    test("should originWidth be width", () {
      expect(photo.originWidth, 12);
    });
    test("should originHeight be height", () {
      expect(photo.originHeight, 13);
    });
    test("should toString() some args independent properties", () {
      expect(photo.toString(),
          "id:0, author:author, width:12, height:13, url:http://demo.io, downloadUrl:https://picsum.photos/id/121/1600/1067, thumbnail:https://picsum.photos/id/121/$THUMBNAIL_SIZE/$THUMBNAIL_SIZE, grayscale:https://picsum.photos/id/121/1600/1067?grayscale");
    });
  });
}
