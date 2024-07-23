import 'dart:async';
import 'dart:convert';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class todoPage extends StatefulWidget {
  final String cateqoryId;
  const todoPage({
    Key? key,
    required this.cateqoryId,
  }) : super(key: key);

  @override
  _todoPageState createState() => _todoPageState();
}

class _todoPageState extends State<todoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController editTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController editDescriptionController = TextEditingController();

  String get title => titleController.text;
  String get editTitle => editTitleController.text;
  String get description => descriptionController.text;
  String get editdescription => editDescriptionController.text;

  StreamController<List<todoData>> streamController = StreamController();
  Future<void> getData() async {
    final category_id = widget.cateqoryId;
    while (true) {
      final response = await http.get(
          Uri.parse('https://ali-izadi.ir/ToDo/public/api/todo/$category_id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<todoData> categories = [];
        data.forEach((item) {
          final categories_Data = todoData.fromJson(item);
          categories.add(categories_Data);
        });
        streamController.sink.add(categories);
      }
      await Future.delayed(Duration(seconds: 2));
    }
  }

  createTodo() async {
    final categoryId = widget.cateqoryId;
    final response = await http.post(
        Uri.parse('https://ali-izadi.ir/ToDo/public/api/CreateTodo'),
        body: {
          'title': title,
          'category_id': categoryId.toString(),
          'description': description
        });
  }

  removeTodo(String id) async {
    final response = await http
        .get(Uri.parse('https://ali-izadi.ir/ToDo/public/api/todo/delete/$id'));
    if (response.statusCode == 200) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Remove Completed Successfully!',
      );
    }
  }

  editingTitle(String id) async {
    final response = await http.post(
        Uri.parse('https://ali-izadi.ir/ToDo/public/api/todo/edit/$id'),
        body: {
          'title': editTitle,
          'description': editdescription,
        });
    if (response.statusCode == 200) {}
  }

  changeStatus(String id, String status) async {
    final response = await http.post(
        Uri.parse('https://ali-izadi.ir/ToDo/public/api/todo/$id'),
        body: {
          'status': status,
        });
    if (response.statusCode == 200) {}
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Tasks',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 3,
        shadowColor: Colors.black,
        centerTitle: true,
      ),
      body: StreamBuilder<List<todoData>>(
        stream: streamController.stream,
        builder:
            (BuildContext context, AsyncSnapshot<List<todoData>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final data = snapshot.data![index];
                final status;
                if (data.status == "0") {
                  status = "To DO";
                } else if (data.status == "1") {
                  status = "Doing";
                } else {
                  status = "Done";
                }
                return InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, right: 20.0),
                            child: Center(
                              child: Text(
                                data.description,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Card(
                    child: ListTile(
                      subtitle: Text(status),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.title,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  editTitleController.text = data.title;
                                  editDescriptionController.text =
                                      data.description;
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.35,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    'Edit Your Title',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  textField(
                                                    titleController:
                                                        editTitleController,
                                                    title: 'Title',
                                                  ),
                                                  textField(
                                                    titleController:
                                                        editDescriptionController,
                                                    title: 'Decription',
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  ElevatedButton(
                                                    child: const Text(
                                                      'Edit Title',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () {
                                                      editingTitle(data.id);
                                                      Navigator.pop(context);
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.blueAccent,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.lightBlue,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    title: 'Remove ${data.title}',
                                    text: 'Are you sure?',
                                    confirmBtnText: 'Yes',
                                    cancelBtnText: 'No',
                                    showCancelBtn: true,
                                    confirmBtnColor: Colors.indigo,
                                    cancelBtnTextStyle: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onConfirmBtnTap: () {
                                      removeTodo(data.id);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.redAccent,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Choose Status',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    if (data.status == "0") ...[
                                                      statusButton(
                                                        data,
                                                        context,
                                                        'Doing',
                                                        '1',
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      statusButton(
                                                        data,
                                                        context,
                                                        'Done',
                                                        '2',
                                                      ),
                                                    ] else if (data.status ==
                                                        "1") ...[
                                                      statusButton(
                                                        data,
                                                        context,
                                                        'To DO',
                                                        '0',
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      statusButton(
                                                        data,
                                                        context,
                                                        'Done',
                                                        '2',
                                                      ),
                                                    ] else if (data.status ==
                                                        "2") ...[
                                                      statusButton(
                                                        data,
                                                        context,
                                                        'To DO',
                                                        '0',
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      statusButton(
                                                        data,
                                                        context,
                                                        'Doing',
                                                        '1',
                                                      ),
                                                    ]
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      if (data.status == "0") ...[
                                        Icon(
                                          Icons.star_outline_sharp,
                                          color: Colors.green,
                                        ),
                                      ] else if (data.status == "1") ...[
                                        Icon(
                                          Icons.star_half_outlined,
                                          color: Colors.green,
                                        ),
                                      ] else if (data.status == "2") ...[
                                        Icon(
                                          Icons.star_outlined,
                                          color: Colors.green,
                                        ),
                                      ]
                                    ],
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                titleController.clear();
                descriptionController.clear();
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Enter Your Title',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                textField(
                                  titleController: titleController,
                                  title: 'Title',
                                ),
                                textField(
                                  titleController: descriptionController,
                                  title: 'Decription',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                ElevatedButton(
                                  child: const Text(
                                    'Add Title',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    createTodo();
                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Icon(
                Icons.add_box_rounded,
                size: 60,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton statusButton(
      todoData data, BuildContext context, String statusText, String id) {
    return ElevatedButton(
      child: Text(
        statusText,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        changeStatus(data.id, id);
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

class textField extends StatelessWidget {
  final String title;
  const textField({
    super.key,
    required this.titleController,
    required this.title,
  });

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 10),
      child: TextField(
        controller: titleController,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          labelText: title,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color.fromARGB(104, 75, 68, 68))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 75, 68, 68))),
        ),
      ),
    );
  }
}

class todoData {
  late String id;
  late String title;
  late String status;
  late String description;
  late String categoryId;

  todoData({
    required this.id,
    required this.title,
    required this.status,
    required this.description,
    required this.categoryId,
  });

  factory todoData.fromJson(Map<String, dynamic> json) {
    return todoData(
      id: json['id'].toString(),
      title: json['title'].toString(),
      status: json['status'].toString(),
      description: json['description'].toString(),
      categoryId: json['category_id'].toString(),
    );
  }
}
