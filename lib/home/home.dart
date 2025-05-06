import 'package:flutter/material.dart';
import 'package:wesh_nakil5/CommentSection.dart';
import 'package:wesh_nakil5/home/favorite.dart';
import 'package:wesh_nakil5/home/offers.dart';
import 'package:wesh_nakil5/home/posts.dart';
import 'package:wesh_nakil5/home/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [const Posts(), const Offers(), const Favorite(), const Profile()];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Posts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.orange,
        actions: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    // Add functionality for the notification icon here
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    // Add functionality for the settings icon here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: () {
          Navigator.pushNamed(context, "add_post");
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.orange,
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // left icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Posts();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.public,
                          color: currentTab == 0
                              ? Colors.black
                              : const Color.fromARGB(255, 87, 87, 87),
                        ),
                        Text(
                          'اقتراحات',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: currentTab == 0
                                ? Colors.black
                                : const Color.fromARGB(255, 87, 87, 87),
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Offers();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.publish,
                          color: currentTab == 1
                              ? Colors.black
                              : const Color.fromARGB(255, 87, 87, 87),
                        ),
                        Text(
                          'العروض',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: currentTab == 1
                                ? Colors.black
                                : const Color.fromARGB(255, 87, 87, 87),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              // Right icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Favorite();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: currentTab == 2
                              ? Colors.black
                              : const Color.fromARGB(255, 87, 87, 87),
                        ),
                        Text(
                          'المفضلة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: currentTab == 2
                                ? Colors.black
                                : const Color.fromARGB(255, 87, 87, 87),
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Profile();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: currentTab == 3
                              ? Colors.black
                              : const Color.fromARGB(255, 87, 87, 87),
                        ),
                        Text(
                          'حسابي',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: currentTab == 3
                                ? Colors.black
                                : const Color.fromARGB(255, 87, 87, 87),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
