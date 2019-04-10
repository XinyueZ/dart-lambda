import 'dart:async';
import 'dart:io';

class FileOps {
  File _file;

  FileOps(String fullFileName) {
    _file = File(fullFileName);
  }

  Future<bool> _isFileOK() => _file.exists();

  Future<File> write(String content) async {
    bool ok = await _isFileOK();
    if (ok) {
      await _file.create(recursive: true);
    }
    return _file.writeAsString(content);
  }

  Future<String> read() async {
    bool ok = await _isFileOK();
    if (ok) {
      return await _file.readAsStringSync();
    }
    return await Future.value("Cannot read file for some reasons.");
  }
}

void main() async {
  var fileOps = FileOps("Test.txt");

  await fileOps.write("Some hello,world");
  var fileContent = await fileOps.read();

  print("Read file:\n");
  print("$fileContent");
}
