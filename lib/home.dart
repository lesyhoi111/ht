import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hiptech_app/component/snackBarError.dart';
import 'package:hiptech_app/component/snackBarNoti.dart';
import 'package:hiptech_app/model/userProfile.dart';
import 'package:hiptech_app/provider/userProfile_Provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'component/floatingActionButton.dart';
import 'component/popupConfirm.dart';
import 'component/snackBarDelete.dart';
import 'component/theme/themeColor.dart';
import 'drawer.dart';
import 'networkApi/networkRequest.dart';
import 'provider/fetchNotification_Provider.dart';

enum SampleItem { itemOne, itemTwo }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SampleItem? selectedMenu;
  String idexRemove = "";
  TextEditingController textController = TextEditingController();
  List items = [];
  List itemsImportant = [];
  bool isAdmin = false;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // HandleFetchAll();
    HandleFetchImportant();
    idexRemove = "";
    Provider.of<FetchNotifiCationProvider>(context, listen: false)
        .fetchAllNotification();
    // HandleGetRole();

    // getData();
  }

  void HandleGetRole() async {
    UserProfile userProfile = await NetworkRequest.getRole();
    String? role = userProfile.role;
    setState(() {
      isAdmin = role?.contains("ROLE_ADMIN") == true ? true : false;
    });
  }

  void HandleFetchAll() async {
    //   List result = await NetworkRequest.fetchNotifications();
    //   setState(() {
    //     items = result;
    //   });
    Provider.of<FetchNotifiCationProvider>(context, listen: false)
        .reFetchAllNotification();
  }

  void HandleFetchImportant() async {
    List result = await NetworkRequest.fetchNotificationsImportant();
    setState(() {
      itemsImportant = result;
    });
  }

  void handlePutSeenNoti(String id) async {
    Map<String, dynamic> params = {
      "userNotifIds": [id],
      "notifStatus": "READ"
    };
    bool result = await NetworkRequest.putStatusRead(params);
    if (result) {
      HandleFetchAll();
      HandleFetchImportant();
    }
  }

  handleSeen(String id) {
    handlePutSeenNoti(id);
  }

  void handlePutArchivedNoti(List<String> listId) async {
    Map<String, dynamic> params = {
      "userNotifIds": listId,
      "notifStatus": "ARCHIVED"
    };
    bool result = await NetworkRequest.putStatusRead(params);
    if (result) {
      HandleFetchAll();
      HandleFetchImportant();
    }
  }

  void handleRePutArchivedNoti(List<String> listId) async {
    Map<String, dynamic> params = {
      "userNotifIds": listId,
      "notifStatus": "READ"
    };
    bool result = await NetworkRequest.putStatusRead(params);
    if (result) {
      HandleFetchAll();
      HandleFetchImportant();
    }
  }

  handleArchivedOneItem(String Id, String status) {
    if (status == "UNREAD") {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarError(context, 'Please read before archive.'));
      return;
    }
    setState(() {
      idexRemove = Id;
    });
    List<String> listIdArchived = [Id];
    handlePutArchivedNoti(listIdArchived);
  }

  handleReArchivedOneItem() {
    List<String> listIdArchived = [idexRemove];
    handleRePutArchivedNoti(listIdArchived);
  }

  handleArchivedAll(List listItemAll) {
    List<String> listIdArchived = [];
    for (var item in listItemAll) {
      if (item.status == "READ") {
        listIdArchived.add(item.id);
      }
    }
    handlePutArchivedNoti(listIdArchived);
  }

  handleDelete(index) {
    setState(() {
      items.removeAt(index);
      idexRemove = index;
    });
  }

  handleBackItem(value) {
    // setState(() {
    //   items.insert(idexRemove, value);
    // });
  }
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;
    TabController tabController = TabController(length: 2, vsync: this);

    return Consumer<UserProfileProvider>(builder: (context, value, child) {
      isAdmin = value.Role?.contains("ROLE_ADMIN") == true ? true : false;
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
                      "Incoming Notification",
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
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: const Color.fromRGBO(242, 247, 250, 1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                        labelStyle: const TextStyle(fontSize: 16),
                        labelPadding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 0),
                        controller: tabController,
                        labelColor: AppColors.primaryColor,
                        unselectedLabelColor: Colors.grey,
                        isScrollable: true,
                        indicatorColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: const HorizontalTabIndicator(
                            color: AppColors.primaryColor,
                            width: 10,
                            height: 3),
                        tabs: const [
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("All"),
                            ),
                          ),
                          Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Important"),
                            ),
                          ),
                        ]),
                  ),
                ),
                Row(
                  children: [
                    // PopupMenuButton<SampleItem>(
                    //   padding: const EdgeInsets.only(
                    //       left: 1, right: 1, top: 1, bottom: 1),
                    //   color: Colors.white,
                    //   offset: const Offset(0, 20),
                    //   shadowColor: Colors.grey,
                    //   elevation: 10,
                    //   icon: const Icon(
                    //     Icons.filter_alt,
                    //     size: 32,
                    //     color: Colors.grey,
                    //   ),
                    //   initialValue: selectedMenu,
                    //   onSelected: (SampleItem item) {
                    //     switch (item) {
                    //       case SampleItem.itemOne:
                    //         break;
                    //       case SampleItem.itemTwo:
                    //         break;
                    //       default:
                    //         break;
                    //     }
                    //   },
                    //   itemBuilder: (BuildContext context) =>
                    //       <PopupMenuEntry<SampleItem>>[
                    //     const PopupMenuItem<SampleItem>(
                    //       value: SampleItem.itemOne,
                    //       child: Center(
                    //         child: Text('Date Send'),
                    //       ),
                    //     ),
                    //     const PopupMenuItem<SampleItem>(
                    //       value: SampleItem.itemTwo,
                    //       child: Center(
                    //         child: Text('Default'),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    TextButton(
                        // style: TextButton.styleFrom(
                        //   backgroundColor: Colors.grey[400],
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 16, vertical: 0),
                        // ),
                        onPressed: () => {
                              if ((tabController.index == 0 &&
                                      items.isNotEmpty) ||
                                  (tabController.index == 1 &&
                                      itemsImportant.isNotEmpty))
                                {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context1) =>
                                        AlertDialog(
                                      backgroundColor: Colors.white,
                                      title:
                                          const Text('Are you sure Archived?'),
                                      // content: const Text('AlertDialog description'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context1, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context1, 'OK');
                                            if (tabController.index == 0) {
                                              handleArchivedAll(items);
                                            } else {
                                              handleArchivedAll(itemsImportant);
                                            }

                                            // handleDelete(index);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBarNoti(
                                                    context,
                                                    "List noti was Archived."));
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  ),
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackBarError(
                                          context, "List noti is empty"))
                                }
                            },
                        child: const Text(
                          "Clear",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color.fromRGBO(226, 76, 75, 1)),
                        ))
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: TabBarView(controller: tabController, children: [
                Consumer<FetchNotifiCationProvider>(
                    builder: (context, value, child) {
                  if (value.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  items = value.notifications;
                  return items.isNotEmpty
                      ? SlidableAutoCloseBehavior(
                          closeWhenOpened: true,
                          closeWhenTapped: true,
                          child: RefreshIndicator(
                            key: _refreshIndicatorKey,
                            color: Colors.white,
                            backgroundColor: Colors.blue,
                            strokeWidth: 4.0,
                            onRefresh: () async {
                              HandleFetchAll();
                              HandleFetchImportant();
                              // Replace this delay with the code to be executed during refresh
                              // and return a Future when code finishes execution.
                              return Future<void>.delayed(
                                  const Duration(seconds: 1));
                            },
                            child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white, // Màu nền của Container
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
                                              // handleDelete(index);
                                              handleArchivedOneItem(
                                                  items[index].id,
                                                  items[index].status);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBarDelete(
                                                      item,
                                                      context,
                                                      handleReArchivedOneItem));
                                            },
                                          ),
                                          motion: const ScrollMotion(),
                                          children: [
                                            // SlidableAction(
                                            //   // An action can be bigger than the others.
                                            //   flex: 2,
                                            //   onPressed: (context) {
                                            //     ScaffoldMessenger.of(context)
                                            //         .showSnackBar(
                                            //             snackBarStore());
                                            //   },
                                            //   backgroundColor:
                                            //       const Color.fromRGBO(
                                            //           83, 213, 96, 1),
                                            //   foregroundColor: Colors.white,
                                            //   icon: Icons.inventory_2,
                                            //   // label: 'Save',
                                            // ),
                                            SlidableAction(
                                              flex: 1,
                                              onPressed: (context2) => {
                                                showDialog<String>(
                                                  context: context2,
                                                  builder:
                                                      (BuildContext context1) =>
                                                          AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    title: const Text(
                                                        'Are you sure Archived?'),
                                                    // content: const Text('AlertDialog description'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context1,
                                                                'Cancel'),
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context1, 'OK');
                                                          handleArchivedOneItem(
                                                              items[index].id,
                                                              items[index]
                                                                  .status);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBarDelete(
                                                                      item,
                                                                      context,
                                                                      handleReArchivedOneItem));
                                                        },
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              },
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      83, 213, 96, 1),
                                              foregroundColor: Colors.white,
                                              icon: Icons.inventory_2,
                                              // label: 'Delete',
                                            ),
                                          ],
                                        ),
                                        child: Builder(
                                          builder: (context) => GestureDetector(
                                            onTap: () {
                                              handleSeen(items[index].id);
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Colors.white,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      scrollable: true,
                                                      content: Container(
                                                        decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15))),
                                                        padding:
                                                            const EdgeInsets
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
                                                                            backgroundColor:
                                                                                AppColors.primaryColor,
                                                                            // Border radius
                                                                            child: ClipOval(
                                                                              child: SizedBox.fromSize(
                                                                                size: const Size.fromRadius(20), // Image radius
                                                                                child: Image.asset("assets/userAvatarDefault.png", fit: BoxFit.cover),
                                                                              ),
                                                                            )),
                                                                        Text(
                                                                          "from: ${items[index].sender}",
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
                                                                      DateFormat(
                                                                              'HH:mm')
                                                                          .format(
                                                                              DateTime.parse(items[index].createdAt)),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        // fontWeight: FontWeight.w500,
                                                                        color: Color.fromRGBO(
                                                                            39,
                                                                            79,
                                                                            107,
                                                                            1),

                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      DateFormat(
                                                                              'dd/MM/yyyy')
                                                                          .format(
                                                                              DateTime.parse(items[index].createdAt)),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        // fontWeight: FontWeight.w500,
                                                                        color: Color.fromRGBO(
                                                                            39,
                                                                            79,
                                                                            107,
                                                                            1),

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
                                                                  vertical: 5),
                                                            ),
                                                            const Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  'To:',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
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
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    "all",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .visible,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      // fontWeight: FontWeight.w500,
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              87,
                                                                              89,
                                                                              90,
                                                                              1),

                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
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
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
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
                                                                      fontSize:
                                                                          16,
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
                                                                      fontSize:
                                                                          16,
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
                                                      size: const Size
                                                              .fromRadius(
                                                          20), // Image radius
                                                      child: Image.asset(
                                                          "assets/userAvatarDefault.png",
                                                          fit: BoxFit.cover),
                                                    ),
                                                  )),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child:
                                                        items[index].isImportant
                                                            ? Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .notification_important_rounded,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            226,
                                                                            76,
                                                                            75,
                                                                            1),
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                      items[index]
                                                                          .title,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        // fontWeight: FontWeight.w500,
                                                                        color: Color.fromRGBO(
                                                                            226,
                                                                            76,
                                                                            75,
                                                                            1),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Text(
                                                                items[index]
                                                                    .title,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  // fontWeight: FontWeight.w500,
                                                                  color: (items[index]
                                                                              .status ==
                                                                          "UNREAD")
                                                                      ? const Color
                                                                              .fromRGBO(
                                                                          39,
                                                                          79,
                                                                          107,
                                                                          1)
                                                                      : Colors
                                                                          .black54,
                                                                  fontWeight: (items[index]
                                                                              .status ==
                                                                          "UNREAD")
                                                                      ? FontWeight
                                                                          .bold
                                                                      : FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(DateTime.parse(
                                                            items[index]
                                                                .createdAt)),
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      // fontWeight: FontWeight.w500,
                                                      color: (items[index]
                                                                  .status ==
                                                              "UNREAD")
                                                          ? const Color
                                                                  .fromRGBO(
                                                              39, 79, 107, 1)
                                                          : Colors.black54,
                                                      fontWeight: (items[index]
                                                                  .status ==
                                                              "UNREAD")
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Text(
                                                items[index].content,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: (items[index].status ==
                                                          "UNREAD")
                                                      ? const Color.fromRGBO(
                                                          39, 79, 107, 1)
                                                      : const Color.fromRGBO(
                                                          39, 79, 107, 1),
                                                  fontWeight:
                                                      (items[index].status ==
                                                              "UNREAD")
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
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
                        );
                }),
                itemsImportant.isNotEmpty
                    ? SlidableAutoCloseBehavior(
                        closeWhenOpened: true,
                        closeWhenTapped: true,
                        child: ListView.builder(
                          itemCount: itemsImportant.length,
                          itemBuilder: (context, index) {
                            final item = itemsImportant[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 15),
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
                                          // handleDelete(index);
                                          handleArchivedOneItem(
                                              itemsImportant[index].id,
                                              itemsImportant[index].status);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBarDelete(
                                                  item,
                                                  context,
                                                  handleReArchivedOneItem));
                                        },
                                      ),
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          flex: 1,
                                          onPressed: (context2) => {
                                            showDialog<String>(
                                                context: context2,
                                                builder: (BuildContext
                                                        context1) =>
                                                    //         AlertDialog(
                                                    //   backgroundColor: Colors.white,
                                                    //   title: const Text(
                                                    //       'Are you sure Archived?'),
                                                    //   // content: const Text('AlertDialog description'),
                                                    //   actions: <Widget>[
                                                    //     TextButton(
                                                    //       onPressed: () =>
                                                    //           Navigator.pop(
                                                    //               context1, 'Cancel'),
                                                    //       child: const Text('Cancel'),
                                                    //     ),
                                                    //     TextButton(
                                                    //       onPressed: () {
                                                    //         Navigator.pop(
                                                    //             context1, 'OK');
                                                    //         handleArchivedOneItem(
                                                    //             itemsImportant[index]
                                                    //                 .id,
                                                    //             itemsImportant[index]
                                                    //                 .status);
                                                    //         // handleDelete(index);
                                                    //         ScaffoldMessenger.of(
                                                    //                 context)
                                                    //             .showSnackBar(
                                                    //                 snackBarDelete(
                                                    //                     item,
                                                    //                     context,
                                                    //                     handleReArchivedOneItem));
                                                    //       },
                                                    //       child: const Text('OK'),
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    PopupConfirm(
                                                        context1,
                                                        "Archive",
                                                        "Are you sure want to archive?",
                                                        () {
                                                      handleArchivedOneItem(
                                                          itemsImportant[index]
                                                              .id,
                                                          itemsImportant[index]
                                                              .status);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBarDelete(
                                                                  item,
                                                                  context,
                                                                  handleReArchivedOneItem));
                                                      Navigator.pop(context1);
                                                    })),
                                          },
                                          backgroundColor: const Color.fromRGBO(
                                              83, 213, 96, 1),
                                          foregroundColor: Colors.white,
                                          icon: Icons.inventory_2,
                                          // label: 'Delete',
                                        ),
                                      ],
                                    ),
                                    child: Builder(
                                      builder: (context) => GestureDetector(
                                        onTap: () {
                                          handleSeen(itemsImportant[index].id);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  scrollable: true,
                                                  content: Container(
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
                                                                      "from: ${itemsImportant[index].sender}",
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
                                                                  DateFormat(
                                                                          'HH:mm')
                                                                      .format(DateTime.parse(
                                                                          itemsImportant[index]
                                                                              .createdAt)),
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
                                                                  DateFormat(
                                                                          'dd/MM/yyyy')
                                                                      .format(DateTime.parse(
                                                                          itemsImportant[index]
                                                                              .createdAt)),
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
                                                        const Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
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
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                "all",
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                                style:
                                                                    TextStyle(
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
                                                                          .bold,
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
                                                                itemsImportant[
                                                                        index]
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
                                                                itemsImportant[
                                                                        index]
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
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .notification_important_rounded,
                                                      color: Color.fromRGBO(
                                                          226, 76, 75, 1),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        itemsImportant[index]
                                                            .title,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          // fontWeight: FontWeight.w500,
                                                          color: Color.fromRGBO(
                                                              226, 76, 75, 1),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    DateTime.parse(
                                                        itemsImportant[index]
                                                            .createdAt)),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  // fontWeight: FontWeight.w500,
                                                  color: (itemsImportant[index]
                                                              .status ==
                                                          "UNREAD")
                                                      ? const Color.fromRGBO(
                                                          39, 79, 107, 1)
                                                      : Colors.black54,
                                                  fontWeight:
                                                      (itemsImportant[index]
                                                                  .status ==
                                                              "UNREAD")
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(
                                            itemsImportant[index].content,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: (itemsImportant[index]
                                                          .status ==
                                                      "UNREAD")
                                                  ? const Color.fromRGBO(
                                                      39, 79, 107, 1)
                                                  : const Color.fromRGBO(
                                                      39, 79, 107, 1),
                                              fontWeight: (itemsImportant[index]
                                                          .status ==
                                                      "UNREAD")
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
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
                      )
              ]),
            )
          ]),
        ),
        // }),
        floatingActionButton: isAdmin ? floatingButton(context) : null,
      );
    });
    // );
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
