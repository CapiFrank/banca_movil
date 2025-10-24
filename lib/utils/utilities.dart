import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void handleError(dynamic error) {
  final message = _mapErrorToMessage(error);
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red),
  );
}

String _mapErrorToMessage(dynamic error) {
  final parts = error.toString().split(": ");
  return parts.length > 1 ? parts[1] : error.toString();
}

String toTitleCase(String text) {
  var splitText = text.split(' ');
  var capitalizedWords = splitText.map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).toList();

  return capitalizedWords.join(' ');
}

double parseLocalizedNumber(String input) {
  final sanitized = input.replaceAll(',', '');
  return double.tryParse(sanitized) ?? 0.0;
}

String formatNumberString(String input, {int decimalRange = 2}) {
  // Elimina cualquier carácter no numérico ni punto decimal
  String sanitized = input.replaceAll(RegExp(r'[^0-9.]'), '');

  // Divide en parte entera y decimal
  List<String> parts = sanitized.split('.');
  String integerPart = parts.first;
  String decimalPart = parts.length > 1 ? parts[1] : '';

  // Limita la cantidad de decimales permitidos
  if (decimalRange > 0 && decimalPart.length > decimalRange) {
    decimalPart = decimalPart.substring(0, decimalRange);
  }

  // Formatea la parte entera con separadores de miles
  String formattedInteger = _addThousandsSeparator(integerPart);

  // Combina la parte entera y decimal
  final buffer = StringBuffer(formattedInteger);
  if (decimalPart.isNotEmpty) {
    buffer.write('.$decimalPart');
  } else if (sanitized.endsWith('.')) {
    buffer.write('.');
  }

  return buffer.toString();
}

String formatNumberWithFixedDecimals(String input, {int decimalRange = 2}) {
  // Elimina caracteres no numéricos ni el punto
  String sanitized = input.replaceAll(RegExp(r'[^0-9.]'), '');

  // Divide en parte entera y decimal
  List<String> parts = sanitized.split('.');
  String integerPart = parts.first;
  String decimalPart = parts.length > 1 ? parts[1] : '';

  // Limita y rellena los decimales
  if (decimalRange > 0) {
    if (decimalPart.length > decimalRange) {
      decimalPart = decimalPart.substring(0, decimalRange);
    } else {
      decimalPart = decimalPart.padRight(decimalRange, '0');
    }
  }

  // Agrega separadores de miles
  String formattedInteger = _addThousandsSeparator(integerPart);

  // Construye el número final (siempre muestra decimales si decimalRange > 0)
  return decimalRange > 0 ? '$formattedInteger.$decimalPart' : formattedInteger;
}

String _addThousandsSeparator(String integerPart) {
  // Si el número es muy corto, no necesita separadores
  if (integerPart.length <= 3) return integerPart;

  final buffer = StringBuffer();
  int count = 0;

  // Recorremos de derecha a izquierda (más claro y preciso)
  for (int i = integerPart.length - 1; i >= 0; i--) {
    buffer.write(integerPart[i]);
    count++;

    // Agrega coma cada 3 dígitos (excepto al final)
    if (count % 3 == 0 && i != 0) {
      buffer.write(',');
    }
  }

  // Invertimos porque se construyó al revés
  return buffer.toString().split('').reversed.join();
}

Widget loadingProgress() {
  return const Center(child: CircularProgressIndicator());
}
