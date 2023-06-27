import '../../Models/Todo/item_model.dart';
import '../crud_repository.dart';

/// The item repository.
///
/// author TintLwinOo
class ItemRepository extends CRUDRepository<ItemModel> {
  String createQuery() {
    return '''
    CREATE TABLE item (
      id INTEGER PRIMARY KEY,
      title VARCHAR(100),
      description VARCHAR(100)
    )
    ''';
  }

  @override
  Future<int?> create(Map<String, Object?> data) async {
    final id = await database.insert('item', data);
    return id;
  }

  @override
  Future<int?> update(id, Map<String, Object?> data) async {
    final rowsAffected =
        await database.update('item', data, where: 'id = ?', whereArgs: [id]);
    return rowsAffected;
  }

  @override
  Future<int?> delete(id) async {
    final rowsAffected =
        await database.delete('item', where: 'id = ?', whereArgs: [id]);
    return rowsAffected;
  }

  @override
  Future<ItemModel?> getById(id) async {
    final List<Map<String, dynamic>> results = await database.query(
      'item',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return ItemModel.fromMap(results.first);
    }

    return null;
  }

  @override
  Future<List<ItemModel>?> list() async {
    final List<Map<String, dynamic>> results = await database.query('item');

    if (results.isNotEmpty) {
      return results.map((map) => ItemModel.fromMap(map)).toList();
    }

    return null;
  }
}
