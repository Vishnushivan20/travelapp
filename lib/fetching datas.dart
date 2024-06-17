import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'travel page.dart';

class Dat extends StatelessWidget {
  final User user;
  const Dat({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Insert(user: user),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
    );
  }
}

class Insert extends StatefulWidget {
  final User user;
  const Insert({Key? key, required this.user}) : super(key: key);

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _about = TextEditingController();
  final TextEditingController _quotes = TextEditingController();
  String? _imageURL;
  bool _uploadingImage = false;
  bool _submittingForm = false;

  @override
  void initState() {
    super.initState();
    _show();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _uploadingImage = true;
      });
      try {
        File imageFile = File(pickedFile.path);
        await _uploadImage(imageFile);
      } catch (e) {
        print('Error: $e');
        setState(() {
          _uploadingImage = false;
        });
      }
    } else {
      print('No image selected');
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child('profilePicture').child('${widget.user.uid}.jpg');
      UploadTask uploadTask = storageReference.putFile(imageFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
      });
      await uploadTask;
      String downloadUrl = await storageReference.getDownloadURL();
      setState(() {
        _imageURL = downloadUrl;
        _uploadingImage = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _uploadingImage = false;
      });
    }
  }

  Future<void> _show() async {
    try {
      setState(() {
        _submittingForm = true;
      });
      DocumentSnapshot data = await FirebaseFirestore.instance.collection('attendance').doc(widget.user.uid).get();
      setState(() {
        _name.text = data['name'] ?? '';
        _about.text = data['about'] ?? '';
        _quotes.text = data['quotes'] ?? '';
        _imageURL=data['profile'];
      });
    } catch (e) {
      print('Fetching error: $e');
    } finally {
      setState(() {
        _submittingForm = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 80),
            GestureDetector(
              onTap: _uploadingImage ? null : _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: _imageURL != null ? NetworkImage(_imageURL!) : null,radius: 60,
                    child: _imageURL == null ? Icon(Icons.person, size: 50) : null,
                  ),
                  if (_uploadingImage)
                    Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(border: Border.all()),
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _name,
                style: TextStyle(color: Colors.blue),
                decoration: InputDecoration(hintText: 'NAME'),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(border: Border.all()),
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _about,
                style: TextStyle(color: Colors.blue),
                decoration: InputDecoration(hintText: 'ABOUT'),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(border: Border.all()),
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _quotes,
                style: TextStyle(color: Colors.blue),
                decoration: InputDecoration(hintText: 'QUOTES'),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submittingForm ? null : _saveData,
              child: Text('Save Data'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    try {
      setState(() {
        _submittingForm = true;
      });
      await FirebaseFirestore.instance.collection('attendance').doc(widget.user.uid).set({
        'name': _name.text,
        'about': _about.text,
        'quotes': _quotes.text,
        'profile': _imageURL,
      });
      print('Data Saved Successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TravelApp(user: widget.user)),
      );
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _submittingForm = false;
      });
    }
  }
}
