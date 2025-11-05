import 'dart:io';

String pluralize(String word) {
  if (word.endsWith('y')) {
    return '${word.substring(0, word.length - 1)}ies';
  } else if (RegExp(r'(s|x|z|ch|sh)$').hasMatch(word)) {
    return '${word}es';
  }
  return '${word}s';
}

/// Convierte un nombre en CamelCase a snake_case
String camelCaseToSnakeCase(String input) {
  return input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
    return '${match.group(1)}_${match.group(2)?.toLowerCase()}';
  }).toLowerCase();
}

/// Convierte un nombre en PascalCase a lowerCamelCase
String lowerCamelCase(String input) {
  if (input.isEmpty) return input;
  return input[0].toLowerCase() + input.substring(1);
}

/// Obtiene automáticamente el nombre del proyecto desde pubspec.yaml
String getProjectName() {
  final file = File('pubspec.yaml'); 
  if (!file.existsSync()) {
    throw Exception("⚠️ No se encontró pubspec.yaml en el directorio actual.");
  }
  final lines = file.readAsLinesSync();
  for (final line in lines) {
    if (line.startsWith('name:')) {
      return line.split(':').last.trim();
    }
  }
  throw Exception("⚠️ No se pudo obtener el nombre del proyecto en pubspec.yaml");
}