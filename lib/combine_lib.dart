import 'dart:io';

void main() {
  final buffer = StringBuffer();
  final dir = Directory('lib');

  // استثناء الملف النهائي من الدمج
  final excludedFiles = ['combine_lib.dart'];

  dir.listSync(recursive: true).whereType<File>().forEach((file) {
    if (file.path.endsWith('.dart') &&
        !excludedFiles.any((e) => file.path.endsWith(e))) {
      buffer.writeln('// File: ${file.path}');
      buffer.writeln(file.readAsStringSync());
      buffer.writeln('\n');
    }
  });

  final outputFile = File('lib/main_combined.dart');
  outputFile.writeAsStringSync(buffer.toString());

  print('✅ تم دمج الملفات في lib/main_combined.dart');
}
