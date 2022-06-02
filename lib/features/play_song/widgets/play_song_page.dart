import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:music_player/Model/songs_data.dart';

String lyrics = '';
var player = AudioPlayer();
int songIndex = 0;
String heroName = '';
bool isOnline = false;

class PlayMusicPage extends StatefulWidget {
  PlayMusicPage(
      {Key? key,
      required int songIndexParam,
      String hero = '',
      bool isOnline = false})
      : super(key: key) {
    songIndex = songIndexParam;
    heroName = hero;
    isOnline = isOnline;
  }

  @override
  PlayMusicPageState createState() => PlayMusicPageState();
}

class PlayMusicPageState extends State<PlayMusicPage> {
  bool isPlaying = false;
  int resume = 0;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void getTime() async {
    if (!isOnline) {
      player = AudioPlayer();
      var filePath = allSongs[songIndex].path;
      player.setFilePath(filePath);
      player.setAudioSource(AudioSource.uri(Uri.file(filePath)));
      player.play();
      isPlaying = true;
      setState(() {});
    } else {
      player = AudioPlayer();
      //var filePath = allSongs[songIndex].path;
      //player.setFilePath(filePath);
      //player.setAudioSource(AudioSource.uri(Uri.file(filePath)));
      player.setUrl(onlinesongs[songIndex].url);
      player.play();
      isPlaying = true;
      setState(() {});
    }
  }

  double onEnd() {
    isPlaying = true;
    player.seek(const Duration(milliseconds: 0));

    return 0;
  }

  Future<void> showMusicLyrics(String query) async {
    var result =
        await http.get(Uri.parse('https://www.google.com/search?q=$query'));
    var document = parse(result.body);
    var priceElement = document.getElementsByClassName('BNeawe tAd8D AP7Wnd');
    lyrics = '${priceElement[0].text}\n\n\n';
    lyrics += priceElement[4].text;
    setState(() {});
  }

