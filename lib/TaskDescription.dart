import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyTaskViewClass extends StatefulWidget {
  const MyTaskViewClass({Key? key, required this.id}) : super(key: key);
   final id;

  @override
  State<MyTaskViewClass> createState() => _MyTaskViewClassState();
}

class _MyTaskViewClassState extends State<MyTaskViewClass> {

  String _uid = "";
  @override
  void initState() {
    // TODO: implement initState
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.blue[900],
     ),
      body: StreamBuilder(
        stream:FirebaseFirestore.instance.collection("Tasks").doc(_uid).collection("mytask").doc(widget.id).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasData){
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,bottom: 3),
                    child: Text(snapshot.data["title"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(snapshot.data["description"],style: TextStyle(fontSize: 15),),
                  ),
                ],
              ),
            );
          }else{
            return Center(child: Text("Something went wrong"),);
          }
      },),
    );
  }
}
