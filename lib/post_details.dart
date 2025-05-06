import 'package:flutter/material.dart';

class PostDetails extends StatefulWidget {
  final data;

  const PostDetails({super.key, this.data});

  @override
  State<StatefulWidget> createState() {
    return _PostDetailsState();
  }
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
