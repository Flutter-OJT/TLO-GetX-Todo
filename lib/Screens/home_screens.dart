import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxassignment/Services/home_service.dart';

import '../Models/Todo/item_model.dart';
import 'Commons/common_widgets.dart';

import 'Todo/todo_form_screen.dart';
import 'itemlist_screen.dart';

//import '../Services/todo_form_service.dart';
class MyHome extends StatelessWidget {
  final MyHomeService controller = Get.put(MyHomeService());

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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        itemCount: controller.itemList.length,
                        itemBuilder: (BuildContext context, int index) {
                          ItemModel item = controller.itemList[index];

                          return GestureDetector(
                            onTap: () {
                              //Navigator.pushNamed(context, '/itemlist_screen');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ItemList(itemlist: item)),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
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
                                          controller.titleController.value
                                              .text = item.title!;
                                          controller.descriptionController.value
                                              .text = item.description!;
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return TodoForm(
                                                onSave: (updatedItem) {
                                                  controller.updateItem(
                                                      updatedItem, item.id!);
                                                },
                                                initialTitle: controller
                                                    .titleController.value,
                                                initialDescription: controller
                                                    .descriptionController
                                                    .value,
                                                isEditing: true,
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
                                                title:
                                                    const Text('Delete Item'),
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
                            ),
                          );
                        },
                      ),
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
              return TodoForm(
                onSave: (newItem) {
                  controller.createItem(newItem);
                },
                initialDescription: controller.descriptionController.value,
                initialTitle: controller.titleController.value,
                isEditing: false,
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
