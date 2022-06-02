import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:music_player/Model/songs_data.dart';
import 'package:music_player/features/play_song/widgets/play_song_page.dart';

class SongDetailsLarge extends StatelessWidget {
  const SongDetailsLarge(this.songIndex, this.isHaveShadow, {Key? key})
      : super(key: key);
  final int songIndex;
  final bool isHaveShadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return PlayMusicPage(
            songIndexParam: songIndex,
            hero: '-$songIndex',
          );
        }));
      },
      child: Hero(
        tag: '-$songIndex',
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: !isHaveShadow
                  ? SizedBox(
                      height: 222,
                      width: 180,
                      child: Image.memory(
                        allSongs[songIndex].cover,
                        fit: BoxFit.fill,
                        errorBuilder: (context, e, ee) {
                          return Container();
                        },
                      ))
                  : ClipRRect(
                      child: SizedBox(
                        height: 250,
                        width: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          key: key,
                          children: <Widget>[
                            Transform.translate(
                              offset: const Offset(0, 0),
                              child: Transform.scale(
                                scale: 1.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: SizedBox(
                                    height: 223,
                                    width: 192,
                                    child: Image.memory(
                                      allSongs[songIndex].cover,
                                      fit: BoxFit.fill,
                                      errorBuilder: (context, e, ee) {
                                        return Container();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Container(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                height: 223,
                                width: 192,
                                child: Image.memory(
                                  allSongs[songIndex].cover,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, e, ee) {
                                    return Container();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
            Positioned(
              bottom: !isHaveShadow ? 7 : 20,
              left: !isHaveShadow ? 1 : 15,
              right: !isHaveShadow ? 1 : 15,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 6, sigmaX: 6),
                    child: Container(
                      //constraints: BoxConstraints.expand(),
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xff2A283C).withOpacity(0.7),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Material(
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          allSongs[songIndex].name,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          allSongs[songIndex].singer,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          style: const TextStyle(
                                              color: Color(0xff919199),
                                              fontSize: 16,
                                              fontFamily: 'Gilroy'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xff9935ED)
                                              .withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: const Offset(-2,
                                              5), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(40),
                                      color: const Color(0xff9935ED),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
