import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wesh_nakil5/current_location.dart';
import 'package:wesh_nakil5/uploadPost.dart';
import 'package:wesh_nakil5/user/user_data.dart';
import 'package:wesh_nakil5/user/user_provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddPostState();
  }
}

var uuid = const Uuid();

class _AddPostState extends State<AddPost> {
  @override
  void initState() {
    super.initState();
    updateUserData();
  }

  updateUserData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];

  bool imageIsValid = true;
  bool resIsValid = true;
  bool locationIsValid = true;
  bool showSpinner = false;
  bool permission_permanently_denied = false;

  final desCotroller = TextEditingController();
  final resCotroller = TextEditingController();

  String latitude = "";
  String longitude = "";

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.clear();
      for (int i = 0; i < selectedImages.length && i < 6; i++) {
        imageFileList.add(selectedImages[i]);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Colors.orange,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop(); // Add navigation logic here
              },
            ),
            title: const Text(''),
            centerTitle: true,
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          progressIndicator: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
          child: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: imageIsValid ? Colors.black : Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                              height: 230,
                              child: imageFileList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3),
                                          itemCount: imageFileList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  left: 3, top: 3),
                                              child: Image.file(
                                                File(imageFileList[index].path),
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          }),
                                    )
                                  : const Center(
                                      child: Text(
                                        'حط صورة الي قاعد تاكله ( من صورة الى 5 صور ) ',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  selectImages();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: Text(
                                  imageFileList.isEmpty
                                      ? 'اختر الصور'
                                      : 'تغيير الصور',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 5),
                    //   child: imageIsValid
                    //       ? SizedBox()
                    //       : const Text(
                    //           'يرجى رفع صورة واحدة على الأقل',
                    //           style: TextStyle(
                    //             color: Colors.red,
                    //           ),
                    //         ),
                    // ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: resCotroller,
                          maxLength: 20,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: resIsValid ? Colors.black : Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'اسم المطعم',
                            hintStyle: const TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: resIsValid ? Colors.black : Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: desCotroller,
                          maxLines: 2,
                          maxLength: 100,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'قم بكتابة وصف أو تعليق (اختياري )',
                            hintStyle: const TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    locationIsValid ? Colors.black : Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: latitude.isEmpty
                                  ? const Center(
                                      child: Text(
                                      'اختار موقع المطعم',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ))
                                  : Image.asset(
                                      'images/KSA_map.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 11, // Adjust the bottom position as needed
                            child: Center(
                              child: permission_permanently_denied
                                  ? const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'تم رفض الوصول للموقع يرجى السماح بالوصول للموقع من الاعدادات',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          showSpinner = true;
                                        });
                                        CurrentLocation currentLocation =
                                            CurrentLocation();

                                        currentLocation
                                            .determinePosition()
                                            .then((position) {
                                          latitude =
                                              position.latitude.toString();
                                          longitude =
                                              position.longitude.toString();
                                          setState(() {
                                            showSpinner = false;
                                          });
                                        }).catchError((error) {
                                          print('$error');
                                          if (error ==
                                              'Location permission permanently denied') {
                                            setState(() {
                                              permission_permanently_denied =
                                                  true;
                                            });
                                          }
                                          setState(() {
                                            showSpinner = false;
                                          });
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                      child: Text(
                                        latitude.isEmpty
                                            ? 'اختر الموقع'
                                            : 'تغيير الموقع',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 45,
                      width: 150,
                      margin: const EdgeInsets.only(top: 40, bottom: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (validateInputs()) {
                            uploadPost();
                          } else {
                            setState(() {});
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'حفظ ونشر',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  bool validateInputs() {
    if (imageFileList.isEmpty) {
      imageIsValid = false;
    } else {
      imageIsValid = true;
    }
    if (resCotroller.text.isEmpty) {
      resIsValid = false;
    } else {
      resIsValid = true;
    }
    if (latitude.isEmpty) {
      locationIsValid = false;
    } else {
      locationIsValid = true;
    }
    if (imageFileList.isEmpty ||
        resCotroller.text.isEmpty ||
        latitude.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void uploadPost() async {
    setState(() {
      showSpinner = true;
    });
    UserData? userData =
        Provider.of<UserProvider>(context, listen: false).getUser;

    List<Uint8List> imageBytesList = [];
    for (var imageFile in imageFileList) {
      List<int> imageBytes = await imageFile.readAsBytes();
      imageBytesList.add(Uint8List.fromList(imageBytes));
    }
    List<String> list = [];
    String resp = await UploadPost().uploadPost(
        uid: userData!.uid,
        postId: uuid.v1(),
        resName: resCotroller.text,
        des: desCotroller.text,
        latitude: latitude,
        longitude: longitude,
        images: imageBytesList,
        likes: list);

    if (resp == "success") {
      setState(() {
        showSpinner = false;
      });
      Navigator.popAndPushNamed(context, "home");
    } else {
      print("Error: $resp");
    }
  }
}
