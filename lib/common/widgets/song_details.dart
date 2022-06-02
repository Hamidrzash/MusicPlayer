import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_player/Model/songs_data.dart';
import 'package:music_player/features/play_song/widgets/play_song_page.dart';

class SongDetails extends StatelessWidget {
  const SongDetails(this.songIndex, {Key? key}) : super(key: key);

  final int songIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return PlayMusicPage(
            songIndexParam: songIndex,
          );
        }));
      },
      child: Container(
        height: 84,
        width: 327,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xff46435A).withOpacity(0.32),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Hero(
                  tag: songIndex.toString(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: allSongs[songIndex].cover != Uint8List(0)
                          ? Image.memory(allSongs[songIndex].cover,
                              fit: BoxFit.fill,
                              errorBuilder: (BuildContext context, e, ee) {
                              return const SizedBox(
                                width: 100,
                                height: 100,
                              );
                            })
                          : const SizedBox(
                              width: 100,
                              height: 100,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      allSongs[songIndex].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      allSongs[songIndex].singer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
    );
  }
}
