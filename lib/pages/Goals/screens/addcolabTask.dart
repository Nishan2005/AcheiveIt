import 'package:acheive_it/pages/Goals/constraints/colors.dart';
import 'package:acheive_it/pages/Goals/screens/home.dart';
import 'package:acheive_it/pages/notifications/services/notification_service.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddColabGoalScreen extends StatefulWidget {
  final String goalId;

  const AddColabGoalScreen({super.key, required this.goalId});
  @override
  State<AddColabGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddColabGoalScreen> {
  // final TextEditingController mainTitleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedCategory = '';
  String selectedGoalType = 'Small Goal';
  String selectedReminder = '';
  final DueDatePickerController _dueDateController = DueDatePickerController();

  late String goalId;

  @override
  void initState() {
    super.initState();
    goalId = widget.goalId; // Assign goalId to goal here
  }


  // Clear all fields
  void clearFields() {
    // mainTitleController.clear();
    subTitleController.clear();
    descriptionController.clear();

    setState(() {
      selectedCategory = '';
      selectedReminder = '';
      selectedGoalType = 'Small Goal'; // Reset goal type to default
    });

    _dueDateController.clear(); // Assuming there's a method to clear the due date controller
  }
  // void onGoalTypeChanged(String newGoalType) {
  //   setState(() {
  //     selectedGoalType = newGoalType;
  //     print("Goal type updated to: $selectedGoalType"); // Debug log
  //   });
  //   clearFields(); // Reset fields for the new goal type
  // }



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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _GoalTypeSelector(
              //   onGoalTypeSelected: onGoalTypeChanged
              // ),
              // Row(
              //   children: [
              //     // Expanded(
              //     //   child: GestureDetector(
              //     //     onTap: () => setState(() => selectedGoalType = 'Small Goal'),
              //     //     child: _TabButton(
              //     //       label: 'Small Goals',
              //     //       isSelected: selectedGoalType == 'Small Goal',
              //     //     ),
              //     //   ),
              //     // ),
              //     // SizedBox(width: 10),
              //     // Expanded(
              //     //   child: GestureDetector(
              //     //     onTap: () => setState(() => selectedGoalType = 'Big Goal'),
              //     //     child: _TabButton(
              //     //       label: 'Big Goals',
              //     //       isSelected: selectedGoalType == 'Big Goal',
              //     //     ),
              //     //   ),
              //     // ),
              //   ],
              // ),
              // const SizedBox(height: 20),


              _TextField(label: 'Title', controller: subTitleController),
              const SizedBox(height: 10),
              _TextField(label: 'Description', controller: descriptionController),
              const SizedBox(height: 10),
              _DueDatePicker(controller: _dueDateController, selectedGoalType: 'Small Goal'),
              // const SizedBox(height: 10),
              // _CategoriesSelector(
              //   onCategorySelected: (category) {
              //     setState(() {
              //       selectedCategory = category;
              //     });
              //   },
              // ),
              const SizedBox(height: 20),
              _ReminderSelector(
                onReminderSelected: (reminder) {
                  setState(() {
                    selectedReminder = reminder;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                 children: [
                //   _ActionButton(
                //     label: 'Add Another Goal',
                //     color: tdGrey,
                //
                //     onPressed: clearFields,
                //   ),
                //   const SizedBox(width: 10),
                  _ActionButton(
                    label: 'Save',
                    color: tdPrimary,
                    onPressed: () {
                      saveData(
                        context,
                        subTitleController,
                        descriptionController.text,
                        _dueDateController.selectedDates,
                        selectedReminder,
                        goalId

                      );
                    },
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

// Goal Type Selector
class _GoalTypeSelector extends StatefulWidget {
  final Function(String) onGoalTypeSelected;

  const _GoalTypeSelector({required this.onGoalTypeSelected});

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
            widget.onGoalTypeSelected("Small Goal");
          },
          child: _TabButton(
            label: "Small Goals",
            isSelected: selectedNum == 'Small Goal',
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedNum = 1;
            });
            widget.onGoalTypeSelected("Big Goal");
          },
          child: _TabButton(
            label: "Big Goals",
            isSelected: selectedNum == 'Big Goal',
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
  final TextEditingController controller;
  final String label;
  // final int maxLines;

  const _TextField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,  // Use the passed controller
      maxLines: null,
      onChanged: (value) {
        if (label == 'Title') {
          controller.text = value;
        } else {
          controller.text = value;
        }
      },
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


class DueDatePickerController {
  List<DateTime?> selectedDates = [];

  void clear() {
    selectedDates.clear(); // Clear the selected dates
  }
}

class _DueDatePicker extends StatefulWidget {
  final DueDatePickerController controller;
  final String selectedGoalType;

  const _DueDatePicker({required this.controller, required this.selectedGoalType});

  @override
  _DueDatePickerState createState() => _DueDatePickerState();
}

class _DueDatePickerState extends State<_DueDatePicker> {
  // Method to pick a due date range
  Future<void> _pickDueDateRange() async {
    final currentDate = DateTime.now(); // Get the current date
    DateTime lastDate;

    // Set lastDate to 15 days from the current date if 'Small Goal'
    if (widget.selectedGoalType == 'Small Goal') {
      lastDate = currentDate.add(Duration(days: 15));
    } else {
      lastDate = DateTime(2026, 12, 31); // Set maximum date to December 31, 2026
    }

    // Ensure that no past months are selectable
    final firstSelectableDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

    // Debugging to ensure correct date range
    print('First Selectable Date: $firstSelectableDate');
    print('Last Selectable Date: $lastDate');

    // Create the calendar configuration, disable past dates
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      firstDate: firstSelectableDate, // Prevent past months from being selected
      lastDate: lastDate, // Allow up to December 31, 2026
    );

    // Show the date picker dialog
    final values = await showCalendarDatePicker2Dialog(
      context: context,
      config: config,
      dialogSize: const Size(325, 400),
      value: widget.controller.selectedDates,
      borderRadius: BorderRadius.circular(15),
    );

    // Validate and update the selected dates
    if (values != null && values.isNotEmpty) {
      setState(() {
        widget.controller.selectedDates = values;
        print('Selected Dates: ${widget.controller.selectedDates}');
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Due Date',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Spacer(),
        // Display the selected date range or a default message
        Text(
          widget.controller.selectedDates.isNotEmpty
              ? '${widget.controller.selectedDates.first?.day}/${widget.controller.selectedDates.first?.month}/${widget.controller.selectedDates.first?.year} - '
              '${widget.controller.selectedDates.last?.day}/${widget.controller.selectedDates.last?.month}/${widget.controller.selectedDates.last?.year}'
              : 'No date range selected',
        ),
        SizedBox(width: 8), // Spacing between text and icon
        // Clear Button to reset the selection

        // Calendar button to open the date picker
        IconButton(
          icon: Icon(Icons.calendar_today, color: Colors.black),
          onPressed: _pickDueDateRange,
        ),
      ],
    );
  }
}








class _CategoriesSelector extends StatefulWidget {
  final Function(String) onCategorySelected;  // Callback function

  const _CategoriesSelector({required this.onCategorySelected});

  @override
  _CategoriesSelectorState createState() => _CategoriesSelectorState();
}

class _CategoriesSelectorState extends State<_CategoriesSelector> {
  String selectedCategory = ''; // Track selected category
  List<Map<String, String>> categories = []; // Hold category data as ID-title pairs
  final int maxCategories = 4; // Max number of categories

  @override
  void initState() {
    super.initState();
    _fetchCategories();  // Fetch categories initially
  }

  // Function to fetch categories from Firebase
  Future<void> _fetchCategories() async {
    final snapshot = await FirebaseFirestore.instance.collection('Categories').get();
    setState(() {
      categories = snapshot.docs.map((doc) {
        return {
          'id': doc.id, // Document ID as a string
          'title': doc['title'].toString(), // Ensure the title is cast as a string
        };
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.w100),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 8.0,
                children: categories.map((category) {
                  return _CategoryChip(
                    label: category['title'] ?? '', // Use the 'title' key for the label
                    isSelected: selectedCategory == category['id'], // Compare selectedCategory with the 'id'
                    onPressed: () {
                      setState(() {
                        selectedCategory = category['id'] ?? ''; // Set the 'id' as the selected category
                      });
                      widget.onCategorySelected(selectedCategory); // Notify parent about the selection
                    },
                  );
                }).toList(),
              ),
            ),
            // Add category button, only enabled if there are less than 4 categories
            if (categories.length < maxCategories)
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _addCategoryDialog();
                },
              ),
          ],
        ),
      ],
    );
  }

  // Function to show a dialog to add a new category
  void _addCategoryDialog() {
    final TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add Category'),
          content: TextField(
            controller: categoryController,
            decoration: InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newCategory = categoryController.text.trim();
                if (newCategory.isNotEmpty) {
                  // Check the number of categories before adding
                  if (categories.length < maxCategories) {
                    // Add the new category to Firebase
                    await FirebaseFirestore.instance.collection('Categories').add({
                      'title': newCategory,
                      'progress': 0,
                    });
                    // Refresh categories
                    _fetchCategories();
                    Navigator.of(ctx).pop();
                  } else {
                    // Show error message if the limit is exceeded
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cannot add more than $maxCategories categories.')),
                    );
                  }
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            isSelected ? tdPrimary : tdGrey, // Change color when selected
          ),
          foregroundColor: MaterialStateProperty.all(tdText),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: onPressed, // Trigger the callback when clicked
        child: Text(label),
      ),
    );
  }
}






