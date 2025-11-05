// ignore_for_file: avoid_print
import 'dart:io';
import 'utils.dart';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print("⚠️  Debes especificar el nombre del controlador.");
    exit(1);
  }
  String modelName = arguments[0];
  String snakeCaseName = camelCaseToSnakeCase(modelName);
  String projectName = getProjectName();

  String blocContent =
      '''
import 'package:$projectName/controllers/${snakeCaseName}_controller.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part '${snakeCaseName}_event.dart';
part '${snakeCaseName}_state.dart';

class ${modelName}Bloc
    extends Bloc<${modelName}Event, ${modelName}State> {
  final ${modelName}Controller controller;

  ${modelName}Bloc(this.controller) : super(${modelName}Initial()) {
    on<${modelName}Event>(_onEvent);
  }
  Future<void> _onEvent(
    ${modelName}Event event,
    Emitter<${modelName}State> emit,
  ) async {

  }
}
''';

  String eventContent =
      '''
part of '${snakeCaseName}_bloc.dart';

sealed class ${modelName}Event extends Equatable {
  const ${modelName}Event();

  @override
  List<Object?> get props => [];
}
''';

  String stateContent =
      '''

part of '${snakeCaseName}_bloc.dart';

sealed class ${modelName}State extends Equatable {
  @override
  List<Object?> get props => [];
}

class ${modelName}Initial extends ${modelName}State {}

class ${modelName}Loading extends ${modelName}State {}

class ${modelName}Error extends ${modelName}State {
  final String message;
  ${modelName}Error(this.message);

  @override
  List<Object?> get props => [message];
}
''';

  Directory('lib/bloc/$snakeCaseName').createSync(recursive: true);
  File(
    'lib/bloc/$snakeCaseName/${snakeCaseName}_bloc.dart',
  ).writeAsStringSync(blocContent);
  File(
    'lib/bloc/$snakeCaseName/${snakeCaseName}_event.dart',
  ).writeAsStringSync(eventContent);
  File(
    'lib/bloc/$snakeCaseName/${snakeCaseName}_state.dart',
  ).writeAsStringSync(stateContent);
  print("✅ Bloc generado: $snakeCaseName");
}
