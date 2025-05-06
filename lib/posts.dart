import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:wesh_nakil5/CommentSection.dart';
import 'package:wesh_nakil5/current_location.dart';
import 'package:wesh_nakil5/fullscreenDialog.dart';
import 'package:wesh_nakil5/google_maps_launcher.dart';
import 'package:wesh_nakil5/like_button.dart';
import 'package:wesh_nakil5/user/user_data.dart';
import 'package:wesh_nakil5/user/user_provider.dart';

enum FilterType { recent, popular, close }

FilterType filterType = FilterType.recent;

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PostsState();
  }
}

class _PostsState extends State<Posts> {
  void refreshPostList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        color: const Color.fromARGB(255, 239, 239, 239),
        child: PostList(),
      ),
    );
  }
}

// Customed Bar*******
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: MaterialButton(
                color: filterType == FilterType.recent ? Colors.orange : null,
                onPressed: () {
                  setState(() {
                    filterType = FilterType.recent;
                    final _PostsState? postsState =
                        context.findAncestorStateOfType<_PostsState>();
                    if (postsState != null) {
                      postsState.refreshPostList();
                    }
                  });
                },
                child: const Text(
                  'الأحدث',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: MaterialButton(
                color: filterType == FilterType.popular ? Colors.orange : null,
                onPressed: () {
                  setState(() {
                    filterType = FilterType.popular;
                    final _PostsState? postsState =
                        context.findAncestorStateOfType<_PostsState>();
                    if (postsState != null) {
                      postsState.refreshPostList();
                    }
                  });
                },
                child: const Text(
                  'الألذ',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: MaterialButton(
                color: filterType == FilterType.close ? Colors.orange : null,
                onPressed: () {
                  setState(() {
                    filterType = FilterType.close;
                    final _PostsState? postsState =
                        context.findAncestorStateOfType<_PostsState>();
                    if (postsState != null) {
                      postsState.refreshPostList();
                    }
                  });
                },
                child: const Text(
                  'الأقرب',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Body *******************
class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  void initState() {
    super.initState();
    updateUserData();
  }

  updateUserData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: getAllPosts(filterType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<DocumentSnapshot> posts = snapshot.data ?? [];
          if (posts.isNotEmpty) {
            return ListView.builder(
              itemCount: posts.length,
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Map<String, dynamic> postData =
                    posts[index].data() as Map<String, dynamic>;
                return PostCard(postData: postData);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          }
        }
      },
    );
  }
}

class PostCard extends StatefulWidget {
  final Map<String, dynamic> postData;

  const PostCard({super.key, required this.postData});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    Widget myImageCarousel = buildImageCarousel(widget.postData);
    return FutureBuilder<DocumentSnapshot>(
      future: getUserData(widget.postData['uid']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic> publisherData =
              snapshot.data!.data() as Map<String, dynamic>;
          return InkWell(
            // onTap: () {
            //   Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => Details(data: products[i])));
            // },
            child: Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: const Color.fromARGB(255, 255, 255, 255),
              shadowColor: const Color.fromARGB(255, 225, 225, 225),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  publisherData['profile_img'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  publisherData['first_name'] +
                                      " " +
                                      publisherData['last_name'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  calculateTimeAgo(
                                      widget.postData['timestamp']),
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  GoogleMapsLauncher().launchGoogleMaps(
                                      double.parse(widget.postData['latitude']),
                                      double.parse(
                                          widget.postData['longitude']));
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.postData['resName'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxHeight: 250,
                      ),
                      margin: const EdgeInsets.only(top: 6),
                      color: const Color.fromARGB(255, 241, 241, 241),
                      child: SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: myImageCarousel),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(5),
                      child:
                          widget.postData['description'].toString().isNotEmpty
                              ? Text(
                                  widget.postData['description'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.right,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : const SizedBox(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        MaterialButton(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.comment_outlined,
                                color: Color.fromARGB(255, 92, 92, 92),
                                size: 30,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 3),
                                child: FutureBuilder<int>(
                                  future: getCommentCount(
                                      widget.postData['postId']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text('0');
                                    } else if (snapshot.hasError) {
                                      return const Text('0');
                                    } else {
                                      int commentCount = snapshot.data!;
                                      if (commentCount > 0) {
                                        return Text(
                                          commentCount.toString(),
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 92, 92, 92),
                                          ),
                                        );
                                      } else {
                                        return const Text(
                                          "0",
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 92, 92, 92),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => CommentSection(
                                postId: widget.postData['postId'],
                              ),
                            );
                          },
                        ),
                        LikeButton(postId: widget.postData['postId']),
                        MaterialButton(
                            child: const Icon(
                              Icons.star,
                              size: 30,
                              // color: posts[i]["fav"] == "false"
                              //     ? Color.fromARGB(255, 92, 92, 92)
                              //     : Colors.orange,
                            ),
                            onPressed: () {
                              // setState(() {
                              //   posts[i]["fav"] = posts[i]["fav"] == "true"
                              //       ? "false"
                              //       : "true";
                              // });
                            })
                      ],
                    ),

                    // Add more widgets if needed
                  ],
                ),
              ),
            ),
          );
          // Text(
          //     'Posted by: ${userData['first_name']} ${userData['last_name']}'

          //     )

          //     ;
        }
      },
    );
  }
}

