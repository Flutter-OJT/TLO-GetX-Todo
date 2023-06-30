import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodoFormService extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
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
    titleController.text = initialTitle;
    descriptionController.text = initialDescription;
    isEditing.value = initialTitle.isNotEmpty || initialDescription.isNotEmpty;
  }

  void updateTitle(String value) {
    initialTitle.value = value;
  }

  void updateDescription(String value) {
    initialDescription.value = value;
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
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
