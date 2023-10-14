import 'package:flutter/material.dart';
import 'package:hiptech_app/networkApi/networkRequest.dart';
import 'package:intl/intl.dart';

import 'component/theme/themeColor.dart';
import 'drawer.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SampleItem? selectedMenu;
  int idexRemove = -1;
  TextEditingController textController = TextEditingController();
  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idexRemove = -1;
    HandleFetchAll();
    // getData();
  }

  void HandleFetchAll() async {
    List result = await NetworkRequest.fetchNotificationsArchived();
    setState(() {
      items = result;
    });
  }

  // handleDelete(index) {
  //   setState(() {
  //     items.removeAt(index);
  //     idexRemove = index;
  //   });
  // }

  // handleAdd(value) {
  //   setState(() {
  //     items.add(value);
  //   });
  // }

  // handleBackItem(value) {
  //   setState(() {
  //     items.insert(idexRemove, value);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: const DrawerOnly(),
      body: Container(
        color: const Color.fromRGBO(242, 247, 250, 1),
        padding: EdgeInsets.only(
            top: safeAreaInsets.top + 5,
            left: safeAreaInsets.left + 12,
            right: safeAreaInsets.right + 12,
            bottom: safeAreaInsets.bottom),
        child: Column(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: Image.asset(
                    "assets/menuButton.png",
                    fit: BoxFit.cover,
                    height: 42,
                    width: 42,
                  ),
                ),
                Container(
                  // padding: const EdgeInsets.only(left: 8),
                  child: const Text(
                    "Archive Notification",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(110, 214, 235, 1),
                          Color.fromRGBO(39, 94, 174, 1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(30),
                        child: Image.asset(
                          "assets/userAvatarDefault.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: items.isNotEmpty
                  ? ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white, // Màu nền của Container
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 20,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Builder(
                            builder: (context) => GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        contentPadding: EdgeInsets.zero,
                                        scrollable: true,
                                        content: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 20),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          CircleAvatar(
                                                              radius: 22,
                                                              backgroundColor:
                                                                  const Color
                                                                          .fromRGBO(
                                                                      22,
                                                                      177,
                                                                      239,
                                                                      1),
                                                              // Border radius
                                                              child: ClipOval(
                                                                child: SizedBox
                                                                    .fromSize(
                                                                  size: const Size
                                                                          .fromRadius(
                                                                      20), // Image radius
                                                                  child: Image.asset(
                                                                      "assets/userAvatarDefault.png",
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              )),
                                                          const Text(
                                                            "from: Admin",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              // fontWeight: FontWeight.w500,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      39,
                                                                      79,
                                                                      107,
                                                                      1),

                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                    ],
                                                  ),
                                                  // const SizedBox(
                                                  //   width: 30,
                                                  // ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        items[index].type ==
                                                                "NOW"
                                                            ? DateFormat(
                                                                    'HH:mm')
                                                                .format(DateTime
                                                                    .parse(items[
                                                                            index]
                                                                        .createdAt))
                                                            : DateFormat(
                                                                    'HH:mm')
                                                                .format(DateTime
                                                                    .parse(items[
                                                                            index]
                                                                        .sendTime)),
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          // fontWeight: FontWeight.w500,
                                                          color: Color.fromRGBO(
                                                              39, 79, 107, 1),

                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        items[index].type ==
                                                                "NOW"
                                                            ? DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(DateTime
                                                                    .parse(items[
                                                                            index]
                                                                        .createdAt))
                                                            : DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(DateTime
                                                                    .parse(items[
                                                                            index]
                                                                        .sendTime)),
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          // fontWeight: FontWeight.w500,
                                                          color: Color.fromRGBO(
                                                              39, 79, 107, 1),

                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 1,
                                                width: double.infinity,
                                                color: const Color.fromRGBO(
                                                    232, 232, 232, 1),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                              ),
                                              const Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'To:',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      // fontWeight: FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                          39, 79, 107, 1),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "all",
                                                      overflow:
                                                          TextOverflow.visible,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        // fontWeight: FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            87, 89, 90, 1),

                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 1,
                                                width: double.infinity,
                                                color: const Color.fromRGBO(
                                                    232, 232, 232, 1),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const Text(
                                                    'Title:',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      // fontWeight: FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                          39, 79, 107, 1),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      items[index].title,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        // fontWeight: FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            87, 89, 90, 1),

                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 1,
                                                width: double.infinity,
                                                color: const Color.fromRGBO(
                                                    232, 232, 232, 1),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      items[index].content,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        // fontWeight: FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            87, 89, 90, 1),

                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // actions: [
                                        //   TextButton(
                                        //       child:
                                        //           const Text("Submit"),
                                        //       onPressed: () {
                                        //         // your code
                                        //       })
                                        // ],
                                      );
                                    });
                              },
                              child: ListTile(
                                // tileColor: Colors.amberAccent,
                                leading: CircleAvatar(
                                    radius: 22,
                                    backgroundColor:
                                        const Color.fromRGBO(22, 177, 239, 1),
                                    // Border radius
                                    child: ClipOval(
                                      child: SizedBox.fromSize(
                                        size: const Size.fromRadius(
                                            20), // Image radius
                                        child: Image.asset(
                                            "assets/userAvatarDefault.png",
                                            fit: BoxFit.cover),
                                      ),
                                    )),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        items[index].title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          // fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(39, 79, 107, 1),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      items[index].type == "NOW"
                                          ? DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                  items[index].createdAt))
                                          : DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                  items[index].sendTime)),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        // fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(39, 79, 107, 1),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  items[index].content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(39, 79, 107, 1),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                // onTap: () {
                                //   final slidable = Slidable.of(context);
                                //   final isClosed = slidable?.actionPaneType.value ==
                                //       ActionPaneType.none;
                                //   if (isClosed) {
                                //     slidable?.openStartActionPane();
                                //   } else {
                                //     slidable?.close();
                                //   }
                                // },
                              ),
                            ),
                          ),
                        );
                      },
                      // separatorBuilder: (context, index) => const Divider(),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/notalarm.png",
                            height: 200,
                            width: 200,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'No notification',
                            style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(210, 211, 211, 90)),
                          )
                        ],
                      ),
                    ))
        ]),
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;

  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  late Color color;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint paint;
    paint = Paint()..color = color;
    paint = paint..isAntiAlias = true;
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, paint);
  }
}

class HorizontalTabIndicator extends Decoration {
  final Color color;
  final double width;
  final double height;

  const HorizontalTabIndicator(
      {required this.color, required this.width, required this.height});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _HorizontalPainter(color: color, width: width, height: height);
  }
}

class _HorizontalPainter extends BoxPainter {
  final double width;
  final double height;
  late Color color;

  _HorizontalPainter(
      {required this.color, required this.width, required this.height});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Rect rect = Rect.fromLTWH(
      offset.dx,
      cfg.size!.height - height,
      cfg.size!.width,
      height,
    );

    final Paint paint = Paint()
      ..color = color
      ..isAntiAlias = true;

    canvas.drawRect(rect, paint);
  }
}
