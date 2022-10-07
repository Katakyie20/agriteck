import 'package:agriteck/Screens/HomePage/CurePlant.dart';
import 'package:agriteck/Screens/HomePage/TipsSection.dart';
import 'package:agriteck/Screens/HomePage/WeatherWidget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: <Widget>[
        const TipsOfTheDay(),
        CureYourPlant(),
        const WeatherSection(),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        )
      ],
    );
  }
}
