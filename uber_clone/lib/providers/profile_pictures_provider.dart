

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uber_clone/services/cached_data/temp_directory_service.dart';
import 'package:uber_clone/services/firebase/auth/uber_auth.dart';
import 'package:uber_clone/services/firebase/storage/storage_provider.dart';

class ProfilePicturesProvider extends ChangeNotifier{


  final FirebaseStorageProvider storageProvider = FirebaseStorageProvider();
  final TempDirectoryService tempDirectoryService = TempDirectoryService();
  File? _profilePicture;
  Map<String, File>? driverProfilePictures = {};

  ProfilePicturesProvider() {
    if(UberAuth.instance.currentUser != null) {
      loadCachedData();
    }

  }

  Future<void> loadCachedData() async {
    print('POZVALO SE CITANJE LOAD COACHED DATA IN PROFILE PICTURES PROVIDER!');
    await _loadDriversPictures();
    await _loadProfilePicture();
    notifyListeners();
  }

  Future<void> _loadProfilePicture() async {
    _profilePicture = await tempDirectoryService.loadUserPicture();
    if( _profilePicture == null) {
      Uint8List? list = await storageProvider.getCurrentUserPicture();
      _profilePicture = await TempDirectoryService.storeUserPicture(list!);
      if(_profilePicture == null)
        print('There was an error storing the profile picture');
    }
  }

  Future<void> _loadDriversPictures() async{
      driverProfilePictures = (await tempDirectoryService.loadDriversPictures())!;
  }



  Future<void> getList(List<String> driverIds) async {
    print('get list se pozvo');
    driverIds.forEach((driverId) async {
      //driver picture isn't cached, get from the storage
      if( driverProfilePictures![driverId] == null) {
        Uint8List list = (await FirebaseStorageProvider.getDriverPicture(driverId))!;
        driverProfilePictures![driverId] = (await TempDirectoryService.storeDriverPicture(driverId, list))!;
        if(driverProfilePictures![driverId] == null) {
          print('Error caching driver picture');
        }
      }
      notifyListeners();
      print('obavijestio je listenere za slike iz get list from chats');
    });



  }

  Future<File?> getDriverPicture(String driverId) async{
    if(driverProfilePictures![driverId] != null) {
      print('its local');
      return driverProfilePictures![driverId];
    }

    Uint8List? list = await FirebaseStorageProvider.getDriverPicture(driverId);
    driverProfilePictures![driverId] = (await TempDirectoryService.storeDriverPicture(driverId, list!))!;
    return driverProfilePictures![driverId];

  }

  Future<File?> pickImageFromSource(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final PickedFile? pickedFile = await picker.getImage(source: source);

    if(pickedFile == null) {
      return null;
    }

    Uint8List list = await pickedFile.readAsBytes();
    final File? picture = await TempDirectoryService.storeUserPicture(list);
    if( picture == null) return null;
    TaskSnapshot? snapshot = await FirebaseStorageProvider.uploadPictureFromFile(picture);
    if(snapshot == null)
      return null;
    _profilePicture = File(pickedFile.path);
    notifyListeners();
    return picture;
  }

  File? get profilePicture => _profilePicture;
}