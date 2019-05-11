import 'package:picsum_photos/domain/photo.dart';
import 'package:test/test.dart';
import 'package:test_core/test_core.dart';

void main() {
  group("Photo functions and properties test-suit", () {
    final Photo photo = Photo(
        "0", "author", 12, 13, "http://demo.io", "http://dummy.io/file.txt");
    test("should webLocation be url", () {
      expect(photo.webLocation, Uri.parse("http://demo.io"));
    });
    test("should downloadLocation be downloadUrl", () {
      expect(photo.downloadLocation, Uri.parse("http://dummy.io/file.txt"));
    });
    test("should originWidth be width", () {
      expect(photo.originWidth, 12);
    });
    test("should originHeight be height", () {
      expect(photo.originHeight, 13);
    });
  });
}
