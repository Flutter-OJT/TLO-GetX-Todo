import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/Todo/item_model.dart';
import '../Repositories/Todo/item_repository.dart';
import 'Commons/common_widgets.dart';
import 'Todo/todo_form_screen.dart';

class MyHome extends StatelessWidget {
  final MyHomeController controller = Get.put(MyHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Obx(
        () => controller.itemList.isEmpty
            ? const Center(
                child: Text(
                  'No records available!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: const Text(
                      'Hello Flutter',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.itemList.length,
                      itemBuilder: (BuildContext context, int index) {
                        ItemModel item = controller.itemList[index];

                        return Card(
                          color: Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.note_add,
                              size: 40,
                            ),
                            title: Text(item.title.toString()),
                            subtitle: Text(item.description.toString()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  child: CommonWidget.commonIconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MyForm(
                                            onSave: (updatedItem) async {
                                              await controller
                                                  .deleteItem(item.id);
                                              await controller
                                                  .createItem(updatedItem);
                                              // item.title = updatedItem.title;
                                              // item.description =
                                              //     updatedItem.description;

                                              //print(updatedItem.title);
                                              //print(updatedItem.description);
                                            },
                                            initialTitle: item.title ?? '',
                                            initialDescription:
                                                item.description ?? '',
                                          );
                                        },
                                      );
                                    },
                                    icon: Icons.edit,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: CommonWidget.commonIconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Delete Item'),
                                            content: const Text(
                                                'Are you sure you want to delete this item?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await controller
                                                      .deleteItem(item.id);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icons.delete,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return MyForm(
                onSave: (newItem) async {
                  await controller.createItem(newItem);
                },
                initialDescription: '',
                initialTitle: '',
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyHomeController extends GetxController {
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

  Future<void> updateItem(ItemModel updatedItem) async {
    await _repository.update(updatedItem.id, updatedItem.toMap());

    int index = itemList.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
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
