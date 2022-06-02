import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:music_player/Model/songs_data.dart';
import 'package:music_player/common/widgets/song_details.dart';

bool isDone = false;
int startNumber = 0;
int endNumber = 15;
int y = 1;
ScrollController controller = ScrollController();

class AllSongsPage extends StatefulWidget {
  const AllSongsPage({Key? key}) : super(key: key);

  @override
  AllSongsPageState createState() => AllSongsPageState();
}

class AllSongsPageState extends State<AllSongsPage> {
  @override
  void initState() {
    // TODO: implement initState

    if (allSongs.isEmpty) {
      getAllSongs();
    } else {
      isDone = true;
      updateCover();
    }
    setState(() {});

    controller = ScrollController();
    controller.addListener(() async {
      if (controller.position.userScrollDirection == ScrollDirection.reverse) {
        if (controller.offset.round() >
            y * controller.position.viewportDimension.round()) {
          for (int i = 0; i < 6 * y; i++) {
            allSongs[i].cover = Uint8List(0);
          }
          y++;

          endNumber += 10;
          await updateCover();

          setState(() {});
        }
      } else if (controller.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (controller.offset.round() <
            y * controller.position.viewportDimension.round()) {
          y--;
          await updateCoverReverse();
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  late Box box;
  void getAllSongs() async {
    allSongs.clear();
    await getdata();
    isDone = true;
    final Box userBox = Hive.box('trackDataBox');
    userBox.put('get', allSongs);
    await updateCover();
    setState(() {});
  }

  Future<void> updateCoverReverse() async {
    for (int i = 6 * y + 1; i >= y + 1 * 6 - 6; i--) {
      Metadata meta = await MetadataRetriever.fromFile(File(allSongs[i].path))
          .timeout(const Duration(seconds: 1));

      allSongs[i].cover = meta.albumArt ?? Uint8List(0);
    }
  }

  Future<void> updateCover() async {
    for (startNumber; startNumber < endNumber; startNumber++) {
      Metadata meta =
          await MetadataRetriever.fromFile(File(allSongs[startNumber].path))
              .timeout(const Duration(seconds: 1));
      allSongs[startNumber].cover = meta.albumArt ?? Uint8List(0);
    }
    startNumber = endNumber;

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
                          '${allSongs.length.toString()} Founded',
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
                          controller: controller,
                          itemCount: allSongs.length,
                          itemBuilder: (context, int index) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                SongDetails(
                                  index,
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
