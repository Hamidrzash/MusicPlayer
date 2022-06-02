import 'package:flutter/material.dart';

class MusicGenre extends StatelessWidget {
  const MusicGenre(this.genreName, this.genreIcon, {Key? key})
      : super(key: key);
  final String genreName;
  final String genreIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff46435A).withOpacity(0.32),
        ),
        height: 40,
        width: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Text(
                  genreName,
                  style: const TextStyle(
                      fontSize: 18, color: Colors.white, fontFamily: 'Gilroy'),
                ),
                Image.asset(
                  genreIcon,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
