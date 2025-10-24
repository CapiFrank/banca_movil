// repository_manager.dart
import 'package:banca_movil/utils/model.dart';

import 'json_repository.dart';
import 'repository.dart';

class RepositoryManager {
  static final Map<String, Repository> _repositories = {};

  static Repository<T> get<T extends Model<T>>(
    String table,
  ) {
    if (!_repositories.containsKey(table)) {
      _repositories[table] = JsonRepository<T>(baseUrl: 'http://192.168.110.15:3000/$table');
    }
    return _repositories[table] as Repository<T>;
  }
}
