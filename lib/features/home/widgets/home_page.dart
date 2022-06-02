import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/Model/songs_data.dart';
import 'package:music_player/features/home/widgets/music_genre.dart';
import 'package:music_player/features/home/widgets/song_details_large.dart';
import 'package:music_player/features/main_page.dart';
import 'package:music_player/features/play_song/widgets/play_song_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  void covers() async {
    try {
      for (int i = 0; i < 3; i++) {
        Metadata meta = await MetadataRetriever.fromFile(File(allSongs[i].path))
            .timeout(const Duration(seconds: 5));
        allSongs[i].cover = meta.albumArt ?? Uint8List(0);
      }
      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (allSongs.isNotEmpty) {
      covers();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        drawerEnableOpenDragGesture: false,
        drawer: const Drawer(
          backgroundColor: Colors.black54,
        ),
        backgroundColor: const Color(0xff1E1B2E),
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 27, left: 27),
                        child: GestureDetector(
                          onTap: () {
                            _key.currentState!.openDrawer();
                          },
                          child: SvgPicture.asset(
                            'assets/icons/menu.svg',
                            color: Colors.white,
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 27, right: 27),
                        child: SvgPicture.asset(
                          'assets/icons/search_icon.svg',
                          color: Colors.white,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 29),
                    child: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 27,
                            ),
                            MusicGenre('Rock', 'assets/images/rock_icon.png'),
                            SizedBox(
                              width: 12,
                            ),
                            MusicGenre('Metal', 'assets/images/metal_icon.png'),
                            SizedBox(
                              width: 12,
                            ),
                            MusicGenre('Pop', 'assets/images/pop_icon.png'),
                            SizedBox(
                              width: 12,
                            ),
                            MusicGenre('Rap', 'assets/images/rap_icon.png'),
                            SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: Row(
                      children: [
                        const Text(
                          'Recently Played',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            tabController.animateTo(1);
                          },
                          child: const Text(
                            'see all',
                            style: TextStyle(
                                color: Color(0xff919199),
                                fontSize: 16,
                                fontFamily: 'Gilroy'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 270,
                    child: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: allSongs.length > 3
                            ? Row(
                                children: [
                                  for (int i = 0; i < 3; i++)
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        SongDetailsLarge(
                                            i, i == 0 ? true : false),
                                      ],
                                    ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: Row(
                      children: [
                        const Text(
                          'Popular Songs',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            tabController.animateTo(2);
                          },
                          child: const Text(
                            'see all',
                            style: TextStyle(
                                color: Color(0xff919199),
                                fontSize: 16,
                                fontFamily: 'Gilroy'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      for (int index = 0; index < 3; index++)
                        onlinesongs.isEmpty
                            ? Container()
                            : Column(
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return PlayMusicPage(
                                              songIndexParam: index,
                                              isOnline: true,
                                            );
                                          }));
                                        },
                                        child: Container(
                                          height: 84,
                                          width: 327,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: const Color(0xff46435A)
                                                .withOpacity(0.32),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12, bottom: 12),
                                                  child: Hero(
                                                    tag: index.toString(),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: SizedBox(
                                                          width: 60,
                                                          height: 60,
                                                          child: Image.asset(
                                                            'images/default_cover_online.jpg',
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        onlinesongs[index].name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Gilroy',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        onlinesongs[index]
                                                            .singer,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xff919199),
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Gilroy'),
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
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
