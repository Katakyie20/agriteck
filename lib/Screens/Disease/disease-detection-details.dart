import 'dart:io';

import 'package:agriteck/utils/AppColors.dart';
import 'package:flutter/material.dart';

class DiseaseDetection extends StatefulWidget {
  final File? imagePath;
  final List? predictions;

  const DiseaseDetection({this.imagePath, this.predictions});
  @override
  _DiseaseDetectionState createState() => _DiseaseDetectionState();
}

class _DiseaseDetectionState extends State<DiseaseDetection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text(
          'Disease Detection Details',
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DiseaseDetectionDetails(
            imagePath: widget.imagePath,
            predictions: widget.predictions,
          ),
        ),
      ),
    );
  }
}

class DiseaseDetectionDetails extends StatelessWidget {
  final File? imagePath;
  final List? predictions;
 const  DiseaseDetectionDetails({this.imagePath, this.predictions});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: size.height - 100,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: size.height * 0.3,
                    width: size.width,
                    child: Image.file(
                      imagePath!,
                      height: 50,
                      width: size.width,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(
                        predictions![0]['label']
                            .toString()
                            .replaceAll(new RegExp(r'_'), ' ')
                            .replaceAll(new RegExp(r'  '), ' ')
                            .toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: primaryDark,
                            fontSize: 24,
                            height: 1.5),
                      ),
                      subtitle: Text(
                        '${double.parse((predictions![0]['confidence'] * 100).toStringAsFixed(2))} Percent Sure',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w400,
                            height: 1.5),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      var diseaseName = predictions![0]['label']
                          .toString()
                          .replaceAll(new RegExp(r'_'), ' ')
                          .replaceAll(new RegExp(r' '), ' ')
                          .replaceAll(new RegExp(r'  '), ' ')
                          .replaceAll(new RegExp(r'   '), ' ');
                      print(diseaseName);
                      // DatabaseServices.queryFromDatabaseByField(
                      //   'Diseases',
                      //   'name',
                      //   diseaseName,
                      // ).then((snapshot) {
                      //   if (snapshot.size > 0) {
                      //     sendToPage(
                      //       context,
                      //       DiseaseDetailsScreen(
                      //         diseaseData: Disease.fromMapObject(
                      //             snapshot.docs.toList()[0].data()),
                      //       ),
                      //     );
                      //   } else {
                      //     showDialog(
                      //             context: context,
                      //             builder: (BuildContext context) {
                      //               return CustomDialogBox(
                      //                 title: 'Sorry',
                      //                 descriptions:
                      //                     'This Disease has not been uploaded yet \n Pls ask the community about it ?',
                      //                 btn1Text: 'Cancel',
                      //                 btn2Text: 'Ask Community',
                      //                 img: 'assets/images/info.png',
                      //                 btn1Press: () {
                      //                   Navigator.pop(context);
                      //                 },
                      //                 btn2Press: () {},
                      //               );
                      //             }) ??
                      //         false;
                      //   }
                      // });
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: primaryDark,
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                           Text(
                            'See Details',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                           Icon(
                            Icons.arrow_right,
                            size: 36.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: primaryLight,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: ListTile(
                      title: Text(
                        'Contribution to Community',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: primaryDark,
                            fontSize: 22,
                            height: 1.5),
                      ),
                      subtitle: Text(
                        '''Don\'t be left out, Help your community by participating in community discussions and activities.\nClick on the button below to participate now.
                  ''',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
