import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/Todo/item_model.dart';
import '../Commons/common_widgets.dart';

class MyForm extends StatelessWidget {
  final Function(ItemModel) onSave;
  final String initialTitle;
  final String initialDescription;

  MyForm({
    Key? key,
    required this.initialTitle,
    required this.initialDescription,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyFormController controller = Get.put(MyFormController(
        initialDescription: initialDescription, initialTitle: initialTitle));

    bool isEditing = initialTitle.isNotEmpty && initialDescription.isNotEmpty;
    if (isEditing) {
      controller.title.value = initialTitle;
      controller.description.value = initialDescription;
    }
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
                  isEditing ? 'Todo Edit' : 'Todo Create',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
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

                        await onSave(newItem);
                        controller.titleController.clear();
                        controller.descriptionController.clear();
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
                    child: Text(isEditing ? 'Update' : 'Create'),
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

class MyFormController extends GetxController {
  final RxString title = RxString('');
  final RxString description = RxString('');

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late FocusNode titleFocusNode;
  late FocusNode descriptionFocusNode;

  final String initialTitle;
  final String initialDescription;

  MyFormController({
    required this.initialTitle,
    required this.initialDescription,
  });

  @override
  void onInit() {
    super.onInit();
    title.value = initialTitle;
    description.value = initialDescription;
    titleController = TextEditingController(text: initialTitle);
    descriptionController = TextEditingController(text: initialDescription);
    titleFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.onClose();
  }
}
