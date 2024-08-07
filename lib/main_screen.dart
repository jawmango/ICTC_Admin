import 'package:flutter/material.dart';
import 'package:ictc_admin/pages/NetIncome/netIncome_page.dart';
import 'package:ictc_admin/pages/courses/courses_page.dart';
import 'package:ictc_admin/pages/dashboard/dashboard_page.dart';
import 'package:ictc_admin/pages/finance/finance_page.dart';
import 'package:ictc_admin/pages/programs/programs_page.dart';
import 'package:ictc_admin/pages/reports/reports_page.dart';
import 'package:ictc_admin/pages/trainers/trainers_page.dart';
import 'package:ictc_admin/pages/trainees/trainees_page.dart';
import 'package:ictc_admin/pages/courses/courses_page.dart';
import 'package:ictc_admin/pages/Vouchers/vouchers_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ictc_admin/pages/courses/course_history.dart';
import 'package:ictc_admin/pages/programs/program_history.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();
  }

  int _selectedIndex = 0;
  PageController pageController = PageController();

  SearchController searchController = SearchController();

   Future<void> _loadSelectedIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = prefs.getInt('selectedIndex') ?? 0; // default to 0 if not found
    });
    pageController.jumpToPage(_selectedIndex);
  }

  void onDestinationChanged(int value) async {
    setState(() {
      _selectedIndex = value;
      pageController.animateToPage(value,
          duration: const Duration(milliseconds: 400), curve: Curves.ease);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedIndex', value); // save the selected index
    
  }

  void logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  String getSearchName() {
    List<String> pageNames = const [
      "Dashboard",
      "Finances",
      "List of Trainers",
      "List of Students",
      "List of Programs",
      "List of Courses",
      // "Net Income",
      // "List of Vouchers",
    ];

    return pageNames[_selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> views = [
      const DashboardPage(),
      const FinancePage(),
      const TrainersPage(),
      const TraineesPage(),
      const ProgramsPage(),
      const CoursesPage(),
      // const NetIncomePage(),
      // const VouchersPage(),
    ];

    List<NavigationRailDestination> destinations = const [
      NavigationRailDestination(
        icon: Icon(
          Icons.home_filled,
          color: Colors.white,
          size: 30,
        ),
        selectedIcon: Icon(
          Icons.home_filled,
          color: Colors.white,
          size: 30,
        ),
        label: Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      NavigationRailDestination(
        icon: Icon(
          Icons.grid_view_outlined,
          color: Colors.white,
          size: 30,
        ),
        selectedIcon: Icon(
          Icons.grid_view_rounded,
          color: Colors.white,
          size: 30,
        ),
        label: Text(
          "Finance",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      NavigationRailDestination(
        icon: Icon(
          Icons.person_outline_rounded,
          color: Colors.white,
          size: 30,
        ),
        selectedIcon: Icon(
          Icons.person_rounded,
          color: Colors.white,
          size: 30,
        ),
        label: Text(
          "Trainers",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      NavigationRailDestination(
        icon: Icon(
          Icons.group_outlined,
          color: Colors.white,
          size: 30,
        ),
        selectedIcon: Icon(
          Icons.group,
          color: Colors.white,
          size: 30,
        ),
        label: Text(
          "Students",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      NavigationRailDestination(
        icon: Icon(
          Icons.playlist_add_check_circle_outlined,
          color: Colors.white,
          size: 30,
        ),
        selectedIcon: Icon(
          Icons.playlist_add_check_circle_rounded,
          color: Colors.white,
          size: 30,
        ),
        label: Text(
          "Programs",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      NavigationRailDestination(
        icon: Icon(
          Icons.book_outlined,
          color: Colors.white,
          size: 30,
        ),
        selectedIcon: Icon(
          Icons.book_rounded,
          color: Colors.white,
          size: 30,
        ),
        label: Text(
          "Courses",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      // NavigationRailDestination(
      //   icon: Icon(
      //     Icons.playlist_add_check_circle_outlined,
      //     color: Colors.white,
      //     size: 30,
      //   ),
      //   selectedIcon: Icon(
      //     Icons.playlist_add_check_circle_rounded,
      //     color: Colors.white,
      //     size: 30,
      //   ),
      //   label: Text(
      //     "Net Income",
      //     style: TextStyle(
      //       fontSize: 16,
      //       fontWeight: FontWeight.w400,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      // NavigationRailDestination(
      //   icon: Icon(
      //     Icons.book_outlined,
      //     color: Colors.white,
      //     size: 30,
      //   ),
      //   selectedIcon: Icon(
      //     Icons.book_rounded,
      //     color: Colors.white,
      //     size: 30,
      //   ),
      //   label: Text(
      //     "Vouchers",
      //     style: TextStyle(
      //       fontSize: 16,
      //       fontWeight: FontWeight.w400,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      // NavigationRailDestination(
      //   icon: Icon(
      //     Icons.table_chart_outlined,
      //     color: Colors.white,
      //     size: 30,
      //   ),
      //   selectedIcon: Icon(
      //     Icons.table_chart_rounded,
      //     color: Colors.white,
      //     size: 30,
      //   ),
      //   label: Text(
      //     "Reports",
      //     style: TextStyle(
      //       fontSize: 16,
      //       fontWeight: FontWeight.w400,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (true) {
          return Scaffold(
            backgroundColor: const Color(0xfff1f5fb),
            body: Row(
              children: [
                Container(
                    // decoration: const BoxDecoration(
                    //     border: Border(bottom: BorderSide(width: 2))),
                    child: buildNavRail(destinations)),
                Expanded(
                  child: Column(
                    children: [
                      buildBar(context),
                      buildPageView(views),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }

  String getTableName() {
    switch (_selectedIndex) {
      case 1:
        return "";
      case 2:
        return "trainer";
      case 3:
        return "student";
      case 4:
        return "program";
      case 5:
        return "course";
      // case 6:
      //   return "net";
      // case 6:
      //   return "vouchers";
      default:
        return "";
    }
  }

  Future<int> getCount(String tableName) async {
    final supabase = Supabase.instance.client;
    final count = await supabase.from(tableName).count();

    return count;
  }

  Container buildBar(BuildContext context) {
    return Container(
        color: const Color(0xfff1f5fb),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        height: 80,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _selectedIndex != 0
              ? AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(0.0, -3),
                              end: const Offset(0.0, 0.0))
                          .animate(animation),
                      child: child),
                  child: Row(
                    children: [
                      Text(
                        getSearchName(),
                        key: ValueKey<String>(getSearchName()),
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      buildCounter(context, getCount(getTableName())),
                    ],
                  ),
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(0.0, -3),
                              end: const Offset(0.0, 0.0))
                          .animate(animation),
                      child: child),
                  child: const Row(
                    children: [
                      Text(
                        "Dashboard",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
        ]));
  }

  Widget buildCounter(BuildContext context, Future<int> count) {
    const key = ValueKey("counter");

    return AnimatedSwitcher(
      key: key,
      duration: const Duration(milliseconds: 350),
      child: FutureBuilder(
        future: count,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data != 0
                ? Text(
                    snapshot.data.toString(),
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black26),
                  )
                : Container(key: key);
          } else {
            return Container(key: key);
          }
        },
      ),
    );
  }

  

  NavigationRail buildNavRail(List<NavigationRailDestination> destinations) {
    return NavigationRail(
      backgroundColor: const Color(0xff19306B),
      destinations: destinations,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int value) {
        // setState(() {
        //   _selectedIndex = value;
        //   pageController.animateToPage(value,
        //       duration: const Duration(milliseconds: 400), curve: Curves.ease);
        // });
        onDestinationChanged(value);
      },
      useIndicator: false,
      extended: true,
      leading: buildLeading(),
      trailing: buildTrailing(context),
    );
  }

  Row buildLeading() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 20),
          child: Image(
              image: AssetImage("assets/images/logo_ictc.png"), height: 60),
        ),
        Padding(
            padding: EdgeInsets.only(left: 8, top: 0, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ateneo ICTC",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                Text("Web Admin",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffffc947)))
              ],
            ))
      ],
    );
  }

  Expanded buildTrailing(context) {
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 256,
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.only(bottom: 24, left: 16),
          child: TextButton.icon(
            icon: const Icon(
              Icons.logout_outlined,
              size: 25,
              color: Colors.white,
            ),
            label: const Text(
              "Log out",
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            onPressed: logout,
          ),
        ),
      ],
    ));
  }

  Expanded buildPageView(List<Widget> views) {
    return Expanded(
      child: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: views,
      ),
    );
  }

}
