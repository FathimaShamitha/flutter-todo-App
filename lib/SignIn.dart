import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Homepage.dart';
import 'SignUp.dart';

class MySignInClass extends StatefulWidget {
  const MySignInClass({Key? key}) : super(key: key);

  @override
  State<MySignInClass> createState() => _MySignInClassState();
}

class _MySignInClassState extends State<MySignInClass> {
  TextEditingController emailcntrl = TextEditingController();
  TextEditingController passwrdcntrl = TextEditingController();
  GlobalKey<FormState> fkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                "SignIn",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    color: Colors.blue[900]),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 40, right: 40, bottom: 20, top: 60),
              child: TextFormField(
                controller: emailcntrl,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email field cannot be empty!!";
                  }
                },
                decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
              child: TextFormField(
                controller: passwrdcntrl,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email field cannot be empty!!";
                  }
                },
                decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            ElevatedButton(
                onPressed: ()async{
                  /*if (fkey.currentState!.validate()) {
                  }*/
                  try {
                    var ref = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: emailcntrl.text,
                        password: passwrdcntrl.text);
                    Fluttertoast.showToast(msg: "Login Success");
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePageClass()));
                  } on FirebaseAuthException catch (e) {
                    Fluttertoast.showToast(
                        msg: "Enter a valid email and password");
                  }
                },
                child: Text(
                  "SignIn",
                  style: TextStyle(fontSize: 20, color: Colors.blue[900]),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "New User?",
                  style: TextStyle(color: Colors.blue
                      , fontSize: 15),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MySignUpClass()));
                    },
                    child: Text(
                      "SignUp",
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
