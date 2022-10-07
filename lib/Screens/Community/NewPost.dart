import 'dart:convert';
import 'dart:io';
import 'package:agriteck/FirebaseServices.dart';
import 'package:agriteck/Objects/UserObject.dart';
import 'package:agriteck/authentication/registerscreen.dart';
import 'package:agriteck/utils/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Objects/PostObject.dart';
import '../../authentication/signup.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewReportState();
}

class _NewReportState extends State<NewPost> {
  final _formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var desController = TextEditingController();
  late Position userLoc;
  List<File> images = [];

  @override
  void initState() {
    super.initState();
  }

  getImages(int index) async {
    if (index == 1) {
      final List<XFile> files = await ImagePicker().pickMultiImage();
      for (var file in files) {
        images.add(File(file.path));
      }
    } else {
      final XFile? file =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (file != null) {
        images.add(File(file.path));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
      stream: FirebaseServices.getUsers(FirebaseAuth.instance.currentUser!=null?FirebaseAuth.instance.currentUser!.uid:"null"),
      builder: (context, snapshot) {
        if(snapshot.hasData&&snapshot.data!.exists) {
          var user = UserObject.fromJson(snapshot.data!.data()!);
          return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text(
                        'Take image of the Report',
                        style: GoogleFonts.poppins(),
                      ),
                      Expanded(
                        child: PopupMenuButton<int>(
                          onSelected: getImages,
                          icon: const Icon(Icons.arrow_circle_down, color: primary),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 1,
                                child:
                                    Text("Gallery", style: GoogleFonts.poppins())),
                            PopupMenuItem(
                                value: 2,
                                child:
                                    Text("Camera", style: GoogleFonts.poppins())),
                          ],
                          offset: const Offset(0, 100),
                          color: Colors.white,
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Image.file(
                        images[index],
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                inputFile(label: "Title", controller: titleController),
                const SizedBox(
                  height: 15,
                ),
                inputFile(label: "Description", controller: desController, max: 6),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Please note that your details as well as your location will be tracked",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                    style: TextButton.styleFrom(backgroundColor: primary),
                    onPressed:()=> (sendReport(user)),
                    child: Text(
                      "Submit Post",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ))
              ],
            ),
          ),
        );
        }else if(snapshot.hasError){
          return Center(child: Text("Error: ${snapshot.error}"));
      }else if(FirebaseAuth.instance.currentUser==null){
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Please login to continue"),
              const SizedBox(height: 10,),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegisterScreen()));
              }, style: TextButton.styleFrom(backgroundColor: primary), child: Text("Login", style: GoogleFonts.poppins(color: Colors.white),),)  
            ],
          )
    );
      }else{
          return const Center(child: SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator()));
        }
      }
    );
  }

  void sendReport(UserObject userObject) async {
    FirebaseServices firebaseServices = FirebaseServices();
    if (titleController.text.isEmpty) {
      SmartDialog.showToast("Ttile can not be empty");
    } else if (desController.text.length < 10) {
      SmartDialog.showToast("Post description is not enough");
    } else if (images.isEmpty) {
      SmartDialog.showToast("At least one image is required");
    } else {
      SmartDialog.showLoading(msg: "Sending Post..........");
      //Todo here we save the report;
      CollectionReference firestore =
          FirebaseFirestore.instance.collection("Reports");
      String id = firestore.doc().id;
      List<String> imagesList = await firebaseServices.uploadFiles(images, id);
      if (imagesList.isEmpty) {
        SmartDialog.showToast("Unable to save Images.. check your internet");
      } else {
       
        PostObject report = PostObject(
          id: id,
          images: imagesList,
          title: titleController.text,
          description: desController.text,
          createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
          sender: userObject.toJson(),
          senderId: FirebaseAuth.instance.currentUser!.uid,
        );
        await firebaseServices.saveReport(report);
        SmartDialog.dismiss();

        SmartDialog.showToast("Post Sent Successfully..waiting for Approval");
        setState(() {
          titleController.text = "";
          desController.text = "";
          images.clear();
        });
      }
    }
  }
}
