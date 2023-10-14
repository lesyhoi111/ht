import 'package:flutter/material.dart';
import 'package:hiptech_app/provider/userProfile_Provider.dart';
import 'package:hiptech_app/services/store.dart';
import 'package:provider/provider.dart';

import 'component/popupConfirm.dart';
import 'login.dart';

class DrawerOnly extends StatelessWidget {
  const DrawerOnly({super.key});

  @override
  Widget build(BuildContext ctxt) {
    bool role = false;
    EdgeInsets safeAreaInsets = MediaQuery.of(ctxt).padding;
    return
        // FutureBuilder<UserProfile>(
        //     future: NetworkRequest.getRole(),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const CircularProgressIndicator();
        //       } else if (snapshot.hasError) {
        //         return Text('Error: ${snapshot.error}');
        //       } else {
        //         final role = snapshot.data?.role?.contains("ROLE_ADMIN") == true
        //             ? true
        //             : false;
        Drawer(
            backgroundColor: Colors.white,
            child:
                Consumer<UserProfileProvider>(builder: (context, value, child) {
              role = value.Role?.contains("ROLE_ADMIN") == true ? true : false;
              return Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(30))),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 20, top: safeAreaInsets.top + 25),
                      child: ListTile(
                        // decoration: const BoxDecoration(color: Colors.white),
                        // accountName: const Text(
                        //   "Pinkesh Darji",
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // accountEmail: const Text(
                        //   "pinkesh.earth@gmail.com",
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        subtitle: const Text(
                          'username@hiptech.portal',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(39, 79, 107, 1),
                              fontWeight: FontWeight.normal),
                        ),
                        title: Text(
                          value.getUserProfile.name ?? '',
                          style: const TextStyle(
                              color: Color.fromRGBO(39, 79, 107, 1),
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(4), // Border width
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromRGBO(110, 214, 235, 1),
                                  Color.fromRGBO(39, 94, 174, 1),
                                ],
                              ),
                              shape: BoxShape.circle),
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(22), // Image radius
                              child: Image.asset("assets/userAvatarDefault.png",
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                    itemButton(
                      ctxt,
                      "Incoming Notification",
                      "12",
                      const Icon(
                        Icons.notifications_active_rounded,
                        size: 40,
                        color: Color.fromRGBO(18, 183, 242, 12),
                      ),
                    ),
                    role
                        ? itemButton(
                            ctxt,
                            "Sent Notification",
                            "2",
                            const Icon(
                              Icons.send_rounded,
                              size: 40,
                              color: Color.fromRGBO(18, 183, 242, 1),
                            ),
                          )
                        : Container(),
                    // itemButton(
                    //   ctxt,
                    //   "Draft Notification",
                    //   "8",
                    //   const Icon(
                    //     Icons.drive_file_rename_outline_rounded,
                    //     size: 40,
                    //     color: Color.fromRGBO(18, 183, 242, 1),
                    //   ),
                    // ),
                    role
                        ? itemButton(
                            ctxt,
                            "Timing Notification",
                            "2",
                            const Icon(
                              Icons.access_time_filled_rounded,
                              size: 40,
                              color: Color.fromRGBO(18, 183, 242, 1),
                            ),
                          )
                        : Container(),
                    itemButton(
                      ctxt,
                      "Archive Notification",
                      "5",
                      const Icon(
                        Icons.inventory_2_rounded,
                        size: 40,
                        color: Color.fromRGBO(18, 183, 242, 1),
                      ),
                    ),

                    Expanded(child: Container()),
                    TextButton(
                        onPressed: () {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context1) => PopupConfirm(
                                      context1,
                                      "Log out",
                                      "Are you sure want to log out?",
                                      () async {
                                    await Store.setToken("");
                                    String? token = await Store.getToken();

                                    Navigator.pushAndRemoveUntil(
                                      ctxt,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const LoginPage()),
                                      (Route<dynamic> route) =>
                                          false, // Xoá tất cả các lịch sử điều hướng
                                    );
                                  }));
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            const RoundedRectangleBorder(
                              side: BorderSide.none,
                            ),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              color: Color.fromRGBO(142, 144, 144, 1),
                              size: 55,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Log out',
                              style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(142, 144, 144, 1)),
                            )
                          ],
                        ))
                  ],
                ),
              );
            }));
  }
  // });
}

Column itemButton(BuildContext ctxt, String title, String number, Icon icon) {
  return Column(
    children: [
      ListTile(
        leading: icon,
        // Icon(
        //   Icons.icon,
        //   size: 40,
        //   color: Color.fromRGBO(18, 183, 242, 1),
        // ),
        // trailing: Text(
        //   number,
        //   style: const TextStyle(
        //       color: Color.fromRGBO(18, 183, 242, 1),
        //       fontSize: 16,
        //       fontWeight: FontWeight.w700),
        // ),
        title: Text(
          title,
          style: const TextStyle(
              color: Color.fromRGBO(39, 79, 107, 1),
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        onTap: () {
          Navigator.pop(ctxt);
          switch (title) {
            case "Incoming Notification":
              Navigator.pushNamed(ctxt, '/home');
              break;
            case "Sent Notification":
              Navigator.pushNamed(ctxt, '/sent');
              break;
            // case "Draft Notification":
            //   Navigator.pushNamed(ctxt, '/draft');
            //   break;
            case "Timing Notification":
              Navigator.pushNamed(ctxt, '/timing');
              break;
            case "Archive Notification":
              Navigator.pushNamed(ctxt, '/store');
              break;
            // case "Delete Notification":
            //   Navigator.pushNamed(ctxt, '/delete');
            //   break;
            default:
              break;
          }
          // stackPage(ctxt, icon);
          // Navigator.push(ctxt,
          //     );
        },
      ),
      const SizedBox(
        height: 10,
      )
    ],
  );
}
