import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/habit_entity.dart';
import '../providers/habits_notifier.dart';

class CreateHabitScreen extends ConsumerStatefulWidget {
  const CreateHabitScreen({
    super.key,
    this.habitId,
  });

  final String? habitId;

  @override
  ConsumerState<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends ConsumerState<CreateHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _frequency = 'daily'; // daily, weekly
  int _targetCount = 1;
  String _selectedIcon = 'water';
  int _selectedColorIndex = 0;

  bool _isEditing = false;
  HabitEntity? _existingHabit;

  final List<Map<String, dynamic>> _icons = const [
    {'name': 'water', 'icon': Icons.water_drop_rounded},
    {'name': 'fitness', 'icon': Icons.fitness_center_rounded},
    {'name': 'book', 'icon': Icons.book_rounded},
    {'name': 'meditation', 'icon': Icons.self_improvement_rounded},
    {'name': 'sleep', 'icon': Icons.bedtime_rounded},
    {'name': 'apple', 'icon': Icons.apple_rounded},
    {'name': 'work', 'icon': Icons.work_rounded},
    {'name': 'savings', 'icon': Icons.savings_rounded},
  ];

  final List<Color> _colors = const [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.habitId != null) {
      _isEditing = true;
      final habits = ref.read(habitsProvider);
      final index = habits.indexWhere((h) => h.id == widget.habitId);
      if (index != -1) {
        _existingHabit = habits[index];
        _titleController.text = _existingHabit!.title;
        _descriptionController.text = _existingHabit!.description;
        _frequency = _existingHabit!.frequency;
        _targetCount = _existingHabit!.targetCount;
        _selectedIcon = _existingHabit!.icon;
        
        final colorValue = Color(_existingHabit!.color);
        final colorIdx = _colors.indexWhere((c) => c.toARGB32() == colorValue.toARGB32());
        if (colorIdx != -1) {
          _selectedColorIndex = colorIdx;
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    if (!_formKey.currentState!.validate()) return;

    final colorValue = _colors[_selectedColorIndex].toARGB32();

    if (_isEditing && _existingHabit != null) {
      final habit = _existingHabit!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        icon: _selectedIcon,
        color: colorValue,
        frequency: _frequency,
        targetCount: _targetCount,
        completedToday: _existingHabit!.currentCount >= _targetCount,
        updatedAt: DateTime.now(),
      );
      ref.read(habitsProvider.notifier).editHabit(habit);
    } else {
      final habit = HabitEntity(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        icon: _selectedIcon,
        color: colorValue,
        frequency: _frequency,
        targetCount: _targetCount,
        currentCount: 0,
        completedToday: false,
        currentStreak: 0,
        longestStreak: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        completionHistory: const {},
      );
      ref.read(habitsProvider.notifier).addHabit(habit);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Habit' : 'New Habit',
          style: const TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            onPressed: _saveHabit,
            tooltip: 'Save Habit',
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.lg),
            children: [
              // Habit Name Field
              TextFormField(
                controller: _titleController,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Habit name (e.g. Drink Water)',
                  hintStyle: TextStyle(color: colorScheme.outline.withValues(alpha: 0.6)),
                  border: InputBorder.none,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a habit name';
                  }
                  return null;
                },
              ),
              const Divider(),
              const SizedBox(height: AppSizes.md),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Description or notes...',
                  hintStyle: TextStyle(color: colorScheme.outline.withValues(alpha: 0.6)),
                  border: InputBorder.none,
                  icon: Icon(Icons.description_outlined, color: colorScheme.primary),
                ),
              ),
              const Divider(),
              const SizedBox(height: AppSizes.lg),

              // Frequency SegmentedButton
              Text(
                'Frequency',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.sm),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'daily', label: Text('Daily')),
                  ButtonSegment(value: 'weekly', label: Text('Weekly')),
                ],
                selected: {_frequency},
                onSelectionChanged: (val) {
                  setState(() {
                    _frequency = val.first;
                  });
                },
              ),
              const SizedBox(height: AppSizes.lg),

              // Target count slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Target Count',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$_targetCount time${_targetCount > 1 ? 's' : ''}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _targetCount.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (val) {
                  setState(() {
                    _targetCount = val.toInt();
                  });
                },
              ),
              const SizedBox(height: AppSizes.lg),

              // Color Row Selector
              Text(
                'Habit Color',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.sm),
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final isSelected = _selectedColorIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColorIndex = index;
                        });
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: colorScheme.onSurface, width: 3)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // Icon Grid Selector
              Text(
                'Habit Icon',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.sm),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: AppSizes.md,
                  crossAxisSpacing: AppSizes.md,
                ),
                itemCount: _icons.length,
                itemBuilder: (context, index) {
                  final item = _icons[index];
                  final isSelected = _selectedIcon == item['name'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIcon = item['name']!;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppSizes.md),
                        border: isSelected
                            ? Border.all(color: colorScheme.primary, width: 2)
                            : null,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.outline,
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
