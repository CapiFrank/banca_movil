// ignore_for_file: avoid_print
import 'dart:io';
import 'utils.dart';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print("⚠️  Debes especificar el nombre del controlador.");
    exit(1);
  }

  String modelName = arguments[0]; // Ej: User
  String modelVar = lowerCamelCase(modelName); // user
  String collectionName = pluralize(modelVar); // users
  String fileName = '${camelCaseToSnakeCase(modelName)}_controller.dart'; // user_controller.dart
  String projectName = getProjectName();

  String controllerContent = '''
import 'package:$projectName/utils/controller.dart';
import 'package:$projectName/models/${camelCaseToSnakeCase(modelName)}.dart';

class ${modelName}Controller extends Controller {
  final List<$modelName> _$collectionName = [];

  List<$modelName> get $collectionName => List.unmodifiable(_$collectionName);

  Future<void> index() async {
      _$collectionName.clear();
      _$collectionName.addAll(await $modelName().all());
  }

  Future<void> store({
    required String id,
  }) async {
      final $modelVar = $modelName(id: id);
      await $modelVar.create();
      _$collectionName.insert(0, $modelVar);
  }

  Future<void> update({
    required String id,
  }) async {
      final $modelVar = await $modelName(id: id).find();
      if ($modelVar == null) {
        throw Exception("⚠️ $modelName with id \$id not found");
      }
      await $modelVar.update();

      final index = _$collectionName.indexWhere((u) => u.id == id);
      if (index != -1) {
        _$collectionName[index] = $modelVar;
      }
  }

  Future<void> destroy({required String id}) async {
      final $modelVar = $modelName(id: id);
      await $modelVar.delete();
      _$collectionName.removeWhere((u) => u.id == id);
  }
}
''';

  Directory('lib/controllers').createSync(recursive: true);
  File('lib/controllers/$fileName').writeAsStringSync(controllerContent);

  print("✅ Controlador creado: lib/controllers/$fileName");
}
