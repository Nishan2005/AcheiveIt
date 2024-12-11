import 'package:acheive_it/constraints/colors.dart';
import 'package:flutter/material.dart';

class AddGoalScreen extends StatelessWidget {

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tdBGColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add Goal',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GoalTypeSelector(),
            const SizedBox(height: 20),
            _TextField(label: 'Main Title'),
            const SizedBox(height: 10),
            _TextField(label: 'Sub Title'),
            const SizedBox(height: 10),
            _TextField(label: 'Description', maxLines: 4),
            const SizedBox(height: 10),
            _DueDatePicker(),
            const SizedBox(height: 10),
            _CategoriesSelector(),
            const SizedBox(height: 20),
            _ReminderSelector(),
            const SizedBox(height: 20),
            Row(
              children: [
                _ActionButton(
                  label: 'Add Another Goal',
                  color: Colors.grey.shade300,
                  textColor: Colors.black,
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                _ActionButton(
                  label: 'Save',
                  color: Color(0xFFB39DCE), // Hex color for the Save button
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Goal Type Selector
class _GoalTypeSelector extends StatefulWidget {
  @override
  State<_GoalTypeSelector> createState() => _GoalTypeSelectorState();
}

class _GoalTypeSelectorState extends State<_GoalTypeSelector> {
  int selectedNum = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedNum = 0;
            });
          },
          child: _TabButton(
            label: "Small Goals",
            isSelected: selectedNum == 0, // Active if index matches
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedNum = 1;
            });
          },
          child: _TabButton(
            label: "Big Goals",
            isSelected: selectedNum == 1, // Active if index matches
          ),
        ),
      ],
    );
  }
}

// Tab Button for Goal Type
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _TabButton({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom TextField Widget
class _TextField extends StatelessWidget {
  final String label;
  final int maxLines;

  const _TextField({required this.label, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }
}

// Due Date Picker
class _DueDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Due Date',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.calendar_today, color: Colors.black),
          onPressed: () {
            // Handle Date Picker here
          },
        ),
      ],
    );
  }
}

// Categories Selector
class _CategoriesSelector extends StatelessWidget {
  final List<String> categories = ['Books', 'Skills', 'Work', 'Projects'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          children: categories.map((category) => _CategoryChip(label: category)).toList(),
        ),
      ],
    );
  }
}

// Custom Category Chip
class _CategoryChip extends StatelessWidget {
  final String label;

  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey.shade300,
    );
  }
}

// Reminder Selector
class _ReminderSelector extends StatelessWidget {
  final List<String> reminders = ['Every day', 'Every week', 'Every month'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set Reminder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          children: reminders.map((reminder) => _CategoryChip(label: reminder)).toList(),
        ),
      ],
    );
  }
}

// Action Button (Reusable for Save and Add Another Goal)
class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
