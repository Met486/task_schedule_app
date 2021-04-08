import 'task_view_model/task_view_model.dart';
import 'task_view_model/task_view_model2.dart';
import 'task_view_model/task_view_model3.dart';

class Load {
  TaskViewModel t1;
  TaskViewModel2 t2;
  TaskViewModel3 t3;

  void loading() {
    t1.getTasks();
    t2.getTasks();
    t3.getTasks();
  }
}
