import 'package:flutter/material.dart';
import 'package:todo/helper.dart';

class signupPage extends StatefulWidget {
  const signupPage({Key? key}) : super(key: key);

  @override
  _signupPageState createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String get fullname => fullNameController.text;
  String get phone => phoneController.text;
  String get email => emailController.text;
  String get password => passwordController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
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
              name: 'Full Name',
              prefix: Text(''),
              type: TextInputType.name,
              obs: false,
              controller: fullNameController,
            ),
            SizedBox(
              height: 15,
            ),
            Fields(
              name: 'Phone Number',
              prefix: Text('+98 | '),
              type: TextInputType.number,
              obs: false,
              controller: phoneController,
            ),
            SizedBox(
              height: 15,
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
                helperPage.signUp(fullname, phone, email, password);
              },
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          )
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
