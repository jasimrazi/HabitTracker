class Habit {
  final String id;
  final String name;
  final bool isCompleted;
  final DateTime createdAt; // Add this field

  Habit({
    required this.id,
    required this.name,
    this.isCompleted = false,
    required this.createdAt, // Initialize in the constructor
  });

  // Convert a Habit object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(), // Store as ISO string
    };
  }

  // Create a Habit object from a Map
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
