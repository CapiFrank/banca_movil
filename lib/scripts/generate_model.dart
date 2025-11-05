import 'dart:io';
import 'utils.dart';


void main(List<String> arguments) {
  if (arguments.isEmpty) {
    exit(1);
  }

  String modelName = arguments[0].trim();
  if (modelName.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(modelName)) {
    exit(1);
  }

  String collectionName = camelCaseToSnakeCase(pluralize(modelName));
  String fileName = camelCaseToSnakeCase(modelName);
  String projectName = getProjectName();

  // Crear el contenido del modelo basado en el nombre
  String modelContent =
      '''
import 'package:$projectName/utils/model.dart';

class $modelName extends Model<$modelName> {
  String text;

  $modelName(
      {super.id,
      this.text = ""
      });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  @override
  $modelName fromJson(Map<String, dynamic> json) {
    return $modelName(
        id: json['id'],
        text: json['text']);
  }

  @override
  String get table => "$collectionName";
  
  @override
  List<String>? get embedRelations => [];
}
''';

  // Crear un archivo en el directorio lib/models (o en el lugar que prefieras)
  Directory('lib/models').createSync(recursive: true);
  File('lib/models/$fileName.dart').writeAsStringSync(modelContent);
}
