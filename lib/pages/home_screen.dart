import 'dart:developer';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:radio_demo/model/radio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<MyRadio>? _radios;

  late MyRadio _selectedRadio;
  Color? _selectedColor;
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // _fetchRadios();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState event) {
      if (event == PlayerState.PLAYING) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
  }

  _playMusic(String url) {
    _audioPlayer.play(url);
    _isPlaying = true;
    setState(() {});
    // _selectedRadio =
    // _radios!.firstWhere((MyRadio element) => element.url == url);
    // log(_selectedRadio.toMap().toString());
  }

  // _fetchRadios() async {
  //   final String _radioJson =
  //       await rootBundle.loadString('assets/json/radio.json');
  //   _radios = MyRadioList.fromJson(_radioJson).radios!;
  //   setState(() {});
  // }

  List<String> demo = [
    'https://drive.google.com/file/d/1VULUgN8kke4oCd_e9BnXJndlKFm_UdlX/view?usp=sharing',
    'https://drive.google.com/file/d/1VULUgN8kke4oCd_e9BnXJndlKFm_UdlX/view?usp=sharing',
    'https://drive.google.com/file/d/1VULUgN8kke4oCd_e9BnXJndlKFm_UdlX/view?usp=sharing'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 3),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // fit: StackFit.expand,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text("Radio"),
              titleTextStyle:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              toolbarHeight: 58,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: PageView.builder(
                itemCount: demo.length,
                controller: PageController(viewportFraction: 0.95),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) => Center(
                  child: InkWell(
                    onTap: () {
                      _playMusic(demo[index]);
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      // color: Colors.blueGrey.withOpacity(0.3),
                      borderOnForeground: false,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://liveonlineradio.net/wp-content/uploads/2018/04/Gakku-FM-220x108.jpg'))),
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.height * 0.35,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.green.withOpacity(0.5),
                                          Colors.blue.withOpacity(0.3),
                                        ],
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft)),
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  "KZ",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Gakku",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 36),
                                  ),
                                  const Text("92.55",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 24)),
                                  CupertinoButton(
                                      child: const Icon(
                                        CupertinoIcons.play,
                                        size: 45,
                                      ),
                                      onPressed: () {})
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Now playing",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "Gakku",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.teal.shade600,
                      borderRadius: BorderRadius.circular(65)),
                  margin: const EdgeInsets.symmetric(vertical: 50),
                  child: CupertinoButton(
                      alignment: Alignment.center,
                      child: Icon(
                        _isPlaying ? Icons.play_arrow : Icons.stop,
                        size: 35,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
