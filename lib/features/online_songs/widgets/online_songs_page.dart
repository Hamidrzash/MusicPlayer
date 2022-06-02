import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:music_player/Model/songs_data.dart';
import 'package:music_player/features/play_song/widgets/play_song_page.dart';

bool isDone = false;

class OnlinePlay extends StatefulWidget {
  const OnlinePlay({Key? key}) : super(key: key);

  @override
  OnlinePlayState createState() => OnlinePlayState();
}

class OnlinePlayState extends State<OnlinePlay> {
  Future<void> getMusicData() async {
    var result = await http.get(Uri.parse('https://iamammiin.ir/musics'));
    var document = parse(result.body);
    var priceElement = document.getElementsByTagName('script');
    int start = 0;
    String text = priceElement[0].text;
    for (int i = 0; i < 62; i++) {
      String x = (text.substring(
          text.indexOf('{', start), text.indexOf('}', start) + 1));
      text = text.replaceRange(0, text.indexOf('}', start) + 2, '');
      start = text.indexOf('{');
      Map y = json.decode(x);
      int index = 0;
      String name = '';
      String singer = '';
      String url = '';
      for (var element in y.values) {
        if (index == 1) {
          name = element;
        }
        if (index == 2) {
          singer = element;
        }
        if (index == 4) {
          url = element;
        }
        index++;
      }
      onlinesongs.add(OnlineTrackData(name, singer, url));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (onlinesongs.isEmpty) {
      getAllSongs();
    }
    setState(() {});

    super.initState();
  }

  void getAllSongs() async {
    isDone = false;
    onlinesongs.clear();
    await getMusicData();
    isDone = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E1B2E),
      body: SafeArea(
        child: isDone
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${onlinesongs.length.toString()} Founded',
                          style: const TextStyle(
                              color: Color(0xff919199),
                              fontSize: 20,
                              fontFamily: 'Gilroy'),
                        ),
                        GestureDetector(
                          onTap: () {
                            getAllSongs();
                          },
                          child: const Icon(
                            Icons.refresh_rounded,
                            size: 25,
                            color: Color(0xff919199),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: Colors.white10,
                  ),
                  Flexible(
                    child: Scrollbar(
                      radius: const Radius.circular(10),
                      child: ScrollConfiguration(
                        behavior:
                            const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView.builder(
                          itemCount: onlinesongs.length,
                          itemBuilder: (context, int songIndex) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return PlayMusicPage(
                                        songIndexParam: songIndex,
                                        isOnline: true,
                                      );
                                    }));
                                  },
                                  child: Container(
                                    height: 84,
                                    width: 327,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: const Color(0xff46435A)
                                          .withOpacity(0.32),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12, bottom: 12),
                                            child: Hero(
                                              tag: songIndex.toString(),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: SizedBox(
                                                    width: 60,
                                                    height: 60,
                                                    child: Image.asset(
                                                      'assets/images/default_cover_online.jpg',
                                                      fit: BoxFit.fill,
                                                    )),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  onlinesongs[songIndex].name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Gilroy',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  onlinesongs[songIndex].singer,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Color(0xff919199),
                                                      fontSize: 16,
                                                      fontFamily: 'Gilroy'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.more_horiz_rounded,
                                            color: Color(0xffB0B0B0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: (SpinKitChasingDots(
                  color: Color(0xff46435A),
                  size: 50,
                )),
              ),
      ),
    );
  }
}
