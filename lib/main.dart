import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'enterotpscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyAppNew(),
    );
  }
}

class MyAppNew extends StatefulWidget {
  const MyAppNew({Key? key}) : super(key: key);

  @override
  _MyAppNewState createState() => _MyAppNewState();
}

class _MyAppNewState extends State<MyAppNew> {
  TextEditingController mobileno = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  var varid;

  FirebaseAuth auth = FirebaseAuth.instance;


void readUser()async{
  FirebaseFirestore.instance
      .collection('users')
      .doc(mobileno.text.toString())
      .get()
      .then((DocumentSnapshot documentSnapshot) async{
    if (documentSnapshot.exists) {
      print('Please Login:');





    } else {
      print('Document does not exist on the database');

      await auth.verifyPhoneNumber(
        phoneNumber: "+91${mobileno.text}",
        verificationCompleted:
            (PhoneAuthCredential credential) async {
          print(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Varificationfailed");
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            print("codesent");
            varid = verificationId;
            Navigator.push(context, MaterialPageRoute(builder: (context)=>EnterOtp(varid: varid,auth: auth,mobileno: mobileno.text,)));
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("timeout");
        },
      );


    }
  });
}

  Future<void> deleteUser() {
    return users
        .doc('ABC123')
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> deleteField() {
    return users
        .doc('7600724658')
        .update({'age': FieldValue.delete()})
        .then((value) => print("User's Property Deleted"))
        .catchError((error) => print("Failed to delete user's property: $error"));
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Authentication"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: mobileno,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: "Mobile No"),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
              onPressed: () async {


                setState(() {

                });
                readUser();

              },
              child: Text("Send OTP")),

          ElevatedButton(onPressed: (){



          }, child: Text("add user")),


          ElevatedButton(onPressed: (){

deleteUser();

          }, child: Text("delete doc")),

          ElevatedButton(onPressed: (){

            deleteField();

          }, child: Text("delete doc field")),



        ],
      ),
    );
  }
}
