import 'dart:io';

import 'package:agriteck/Objects/Comment.dart';
import 'package:agriteck/Objects/PostObject.dart';
import 'package:agriteck/Objects/UserObject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  Future<String> uploadImage(File imageFile, String userId) async {
    String fileName = userId;
    var firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profileImages/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    String profileImageUrl = await taskSnapshot.ref.getDownloadURL();
    return profileImageUrl;
  }

  Future<void> saveUserData(UserObject userObject) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(userObject.id).set(userObject.toJson());
  }

  Future<dynamic> getUser(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      return value.data();
    });
  }

  Future<List<String>> uploadFiles(List<File> _images, String folder) async {
    var imageUrls =
        await Future.wait(_images.map((_image) => uploadFile(_image, folder)));
    return imageUrls;
  }

  Future<String> uploadFile(File _image, String folder) async {
    var storageReference = FirebaseStorage.instance
        .ref("Report")
        .child('$folder/${_image.path.split('/').last}');
    var uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() => null);
    return await storageReference.getDownloadURL();
  }

  Future<void> saveReport(PostObject report) {
    return FirebaseFirestore.instance
        .collection('Posts')
        .doc(report.id)
        .set(report.toJson());
  }

  static getUsers(String s) =>
      FirebaseFirestore.instance.collection('users').doc(s).snapshots();

  static getRecentPost(String uid) => FirebaseFirestore.instance
      .collection('Posts')
      .where('senderId', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots();

  static getPosts() => FirebaseFirestore.instance
      .collection('Posts')
      .orderBy('createdAt', descending: true)
      .snapshots();

  static getComments(String s) => FirebaseFirestore.instance
      .collection('Posts')
      .doc(s)
      .collection('Comments')
      .orderBy('createdAt', descending: true)
      .snapshots();

  addComment(CommentObject comment, String s) {
    return FirebaseFirestore.instance
        .collection('Posts')
        .doc(s)
        .collection('Comments')
        .doc(comment.id)
        .set(comment.toJson());
  }
}
