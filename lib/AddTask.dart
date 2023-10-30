import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'Homepage.dart';

class MyNewTaskClass extends StatefulWidget {
  const MyNewTaskClass({Key? key}) : super(key: key);

  @override
  State<MyNewTaskClass> createState() => _MyNewTaskClassState();
}

class _MyNewTaskClassState extends State<MyNewTaskClass> {

  TextEditingController titlecntrl = TextEditingController();
  TextEditingController decsriptioncntrl = TextEditingController();
  TextEditingController datecntrl = TextEditingController();

  void addTask()async{
    var ref = FirebaseAuth.instance;
    User user = await ref.currentUser!;
    String uid = user.uid;
    await FirebaseFirestore.instance.collection("Tasks").doc(uid).collection("mytask").add({
      "title":titlecntrl.text,
      "description":decsriptioncntrl.text,
      "date":datecntrl.text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("New Task",style: TextStyle(color: Colors.white,fontSize: 20),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30,bottom: 20,left: 20,right: 20),
            child: TextField(
              controller: titlecntrl,
              decoration: InputDecoration(
                hintText: "Enter Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
            child: TextField(
              controller: decsriptioncntrl,
              decoration: InputDecoration(
                hintText: "Enter Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
            child: TextField(
              controller: datecntrl,
              decoration: InputDecoration(
                hintText: "Enter the date",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),

                )
              ),
              onTap: () async{
                final DateTime? dt = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1999),
                  lastDate: DateTime(2050),
                );
                if(dt != null){
                  String formatted_date = DateFormat("yyyy-MM-dd").format(dt);
                  setState(() {
                    datecntrl.text = formatted_date;
                  });
                }
              },
            ),
          ),
          ElevatedButton(onPressed: (){
              addTask();
              Fluttertoast.showToast(msg: "Task Added");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePageClass()));
            }, child: Text("Add Task",style: TextStyle(fontSize: 18,color: Colors.blue[900]),))
        ],
      ),
    );
  }
}
