
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:wesh_nakil5/user/user_data.dart';
import 'package:wesh_nakil5/user/user_provider.dart';

class CommentSection extends StatefulWidget {
  final String postId;

  const CommentSection({super.key, required this.postId});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool showSpinner = false;
  updateUserData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    updateUserData();
    fetchComments(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    UserData? userData =
        Provider.of<UserProvider>(context, listen: false).getUser;
    //   final screenHeight = MediaQuery.of(context).size.height;
    // final drawerHeight = screenHeight * 0.7;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
      ),
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(children: [
            Drawer(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    color: const Color.fromARGB(255, 254, 250, 244),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 7.5),
                      child: Center(
                        child: Text(
                          'التعليقات',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: _comments.isNotEmpty
                          ? Container(
                              color: const Color.fromARGB(255, 254, 250, 244),
                              child: ListView.builder(
                                itemCount: _comments.length,
                                itemBuilder: (context, index) {
                                  final item = _comments[index];
                                  //  print(item['commenterId']);
                                  return FutureBuilder<DocumentSnapshot>(
                                      future:
                                          getCommentorData(item['commenterId']),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Text('');
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          Map<String, dynamic> commentorData =
                                              snapshot.data!.data()
                                                  as Map<String, dynamic>;
                                          if (commentorData.isNotEmpty) {
                                            return Container(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: Row(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  right: 5),
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Color
                                                                .fromARGB(
                                                                255, 240, 5, 5),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: ClipOval(
                                                            child:
                                                                Image.network(
                                                              commentorData[
                                                                  "profile_img"],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 16.0),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl,
                                                                children: [
                                                                  Text(
                                                                    commentorData["first_name"] +
                                                                            " " +
                                                                            commentorData['last_name'] ??
                                                                        "",
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                    child: Text(
                                                                      textDirection:
                                                                          TextDirection
                                                                              .rtl,
                                                                      calculateTimeAgo(
                                                                          item[
                                                                              "timestamp"]),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              75,
                                                                              75,
                                                                              75)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                item["comment"] ??
                                                                    "",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16),
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  userData!.uid !=
                                                          item['commenterId']
                                                      ? GestureDetector(

                                                          ///deteting the comment
                                                          onTap: () async {
                                                            bool confirmDelete =
                                                                await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  content: const Text(
                                                                      textDirection:
                                                                          TextDirection
                                                                              .rtl,
                                                                      "تأكيد حذف التعليق؟"),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop(false); // User does not confirm delete
                                                                      },
                                                                      child: const Text(
                                                                          'الغاء'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop(true); // User confirms delete
                                                                      },
                                                                      child: const Text(
                                                                          'حذف'),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );

                                                            if (confirmDelete ==
                                                                true) {
                                                              setState(() {
                                                                showSpinner =
                                                                    true;
                                                              });
                                                              String
                                                                  deleteResponse =
                                                                  await deleteComment(
                                                                      item[
                                                                          'commentId'],
                                                                      widget
                                                                          .postId);
                                                              fetchComments(
                                                                  widget
                                                                      .postId);

                                                              setState(() {
                                                                showSpinner =
                                                                    false;
                                                              });
                                                            }
                                                          },
                                                          child: Row(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            60),
                                                                child:
                                                                    GestureDetector(
                                                                        child:
                                                                            const Text(
                                                                  'حذف',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                )),
                                                              )
                                                            ],
                                                          ))
                                                      : GestureDetector(
                                                          // onTap: () {
                                                          //   addReplyTag(commentorData[
                                                          //           'first_name'] +
                                                          //       " " +
                                                          //       commentorData[
                                                          //           'last_name']);
                                                          // },
                                                          child: const Row(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          children: [
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            60),
                                                                child: Text(
                                                                  'رد',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                )),
                                                            Icon(
                                                              Icons.reply,
                                                              size: 16,
                                                            )
                                                          ],
                                                        ))
                                                ],
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.orange,
                                              ),
                                            );
                                          }
                                        }
                                      });
                                },
                              ),
                            )
                          : Container()),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Expanded(
                            child: TextField(
                              textDirection: TextDirection.rtl,
                              controller: _commentController,
                              decoration: const InputDecoration(
                                hintText: 'اكتب تعليقك...',
                                hintTextDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              color: Colors.orange,
                              onPressed: _addComment,
                              child: const Text(
                                'ارسال',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ])),
    );
  }

// Fetch comments from Firebase and update the _comments list
  void fetchComments(String postId) {
    fetchCommentsFromFirebase(postId).then((comments) {
      setState(() {
        _comments = comments;
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchCommentsFromFirebase(
      String postId) async {
    List<Map<String, dynamic>> comments = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data =
            doc.data() as Map<String, dynamic>?; // Explicit cast
        if (data != null) {
          String commentId = doc.id;
          Map<String, dynamic> commentWithId = {
            'commentId': commentId,
            ...data
          };
          comments.add(commentWithId);
        }
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }

    return comments;
  }

  //get commentor data
  Future<DocumentSnapshot> getCommentorData(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc;
  }

//add a comment
  void _addComment() async {
    setState(() {
      showSpinner = true;
    });
    UserData? userData =
        Provider.of<UserProvider>(context, listen: false).getUser;
    if (_commentController.text.isNotEmpty) {
      String resp = await uploadComment(
          uid: userData!.uid,
          postId: widget.postId,
          comment: _commentController.text);

      _commentController.clear();
    }
    fetchComments(widget.postId);
    setState(() {
      showSpinner = false;
    });
  }

//upload a comment
  Future<String> uploadComment({
    required String uid,
    required String postId,
    required String comment,
  }) async {
    String resp = "success";
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add({
        'commenterId': uid,
        'timestamp': FieldValue.serverTimestamp(),
        'comment': comment,
      });
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

//delete comment
  Future<String> deleteComment(String commentId, String postId) async {
    String resp = "success";
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

//add mention tag to text
  // addReplyTag(String name) {
  //   _commentController.clear();
  //   _commentController.text = "@" + name;
  //   _commentController.call();
  // }

  String calculateTimeAgo(Timestamp timestamp) {
    DateTime commentTime = timestamp.toDate();
    DateTime currentTime = DateTime.now();

    Duration difference = currentTime.difference(commentTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الان';
    }
  }
}
