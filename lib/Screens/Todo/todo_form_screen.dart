import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/Todo/item_model.dart';
import '../../Services/todo_form_service.dart';
import '../Commons/common_widgets.dart';

class TodoForm extends StatelessWidget {
  final void Function(ItemModel) onSave;
  final String initialTitle;
  final String initialDescription;

  TodoForm({
    Key? key,
    required this.onSave,
    required this.initialTitle,
    required this.initialDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TodoFormService controller = Get.put(TodoFormService());
    controller.initializeData(initialTitle, initialDescription);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  controller.isEditing.value ? 'Todo Edit' : 'Todo Create',
                  style: CommonWidget.titleText(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  controller.initialTitle.value = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  hintText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  controller.initialDescription.value = value!;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (controller.titleController.text.isNotEmpty &&
                          controller.descriptionController.text.isNotEmpty) {
                        final newItem = ItemModel(
                          title: controller.titleController.text,
                          description: controller.descriptionController.text,
                        );

                        onSave(newItem);
                        controller.clearFields();
                        Navigator.of(context).pop();
                      }
                    },
                    style: CommonWidget.primaryButtonStyle().copyWith(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child:
                        Text(controller.isEditing.value ? 'Update' : 'Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
