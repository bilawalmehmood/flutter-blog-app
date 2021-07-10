import 'dart:io';

import 'package:blogapp/widget/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'HomeScreen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  File _imageFile;
  bool _loading = false;

  ImagePicker imagePicker = ImagePicker();

  Future<void> _choseImage() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  void _velidate() {
    if (_imageFile == null && _descriptionController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please select an image and Filled up descripton ");
    } else if (_imageFile == null) {
      Fluttertoast.showToast(msg: "Please select an image ");
    } else if (_descriptionController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please Filled up descripton ");
    } else {
      setState(() {
        _loading = true;
      });
      _uploadImage();
    }
  }

  void _uploadImage() {
    String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();
    final Reference storageRefence =
        FirebaseStorage.instance.ref().child("Image").child(imageFileName);
    final UploadTask uploadTask = storageRefence.putFile(_imageFile);
    uploadTask.then((TaskSnapshot taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((imageUrl) {
        _saveData(imageUrl);
      });
    }).catchError((error) {
      Fluttertoast.showToast(msg: error.toString());
    });
  }

  void _saveData(String imageUrl) {
    var dateFormate = DateFormat("MMM d, yyyy");
    var timeFormate = DateFormat("EEEE  hh:mm a");

    String date = dateFormate.format(DateTime.now()).toString();
    String time = timeFormate.format(DateTime.now()).toString();

    FirebaseFirestore.instance.collection("Post").add({
      'imageUrl': imageUrl,
      'description': _descriptionController.text,
      'date': date,
      'time': time
    }).whenComplete(() {
      setState(() {
        _loading=false;
      });
      Fluttertoast.showToast(msg: "POST ADD SUCCESSFULY ");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(msg: error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upoad"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: <Widget>[
            _imageFile == null
                ? Container(
                    height: 240,
                    width: double.infinity,
                    color: Colors.grey,
                    child: Center(
                        child: RaisedButton(
                      onPressed: () {
                        _choseImage();
                      },
                      color: Colors.blueAccent,
                      child: Text(
                        "Chose File",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )),
                  )
                : GestureDetector(
                    onTap: () {
                      _choseImage();
                    },
                    child: Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: FileImage(_imageFile),
                        fit: BoxFit.cover,
                      )),
                    ),
                  ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: _descriptionController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Description",
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            _loading ? circularProgress():GestureDetector(
              onTap: _velidate,
              child: Container(
                color: Colors.pink,
                width: double.infinity,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Add new Post",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
