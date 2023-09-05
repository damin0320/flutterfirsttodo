import 'package:flutter/material.dart';
import 'task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // TextEditingController를 클래스의 필드로 정의합니다.
  TextEditingController textFieldController = TextEditingController();

  List<Task> tasks = [];

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('할 일 목록'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              tasks[index].title,
              style: TextStyle(
                decoration:
                    tasks[index].isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            leading: Checkbox(
              value: tasks[index].isDone,
              onChanged: (value) {
                toggleTask(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('할 일 추가'),
                content: TextField(
                  controller: textFieldController, // 컨트롤러를 설정합니다.
                  decoration: InputDecoration(hintText: '할 일을 입력하세요'),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      addTask(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('취소'),
                  ),
                  TextButton(
                    onPressed: () {
                      // 컨트롤러에서 입력 값을 가져옵니다.
                      var value = textFieldController.text;
                      if (value.isNotEmpty) {
                        addTask(value);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('확인'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
