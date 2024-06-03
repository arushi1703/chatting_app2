import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageService{

  final FirebaseStorage _firebaseStorage= FirebaseStorage.instance;

  StorageService(){}

  Future<String?> uploadPfp({required File file, required String uid}) async{
    //stores the file as the uid+extension
    Reference fileRef= _firebaseStorage
        .ref('users/pfps')
        .child('$uid${p.extension(file.path)}');
    UploadTask task = fileRef.putFile(file); //starts the upload task of the file to the location specified by fileRef.
    //The then method is used to handle the result of the upload task once it completes.
    return task.then((p){
      if (p.state == TaskState.success){//Checks if the upload was successful.
        return fileRef.getDownloadURL();//If the upload was successful, this retrieves the download URL of the uploaded file.
      }
    });
  }
}