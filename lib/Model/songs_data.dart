import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:hive/hive.dart';

part 'songsdata.g.dart';

Future<bool> getdata() async {
  Directory directory = Directory('/storage/emulated/0/Music');
  List<FileSystemEntity> files = directory.listSync(recursive: true);

  for (FileSystemEntity element in files) {
    int x = 1;
    print(element.path);

    if (element.toString().contains('.mp3')) {
      Metadata meta =
          await MetadataRetriever.fromFile(File(element.path.toString()))
              .timeout(const Duration(seconds: 1), onTimeout: () {
        x = 0;
        return const Metadata();
      });
      if (x == 1) {
        allSongs.add(TrackData(
            meta.trackName ??
                element.uri.pathSegments.last.replaceAll('.mp3', ''),
            meta.trackArtistNames == null
                ? 'Unknown'
                : meta.trackArtistNames![0],
            Uint8List(0),
            element.path,
            element.statSync().modified.toString(),
            meta.trackDuration ?? 0));
      }
    }
  }
  allSongs.sort((a, b) => DateTime.parse(a.modified.toString())
      .compareTo(DateTime.parse(b.modified.toString())));
  allSongs = allSongs.reversed.toList();

  return true;
}

List<OnlineTrackData> onlinesongs = [];

class OnlineTrackData {
  String name;
  String singer;
  String url;
  bool isliked = false;
  OnlineTrackData(this.name, this.singer, this.url);
}

List<TrackData> allSongs = [];

@HiveType(typeId: 0)
class TrackData extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String singer;
  @HiveField(2)
  Uint8List cover;
  @HiveField(3)
  String path;
  @HiveField(4)
  String modified;
  @HiveField(5)
  int duration;
  @HiveField(6)
  bool isLiked = false;
  TrackData(this.name, this.singer, this.cover, this.path, this.modified,
      this.duration);

  liked(bool isliked) {
    if (isliked) {
      isLiked = true;
    } else {
      isLiked = false;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'singer': singer,
      'path': path,
      'modified': modified,
      'duration': duration,
      'isliked': isLiked == false ? 0 : 1,
    };
  }

  @override
  String toString() {
    return 'track{id: $name, singer: $singer, path: $path}';
  }
}
