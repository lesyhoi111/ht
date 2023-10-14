import 'package:flutter/material.dart';

class PopularMountains extends StatefulWidget {
  const PopularMountains({Key? key}) : super(key: key);

  @override
  State<PopularMountains> createState() => _PopularMountainsState();
}

class _PopularMountainsState extends State<PopularMountains>
    with TickerProviderStateMixin {
  List images = [
    "mountain4.jpeg",
    "mountain8.jpeg",
    "mountain9.jpeg",
  ];
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //menu text

          const SizedBox(
            height: 20,
          ),
          //tabbar
          Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                  labelPadding: const EdgeInsets.only(left: 20, right: 20),
                  controller: tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: CircleTabIndicator(color: Colors.amber, radius: 4),
                  tabs: const [
                    Tab(text: "Places"),
                    Tab(text: "Inspiration"),
                    Tab(text: "Emotions"),
                  ]),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            height: 300,
            width: double.maxFinite,
            child: TabBarView(
              controller: tabController,
              children: [
                ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // BlocProvider.of<AppCubits>(context).detailPage(info[index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 15, top: 10),
                        width: 200,
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            image: const DecorationImage(
                                image: NetworkImage(
                                    "data:image/jpeg;base64,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"),
                                fit: BoxFit.cover)),
                      ),
                    );
                  },
                ),
                ListView.builder(itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: Text("Line ${index + 1}"),
                    selectedTileColor: Colors.green[400],
                    onTap: () {
                      setState(() {});
                    },
                  );
                }),
                const Text("Bye")
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Explore more"), Text("See all")],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
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
