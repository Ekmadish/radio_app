import 'dart:developer';
import 'dart:html';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/web/audioplayers_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:radio_demo/model/radio.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<MyRadio> _radios;

  late MyRadio _selectedRadio;
  late Color _selectedColor;
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _fetchRadios();
    _audioPlayer.onPlayerStateChanged.listen((event) {
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
    _selectedRadio =
        _radios.firstWhere((MyRadio element) => element.url == url);
    log(_selectedRadio.toMap().toString());
  }

  _fetchRadios() async {
    final String _radioJson =
        await rootBundle.loadString('assets/json/radio.json');
    _radios = MyRadioList.fromJson(_radioJson).radios!;
    log(_radios.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(const LinearGradient(
                colors: [Colors.green, Colors.teal],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ))
              .make(),
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            title: "Radio".text.xl4.bold.make().shimmer(
                primaryColor: Colors.teal,
                secondaryColor: Colors.white,
                duration: const Duration(seconds: 3)),
          ).h(80).p16(),
          VxSwiper.builder(
              aspectRatio: 1.0,
              enlargeCenterPage: true,
              itemCount: _radios.length,
              itemBuilder: (context, index) => VxBox(
                          child: ZStack([
                    Positioned(
                      child: VxBox(
                        child: _radios[index]
                            .category!
                            .text
                            .uppercase
                            .white
                            .make()
                            .p16(),
                      )
                          .height(55)
                          .black
                          .alignCenter
                          .withRounded(value: 10)
                          .make(),
                      top: 0,
                      right: 0,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: VStack(
                        [
                          _radios[index].name!.text.xl3.white.bold.make(),
                          5.heightBox,
                          _radios[index].tagline!.text.sm.white.semiBold.make()
                        ],
                        crossAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: [
                          const Icon(
                            CupertinoIcons.play,
                            color: Colors.white,
                          ),
                          .10.heightBox,
                          "Double tap to play".text.gray400.make(),
                        ].vStack()),
                  ]))
                      .clip(Clip.antiAlias)
                      .bgImage(
                        DecorationImage(
                            image: NetworkImage(_radios[index].image!),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken)),
                      )
                      .border(color: Colors.black, width: .5)
                      .withRounded(value: 60)
                      .make()
                      .p16()
                      .onInkDoubleTap(() {})
                      .centered()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              _isPlaying
                  ? CupertinoIcons.stop_circle_fill
                  : CupertinoIcons.stop_circle_fill,
              color: Colors.white,
              size: 50,
            ),
          ).pOnly(bottom: context.percentHeight * 12)
        ],
        fit: StackFit.expand,
      ),
    );
  }
}
