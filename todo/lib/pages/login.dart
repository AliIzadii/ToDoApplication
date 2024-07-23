import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/helper.dart';
import 'package:todo/pages/signup.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String get email => emailController.text;
  String get password => passwordController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log In',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Please Fill in The Fields Below',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 35,
            ),
            Fields(
              name: 'Email',
              prefix: Text(''),
              type: TextInputType.emailAddress,
              obs: false,
              controller: emailController,
            ),
            SizedBox(
              height: 15,
            ),
            Fields(
              name: 'Password',
              prefix: Text(''),
              type: TextInputType.text,
              obs: true,
              controller: passwordController,
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonBar(
        alignment: MainAxisAlignment.center,
        buttonPadding: EdgeInsets.all(50),
        children: [
          Container(
            width: 320,
            child: ElevatedButton(
              onPressed: () {
                helperPage.logIn(email, password);
              },
              child: Text(
                'Log In',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't Have An Account?"),
              SizedBox(width: 5,),
              InkWell(
                onTap: () {
                  Get.to(signupPage());
                },
                child: Text('Sign Up', style: TextStyle(color: Colors.blueAccent),),
              )
            ],
          ),
          
        ],
      ),
    );
  }
}

class Fields extends StatelessWidget {
  final String name;
  final Widget prefix;
  final TextInputType type;
  final bool obs;
  final TextEditingController controller;
  const Fields(
      {super.key,
      required this.name,
      required this.prefix,
      required this.type,
      required this.obs,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: type,
      obscureText: obs,
      controller: controller,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        labelText: name,
        prefix: prefix,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color.fromARGB(104, 75, 68, 68))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 75, 68, 68))),
      ),
    );
  }
}
