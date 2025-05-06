import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wesh_nakil5/edit_profile.dart';
import 'package:wesh_nakil5/post_details.dart';
import 'package:wesh_nakil5/user/user_data.dart';
import 'package:wesh_nakil5/user/user_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  List products = [
    {
      "image": "images/pasta.png",
      "name": "laptop",
      "des": "new dell laptop for ever",
      "price": "342\$"
    },
    {
      "image": "images/pasta2.png",
      "name": "phone",
      "des": "new dell laptop for ever",
      "price": "344\$"
    },
    {
      "image": "images/pancake.png",
      "name": "ps",
      "des": "fsdfds fdsfsd fdsfdsf sfdsfds fdsf",
      "price": "655\$"
    },
    {
      "image": "images/hunger.png",
      "name": "ps",
      "des": "fsdfds fdsfsd fdsfdsf sfdsfds fdsf",
      "price": "655\$"
    },
    {
      "image": "images/pasta.png",
      "name": "laptop",
      "des": "new dell laptop for ever",
      "price": "342\$"
    },
    {
      "image": "images/pasta2.png",
      "name": "phone",
      "des": "new dell laptop for ever",
      "price": "344\$"
    },
    {
      "image": "images/pancake.png",
      "name": "ps",
      "des": "fsdfds fdsfsd fdsfdsf sfdsfds fdsf",
      "price": "655\$"
    },
    {
      "image": "images/hunger.png",
      "name": "ps",
      "des": "fsdfds fdsfsd fdsfdsf sfdsfds fdsf",
      "price": "655\$"
    }
  ];

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  String firstName = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUserData();
  }

  updateUserData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    UserData? userData = Provider.of<UserProvider>(context).getUser;

    if (userData != null) {
      return Scaffold(
        body: ListView(
          children: [
            Center(
                child: Column(
              children: [
                // MaterialButton(
                //   onPressed: () async {
                //     await FirebaseAuth.instance.signOut();
                //     Navigator.popAndPushNamed(context, "login");
                //   },
                //   child: Container(),
                // ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userData.profile_img),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "${userData.first_name} ${userData.last_name}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return EditProfile(userId: userData.uid);
                      }));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: SizedBox(
                      width: 160,
                      child: const Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'تعديل الملف الشخصي',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 3,
                  ),
                ),
              ],
            )),
            GridView.builder(
                itemCount: products.length,
                //******because listview has scroll we should disable it in Grid ***
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              PostDetails(data: products[i])));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 3),
                      color: Colors.grey[300],
                      child: Image.asset(
                        products[i]["image"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                })
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
}
