// lib/features/planner/presentation/providers/categories_notifier.dart
//
// Orynta 2.0 — Categories Notifier using Hive for persistence

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/models/category_model.dart';

class CategoriesNotifier extends StateNotifier<List<PlannerCategory>> {
  CategoriesNotifier() : super([]) {
    _loadFromHive();
  }

  Box<String> get _box => Hive.box<String>(AppStrings.settingsBoxName);

  void _loadFromHive() {
    final cached = _box.get('custom_categories');
    if (cached != null) {
      try {
        final List decoded = jsonDecode(cached);
        state = decoded.map((item) => PlannerCategory.fromJson(item)).toList();
        return;
      } catch (_) {
        // Fallback to built-in
      }
    }
    state = PlannerCategory.builtInCategories;
  }

  Future<void> _saveToHive() async {
    final list = state.map((c) => c.toJson()).toList();
    await _box.put('custom_categories', jsonEncode(list));
  }

  Future<void> addCategory(String name, IconData icon, Color color) async {
    final id = name.trim();
    if (id.isEmpty) return;
    if (state.any((c) => c.id.toLowerCase() == id.toLowerCase())) return;

    final newCat = PlannerCategory(id: id, name: name, icon: icon, color: color);
    state = [...state, newCat];
    await _saveToHive();
  }

  Future<void> updateCategory(String id, String newName, IconData icon, Color color) async {
    state = [
      for (final c in state)
        if (c.id == id)
          c.copyWith(name: newName, icon: icon, color: color)
        else
          c,
    ];
    await _saveToHive();
  }

  Future<void> deleteCategory(String id) async {
    state = state.where((c) => c.id != id).toList();
    await _saveToHive();
    
    // Reset default category if deleted
    if (defaultCategoryId == id) {
      await setDefaultCategoryId('Personal');
    }
  }

  Future<void> reorderCategories(int oldIndex, int newIndex) async {
    var index = newIndex;
    if (oldIndex < index) {
      index -= 1;
    }
    final list = List<PlannerCategory>.from(state);
    final item = list.removeAt(oldIndex);
    list.insert(index, item);
    state = list;
    await _saveToHive();
  }

  String get defaultCategoryId => _box.get('default_category_id') ?? 'Personal';

  Future<void> setDefaultCategoryId(String id) async {
    await _box.put('default_category_id', id);
    // Force rebuild by reassigning state (same list, trigger consumers to refresh default indicator)
    state = [...state];
  }
}

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, List<PlannerCategory>>((ref) {
  return CategoriesNotifier();
});
