import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/helper.dart';
import 'package:todo/pages/login.dart';
import 'package:todo/pages/todo.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController editTitleController = TextEditingController();
  String get title => titleController.text;
  String get editTitle => editTitleController.text;

  StreamController<List<categoriesData>> streamController = StreamController();
  Future<void> getData() async {
    final userId = await helperPage.sendData();
    while (true) {
      final response = await http.get(
          Uri.parse('https://ali-izadi.ir/ToDo/public/api/categories/$userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<categoriesData> categories = [];
        data.forEach((item) {
          final categories_Data = categoriesData.fromJson(item);
          categories.add(categories_Data);
        });
        streamController.sink.add(categories);
      }
      await Future.delayed(Duration(seconds: 2));
    }
  }

  createCategory() async {
    final userId = await helperPage.sendData();
    final response = await http.post(
        Uri.parse('https://ali-izadi.ir/ToDo/public/api/CreateCategory'),
        body: {
          'name': title,
          'user_id': userId.toString(),
        });
  }

  removeCategory(String id) async {
    final response = await http.get(
        Uri.parse('https://ali-izadi.ir/ToDo/public/api/category/delete/$id'));
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
        Uri.parse('https://ali-izadi.ir/ToDo/public/api/category/edit/$id'),
        body: {
          'name': editTitle,
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: () async {
                await helperPage.removeToken();
                Get.offAll(loginPage());
              },
              child: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
            ),
          )
        ],
        title: Text(
          'Boards',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 3,
        shadowColor: Colors.black,
        centerTitle: true,
      ),
      body: StreamBuilder<List<categoriesData>>(
        stream: streamController.stream,
        builder: (BuildContext context,
            AsyncSnapshot<List<categoriesData>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final data = snapshot.data![index];
                return InkWell(
                  onTap: () {
                    Get.to(todoPage(cateqoryId: data.id));
                  },
                  child: Card(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.name,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  editTitleController.text = data.name;
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
                                                0.3,
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30.0),
                                                    child: TextField(
                                                      controller:
                                                          editTitleController,
                                                      textAlign: TextAlign.left,
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide: BorderSide(
                                                                color: Color
                                                                    .fromARGB(
                                                                        104,
                                                                        75,
                                                                        68,
                                                                        68))),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide: BorderSide(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    75,
                                                                    68,
                                                                    68))),
                                                      ),
                                                    ),
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
                                    title: 'Remove ${data.name}',
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
                                      removeCategory(data.id);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.redAccent,
                                ),
                              ),
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
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Enter Your Title',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: TextField(
                                    controller: titleController,
                                    textAlign: TextAlign.left,
                                    decoration: InputDecoration(
                                      labelText: 'Title',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  104, 75, 68, 68))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                  255, 75, 68, 68))),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  child: const Text(
                                    'Add Title',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    createCategory();
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
}

class categoriesData {
  late String id;
  late String name;
  late String status;
  late String userId;

  categoriesData({
    required this.id,
    required this.name,
    required this.status,
    required this.userId,
  });

  factory categoriesData.fromJson(Map<String, dynamic> json) {
    return categoriesData(
      id: json['id'].toString(),
      name: json['name'].toString(),
      status: json['status'].toString(),
      userId: json['user_id'].toString(),
    );
  }
}
