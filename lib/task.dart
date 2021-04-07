class Task {
  Task(
      {
      //this.id,
      this.title,
      this.subtitle,
      //  this.priority,
      this.isDone = false,
      this.updatedAt,
      this.createdAt});

  // int id;
  String title;
  String subtitle;
  // int priority;
  bool isDone;
  DateTime updatedAt;
  final DateTime createdAt;
}