class _ReminderSelector extends StatefulWidget {
  final Function(String) onReminderSelected;

  const _ReminderSelector({super.key, required this.onReminderSelected});

  @override
  _ReminderSelectorState createState() => _ReminderSelectorState();
}

class _ReminderSelectorState extends State<_ReminderSelector> {
  String selectedReminder = ''; // Track selected reminder

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
          children: reminders.map((reminder) {
            return _ReminderChip(
              label: reminder,
              isSelected: selectedReminder == reminder, // Check if it's selected
              onPressed: () {
                // Directly update the selected reminder without async
                setState(() {
                  selectedReminder = reminder; // Update selected reminder
                });
                widget.onReminderSelected(reminder); // Notify parent about selection
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}



class _ReminderChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ReminderChip({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ButtonStyle(

          backgroundColor: MaterialStateProperty.all(
            isSelected ? tdPrimary : tdBGColor, // Change color when selected
          ),
          foregroundColor: MaterialStateProperty.all(tdText),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isSelected? tdPrimary: Color(0xFFD9D9D9), // Set border color
                width: 1, // Set border width
              ),// Adjust the radius for rounded corners
            ),
          ),
        ),
        onPressed: onPressed, // Use the callback passed from the parent
        child: Text(label),
      ),
    );
  }
}