// post images slider wideget
Widget buildImageCarousel(Map<String, dynamic> postData) {
  return FutureBuilder<List<String>>(
    future: getImageUrls(postData['postId']),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Errorrrrr: ${snapshot.error}'));
      } else {
        List<String> imageUrls = snapshot.data ?? [];

        return AnotherCarousel(
          images: List.generate(imageUrls.length, (index) {
            int reversedIndex = imageUrls.length - 1 - index;
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return FullScreenImageDialog(
                      imageUrl: imageUrls[reversedIndex],
                    );
                  },
                );
              },
              child: Image.network(
                imageUrls[reversedIndex],
                fit: BoxFit.cover,
              ),
            );
          }),
          dotSize: 5,
          indicatorBgPadding: 4.0,
          autoplay: false,
          showIndicator: imageUrls.length > 1,
        );
      }
    },
  );
}

// Function to retrieve all posts
Future<List<DocumentSnapshot>> getAllPosts(FilterType filterType) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('posts').get();
  List<DocumentSnapshot> posts = querySnapshot.docs;

  if (filterType == FilterType.close) {
    CurrentLocation currentLocation = CurrentLocation();
    Position position = await currentLocation.determinePosition();

    posts.sort((a, b) {
      double latitudeA = double.parse(a['latitude']);
      double longitudeA = double.parse(a['longitude']);
      double distanceA = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        latitudeA,
        longitudeA,
      );

      double latitudeB = double.parse(b['latitude']);
      double longitudeB = double.parse(b['longitude']);
      double distanceB = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        latitudeB,
        longitudeB,
      );

      return distanceA.compareTo(distanceB);
    });
  } else if (filterType == FilterType.popular) {
    // Fetch like counts for all posts asynchronously
    List<int> likeCounts =
        await Future.wait(posts.map((post) => getLikeCount(post.id)));

    // Sort posts based on like counts in descending order
    posts.sort((a, b) {
      int likeCountA = likeCounts[posts.indexOf(a)];
      int likeCountB = likeCounts[posts.indexOf(b)];

      return likeCountB.compareTo(likeCountA);
    });
  }

  return posts;
}

// Function to retrieve all images of the post
Future<List<String>> getImageUrls(String postId) async {
  DocumentSnapshot postDoc =
      await FirebaseFirestore.instance.collection('posts').doc(postId).get();

  List<String> imageUrls = [];

  if (postDoc.exists) {
    Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;

    if (postData.containsKey('imageUrls')) {
      dynamic images = postData['imageUrls'];

      if (images is List) {
        imageUrls = List<String>.from(images);
      } else if (images is String) {
        imageUrls.add(images);
      }
    }
  }

  return imageUrls;
}

// get the user data
Future<DocumentSnapshot> getUserData(String uid) async {
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return userDoc;
}

Future<int> getCommentCount(String postId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .collection('comments')
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.length;
  } else {
    return 0;
  }
}

Future<int> getLikeCount(String postId) async {
  DocumentSnapshot postDoc =
      await FirebaseFirestore.instance.collection('posts').doc(postId).get();

  if (postDoc.exists) {
    Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;

    if (postData.containsKey('liked_by')) {
      List<dynamic> likedBy = postData['liked_by'];
      return likedBy.length;
    } else {
      return 0;
    }
  } else {
    return 0;
  }
}

Future<int> getfavCount(String postId) async {
  DocumentSnapshot commentDoc =
      await FirebaseFirestore.instance.collection('post_fav').doc(postId).get();
  if (commentDoc.exists) {
    Map<String, dynamic> commentData =
        commentDoc.data() as Map<String, dynamic>;
    List<dynamic> commentTextList = commentData['fav_by'];
    List<String> commentTextListString =
        commentTextList.map((e) => e.toString()).toList();
    return commentTextListString.length;
  } else {
    return 0;
  }
}

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
