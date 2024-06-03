import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class DatabaseService{
  final FirebaseFirestore _firebaseFirestore= FirebaseFirestore.instance;
  //creating a collection reference using which we can store documents in firestore
  CollectionReference? _usersCollection;

  DatabaseService(){
    _setupCollectionReferences();
  }

  void _setupCollectionReferences(){
    //defined a ref to the user collection with type safety built in it so that we aer able to send/get info to/from cloud firestore that conforms to a certain schema
    //what happens when we add info to this collection
    _usersCollection=_firebaseFirestore.collection('users').withConverter<UserProfile>(
      //will be called when we retrieve data from this collection
      fromFirestore: (snapshots,_) => UserProfile.fromJson(//converting from Json to userprofile
        snapshots.data()!,
      ),
      //no second parameter so we write '_'
      //will be called when we add data to this collection
      toFirestore: (userProfile,_)=> userProfile.toJson(),//from userprofile to json
    );
  }

  Future<void> createUserProfile({required UserProfile userProfile})async{
    await _usersCollection?.doc(userProfile.uid).set(userProfile); //automatically understands using withConverter when we save info to firestore, it needs to convert this UserProfile to Json
  }
}