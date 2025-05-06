import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:wesh_nakil5/CommentSection.dart';
import 'package:wesh_nakil5/fullscreenDialog.dart';

class Offers extends StatefulWidget {
  const Offers({super.key});

  @override
  State<StatefulWidget> createState() {
    return _OffersState();
  }
}

class _OffersState extends State<Offers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('خيارات وعروض رهيبة')),
      ),
      body: Container(
        color: const Color.fromARGB(255, 239, 239, 239),
        child: const PostCard(),
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  const PostCard({super.key});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  List posts = [
    {
      "publisherName": "هرفي",
      "publisherPhoto": "images/herfy.png",
      "time": "1 دقيقة",
      "restaurantName": "هرفي",
      "des":
          " مطعم رهييب وحلو مرره البرقر لذيذ وطازج وانصح الكل يجربه ولا يفوت التجربه",
      "foodPhotos": [
        "images/herfy1.png",
      ],
      "location": "here",
      "likes": int.parse("23"),
      "isliked": "false",
      "fav": "false",
      "comments": 3
    },
    {
      "publisherName": "Macdonalds",
      "publisherPhoto": "images/mac.png",
      "time": "23 دقيقة",
      "restaurantName": "ماكدونالدز",
      "des": "مطعم رهييب وحلو مرره",
      "foodPhotos": [
        "images/mac1.png",
      ],
      "location": "here",
      "likes": int.parse("10"),
      "isliked": "false",
      "fav": "false",
      "comments": 7
    },
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      shrinkWrap: true,
      itemBuilder: (context, i) {
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
                              color: Color.fromARGB(255, 240, 5, 5),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                posts[i]["publisherPhoto"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                posts[i]["publisherName"],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                posts[i]["time"],
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.location_on),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                posts[i]["restaurantName"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxHeight: 300,
                    ),
                    margin: const EdgeInsets.only(top: 6),
                    color: const Color.fromARGB(255, 239, 3, 3),
                    child: SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: AnotherCarousel(
                        images: List.generate(posts[i]["foodPhotos"].length,
                            (index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return FullScreenImageDialog(
                                      imageUrl: posts[i]["foodPhotos"][index]);
                                },
                              );
                            },
                            child: Image(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage(posts[i]["foodPhotos"][index])),
                          );
                        }),
                        dotSize: 5,
                        indicatorBgPadding: 4.0,
                        autoplay: false,
                        showIndicator: posts[i]["foodPhotos"].length > 1,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(5),
                    child: Text(
                      posts[i]["des"],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                              child: Text(
                                posts[i]["comments"].toString(),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 92, 92, 92),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => CommentSection(
                              postId: i.toString(),
                            ),
                          );
                        },
                      ),
                      MaterialButton(
                        child: Row(
                          children: [
                            Icon(
                              Icons.restaurant_menu_outlined,
                              size: 30,
                              color: posts[i]["isliked"] == "false"
                                  ? const Color.fromARGB(255, 92, 92, 92)
                                  : Colors.orange,
                            ),
                            Text(
                              posts[i]["likes"].toString(),
                              style: TextStyle(
                                color: posts[i]["isliked"] == "false"
                                    ? const Color.fromARGB(255, 92, 92, 92)
                                    : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            if (posts[i]["isliked"] == "false") {
                              posts[i]["likes"] = posts[i]["likes"] + 1;
                            } else {
                              posts[i]["likes"] = posts[i]["likes"] - 1;
                            }
                            posts[i]["isliked"] = posts[i]["isliked"] == "true"
                                ? "false"
                                : "true";
                          });
                        },
                      ),
                      MaterialButton(
                          child: Icon(
                            Icons.star,
                            size: 30,
                            color: posts[i]["fav"] == "false"
                                ? const Color.fromARGB(255, 92, 92, 92)
                                : Colors.orange,
                          ),
                          onPressed: () {
                            setState(() {
                              posts[i]["fav"] =
                                  posts[i]["fav"] == "true" ? "false" : "true";
                            });
                          })
                    ],
                  ),

                  // Add more widgets if needed
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
