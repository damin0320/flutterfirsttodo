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

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void editTask(int index) {
    var updatedTask = tasks[index]; // 선택한 할 일 항목을 가져옵니다.

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController editingController = TextEditingController()
          ..text = updatedTask.title; // 편집 화면에 현재 할 일을 설정합니다.

        return AlertDialog(
          title: Text('할 일 편집'),
          content: TextField(
            controller: editingController,
            decoration: InputDecoration(hintText: '할 일을 입력하세요'),
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
                var updatedTitle = editingController.text;
                if (updatedTitle.isNotEmpty) {
                  setState(() {
                    updatedTask.title = updatedTitle;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('처음 만드는 Flutter ToDo List'),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit), // "편집" 버튼
                  onPressed: () {
                    // 선택한 할 일 항목을 편집할 수 있는 화면을 표시합니다.
                    editTask(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // 해당 인덱스의 할 일 항목을 삭제합니다.
                    deleteTask(index);
                  },
                ),
              ],
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
