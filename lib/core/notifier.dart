import 'package:flutter/material.dart';

ValueNotifier<bool> isListViews = ValueNotifier(true);

Icon get listViews {
  return isListViews.value ? Icon(Icons.grid_view) : Icon(Icons.splitscreen);
}
