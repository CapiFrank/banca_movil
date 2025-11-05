import 'package:banca_movil/repositories/repository.dart';
import 'package:banca_movil/repositories/repository_manager.dart';

abstract class Model<T extends Model<T>> {
  String? id;
  dynamic createdAt;
  dynamic updatedAt;
  String get table;
  List<String>? get embedRelations;

  Model({this.id, this.createdAt, this.updatedAt});

  Map<String, dynamic> toJson();
  T fromJson(Map<String, dynamic> json);

  Repository<T> get repository => RepositoryManager.get<T>(table);

  Future<T> create() async => repository.create(this as T);
  Future<void> update() async =>
      await repository.update(id as dynamic, this as T);
  Future<void> delete() async =>
      await repository.delete(id as dynamic, this as T);
  Future<T?> find() => repository.find(this as T);
  Future<List<T>> all() => repository.all(this as T);
  Future<List<T>> where(bool Function(T) test) =>
      repository.where(test, this as T);
  Future<T?> firstWhere(bool Function(T) test) =>
      repository.firstWhere(test, this as T);
  Future<bool> exists(bool Function(T) test) =>
      repository.exists(test, this as T);
  Future<List<T>> orderBy(
    Comparable Function(T) key, {
    bool descending = false,
  }) => repository.orderBy(key, this as T, descending: descending);
  Future<List<T>> limit(int count) => repository.limit(count, this as T);
  Future<int> count() => repository.count(this as T);

}
