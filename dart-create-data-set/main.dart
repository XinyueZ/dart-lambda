import 'dart:io';

void createOnePartDataSet({Directory srcDir, Directory destDir}) {
  if (srcDir == null || destDir == null) {
    print("source directory and destination directory must be filled.");
    return;
  }
  final List<FileSystemEntity> underSrcDir = srcDir.listSync();
  for (final FileSystemEntity sub in underSrcDir) {
    if (sub is! Directory) {
      print("$sub is not a directory!");
      continue;
    }
    final Directory subDir = sub as Directory;
    final List<FileSystemEntity> underSub = subDir.listSync();
    for (final FileSystemEntity underSubFile in underSub) {
      if (underSubFile is! File) {
        print("$underSubFile is not a file!");
        continue;
      }
      final File file = underSubFile as File;
      final String fileName = file.path.split('/').last;
      final String extendName = fileName.split(".").last;
      final String dest =
          "${destDir.path}/${DateTime.now().millisecondsSinceEpoch}.$extendName"
              .replaceAll("-", "_");
      print("from ${file.path} ======> $dest");
      file.copySync(dest);
    }
  }
}

Future<void> main(List<String> args) async {
  final Directory withoutMaskDir = Directory("without_mask");
  if (!withoutMaskDir.existsSync()) {
    withoutMaskDir.createSync();
  }

  final Directory withMaskDir = Directory("with_mask");
  if (!withMaskDir.existsSync()) {
    withMaskDir.createSync();
  }

  await Future.wait(<Future<void>>[
    Future<void>(() async {
      createOnePartDataSet(
        srcDir: Directory("AFDB_face_dataset"),
        destDir: withoutMaskDir,
      );
    }),
    Future<void>(() async {
      createOnePartDataSet(
        srcDir: Directory("AFDB_masked_face_dataset"),
        destDir: withMaskDir,
      );
    }),
  ]);
}
