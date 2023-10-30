import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'AddTask.dart';
import 'SignIn.dart';
import 'TaskDescription.dart';

class MyHomePageClass extends StatefulWidget {
  const MyHomePageClass({Key? key}) : super(key: key);

  @override
  State<MyHomePageClass> createState() => _MyHomePageClassState();
}

class _MyHomePageClassState extends State<MyHomePageClass> {
  String _uid = "";

  @override
  void initState() {
    super.initState();
    getUid();
  }

  void getUid()async{
    var ref = FirebaseAuth.instance;
    User user = ref.currentUser!;
    setState(() {
      _uid = user.uid;
    });
  }

  void signOut()async{
    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(msg: "Logged Out");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MySignInClass()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          "TODO",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [InkWell(
          onTap: (){
             signOut();
          },
            child: Icon(Icons.account_circle,color: Colors.white,)),SizedBox(width: 20,)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyNewTaskClass()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Tasks")
            .doc(_uid)
            .collection("mytask")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error!!!"),
            );
          }
          if (snapshot.hasData) {
            List docslist = snapshot.data.docs;
            return ListView.builder(
                itemCount: docslist.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyTaskViewClass(id: docslist[index].id,)));
                    },
                    child: Card(
                      margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                      color: Colors.blue[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20,top: 20),
                                child: Text(
                                  docslist[index]["title"],
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                ),
                              ),
                             /* Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(docslist[index]["description"],style: TextStyle(fontSize: 15),),
                              ),*/
                              Padding(
                                padding: const EdgeInsets.only(left: 20,bottom: 10),
                                child: Text(docslist[index]["date"]),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection("Tasks")
                                    .doc(_uid)
                                    .collection("mytask")
                                    .doc(docslist[index].id)
                                    .delete();
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: Text("Something went wrong!!!"),
            );
          }
        },
      ),
    );
  }
}
