import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:agriteck/FirebaseServices.dart';
import 'package:agriteck/Objects/PostObject.dart';
import 'package:agriteck/Screens/Community/NewPost.dart';
import 'package:agriteck/Screens/Community/PostCard.dart';
import 'package:agriteck/utils/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../authentication/registerscreen.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with AfterLayoutMixin<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseServices.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              floatingActionButton: GestureDetector(
                onTap: () {
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => const NewPost(),
                  );
                },
                child: Card(
                  elevation: 10,
                  color: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.question_answer,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Ask Community',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              appBar: AppBar(
                backgroundColor: primary,
                title: const Text('Community Page'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (!snapshot.hasData) {
              return Scaffold(
                floatingActionButton: GestureDetector(
                  onTap: () {
                    showMaterialModalBottomSheet(
                      context: context,
                      builder: (context) => const NewPost(),
                    );
                  },
                  child: Card(
                    elevation: 10,
                    color: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.question_answer,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Ask Community',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                appBar: AppBar(
                  backgroundColor: primary,
                  title: const Text('Community Page'),
                ),
                body: const Center(
                  child: Text('No Post Found'),
                ),
              );
            } else {
             List<PostObject>posts=[];
              for (var item in snapshot.data!.docs) {
                posts.add(PostObject.fromJson(item.data() as Map<String, dynamic>));
              }
              return Scaffold(
                  floatingActionButton: GestureDetector(
                    onTap: () {
                      showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => const NewPost(),
                      );
                    },
                    child: Card(
                      elevation: 10,
                      color: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.question_answer,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Ask Community',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  appBar: AppBar(
                    backgroundColor: primary,
                    title: const Text('Community Page'),
                  ),
                  body: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) =>PostCard(post: posts[index],)));
            }
          }
        });
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    CheckAuthentication();
  }

  CheckAuthentication() async {
    if (FirebaseAuth.instance.currentUser == null) {
      SmartDialog.show(builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                  'You are not authenticated',
                  style: GoogleFonts.poppins(
                      color: primaryDark,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'For better experience please login',
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 13),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          SmartDialog.dismiss();
                        },
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold))),
                    const SizedBox(
                      width: 15,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: primaryDark,
                        ),
                        onPressed: login,
                        child: Text('Login',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold))),
                  ],
                )
              ]),
            ),
          ),
        );
      });
    }
  }

  login() {
    SmartDialog.dismiss();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }
}
