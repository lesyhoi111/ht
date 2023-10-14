import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiptech_app/component/snackBarError.dart';
import 'package:hiptech_app/component/snackBarNoti.dart';
import 'package:hiptech_app/model/user.dart';
import 'package:hiptech_app/networkApi/networkRequest.dart';
import 'component/mulriselectpeople.dart';
import 'component/theme/themeColor.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  _DetailPageState createState() => _DetailPageState();
}

enum SingingSendTime { now, schedule }

enum SingingSendTo { all, choose, group }

class _DetailPageState extends State<DetailPage> {
  bool Checked = true;
  bool CheckedTimeNow = true;
  final SingingSendTime _timeSend = SingingSendTime.now;
  SingingSendTo? _sendTo = SingingSendTo.all;
  final searchPeopleController = TextEditingController();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List groups = [];
  List<UserDetail> peopleSent = [];
  // List<String> selectPeopleSent = [];
  late String groupChose;
  List<UserDetail> selectPeopleSent = [];

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API

    final List<UserDetail>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
            peopleSent: peopleSent, selectPeopleSent: selectPeopleSent);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        selectPeopleSent = results;
      });
    }
  }

  void handlePostNotificationSchedule(
      List<String> listId, bool isSendAll, List<String> idReceivers) async {
    Map<String, dynamic> params = {
      "title": titleController.text,
      "content": contentController.text,
      "isImportant": Checked,
      "type": "SCHEDULE",
      "sendTime": "${dateTime.toIso8601String()}Z",
      "receivers": listId,
      "receiverGroups": idReceivers,
      "isSendAll": isSendAll
    };
    bool result = await NetworkRequest.postNotification(params);
    if (result) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarNoti(context, "Notification has been created"));
    }
  }

  void handlePostNotificationNow(
      List<String> listId, bool isSendAll, List<String> idReceivers) async {
    Map<String, dynamic> params = {
      "title": titleController.text,
      "content": contentController.text,
      "isImportant": Checked,
      "type": "NOW",
      "receivers": listId,
      "receiverGroups": idReceivers,
      "isSendAll": isSendAll
    };
    bool result = await NetworkRequest.postNotification(params);
    if (result) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarNoti(context, "Notification has been created"));
    }
  }

  void HandleSendNotification() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          snackBarError(context, 'Please enter all information.'));
      return;
    }
    if (_sendTo == SingingSendTo.choose && selectPeopleSent.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarError(context, 'Please choose receivers.'));
      return;
    }
    List<String> listIdUserReceivers = [];
    bool isSendAll = _sendTo == SingingSendTo.all;
    List<String> idReceivers = [];

    if (_sendTo == SingingSendTo.choose) {
      for (var item in selectPeopleSent) {
        listIdUserReceivers.add(item.id!);
      }
    }
    if (_sendTo == SingingSendTo.group) {}

    if (CheckedTimeNow) {
      handlePostNotificationNow(listIdUserReceivers, isSendAll, idReceivers);
    }
    if (CheckedTimeNow == false) {
      handlePostNotificationSchedule(
          listIdUserReceivers, isSendAll, idReceivers);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBarNoti(context, "The noti was sent."));
    Navigator.pop(context);
  }

  void HandleFetchAllUser() async {
    List<UserDetail> result = await NetworkRequest.fetchListUser();

    setState(() {
      peopleSent = result;
    });
  }

  // final quill.QuillController _controller = quill.QuillController.basic();
  void HandleDeletePeopleSent(UserDetail people) {
    setState(() {
      selectPeopleSent.remove(people);
    });
  }

  @override
  void initState() {
    groups = List<String>.generate(10, (i) => 'Group ${i + 1}');
    groupChose = groups[0];
    HandleFetchAllUser();
    super.initState();
  }

  // void _CheckChange(UserDetail userItem, bool isChecked) {
  //   setState(() {
  //     if (isChecked) {
  //       selectPeopleSent.add(userItem);
  //     } else {
  //       selectPeopleSent.remove(userItem);
  //     }
  //   });
  // }

  DateTime dateTime = DateTime.now();
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(
          Icons.notifications_active_rounded,
          color: Color.fromRGBO(226, 76, 75, 1),
        );
      }
      return const Icon(Icons.notifications);
    },
  );

  @override
  void dispose() {
    contentController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      setState(() {
        titleController.text = arguments['message'].content;
        dateTime = arguments['message'].timestamp;
      });
    }
    EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: safeAreaInsets.top,
              left: safeAreaInsets.left,
              right: safeAreaInsets.right,
              bottom: safeAreaInsets.bottom),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(0, 210, 255, 1),
                Color.fromRGBO(58, 123, 213, 0.84),
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.1,
              //   padding: const EdgeInsets.only(left: 15, right: 21),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       IconButton(
              //           onPressed: () {
              //             Navigator.pop(context);
              //           },
              //           icon: const Icon(
              //             Icons.arrow_back_ios,
              //             size: 35,
              //             color: Colors.white,
              //           )),
              //       Image.asset('assets/HiptechLogo.png'),
              //     ],
              //   ),
              // ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                padding: const EdgeInsets.only(
                    top: 18, left: 12, right: 12, bottom: 15),
                width: MediaQuery.of(context).size.width - 42,
                height: MediaQuery.of(context).size.height * 0.88,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              weight: 100,
                              size: 35,
                              color: AppColors.textGreyPrimaryColor,
                            )),

                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'New notification',
                              style: TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(39, 79, 107, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "from: Admin",
                              style: TextStyle(
                                fontSize: 12,
                                // fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(39, 79, 107, 1),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   width: 30,
                        // ),
                        Switch(
                            thumbIcon: thumbIcon,
                            value: Checked,
                            onChanged: (bool value) {
                              setState(() {
                                Checked = value;
                              });
                            },
                            activeColor: Colors.white,
                            activeTrackColor:
                                const Color.fromRGBO(226, 76, 75, 1)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Title:',
                          style: TextStyle(
                            fontSize: 17,
                            // fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(39, 79, 107, 1),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            alignment: Alignment.topLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width - 150,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(232, 232, 232, 1),
                                    width: 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12))
                                // borderRadius: const BorderRadius.vertical(
                                //     top: Radius.circular(12))
                                ),
                            child: TextFormField(
                              controller: titleController,
                              keyboardType: TextInputType.multiline,
                              // textAlignVertical: TextAlignVertical.top,
                              maxLines: null,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: Colors.white.withOpacity(.08),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromRGBO(232, 232, 232, 1),
                                width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: TextFormField(
                          controller: contentController,
                          keyboardType: TextInputType.multiline,
                          // textAlignVertical: TextAlignVertical.top,
                          maxLines: null,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            filled: true,
                            fillColor: Colors.white.withOpacity(.08),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Time:',
                          style: TextStyle(
                            fontSize: 17,
                            // fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(39, 79, 107, 1),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Switch(
                          trackColor: MaterialStateProperty.all(
                              AppColors.gradientColor1.withOpacity(0.5)),
                          activeColor: AppColors.primaryColor,
                          inactiveThumbColor: AppColors.primaryColor,
// when the switch is on, this image will be displayed
                          activeThumbImage:
                              const AssetImage('assets/Time2.png'),
// when the switch is off, this image will be displayed
                          inactiveThumbImage:
                              const AssetImage('assets/Time1.png'),
                          value: CheckedTimeNow,
                          onChanged: (value) =>
                              setState(() => CheckedTimeNow = value),
                        ),
                        // Row(
                        //   children: [
                        //     Radio(
                        //       activeColor:
                        //           const AppColors.primaryColor,
                        //       value: SingingSendTime.now,
                        //       groupValue: _timeSend,
                        //       onChanged: (SingingSendTime? value) {
                        //         setState(() {
                        //           _timeSend = value;
                        //         });
                        //       },
                        //     ),
                        //     const Text(
                        //       'Now',
                        //       style: TextStyle(fontSize: 17),
                        //     ),
                        //   ],
                        // ),
                        // // const SizedBox(
                        // //   width: 12,
                        // // ),
                        // Row(
                        //   children: [
                        //     Radio(
                        //       activeColor:
                        //           const AppColors.primaryColor,
                        //       value: SingingSendTime.schedule,
                        //       groupValue: _timeSend,
                        //       onChanged: (SingingSendTime? value) {
                        //         setState(() {
                        //           _timeSend = value;
                        //         });
                        //       },
                        //     ),
                        //     const Text(
                        //       'Schedule',
                        //       style: TextStyle(fontSize: 17),
                        //     ),
                        //   ],
                        // )

                        !CheckedTimeNow
                            ? OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                onPressed: () {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          SizedBox(
                                            height: 250,
                                            child: CupertinoDatePicker(
                                              onDateTimeChanged:
                                                  (DateTime dateTimePic) {
                                                setState(() {
                                                  dateTime = dateTimePic;
                                                });
                                              },
                                              // ususe24hFormat: true,
                                              backgroundColor: Colors.white,
                                              initialDateTime: dateTime.add(
                                                  const Duration(seconds: 10)),
                                              minimumDate: dateTime,
                                            ),
                                          ));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      color: Colors.grey,
                                      padding: const EdgeInsets.all(5),
                                      child: const Icon(
                                        Icons.date_range_rounded,
                                        size: 23,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${dateTime.hour}:${dateTime.minute} ${dateTime.day}-${dateTime.month}-${dateTime.year}',
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ))
                            : const Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Now",
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor),
                                  ),
                                ],
                              )
                      ],
                    ),
                    // Container(
                    //   padding: const EdgeInsets.only(right: 100),
                    //   child: _timeSend == SingingSendTime.schedule
                    //       ? OutlinedButton(
                    //           style: OutlinedButton.styleFrom(
                    //             padding: const EdgeInsets.all(0),
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(0),
                    //             ),
                    //           ),
                    //           onPressed: () {
                    //             showCupertinoModalPopup(
                    //                 context: context,
                    //                 builder: (BuildContext context) => SizedBox(
                    //                       height: 250,
                    //                       child: CupertinoDatePicker(
                    //                         onDateTimeChanged:
                    //                             (DateTime dateTimePic) {
                    //                           setState(() {
                    //                             dateTime = dateTimePic;
                    //                           });
                    //                         },
                    //                         // ususe24hFormat: true,
                    //                         backgroundColor: Colors.white,
                    //                         initialDateTime: dateTime,
                    //                       ),
                    //                     ));
                    //           },
                    //           child: Row(
                    //             children: [
                    //               Container(
                    //                 color: Colors.grey,
                    //                 padding: const EdgeInsets.all(5),
                    //                 child: const Icon(
                    //                   Icons.date_range_rounded,
                    //                   size: 25,
                    //                   color: Colors.white,
                    //                 ),
                    //               ),
                    //               const SizedBox(
                    //                 width: 10,
                    //               ),
                    //               Text(
                    //                 '${dateTime.minute}:${dateTime.hour} ${dateTime.day}-${dateTime.month}-${dateTime.year}',
                    //                 style: const TextStyle(
                    //                     fontSize: 17, color: Colors.black),
                    //               )
                    //             ],
                    //           ))
                    //       : Container(),
                    // ),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: const Color.fromRGBO(232, 232, 232, 1),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                    ),
                    // const SizedBox(
                    //   height: 12,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'To:',
                          style: TextStyle(
                            fontSize: 17,
                            // fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(39, 79, 107, 1),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: AppColors.primaryColor,
                              value: SingingSendTo.all,
                              groupValue: _sendTo,
                              onChanged: (SingingSendTo? value) {
                                setState(() {
                                  _sendTo = value;
                                });
                              },
                            ),
                            const Text(
                              'All',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   width: 12,
                        // ),
                        Row(
                          children: [
                            Radio(
                              activeColor: AppColors.primaryColor,
                              value: SingingSendTo.choose,
                              groupValue: _sendTo,
                              onChanged: (SingingSendTo? value) {
                                setState(() {
                                  _sendTo = value;
                                });
                              },
                            ),
                            const Text(
                              'Choose indivials',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Radio(
                        //       activeColor: AppColors.primaryColor,
                        //       value: SingingSendTo.group,
                        //       groupValue: _sendTo,
                        //       onChanged: (SingingSendTo? value) {
                        //         setState(() {
                        //           _sendTo = value;
                        //         });
                        //       },
                        //     ),
                        //     const Text(
                        //       'Group',
                        //       style: TextStyle(fontSize: 14),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                    _sendTo == SingingSendTo.choose
                        ? Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(232, 232, 232, 1),
                                    width: 1),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12))),
                            child: TextFormField(
                              readOnly: true,
                              onTap: _showMultiSelect,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: Colors.white.withOpacity(.08),
                                prefixIcon: const Icon(Icons.person),
                                // prefixIconConstraints:
                                //     const BoxConstraints(minHeight: 0),
                                // hintText: 'Enter your user',
                              ),
                            ))
                        : Container(),
                    _sendTo == SingingSendTo.choose
                        ? Container(
                            height: 70,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(232, 232, 232, 1),
                                    width: 1),
                                borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(12))),
                            child: SingleChildScrollView(
                              child: Wrap(
                                children: selectPeopleSent.map((itemPeople) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 2),
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 0, top: 0, bottom: 0),
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            110, 214, 235, 0.2),
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors.primaryColor),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          itemPeople.name!,
                                          style: const TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                            padding: const EdgeInsets.all(0),
                                            iconSize: 20,
                                            onPressed: () {
                                              HandleDeletePeopleSent(
                                                  itemPeople);
                                            },
                                            icon: const Icon(
                                              Icons.clear_rounded,
                                              size: 25,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ))
                        : Container(),
                    // _sendTo == SingingSendTo.group
                    //     ? Container(
                    //         width: double.infinity,
                    //         padding: const EdgeInsets.symmetric(horizontal: 5),
                    //         decoration: BoxDecoration(
                    //             border: Border.all(
                    //                 color: AppColors.backgroundGreyPrimaryColor,
                    //                 width: 1),
                    //             borderRadius: const BorderRadius.all(
                    //                 Radius.circular(12))),
                    //         child: DropdownButton(
                    //           menuMaxHeight: 150,
                    //           underline: Container(),
                    //           isExpanded: true,
                    //           value: groupChose,
                    //           onChanged: (value) {
                    //             setState(() {
                    //               groupChose = value.toString();
                    //             });
                    //           },
                    //           items: groups.map((valueItem) {
                    //             return DropdownMenuItem(
                    //                 value: valueItem, child: Text(valueItem));
                    //           }).toList(),
                    //         ),
                    //       )
                    //     : Container(),
                    // Expanded(child: Container()),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 42,
                      height: 50,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(0, 210, 255, 1),
                              Color.fromRGBO(58, 123, 213, 0.84),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/login');

                          HandleSendNotification();
                        },
                        child: const Text(
                          'Send',
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.04,
              )
            ],
          ),
        ),
      ),
    );
  }
}
