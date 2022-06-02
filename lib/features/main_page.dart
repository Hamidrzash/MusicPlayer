import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:music_player/Model/songs_data.dart';
import 'package:music_player/common/utils.dart';
import 'package:music_player/features/all_songs/widgets/all_songs_page.dart';
import 'package:music_player/features/online_songs/widgets/online_songs_page.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'all_songs/widgets/all_songs_page.dart';
import 'home/widgets/home_page.dart';

late TabController tabController;
int pageIndex = 0;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    final Box userBox = Hive.box('trackDataBox');
    final eventsFromHive = userBox.get('get') != null
        ? userBox.get('get').cast<TrackData>() ?? []
        : allSongs;

    allSongs = eventsFromHive;

    tabController = TabController(length: tabPages.length, vsync: this);
    tabController.addListener(() {
      if (tabController.index != pageIndex) {
        setState(() {});
        pageIndex = tabController.index;
      }
    });
    Utils.getStoragePermission();
    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  var tabPages = [const HomePage(), const AllSongsPage(), const OnlinePlay()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff1E1B2E),
        body: tabPages[tabController.index],
        bottomNavigationBar: Stack(
          children: [
            Container(
              width: double.infinity,
              height: (MediaQuery.of(context).size.height / 10) - 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: const Alignment(0.4, 0),
                  colors: [
                    const Color(0xffFFFFFF).withOpacity(0.28),
                    const Color(0xff343243),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 1.5,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Material(
                    elevation: 0,
                    color: const Color(0xff343243),
                    child: TabBar(
                      indicatorColor: Colors.transparent,
                      labelColor: const Color(0xff9935ED),
                      unselectedLabelColor: Colors.white,
                      tabs: [
                        tabController.index == 0
                            ? SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height / 10) -
                                        5,
                                child: Center(
                                    child: SimpleShadow(
                                  color: const Color(0xffA02FFF),
                                  offset: const Offset(0, 1),
                                  opacity: 0.76,
                                  sigma: 5,
                                  child: SvgPicture.asset(
                                    'assets/icons/home.svg',
                                    height: 24,
                                    width: 24,
                                    color: const Color(0xff9935ED),
                                    // size: 30,
                                    // shadows: [
                                    //   BoxShadow(
                                    //     spreadRadius: 100,
                                    //     blurRadius: 30,
                                    //     color: Color(0xffA02FFF),
                                    //     offset: Offset(0, 2),
                                    //   ),
                                    // ],
                                  ),
                                )),
                              )
                            : SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height / 10) -
                                        5,
                                child: SvgPicture.asset(
                                  'assets/icons/home.svg',
                                  height: 24,
                                  width: 24,
                                  color: Colors.white,
                                )),
                        tabController.index == 1
                            ? SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height / 10) -
                                        5,
                                child: const Center(
                                    child: DecoratedIcon(
                                  Icons.clear_all_rounded,
                                  size: 40,
                                  shadows: [
                                    BoxShadow(
                                      spreadRadius: 100,
                                      blurRadius: 30,
                                      color: Color(0xffA02FFF),
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                )),
                              )
                            : SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height / 10) -
                                        5,
                                child: const Icon(
                                  Icons.clear_all_rounded,
                                  size: 40,
                                )),
                        tabController.index == 2
                            ? SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height / 10) -
                                        5,
                                child: Center(
                                    child: SimpleShadow(
                                  color: const Color(0xffA02FFF),
                                  offset: const Offset(0, 1),
                                  opacity: 0.76,
                                  sigma: 5,
                                  child: SvgPicture.asset(
                                    'assets/icons/like.svg',
                                    height: 22,
                                    width: 22,
                                    color: const Color(0xff9935ED),
                                    // size: 30,
                                    // shadows: [
                                    //   BoxShadow(
                                    //     spreadRadius: 100,
                                    //     blurRadius: 30,
                                    //     color: Color(0xffA02FFF),
                                    //     offset: Offset(0, 2),
                                    //   ),
                                    // ],
                                  ),
                                )),
                              )
                            : SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height / 10) -
                                        5,
                                child: SvgPicture.asset(
                                  'assets/icons/like.svg',
                                  height: 22,
                                  width: 22,
                                  color: Colors.white,
                                )),
                      ],
                      controller: tabController,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
