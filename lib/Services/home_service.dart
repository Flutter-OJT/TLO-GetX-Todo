import 'package:get/get.dart';

import '../Models/Todo/item_model.dart';
import '../Repositories/Todo/item_repository.dart';

class MyHomeService extends GetxController {
  final ItemRepository _repository = ItemRepository();
  RxList<ItemModel> itemList = <ItemModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDataFromDatabase();
  }

  Future<void> fetchDataFromDatabase() async {
    isLoading.value = true;

    List<ItemModel>? items = await _repository.list();

    itemList.value = items ?? [];
    isLoading.value = false;
  }

  Future<void> createItem(ItemModel newItem) async {
    int? id = await _repository.create(newItem.toMap());
    if (id != null) {
      newItem.id = id;
      itemList.add(newItem);
    }
  }

  Future<void> updateItem(ItemModel updatedItem, int id) async {
    updatedItem.id = id;
    await _repository.update(id, updatedItem.toMap());

    int index = itemList.indexWhere((item) => item.id == id);
    if (index != -1) {
      itemList[index].id = id;
      itemList[index].title = updatedItem.title;
      itemList[index].description = updatedItem.description;
      itemList.refresh(); // Notify observers about the change
    }
  }

  Future<void> deleteItem(int? id) async {
    if (id != null) {
      await _repository.delete(id);
      itemList.removeWhere((item) => item.id == id);
    }
  }
}
