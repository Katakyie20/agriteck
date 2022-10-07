import 'dart:io';

import 'package:agriteck/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../GlobalWidgets/ClickableText.dart';
import '../Disease/disease-detection-details.dart';

class CureYourPlant extends StatelessWidget {
  CureYourPlant({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SliverToBoxAdapter(
        child: Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Cure Your Plant',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  radius: screenWidth * 0.1,
                  backgroundImage:
                      const AssetImage('assets/images/capture.jpg'),
                ),
                SizedBox(height: screenHeight * 0.015),
                const Text(
                  'Focus and\nCapture',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            const Icon(FontAwesomeIcons.arrowRight, size: 30.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  radius: screenWidth * 0.1,
                  backgroundImage: const AssetImage('assets/images/sick.png'),
                ),
                SizedBox(height: screenHeight * 0.015),
                const Text(
                  'Focus and\nCapture',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            const Icon(FontAwesomeIcons.arrowRight, size: 30.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  radius: screenWidth * 0.1,
                  backgroundImage:
                      const AssetImage('assets/images/healthy.png'),
                ),
                SizedBox(height: screenHeight * 0.015),
                const Text(
                  'Focus and\nCapture',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            )
          ]),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: primaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                ),
                onPressed: () => detectDisease(context),
                icon: const Icon(
                  FontAwesomeIcons.camera,
                  color: Colors.white,
                ),
                label: Text(
                  'Capture Plant',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ClickableText(
            text1: "",
            text2: 'Click to View Diseases List',
            press: () {
              // sendToPage(context, DiseasesScreen());
            },
          )
        ],
      ),
    ));
  }

  final ImagePicker _picker = ImagePicker();
  Future detectDisease(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Select an Option',
              style: TextStyle(fontSize: 18, color: primaryLight),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: FaIcon(
                            FontAwesomeIcons.photoFilm,
                            color: primaryDark,
                          ),
                        ),
                        Text(
                          'Open Gallery',
                          style: TextStyle(fontSize: 16, color: primary),
                        ),
                      ],
                    ),
                    onTap: () => getImage(ImageSource.gallery, context),
                  ),
                  // Padding(padding: const EdgeInsets.all(8)),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: FaIcon(FontAwesomeIcons.camera,
                              color: primaryDark),
                        ),
                        Text(
                          'open Camera',
                          style: TextStyle(fontSize: 16, color: primary),
                        ),
                      ],
                    ),
                    onTap: () => getImage(ImageSource.camera, context),
                  ),
                  // ignore: prefer_const_constructors
                  Divider(
                    color: primaryLight,
                  ),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: FaIcon(
                            FontAwesomeIcons.rectangleXmark,
                            color: primaryDark,
                          ),
                        ),
                        Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16, color: primary),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  getImage(ImageSource source, BuildContext context) async {
    var imageFile = await _picker.pickImage(source: source);
    if (imageFile != null) {
      predictDesease(imageFile).then((predictions) async {
        print("predictions:========================================== $predictions");
        Navigator.of(context).pop();
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DiseaseDetection(
            imagePath: File(imageFile.path),
            predictions: predictions,
          );
        }));
      });
    } else {
      //showToast(content: 'No Image Selected');
    }
  }

  Future<List> predictDesease(XFile imageFile) async {
    var image = imageFile.path;
    String? res = await Tflite.loadModel(
        model: "assets/files/model.tflite",
        labels: "assets/files/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
    await Tflite.close();
    var recognitions = await Tflite.runModelOnImage(
        path: image, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );
    return recognitions!;
  }
}
