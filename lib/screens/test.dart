import 'dart:math';

import 'package:flutter/material.dart';

late TabController _tabController;
final ValueNotifier<int> _tabIndex = ValueNotifier<int>(0);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: DashboardHeaderPersistentDelegate(),
          )
        ];
      },
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[
          CustomScrollView(
            slivers: [
              // SliverOverlapInjector(
              //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              // ),
              SliverToBoxAdapter(
                child: Column(
                  children: List<Widget>.generate(
                    100,
                    (index) => Text(index == 0
                        ? 'start'
                        : index == 99
                            ? 'end'
                            : 'tab 1 item $index'),
                  ),
                ),
              ),
            ],
          ),
          Builder(
            builder: (context) {
              return CustomScrollView(
                slivers: [
                  // SliverOverlapInjector(
                  //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  // ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: List<Widget>.generate(
                        40,
                        (index) => Text(index == 0
                            ? 'start'
                            : index == 39
                                ? 'end'
                                : 'tab 2 item $index'),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

const categories = ['Grocieries', 'Transport', 'House Rent', 'Shopping', 'Career'];
const categoriesIcons = [
  Icons.ac_unit,
  Icons.access_alarms,
  Icons.dashboard,
  Icons.accessible_forward,
  Icons.backspace,
];

class DashboardHeaderPersistentDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double shrinkPercentage = min(1, shrinkOffset / (maxExtent - minExtent));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            height: max(
              60,
              100 * (1 - shrinkPercentage),
            ),
          ),
          child: FittedBox(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 200,
              child: const Text(
                '\$ 5329.05',
                style: TextStyle(
                  fontFamily: 'Barlow',
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (shrinkPercentage != 1)
                Opacity(
                  opacity: 1 - shrinkPercentage,
                  child: _buildInformationWidget(context),
                ),
              if (shrinkPercentage != 0)
                Opacity(
                  opacity: shrinkPercentage,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _buildCollapsedInformationWidget(),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildInformationWidget(BuildContext context) => ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'AVAILABLE BALANCE',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black26),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 100,
                          child: Text(
                            '\$ 11200',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Barlow',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.green[400],
                            ),
                          ),
                        ),
                        const Text(
                          ' I ',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black12,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            '\$ 400',
                            style: TextStyle(
                              fontFamily: 'Barlow',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.red[400],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 12, top: 12),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "CATEGORIES",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.black26,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 88,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: (index == 0) ? 24.0 : 8.0, right: (index == categories.length - 1) ? 24.0 : 8.0),
                          child: _buildCategoryItem(
                            categoriesIcons[index],
                            categories[index],
                            .9,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildCollapsedInformationWidget() => Row(
        children: [
          const Text("Recent"),
          const Spacer(),
          Container(
            child: Text(
              '\$ 11200',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Barlow',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.green[400],
              ),
            ),
          ),
          const Text(
            ' I ',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black12,
            ),
          ),
          Container(
            child: Text(
              '\$ 400',
              style: TextStyle(
                fontFamily: 'Barlow',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.red[400],
              ),
            ),
          )
        ],
      );

  Widget _buildCategoryItem(IconData data, String categoryTitle, double percentage) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black12,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  color: Colors.blue[400],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    data,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 2,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              )
            ],
          ),
          Container(
            width: 72,
            alignment: Alignment.center,
            child: Text(
              categoryTitle,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black45,
              ),
            ),
          )
        ],
      );

  @override
  double get maxExtent => 300;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
