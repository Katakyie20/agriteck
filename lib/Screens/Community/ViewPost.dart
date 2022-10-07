import 'package:agriteck/FirebaseServices.dart';
import 'package:agriteck/Objects/Comment.dart';
import 'package:agriteck/Objects/PostObject.dart';
import 'package:agriteck/Objects/UserObject.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../utils/AppColors.dart';

class ViewPost extends StatefulWidget {
  const ViewPost({super.key, required this.post, required this.comment});
  final PostObject post;
  final List<CommentObject> comment;

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  var desController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var post = widget.post;
    var user = UserObject.fromJson(widget.post.sender!);
    var dt = DateTime.fromMillisecondsSinceEpoch(post.createdAt!);
    final fifteenAgo = DateTime.now().subtract(Duration(
        days: dt.day,
        hours: dt.hour,
        minutes: dt.minute,
        seconds: dt.second,
        milliseconds: dt.millisecond,
        microseconds: dt.microsecond));
    var size = MediaQuery.of(context).size;

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseServices.getUsers(
            FirebaseAuth.instance.currentUser != null
                ? FirebaseAuth.instance.currentUser!.uid
                : "1234"),
        builder: (context, snapshot) {
          UserObject? commentor;
          if (snapshot.hasData) {
            commentor = UserObject.fromJson(
                snapshot.data!.data() as Map<String, dynamic>);
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: primary,
              title: const Text('Post Details'),
            ),
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: size.height * .2,
                            width: double.infinity,
                            child: CarouselSlider.builder(
                              itemCount: widget.post.images!.length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        widget.post.images![itemIndex]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              options: CarouselOptions(
                                height: 400,
                                aspectRatio: 16 / 9,
                                viewportFraction: 1,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                              ),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          title: Text(
                            widget.post.title!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Column(
                            children: [
                              SizedBox(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      user.profile!,
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        user.profile!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        user.name!,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: primary,
                                            fontWeight: FontWeight.w400),
                                        maxLines: 1,
                                      ),
                                      Text(
                                        timeago.format(fifteenAgo),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: primaryLight,
                                            fontWeight: FontWeight.w200),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(widget.post.description!),
                              const SizedBox(
                                height: 20,
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Comments",
                                    style: GoogleFonts.poppins(fontSize: 20),
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.comment.length,
                                itemBuilder: (context, index) =>
                                    commentCard(widget.comment[index]),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                              onPressed:()=> sendComment(commentor!),
                              icon: const Icon(Icons.send)),
                          hintText: 'Write a comment'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          );
        });
  }

  Widget commentCard(CommentObject comment) {
    var dt = DateTime.fromMillisecondsSinceEpoch(comment.createdAt!);
    final fifteenAgo = DateTime.now().subtract(Duration(
        days: dt.day,
        hours: dt.hour,
        minutes: dt.minute,
        seconds: dt.second,
        milliseconds: dt.millisecond,
        microseconds: dt.microsecond));
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(comment.senderProfile!),
        child: ClipOval(
          child: Image.network(
            comment.senderProfile!,
            fit: BoxFit.fill,
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            comment.senderName!,
            style: const TextStyle(
                fontSize: 16, color: primary, fontWeight: FontWeight.w400),
            maxLines: 1,
          ),
          Text(
            timeago.format(fifteenAgo),
            style: const TextStyle(
                fontSize: 12, color: primaryLight, fontWeight: FontWeight.w200),
            maxLines: 1,
          ),
        ],
      ),
      subtitle: Text(comment.comment!),
    );
  }

  void sendComment(UserObject commentor) async {
    if (desController.text.isNotEmpty) {
      String id = FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.post.id)
          .collection("Comments")
          .id;
      var comment = CommentObject(
          comment: desController.text,
          createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
          senderId: commentor.id,
          senderName: commentor.name,
          senderProfile: commentor.profile,
          postId: widget.post.id,
          id: id);
      await FirebaseServices().addComment(comment, widget.post.id!);
      setState(() {
        desController.clear();
        widget.comment.add(comment);
      });
    }
  }
}
