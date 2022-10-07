import 'dart:convert';
import 'dart:io';
import 'package:agriteck/Objects/UserObject.dart';
import 'package:agriteck/Screens/Home/HomePage.dart';
import 'package:agriteck/utils/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../FirebaseServices.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? imageFile;
  var teacherName = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 90,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Your data is not saved, Do you want to exit?"),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            exit(0);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade800),
                          child: Text(
                            "Yes",
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Text("No",
                            style: TextStyle(color: Colors.black)),
                      ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo.png',
                      width: screenHeight * .4,
                      height: screenHeight * .4,
                    ),
                    Text(
                      "Let's finish up with your profile",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                uploadImage(),
                const SizedBox(
                  height: 20,
                ),
                inputFile(label: "Full Name", controller: teacherName, max: 1),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: const Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      )),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 40,
                    onPressed: saveUser,
                    color: primaryDark,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      "Save Data",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  Widget uploadImage() {
    return GestureDetector(
      onTap: () {
        pickUploadProfilePic();
      },
      child: Container(
        height: 120,
        width: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red,
        ),
        child: Center(
          child: imageFile == null
              ? const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 80,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(imageFile!,
                      height: 120, width: 120, fit: BoxFit.cover),
                ),
        ),
      ),
    );
  }

  void saveUser() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    if (imageFile != null && teacherName.text.isNotEmpty) {
      SmartDialog.showLoading(msg: "Saving User Data.....");
      String profileImageUrl =
          await FirebaseServices().uploadImage(imageFile!, userId);
      User user = FirebaseAuth.instance.currentUser!;
      UserObject userData = UserObject(
        id: user.uid,
        name: teacherName.text,
        phone: user.phoneNumber,
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
        profile: profileImageUrl,
      );
      await FirebaseServices().saveUserData(userData);
      Map<String, dynamic> data =
          await FirebaseServices().getUser(user.uid) as Map<String, dynamic>;
      String userString = jsonEncode(data);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('user', userString);
      SmartDialog.dismiss();
      SmartDialog.showToast("User Data Saved Successfully");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      SmartDialog.showToast("User Image is Required and Name is Required");
    }
  }
}

// we will be creating a widget for text field
Widget inputFile({label, obscureText = false, controller, int max = 1}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        controller: controller,
        maxLines: max,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 115, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!))),
      ),
      const SizedBox(
        height: 10,
      )
    ],
  );
}