// Action Button (Reusable for Save and Add Another Goal)
class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;

  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,

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
          style: TextStyle(color: tdText, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}


Future<void> saveData(
    BuildContext context,
    TextEditingController subTitleController,
    String description,
    List<DateTime?> dueDates,

    String selectedReminder,

    String goal
    ) async {
  try {
    // Extract subtitle value from the controller
    final subTitle = subTitleController.text.trim();
    final String normalizedSubtitle = subTitleController.text.toLowerCase();

    // Check if any required field is empty or null
    if (subTitle.isEmpty || description.isEmpty|| selectedReminder.isEmpty || dueDates.isEmpty || dueDates.any((date) => date == null)) {
      // Show a message box if any field is missing or null
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Missing Information'),
          content: const Text('Please make sure all fields are filled correctly, including start and end dates.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return; // Exit the function without adding the goal
    }

    // Check if a goal with the same subtitle already exists
    final querySnapshot = await FirebaseFirestore.instance.collection('goals').get();  // Fetch all documents

    // Check if any subtitle matches in lowercase
    final duplicateGoal = querySnapshot.docs.any((doc) {
      final storedSubtitle = doc['subtitle'] as String? ?? '';
      return storedSubtitle.toLowerCase() == normalizedSubtitle;
    });

    if (duplicateGoal) {
      // Goal with the same subtitle exists, show a message box
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Duplicate Goal'),
          content: const Text('A goal with this subtitle already exists. Please change the subtitle.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the duplicate dialog
                // Allow the user to change the subtitle
                subTitleController.clear(); // Optionally clear the subtitle
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return; // Stop further execution and do not save the goal yet
    }

    // Validate the dueDates list
    final startDate = dueDates[0];
    final endDate = dueDates[1];

    // Debug: Print converted Firebase Timestamp values
    print("Start Timestamp: ${Timestamp.fromDate(startDate!)}");
    print("End Timestamp: ${Timestamp.fromDate(endDate!)}");

    // Add the new goal to Firestore after resolving duplicate check
    await FirebaseFirestore.instance.collection('collabTask').add({
      'subtitle': subTitle,
      'description': description,
      'goalId': goal,
      'reminder': selectedReminder,
      'start_date': Timestamp.fromDate(startDate),
      'end_date': Timestamp.fromDate(endDate),
      'created_user': FirebaseAuth.instance.currentUser?.uid,
      'status': false
    });

    await scheduleNotificationsForDateRange(
        title: subTitle,
        body: description,
        startDate: startDate,
        endDate: endDate,
        reminder: selectedReminder
    );

    // Success message box
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Goal Saved Successfully'),
        content: const Text('Your goal has been saved successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushAndRemoveUntil( // Navigate to Home and remove the current screens from the stack
                context,
                MaterialPageRoute(builder: (context) => home()),
                    (Route<dynamic> route) => false, // This removes all previous routes from the stack
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    print("Data saved successfully.");
  } catch (error) {
    print("Error saving to Firestore: $error");
    // Show an error dialog if something goes wrong
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: const Text('There was an error while saving your goal. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();

            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
Future<void> scheduleNotificationsForDateRange({
  required String title,
  required String body,
  required DateTime startDate,
  required DateTime endDate,
  required String reminder
}) async {
  final now = DateTime.now();

  if(reminder == 'Every day') {
    for (var date = startDate; date.isBefore(endDate.add(Duration(days: 1)));
    date = date.add(Duration(days: 1))) {
      if (date.isAfter(now)) {
        final notificationTime = date.subtract(
            Duration(minutes: 30)); // Adjust notification timing

        final intervalInSeconds = notificationTime
            .difference(now)
            .inSeconds;

        await NotificationService.showNotification(
          title: title,
          body: body,
          payload: {
            'title': title,
            'body': body,
          },
          scheduled: true,
          interval: intervalInSeconds,
        );
        print("notifications set");
      }
    }
  }
  if(reminder == 'Every week'){
    for (var date = startDate; date.isBefore(endDate.add(Duration(days: 1))); date = date.add(Duration(days: 7))) {
      if (date.isAfter(now)) {
        final notificationTime = date.subtract(Duration(minutes: 30)); // Adjust notification timing
        final intervalInSeconds = notificationTime.difference(now).inSeconds;

        await NotificationService.showNotification(
          title: title,
          body: body,
          payload: {
            'title': title,
            'body': body,
          },
          scheduled: true,
          interval: intervalInSeconds,
        );
        print("Weekly notification set for ${date.toLocal()}");
      }
    }
  }
  if(reminder == 'Every month'){
    for (var date = startDate; date.isBefore(endDate.add(Duration(days: 1))); date = date.add(Duration(days: 30))) {
      if (date.isAfter(now)) {
        final notificationTime = date.subtract(Duration(minutes: 30)); // Adjust notification timing
        final intervalInSeconds = notificationTime.difference(now).inSeconds;

        await NotificationService.showNotification(
          title: title,
          body: body,
          payload: {
            'title': title,
            'body': body,
          },
          scheduled: true,
          interval: intervalInSeconds,
        );
        print("Monthly notification set for ${date.toLocal()}");
      }
    }
  }
}










