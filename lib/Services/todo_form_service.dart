import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodoFormService extends GetxController {
  final titleController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();

  // Reactive state variables
  RxString initialTitle = RxString('');
  RxString initialDescription = RxString('');
  RxBool isEditing = false.obs;

  @override
  void onInit() {
    // Assign initial values to reactive state variables
    initialTitle.value = '';
    initialDescription.value = '';
    super.onInit();
  }

  void initializeData(String initialTitle, String initialDescription) {
    this.initialTitle.value = initialTitle;
    this.initialDescription.value = initialDescription;
    titleController.value.text = initialTitle;
    descriptionController.value.text = initialDescription;

    isEditing.value = initialTitle.isNotEmpty || initialDescription.isNotEmpty;
  }

  void updateTitle(String value) {
    initialTitle.value = value;
  }

  void updateDescription(String value) {
    initialDescription.value = value;
  }

  void clearFields() {
    titleController.value.clear();
    descriptionController.value.clear();
  }

  @override
  void onClose() {
    titleController.value.dispose();
    descriptionController.value.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.onClose();
  }
}
