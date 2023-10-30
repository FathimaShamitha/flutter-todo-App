import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Homepage.dart';

class MySignUpClass extends StatefulWidget {
  const MySignUpClass({Key? key}) : super(key: key);

  @override
  State<MySignUpClass> createState() => _MySignUpClassState();
}

class _MySignUpClassState extends State<MySignUpClass> {
  TextEditingController namecntrl = TextEditingController();
  TextEditingController emailcntrl = TextEditingController();
  TextEditingController passwordcntrl = TextEditingController();
  GlobalKey<FormState> _fkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _fkey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40, top: 60),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                      fontSize: 50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: TextFormField(
                  controller: namecntrl,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Username cannot be empty!!!";
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: TextFormField(
                  controller: emailcntrl,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email cannot be empty!!!";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                child: TextFormField(
                  controller: passwordcntrl,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password cannot be empty!!!";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_fkey.currentState!.validate()) {
                      try {
                        var ref = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailcntrl.text,
                                password: passwordcntrl.text);
                        User? user = ref.user;
                        if (user != null) {
                          final db_ref = FirebaseFirestore.instance
                              .collection("Users")
                              .add({
                            "name": namecntrl.text,
                            "email": emailcntrl.text,
                            "password": passwordcntrl.text,
                            "id": user.uid
                          });
                        }
                        Fluttertoast.showToast(msg: "Register Success");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePageClass()));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == "invalid-email") {
                          Fluttertoast.showToast(msg: "Invaild Email Format");
                        }
                        if (e.code == "weak-password") {
                          Fluttertoast.showToast(
                              msg: "Enter a strong password");
                        }
                        if (e.code == "email-already-in-use") {
                          Fluttertoast.showToast(msg: "Email already exists");
                        }
                      } catch (e) {
                        Fluttertoast.showToast(msg: "An error occured");
                      }
                    }
                  },
                  child: Text(
                    "SignUp",
                    style: TextStyle(fontSize: 20,color: Colors.blue[900]),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
