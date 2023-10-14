import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hiptech_app/api/firebase.dart';
import 'package:hiptech_app/networkApi/networkRequest.dart';
import 'package:hiptech_app/services/store.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as Http;
import 'component/theme/themeColor.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final controller = PageController();
  bool islastPage = false;
  bool isLoading = true;
  FirebaseApi fbapi = FirebaseApi();

  @override
  void initState() {
    // TODO: implement initState
    fbapi.requestNotiPermission();
    fbapi.firebaseInit(context);
    // fbapi.initlocalNotification();
    HandleGetState();
    super.initState();
  }

  void HandleGetState() async {
    // setState(() {
    //   isLoading = true;
    // });
    String? token = await Store.getToken();
    if (token == "") {
      Navigator.pushNamed(context, '/login');
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (token == "TOKEN") {
      setState(() {
        isLoading = false;
      });
      return;
    }
    final response = await Http.get(
      Uri.parse("${dotenv.get("API_URL")}/api/profile"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/home');
    }
    if (response.statusCode == 401) {
      final result = await NetworkRequest.SaveRefreshToken();
      if (result) {
        return HandleGetState();
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;
    return MaterialApp(
        title: 'Onboarding',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          useMaterial3: true,
        ),
        home: Scaffold(
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.only(
                      top: safeAreaInsets.top,
                      left: safeAreaInsets.left,
                      right: safeAreaInsets.right,
                      bottom: safeAreaInsets.bottom),
                  child: Stack(children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: PageView(
                        onPageChanged: (index) {
                          setState(() {
                            islastPage = index == 2;
                          });
                        },
                        controller: controller,
                        children: [
                          page_boarding(
                              "assets/Onboard1.png",
                              "Welcome to Noti",
                              "Stay connected and never miss an update. Get ready to receive personalized notifications that matter to you."),
                          page_boarding(
                              "assets/Onboard2.png",
                              "Real-time Notifications",
                              "Receive instant updates, breaking news, and time-sensitive alerts directly on your device. Be the first to know what's happening."),
                          page_boarding(
                              "assets/Onboard3.png",
                              "Let's Get Started!",
                              " Set up your notification preferences now and experience a smarter way to stay informed. It only takes a few moments!"),
                        ],
                      ),
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: !islastPage
                            ? Container(
                                color: Colors.white,
                                height: 80,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            controller.jumpToPage(2);
                                          },
                                          child: const Text(
                                            "Skip",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Center(
                                        child: SmoothPageIndicator(
                                          controller: controller,
                                          count: 3,
                                          effect: const ExpandingDotsEffect(
                                            activeDotColor:
                                                AppColors.primaryColor,
                                            dotColor: Colors.grey,
                                            dotHeight: 10,
                                            dotWidth: 15,
                                            expansionFactor: 3.5,
                                          ),
                                          // const WormEffect(
                                          //   dotHeight: 10,
                                          //   dotWidth: 10,
                                          //   spacing: 10,
                                          //   dotColor: Colors.black26,
                                          //   activeDotColor:
                                          //       Color.fromRGBO(39, 94, 174, 1),
                                          // ),
                                          onDotClicked: (index) {
                                            controller.animateToPage(index,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.easeInOut);
                                          },
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            controller.nextPage(
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.easeInOut);
                                          },
                                          child: const Text(
                                            "Next",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ]),
                              )
                            : Container(
                                color: Colors.white,
                                height: 80,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 73, right: 73, bottom: 20, top: 0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color.fromRGBO(0, 210, 255, 1),
                                            Color.fromRGBO(58, 123, 213, 0.84),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                      child: const Text(
                                        'Start',
                                        style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ))),
                  ]),
                ),
          // bottomSheet: !islastPage
          //     ? Container(
          //         color: const Color.fromRGBO(110, 214, 235, 0.1),
          //         height: 80,
          //         child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceAround,
          //             children: [
          //               TextButton(
          //                   onPressed: () {
          //                     controller.jumpToPage(2);
          //                   },
          //                   child: const Text(
          //                     "Skip",
          //                     style: TextStyle(
          //                         fontSize: 18,
          //                         color: Color.fromRGBO(39, 94, 174, 1),
          //                         fontWeight: FontWeight.bold),
          //                   )),
          //               Center(
          //                 child: SmoothPageIndicator(
          //                   controller: controller,
          //                   count: 3,
          //                   effect: const WormEffect(
          //                     dotHeight: 10,
          //                     dotWidth: 10,
          //                     spacing: 10,
          //                     dotColor: Colors.black26,
          //                     activeDotColor: Color.fromRGBO(39, 94, 174, 1),
          //                   ),
          //                   onDotClicked: (index) {
          //                     controller.animateToPage(index,
          //                         duration: const Duration(milliseconds: 500),
          //                         curve: Curves.easeInOut);
          //                   },
          //                 ),
          //               ),
          //               TextButton(
          //                   onPressed: () {
          //                     controller.nextPage(
          //                         duration: const Duration(milliseconds: 500),
          //                         curve: Curves.easeInOut);
          //                   },
          //                   child: const Text(
          //                     "Next",
          //                     style: TextStyle(
          //                         fontSize: 18,
          //                         color: Color.fromRGBO(39, 94, 174, 1),
          //                         fontWeight: FontWeight.bold),
          //                   ))
          //             ]),
          //       )
          //     : Container(
          //         color: const Color.fromRGBO(110, 214, 235, 0.1),
          //         height: 80,
          //         child: SizedBox(
          //           width: double.infinity,
          //           height: 80,
          //           child: FilledButton(
          //               onPressed: () {
          //                 Navigator.pushNamed(context, '/login');
          //               },
          //               style: ButtonStyle(
          //                   backgroundColor:
          //                       const MaterialStatePropertyAll<Color>(
          //                           Color.fromRGBO(39, 94, 174, 1)),
          //                   shape: MaterialStateProperty.all(
          //                       const RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.vertical(
          //                               top: Radius.circular(30))))),
          //               child: const Text(
          //                 "Get started",
          //                 style: TextStyle(
          //                     fontSize: 26,
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.bold),
          //               )),
          //         ))
        ));
  }

  Container page_boarding(String urlImage, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(urlImage),
          fit: BoxFit.cover,
        ),
      ),
      // color: const Color.fromRGBO(110, 214, 235, 0.1),
      child: Padding(
        padding: const EdgeInsets.only(top: 25, left: 20, right: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset('assets/HiptechLogo.png'),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 35,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400),
          )
        ]),
      ),
    );
  }
}
