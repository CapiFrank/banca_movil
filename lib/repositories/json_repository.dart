import 'dart:convert';
import 'package:banca_movil/utils/model.dart';
import 'package:http/http.dart' as http;
import 'repository.dart'; // tu clase abstracta base

/// Implementación genérica del repositorio para JSON Server
class JsonRepository<T extends Model<T>> implements Repository<T> {
  final String baseUrl;

  JsonRepository({required this.baseUrl});

  /// Obtiene todos los registros de la tabla

  String buildEmbedQuery(T model) {
    final relations = model.embedRelations;
    if (relations == null || relations.isEmpty) return '';

    // Crea un solo string como "?_embed=relation1&_embed=relation2"
    final query = relations.map((r) => '_embed=$r').join('&');
    return '?$query';
  }

  @override
  Future<List<T>> all(T model) async {
    final response = await http.get(
      Uri.parse('$baseUrl${buildEmbedQuery(model)}'),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al obtener los registros');
    }
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => model.fromJson(e)).toList();
  }

  /// Busca un registro por ID
  @override
  Future<T?> find(T model) async {
    final id = (model.toJson()['id']);
    if (id == null) return null;

    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return model.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  /// Filtra registros localmente (tras obtener todos)
  @override
  Future<List<T>> where(bool Function(T) where, T model) async {
    final items = await all(model);
    return items.where(where).toList();
  }

  /// Retorna el primer registro que cumpla la condición
  @override
  Future<T?> firstWhere(bool Function(T) where, T model) async {
    final items = await all(model);
    try {
      return items.firstWhere(where);
    } catch (_) {
      return null;
    }
  }

  /// Verifica si existe al menos un registro que cumpla la condición
  @override
  Future<bool> exists(bool Function(T) where, T model) async {
    final items = await all(model);
    return items.any(where);
  }

  /// Ordena los registros localmente
  @override
  Future<List<T>> orderBy(
    Comparable Function(T) key,
    T model, {
    bool descending = false,
  }) async {
    final items = await all(model);
    items.sort((a, b) {
      final compare = key(a).compareTo(key(b));
      return descending ? -compare : compare;
    });
    return items;
  }

  /// Limita el número de registros
  @override
  Future<List<T>> limit(int count, T model) async {
    final items = await all(model);
    return items.take(count).toList();
  }

  /// Devuelve la cantidad total de registros
  @override
  Future<int> count(T model) async {
    final items = await all(model);
    return items.length;
  }

  /// Crea un nuevo registro
  @override
  void create(T item) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al crear el registro');
    }
  }

  /// Actualiza un registro existente
  @override
  Future<void> update(String id, T newItem) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newItem.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el registro');
    }
  }

  /// Elimina un registro por ID
  @override
  Future<void> delete(String id, T model) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el registro');
    }
  }
}
