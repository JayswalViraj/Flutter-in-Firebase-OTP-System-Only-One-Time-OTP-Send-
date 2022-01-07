import 'package:firebaseotpwithcloud/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EnterOtp extends StatefulWidget {
  var varid;
  var auth;
  var mobileno;
  EnterOtp({this.varid,this.auth,this.mobileno});

  @override
  _EnterOtpState createState() => _EnterOtpState();
}

class _EnterOtpState extends State<EnterOtp> {



  CollectionReference users = FirebaseFirestore.instance.collection('users');

  TextEditingController otp = TextEditingController();

  Future<void> addUser() {
    return users
        .doc('${widget.mobileno}')
        .set({
      'Name': "Viraj",
      'age': 18
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: otp,
            decoration: InputDecoration(hintText: "Otp"),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
              onPressed: () async {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.varid, smsCode: otp.text);
                try {
                  final authenticate =
                  await widget.auth.signInWithCredential(credential);
                  if (authenticate != null) {
                    print("login");

                    addUser();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                  }
                } catch (e) {
                  print("in exception");
                }
              },
              child: Text("Submit Otp"))
        ],
      ),
    );
  }
}

