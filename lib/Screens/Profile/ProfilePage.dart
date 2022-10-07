import 'package:agriteck/FirebaseServices.dart';
import 'package:agriteck/Objects/PostObject.dart';
import 'package:agriteck/Objects/UserObject.dart';
import 'package:agriteck/utils/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/registerscreen.dart';
import '../Community/PostCard.dart';
import 'widgets/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  saveDummyData(UserObject user) async {
    for (var data in dummyPost) {
      String id = FirebaseFirestore.instance.collection("Posts").doc().id;
      data.id = id;
      data.senderId = user.id;
      data.sender = user.toJson();
      data.createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;
      await FirebaseServices().saveReport(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text('My Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseServices.getUsers(
              FirebaseAuth.instance.currentUser != null
                  ? FirebaseAuth.instance.currentUser!.uid
                  : "123"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()));
            } else {
              if (FirebaseAuth.instance.currentUser == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Please Login to view your profile"),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        child: TextButton(
                            style:
                                TextButton.styleFrom(backgroundColor: primary),
                            onPressed: login,
                            child: Text(
                              "Sign In",
                              style: GoogleFonts.poppins(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                );
              } else {
                if (snapshot.hasData) {
                  var userData = UserObject.fromJson(
                      snapshot.data!.data()! as Map<String, dynamic>);
                  // saveDummyData(userData);
                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ProfileWidget(
                        imagePath: userData.profile!,
                        onClicked: () async {},
                      ),
                      const SizedBox(height: 24),
                      buildName(
                          userData.name != null ? userData.name! : "User Not",
                          userData.phone != null ? userData.phone! : "Found"),
                      const SizedBox(height: 24),
                      if (FirebaseAuth.instance.currentUser != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: primary),
                              onPressed: signOut,
                              child: Text(
                                "Sign Out",
                                style: GoogleFonts.poppins(color: Colors.white),
                              )),
                        ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("My Recent Posts",
                              style: GoogleFonts.poppins(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      if (FirebaseAuth.instance.currentUser != null)
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseServices.getRecentPost(
                                FirebaseAuth.instance.currentUser!.uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator()));
                              } else {
                                if (snapshot.hasData) {
                                  var data = snapshot.data!.docs;
                                  List<PostObject> post =
                                      List.empty(growable: true);
                                  for (var item in data) {
                                    var map =
                                        item.data() as Map<String, dynamic>;
                                    post.add(PostObject.fromJson(map));
                                  }
                                  return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          post.length > 3 ? 3 : post.length,
                                      itemBuilder: (context, index) {
                                        return PostCard(
                                          post: post[index],
                                        );
                                      });
                                } else {
                                  return const Center(
                                      child: Text("No Recent Posts"));
                                }
                              }
                            }),
                    ],
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Please Login to view your profile"),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: primary),
                              onPressed: login,
                              child: Text(
                                "Sign In",
                                style: GoogleFonts.poppins(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  );
                }
              }
            }
          }),
    );
  }

  Widget buildName(String name, String phone) => Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            phone,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  void login() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void signOut() async {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("user");
      setState(() {});
    }
  }
}
