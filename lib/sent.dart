import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hiptech_app/component/snackBarDeleteSent.dart';
import 'package:hiptech_app/networkApi/networkRequest.dart';
import 'package:intl/intl.dart';

import 'component/floatingActionButton.dart';
import 'component/popupConfirm.dart';
import 'component/theme/themeColor.dart';
import 'drawer.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class SentPage extends StatefulWidget {
  const SentPage({super.key});

  @override
  _SentPageState createState() => _SentPageState();
}

class _SentPageState extends State<SentPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SampleItem? selectedMenu;
  TextEditingController textController = TextEditingController();
  List items = [];
  List peopleSeen = [];
  List peopleNotSeen = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HandleFetchSent();
    // people = List<String>.generate(7, (i) => 'Name ${i + 1}');
    // getData();
  }

  void HandleFetchSent() async {
    List result = await NetworkRequest.fetchNotificationSent();
    setState(() {
      items = result;
    });
  }

  void HandleFetchDetailSeenNoti(String id) async {
    List result = await NetworkRequest.fetchStatusReadUser(id);
    setState(() {
      peopleSeen = result.where((people) => people.status != "UNREAD").toList();
      peopleNotSeen =
          result.where((people) => people.status == "UNREAD").toList();
    });
  }

  handleDelete(item) async {
    bool result = await NetworkRequest.deleteNotification(item.id);
    if (result) {
      HandleFetchSent();
    }
  }

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
              top: safeAreaInsets.top + 8,
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
                      "Sent Notification",
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
                    ? SlidableAutoCloseBehavior(
                        closeWhenOpened: true,
                        closeWhenTapped: true,
                        child: ListView.builder(
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Slidable(
                                    key: Key(item.id),
                                    endActionPane: ActionPane(
                                      dismissible: DismissiblePane(
                                        onDismissed: () {
                                          handleDelete(item);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBarDeleteSent(
                                                  item, context));
                                        },
                                      ),
                                      motion: const ScrollMotion(),
                                      children: [
                                        // SlidableAction(
                                        //   // An action can be bigger than the others.
                                        //   flex: 2,
                                        //   onPressed: (context) {
                                        //     // ScaffoldMessenger.of(context)
                                        //     //     .showSnackBar(snackBarStore());
                                        //   },
                                        //   backgroundColor: const Color.fromRGBO(
                                        //       83, 213, 96, 1),
                                        //   foregroundColor: Colors.white,
                                        //   icon: Icons.inventory_2,
                                        //   label: 'Save',
                                        // ),
                                        SlidableAction(
                                          // flex: 2,
                                          onPressed: (context2) => {
                                            showDialog<String>(
                                                context: context2,
                                                builder: (BuildContext
                                                        context1) =>
                                                    PopupConfirm(
                                                        context1,
                                                        "Delete",
                                                        "Are you sure want to delete?",
                                                        () {
                                                      handleDelete(item);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBarDeleteSent(
                                                                  item,
                                                                  context));
                                                      Navigator.pop(context2);
                                                    })),
                                          },
                                          backgroundColor: const Color.fromRGBO(
                                              226, 76, 75, 1),
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          // label: 'Delete',
                                        ),
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
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  scrollable: true,
                                                  content: Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                      minHeight: 200,
                                                      minWidth: double.infinity,
                                                    ),
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15,
                                                        vertical: 20),
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
                                                                        radius:
                                                                            22,
                                                                        backgroundColor: const Color.fromRGBO(
                                                                            22,
                                                                            177,
                                                                            239,
                                                                            1),
                                                                        // Border radius
                                                                        child:
                                                                            ClipOval(
                                                                          child:
                                                                              SizedBox.fromSize(
                                                                            size:
                                                                                const Size.fromRadius(20), // Image radius
                                                                            child:
                                                                                Image.asset("assets/userAvatarDefault.png", fit: BoxFit.cover),
                                                                          ),
                                                                        )),
                                                                    Text(
                                                                      "from: ${items[index].senderName}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        // fontWeight: FontWeight.w500,
                                                                        color: Color.fromRGBO(
                                                                            39,
                                                                            79,
                                                                            107,
                                                                            1),

                                                                        fontWeight:
                                                                            FontWeight.w500,
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
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  items[index].type ==
                                                                          "NOW"
                                                                      ? DateFormat(
                                                                              'HH:mm')
                                                                          .format(DateTime.parse(items[index]
                                                                              .createdAt))
                                                                      : DateFormat(
                                                                              'HH:mm')
                                                                          .format(
                                                                              DateTime.parse(items[index].sendTime)),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    // fontWeight: FontWeight.w500,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            39,
                                                                            79,
                                                                            107,
                                                                            1),

                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  items[index].type ==
                                                                          "NOW"
                                                                      ? DateFormat(
                                                                              'dd/MM/yyyy')
                                                                          .format(DateTime.parse(items[index]
                                                                              .createdAt))
                                                                      : DateFormat(
                                                                              'dd/MM/yyyy')
                                                                          .format(
                                                                              DateTime.parse(items[index].sendTime)),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    // fontWeight: FontWeight.w500,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            39,
                                                                            79,
                                                                            107,
                                                                            1),

                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 1,
                                                          width:
                                                              double.infinity,
                                                          color: const Color
                                                                  .fromRGBO(
                                                              232, 232, 232, 1),
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            const Text(
                                                              'Create at:',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                // fontWeight: FontWeight.w500,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        39,
                                                                        79,
                                                                        107,
                                                                        1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                DateFormat(
                                                                        'HH:mm dd/MM/yyyy')
                                                                    .format(DateTime.parse(
                                                                        items[index]
                                                                            .createdAt)),
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  // fontWeight: FontWeight.w500,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          87,
                                                                          89,
                                                                          90,
                                                                          1),

                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        // Container(
                                                        //   height: 1,
                                                        //   width:
                                                        //       double.infinity,
                                                        //   color: const Color
                                                        //           .fromRGBO(
                                                        //       232, 232, 232, 1),
                                                        //   margin:
                                                        //       const EdgeInsets
                                                        //               .symmetric(
                                                        //           horizontal:
                                                        //               10,
                                                        //           vertical: 5),
                                                        // ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            const Text(
                                                              'To:',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                // fontWeight: FontWeight.w500,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        39,
                                                                        79,
                                                                        107,
                                                                        1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                items[index]
                                                                            .receiverGroups
                                                                            .length !=
                                                                        0
                                                                    ? "Group ${items[index].receiverGroups}"
                                                                    : "Some people",
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 16,
                                                                  // fontWeight: FontWeight.w500,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          87,
                                                                          89,
                                                                          90,
                                                                          1),

                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 1,
                                                          width:
                                                              double.infinity,
                                                          color: const Color
                                                                  .fromRGBO(
                                                              232, 232, 232, 1),
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            const Text(
                                                              'Title:',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                // fontWeight: FontWeight.w500,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        39,
                                                                        79,
                                                                        107,
                                                                        1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                items[index]
                                                                    .title,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 16,
                                                                  // fontWeight: FontWeight.w500,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          87,
                                                                          89,
                                                                          90,
                                                                          1),

                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 1,
                                                          width:
                                                              double.infinity,
                                                          color: const Color
                                                                  .fromRGBO(
                                                              232, 232, 232, 1),
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                        ),
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                items[index]
                                                                    .content,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 16,
                                                                  // fontWeight: FontWeight.w500,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          87,
                                                                          89,
                                                                          90,
                                                                          1),

                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  height: 1,
                                                                  width: double
                                                                      .infinity,
                                                                  color: const Color
                                                                          .fromRGBO(
                                                                      232,
                                                                      232,
                                                                      232,
                                                                      1),
                                                                  margin: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    HandleFetchDetailSeenNoti(
                                                                        items[index]
                                                                            .id);
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return Dialog(
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                          // contentPadding:
                                                                          //     EdgeInsets.zero,
                                                                          // scrollable:
                                                                          //     true,
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                350,
                                                                            decoration:
                                                                                const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                                                            constraints:
                                                                                const BoxConstraints(
                                                                              minHeight: 350,
                                                                              minWidth: double.infinity,
                                                                            ),
                                                                            child:
                                                                                DefaultTabController(
                                                                              length: 2,
                                                                              child: Column(children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    IconButton(
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        icon: const Icon(
                                                                                          Icons.arrow_back_ios_new_rounded,
                                                                                          size: 30,
                                                                                          color: AppColors.textGreyPrimaryColor,
                                                                                        )),
                                                                                    const TabBar(labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), labelPadding: EdgeInsets.only(left: 10, right: 10), labelColor: AppColors.textPrimaryColor, unselectedLabelColor: Colors.grey, isScrollable: true, indicatorColor: AppColors.textPrimaryColor, indicatorSize: TabBarIndicatorSize.tab, tabs: [
                                                                                      Tab(
                                                                                        text: "Seen",
                                                                                      ),
                                                                                      Tab(text: "Not seen"),
                                                                                    ]),
                                                                                    const SizedBox(
                                                                                      width: 30,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                // const SizedBox(
                                                                                //   // color: AppColors.gradientColor1,
                                                                                //   width: double.infinity,
                                                                                //   child: Center(
                                                                                //     child: TabBar(labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), labelColor: AppColors.textPrimaryColor, unselectedLabelColor: Colors.grey, isScrollable: true, indicatorColor: AppColors.textPrimaryColor, indicatorSize: TabBarIndicatorSize.tab, tabs: [
                                                                                //       Tab(
                                                                                //         text: "Seen",
                                                                                //       ),
                                                                                //       Tab(text: "Not seen"),
                                                                                //     ]),
                                                                                //   ),
                                                                                // ),
                                                                                // Container(
                                                                                //   height: 3,
                                                                                //   width: double.infinity,
                                                                                //   color: Colors.grey,
                                                                                //   margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                                // ),
                                                                                Expanded(
                                                                                  // child: Container(),
                                                                                  child: TabBarView(
                                                                                    children: [
                                                                                      peopleNotSeen.isNotEmpty
                                                                                          ? SingleChildScrollView(
                                                                                              child: Column(
                                                                                                children: peopleNotSeen
                                                                                                    .map((e) => Padding(
                                                                                                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                                                                          child: ListTile(
                                                                                                            leading: CircleAvatar(
                                                                                                                radius: 20,
                                                                                                                backgroundColor: AppColors.primaryColor,
                                                                                                                // Border radius
                                                                                                                child: ClipOval(
                                                                                                                  child: SizedBox.fromSize(
                                                                                                                    size: const Size.fromRadius(17), // Image radius
                                                                                                                    child: Image.asset("assets/userAvatarDefault.png", fit: BoxFit.cover),
                                                                                                                  ),
                                                                                                                )),
                                                                                                            title: Text(
                                                                                                              e.nameUser,
                                                                                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ))
                                                                                                    .toList(),
                                                                                              ),
                                                                                            )
                                                                                          : const Center(
                                                                                              child: Text(
                                                                                                'Not views...',
                                                                                                style: TextStyle(),
                                                                                              ),
                                                                                            ),
                                                                                      peopleSeen.isNotEmpty
                                                                                          ? SingleChildScrollView(
                                                                                              child: Column(
                                                                                                children: peopleSeen
                                                                                                    .map((e) => Padding(
                                                                                                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                                                                          child: ListTile(
                                                                                                            leading: CircleAvatar(
                                                                                                                radius: 20,
                                                                                                                backgroundColor: AppColors.primaryColor,
                                                                                                                // Border radius
                                                                                                                child: ClipOval(
                                                                                                                  child: SizedBox.fromSize(
                                                                                                                    size: const Size.fromRadius(17), // Image radius
                                                                                                                    child: Image.asset("assets/userAvatarDefault.png", fit: BoxFit.cover),
                                                                                                                  ),
                                                                                                                )),
                                                                                                            title: Text(
                                                                                                              e.nameUser,
                                                                                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ))
                                                                                                    .toList(),
                                                                                              ),
                                                                                            )
                                                                                          : const Center(
                                                                                              child: Text(
                                                                                                'Awaiting views...',
                                                                                                style: TextStyle(),
                                                                                              ),
                                                                                            )
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ]),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "List viewers",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: AppColors
                                                                            .primaryColor),
                                                                  )),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  height: 1,
                                                                  width: double
                                                                      .infinity,
                                                                  color: const Color
                                                                          .fromRGBO(
                                                                      232,
                                                                      232,
                                                                      232,
                                                                      1),
                                                                  margin: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                                ),
                                                              ),
                                                            ]),
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
                                                  const Color.fromRGBO(
                                                      22, 177, 239, 1),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: items[index].isImportant
                                                    ? Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .notification_important_rounded,
                                                            color:
                                                                Color.fromRGBO(
                                                                    226,
                                                                    76,
                                                                    75,
                                                                    1),
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              items[index]
                                                                  .title,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                // fontWeight: FontWeight.w500,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        226,
                                                                        76,
                                                                        75,
                                                                        1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Text(
                                                        items[index].title,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          // fontWeight: FontWeight.w500,
                                                          color: Color.fromRGBO(
                                                              39, 79, 107, 1),
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                items[index].type == "NOW"
                                                    ? DateFormat('dd/MM/yyyy')
                                                        .format(DateTime.parse(
                                                            items[index]
                                                                .createdAt))
                                                    : DateFormat('dd/MM/yyyy')
                                                        .format(DateTime.parse(
                                                            items[index]
                                                                .sendTime)),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  // fontWeight: FontWeight.w500,
                                                  color: Color.fromRGBO(
                                                      39, 79, 107, 1),
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
                                              color: Color.fromRGBO(
                                                  39, 79, 107, 1),
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
                                    )),
                              ),
                            );
                          },
                          // separatorBuilder: (context, index) => const Divider(),
                        ),
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
        floatingActionButton: floatingButton(context));
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
