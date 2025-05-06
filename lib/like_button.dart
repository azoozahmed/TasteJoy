import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wesh_nakil5/user/user_data.dart';
import 'package:wesh_nakil5/user/user_provider.dart';

class LikeButton extends StatefulWidget {
  final String postId;

  const LikeButton({super.key, required this.postId});

  @override
  State<StatefulWidget> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _handleLikePost,
      child: Row(
        children: [
          _buildLikeIcon(),
          _buildLikeCount(),
        ],
      ),
    );
  }

  FutureBuilder<bool> _buildLikeIcon() {
    return FutureBuilder<bool>(
      future: isPostLiked(context, widget.postId),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: snapshot.connectionState == ConnectionState.waiting
              ? const Icon(Icons.restaurant_menu_outlined,
                  color: Color.fromARGB(255, 92, 92, 92), size: 30)
              : snapshot.hasData && snapshot.data!
                  ? _buildAnimatedIcon(
                      Icons.restaurant_menu_outlined, Colors.orange)
                  : _buildAnimatedIcon(Icons.restaurant_menu_outlined,
                      const Color.fromARGB(255, 92, 92, 92)),
        );
      },
    );
  }

  Widget _buildAnimatedIcon(IconData icon, Color color) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      child: Icon(
        icon,
        size: 30,
        color: color,
        key: ValueKey<Color>(color),
      ),
    );
  }

  static int oldLikes = 0;
  FutureBuilder<int> _buildLikeCount() {
    return FutureBuilder<int>(
      future: getLikeCount(widget.postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(oldLikes.toString());
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else {
          int likeCount = snapshot.data!;
          oldLikes = likeCount;
          return Text(
            likeCount.toString(),
            style: const TextStyle(color: Color.fromARGB(255, 92, 92, 92)),
          );
        }
      },
    );
  }

  void _handleLikePost() {
    likeThePost(context, widget.postId).then((isLiked) {
      setState(() {
        // Update UI if necessary
      });
        });
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

  Future<bool> isPostLiked(BuildContext context, String postId) async {
    UserData? userData =
        Provider.of<UserProvider>(context, listen: false).getUser;

    DocumentSnapshot postDoc =
        await FirebaseFirestore.instance.collection('posts').doc(postId).get();

    if (postDoc.exists) {
      Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;

      List<dynamic> likedBy = postData['liked_by'] ?? [];

      if (likedBy.contains(userData!.uid)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> likeThePost(BuildContext context, String postId) async {
    UserData? userData =
        Provider.of<UserProvider>(context, listen: false).getUser;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot postDoc =
        await firestore.collection('posts').doc(postId).get();

    if (postDoc.exists) {
      Map<String, dynamic> postData = postDoc.data() as Map<String, dynamic>;
      List<dynamic> likedBy = postData['liked_by'] ?? [];

      if (likedBy.contains(userData!.uid)) {
        // User has already liked the post, unlike it
        likedBy.remove(userData.uid);
        await firestore
            .collection('posts')
            .doc(postId)
            .update({'liked_by': likedBy});
        return false;
      } else {
        // User has not liked the post, like it
        likedBy.add(userData.uid);
        await firestore
            .collection('posts')
            .doc(postId)
            .update({'liked_by': likedBy});
        return true;
      }
    } else {
      return false; // Post not found
    }
  }
}