  int duration = 60000;
  @override
  void initState() {
    // TODO: implement initState

    showMusicLyrics(
        '${!isOnline ? allSongs[songIndex].name : onlinesongs[songIndex].name} ${!isOnline ? allSongs[songIndex].singer : onlinesongs[songIndex].singer} lyrics');
    getTime();
    if (isOnline) {
      player.durationStream.listen((event) {
        duration = event!.inMilliseconds;
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    lyrics = '';
    player.pause();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff1E1B2E),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 27, left: 27, top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Color(0xffB0B0B0),
                          ),
                        ),
                        const Text(
                          'Playing Now',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.bold,
                              fontSize: 19),
                        ),
                        const Icon(
                          Icons.more_horiz_rounded,
                          color: Color(0xffB0B0B0),
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                  //end top
                  const SizedBox(
                    height: 45,
                  ),
                  Center(
                    child: PhysicalModel(
                      color: Colors.transparent,
                      elevation: 10,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      child: Hero(
                        tag: heroName == '' ? songIndex.toString() : heroName,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: !isOnline
                                ? Image.memory(
                                    allSongs[songIndex].cover,
                                    height: 285,
                                    width: 285,
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, h, hh) {
                                      return const SizedBox(
                                        height: 285,
                                        width: 285,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    'assets/images/default_cover_online.jpg',
                                    width: 285,
                                    height: 285,
                                    fit: BoxFit.fill,
                                  )),
                      ),
                    ),
                  ),
                  //end image
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 46),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            !isOnline
                                ? allSongs[songIndex].name
                                : onlinesongs[songIndex].name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (!isOnline) {
                              if (!allSongs[songIndex].isLiked) {
                                allSongs[songIndex].liked(true);

                                //var name = box.get('name');
                                //print('Name: $name');
                              } else {
                                allSongs[songIndex].liked(false);
                              }
                            } else {
                              if (!onlinesongs[songIndex].isliked) {
                                onlinesongs[songIndex].isliked = true;

                                //var name = box.get('name');
                                //print('Name: $name');
                              } else {
                                onlinesongs[songIndex].isliked = false;
                              }
                            }
                            setState(() {});
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 50,
                              width: 50,
                              color: !isOnline
                                  ? allSongs[songIndex].isLiked
                                      ? const Color(0xff46435A)
                                          .withOpacity(0.32)
                                      : const Color(0xff46435A)
                                          .withOpacity(0.20)
                                  : !onlinesongs[songIndex].isliked
                                      ? const Color(0xff46435A)
                                          .withOpacity(0.32)
                                      : const Color(0xff46435A)
                                          .withOpacity(0.20),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/like.svg',
                                  color: !isOnline
                                      ? !allSongs[songIndex].isLiked
                                          ? Colors.white
                                          : const Color(0xff9935ED)
                                      : !onlinesongs[songIndex].isliked
                                          ? Colors.white
                                          : const Color(0xff9935ED),
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 46.0, right: 46.0),
                      child: Text(
                        !isOnline
                            ? allSongs[songIndex].singer
                            : onlinesongs[songIndex].singer,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            color: Color(0xff919199),
                            fontSize: 18,
                            fontFamily: 'Gilroy'),
                      ),
                    ),
                  ),

                  StreamBuilder(
                    stream: player.createPositionStream(
                        minPeriod: const Duration(milliseconds: 16),
                        maxPeriod: const Duration(milliseconds: 16)),
                    builder: (BuildContext context,
                        AsyncSnapshot<Duration> snapshot) {
                      return Slider(
                        value: (snapshot.data != null
                                    ? snapshot.data!.inMilliseconds.toDouble()
                                    : 0) >=
                                (!isOnline
                                    ? allSongs[songIndex].duration
                                    : duration)
                            ? onEnd()
                            : snapshot.data!.inMilliseconds.toDouble(),
                        inactiveColor:
                            const Color(0xff9935ED).withOpacity(0.30),
                        activeColor: const Color(0xff9935ED),
                        thumbColor: const Color(0xff9935ED),
                        min: 0,
                        max: !isOnline
                            ? allSongs[songIndex].duration.toDouble()
                            : duration.toDouble(),
                        onChanged: (double value) {
                          setState(() {
                            isPlaying = true;
                            player.seek(Duration(milliseconds: value.toInt()));
                            if (!player.playing) {
                              resume = value.toInt();
                              isPlaying = false;
                              //player.play();
                            }
                          });
                        },
                      );
                    },
                  ),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder(
                          stream: player.createPositionStream(
                              minPeriod: const Duration(seconds: 1),
                              maxPeriod: const Duration(seconds: 1)),
                          builder: (BuildContext context,
                              AsyncSnapshot<Duration> snapshot) {
                            return Text(
                              '${snapshot.data!.inMinutes}:${snapshot.data!.inSeconds % 60}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          '/${((!isOnline ? allSongs[songIndex].duration : duration) / 1000) ~/ 60}:${(((!isOnline ? allSongs[songIndex].duration : duration) / 1000) % 60).round()}',
                          style: const TextStyle(
                              color: Color(0xff919199),
                              fontSize: 18,
                              fontFamily: 'Gilroy'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 17,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/refresh.svg',
                          //size: 35,
                          height: 25,
                          width: 25,

                          color: const Color(0xffB0B0B0),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (songIndex > 0) {
                              lyrics = '';
                              player.pause();
                              player.dispose();
                              songIndex--;
                              getTime();
                              setState(() {});
                            }
                          },
                          child: SvgPicture.asset(
                            'assets/icons/last.svg',
                            //size: 35,
                            height: 27,
                            width: 27,

                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (!isPlaying) {
                              player.play();
                              isPlaying = true;
                            } else {
                              player.pause();
                              isPlaying = false;
                            }
                            setState(() {});
                          },
                          child: Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff9935ED).withOpacity(0.42),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(
                                      0, 7), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(40),
                              color: const Color(0xff9935ED),
                            ),
                            child: Center(
                                child: !isPlaying
                                    ? const Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 50,
                                      )
                                    : const Icon(
                                        Icons.pause_rounded,
                                        color: Colors.white,
                                        size: 50,
                                      )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            //skip
                            if (songIndex <
                                (!isOnline
                                    ? allSongs.length - 1
                                    : onlinesongs.length - 1)) {
                              lyrics = '';
                              player.pause();
                              player.dispose();
                              songIndex++;
                              getTime();
                              setState(() {});
                            }
                          },
                          child: SvgPicture.asset(
                            'assets/icons/next.svg',
                            //size: 35,
                            height: 27,
                            width: 27,

                            color: Colors.white,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/icons/volume.svg',
                          //size: 35,
                          height: 35,
                          width: 35,

                          color: const Color(0xffB0B0B0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              DraggableScrollableSheet(
                  minChildSize: 0.1,
                  maxChildSize: 0.9,
                  initialChildSize: 0.1,
                  builder: (context, scroll) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      child: GlassContainer(
                        borderRadius: BorderRadius.zero,
                        shadowStrength: 0,
                        opacity: 0.05,
                        blur: 10,
                        border: Border.all(width: 0),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(overscroll: false),
                          child: SingleChildScrollView(
                            controller: scroll,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.keyboard_arrow_up_rounded,
                                        color: Color(0xffB0B0B0),
                                      ),
                                      Text(
                                        'Lyrics',
                                        style: TextStyle(
                                            color: Color(0xffB0B0B0),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Gilroy'),
                                      ),
                                    ],
                                  ),
                                ),
                                lyrics != ''
                                    ? Padding(
                                        padding: const EdgeInsets.all(27),
                                        child: Text(
                                          lyrics,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              height: 1.6,
                                              color: Color(0xffB0B0B0),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Gilroy'),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
            ],
          ),
        ));
  }
}
