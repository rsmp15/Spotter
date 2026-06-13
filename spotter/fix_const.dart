// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  print('Running flutter analyze...');
  final result = await Process.run('flutter.bat', ['analyze']);
  final lines = result.stdout.toString().split('\n');
  
  for (final line in lines) {
    if (line.contains('invalid_constant') || line.contains('const_with_non_constant_argument')) {
      final parts = line.split(' - ');
      if (parts.length >= 3) {
        final fileAndLine = parts[2].trim();
        final coords = fileAndLine.split(':');
        if (coords.length >= 3) {
          final file = coords[0];
          final lineNum = int.tryParse(coords[1]);
          if (lineNum != null) {
            final f = File(file);
            if (f.existsSync()) {
              final fileLines = f.readAsStringSync().split('\n');
              if (lineNum > 0 && lineNum <= fileLines.length) {
                // Remove the first occurrence of 'const ' on that line
                fileLines[lineNum - 1] = fileLines[lineNum - 1].replaceFirst('const ', '');
                f.writeAsStringSync(fileLines.join('\n'));
              }
            }
          }
        }
      }
    }
  }
  print('Done fixing constants.');
}
