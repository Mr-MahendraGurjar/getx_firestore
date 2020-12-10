import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:getx_firestore/controllers/todoController.dart';
import 'package:getx_firestore/services/database.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData.dark(),
    );
  }
}

class Home extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _initialization,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text('Error');
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return TodoList();
            }

            return Text('Data');
          },
        ),
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  TodoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 16,top: 10),
                      child: TextField(
                        decoration: new InputDecoration(
                          hintText: 'Title',
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                        ),
                        controller: titleController,
                        onSubmitted: (value) {
                          if (titleController.text != "") {
                            Database().addTodo(
                                titleController.text, descController.text);

                            titleController.clear();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16),
                      child: TextField(
                        controller: descController,
                        decoration: new InputDecoration(
                          hintText: 'Description',
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.orange)),
                        ),
                        onSubmitted: (value) {
                          if (descController.text != "") {
                            Database().addTodo(
                                descController.text, titleController.text);

                            descController.clear();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (titleController.text != "" && descController.text != "") {
                    Database()
                        .addTodo(titleController.text, descController.text);

                    titleController.clear();
                    descController.clear();
                  }
                },
              )
            ],
          ),
        ),
        GetX<TodoController>(
          init: Get.put<TodoController>(TodoController()),
          builder: (TodoController todoController) {
            if (todoController != null && todoController.todos != null) {
              return Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: todoController.todos.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
//
                            /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UpdateNote(
                                      docEdit: snapshot.data.documents[index],
                                    )));*/
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.all(10),
                            height: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    todoController.todos[index].todo,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    todoController.todos[index].description,
                                    style: TextStyle(
                                        color: Colors.orangeAccent,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                  );
            } else {
              return Text('No Data');
            }
          },
        ),
      ],
    );
  }
}
