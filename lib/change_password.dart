import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class pass extends StatelessWidget {
  const pass({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: password(),
    );
  }
}
class password extends StatefulWidget {
  const password({super.key});

  @override
  State<password> createState() => _passwordState();
}

class _passwordState extends State<password> {
  final TextEditingController _email=TextEditingController();
  Future<void>reset(BuildContext context)async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text);
    }
    catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100,),
          Container(
            height: 50,
            width: 300,
            decoration: BoxDecoration(border: Border.all()),
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: _email,
              style: TextStyle(color: Colors.blue),
              decoration: InputDecoration(hintText: 'email'),
            ),
          ),
          ElevatedButton(onPressed: () {
            reset(context);
          }, child: Text('change'))
        ],
      ),
    );
  }
}
