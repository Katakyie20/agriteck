import 'package:agriteck/FirebaseServices.dart';
import 'package:agriteck/Objects/PostObject.dart';
import 'package:agriteck/Objects/UserObject.dart';
import 'package:agriteck/utils/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../Objects/Comment.dart';
import '../../authentication/registerscreen.dart';
import 'ViewPost.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.post});
  final PostObject post;
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseServices.getComments(post.id!),
      builder: (context, snapshot) {
        List<CommentObject>comments = [];
        if(snapshot.hasData){
          comments = snapshot.data!.docs.map((e) => CommentObject.fromJson(e.data() as Map<String,dynamic>)).toList();
        }
        return GestureDetector(
          onTap: () {
           Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ViewPost(post: post,comment: comments,)),
              );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Card(
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    width: size.width,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                      child: Image.network(
                        post.images![0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(
                        post.title!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: primaryDark,
                            fontSize: 18,
                            height: 1.5),
                      ),
                      subtitle: Text(
                        post.description!,
                        style: const TextStyle(
                            fontSize: 15,
                            color: primaryLight,
                            fontWeight: FontWeight.w400,
                            height: 1.5),
                        maxLines: 3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child:  Text(
                        'Comment(${comments.length})',
                        style: const TextStyle(
                            color: primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
