import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageProvider {

  static final Reference storageReference = FirebaseStorage.instance.ref();


  static Future<bool> pictureExists() async {
    Uint8List? x = await storageReference.child("images/riders/${FirebaseAuth.instance.currentUser!.uid}").getData();
    return x != null;
  }



  static Future<TaskSnapshot?> uploadPictureFromFile(File file) async {

    TaskSnapshot x = await storageReference.child("images/riders/${FirebaseAuth.instance.currentUser!.uid}").putFile(file);

    if(x.state == TaskState.running) {
      print('Running..');
    }
    if(x.state == TaskState.canceled) {
      print('CANCELLED');
    }
    if(x.state == TaskState.paused) {
      print('Paused');
    }

    if(x.state == TaskState.error) {
      print('Error');
    }

    if(x.state == TaskState.success) {
      print('Success');
      String url =  await x.ref.getDownloadURL();
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid), {
          'profilePictureUrl' : url,
          'profilePictureTimestamp' : Timestamp.now()
        });
      });
      print('updated url');
    }

    return x;
  }

  static Future<void> uploadPictureFromList(Uint8List list)  async{
    TaskSnapshot x = await storageReference.child("images/riders/${FirebaseAuth.instance.currentUser!.uid}").putData(list);
    if(x.state == TaskState.running) {
      print('Running..');
    }
    if(x.state == TaskState.canceled) {
      print('CANCELLED');
    }
    if(x.state == TaskState.paused) {
      print('Paused');
    }

    if(x.state == TaskState.error) {
      print('Error');
    }

    if(x.state == TaskState.success) {
      print('Success');
    }

    if(x.state == TaskState.success) {
      print('Success');
      String url =  await x.ref.getDownloadURL();
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid), {
          'profilePictureUrl' : url,
          'profilePictureTimestamp' : Timestamp.now()
        });
      });
      print('updated url');
    }
  }


  static Future<Uint8List?> getDriverPicture(String driverId) async {
    print('skidanje slika sa storage ' + driverId );
    return await storageReference.child("images/drivers/$driverId").getData();
  }

   Future<Uint8List?> getCurrentUserPicture() async {
    String? host = 'images/riders/';
    String? path = host + FirebaseAuth.instance.currentUser!.uid;
    try {
      Uint8List? picture = await storageReference.child(path).getData(10485750);
      return picture;
    }
    catch(err) {
      print('nije uspjelo dobavljanje');
      print(err.toString());
      return null;
    }
  }





}