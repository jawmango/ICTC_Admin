import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ictc_admin/models/course.dart';
import 'package:ictc_admin/models/payment.dart';
import 'package:ictc_admin/pages/courses/course_details.dart';
import 'package:ictc_admin/pages/dashboard/ads_image.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Payment? payment;
  late Stream<List<Course>> courses;
  late Stream<List<Course>> onGoingCourses;
  @override
  void initState() {
    courses = Supabase.instance.client
        .from('course')
        .stream(primaryKey: ['id'])
        .limit(9)
        .order('start_date', ascending: false)
        .map((data) {
          List<Course> courses = data.map((e) => Course.fromJson(e)).toList();
          DateTime today = DateTime.now();
          courses = courses.where((course) => course.startDate.isAfter(today)).toList();
          return courses;
        });

    onGoingCourses = Supabase.instance.client
        .from('course')
        .stream(primaryKey: ['id'])
        .limit(9)
        .order('start_date', ascending: false)
        .map((data) {
          List<Course> courses = data.map((e) => Course.fromJson(e)).toList();
          DateTime today = DateTime.now();
          courses = courses.where((course) => (course.startDate.isAtSameMomentAs(today) || course.startDate.isBefore(today)) && (course.endDate.isAfter(today) || course.endDate.isAtSameMomentAs(today))).toList();
          return courses;
        });

    super.initState();
  }


  Future<int> fetchNumberOfPreRegisters(int courseId) async {
    print('fetching number of pre-registers');
    final response = await Supabase.instance.client
        .from('registration')
        .select('id')
        .eq('course_id', courseId)
        .or('is_approved.eq.false,bill_status.eq.false')
        .count();

    print(response);

    return response.count;
  }

  Future<int> fetchNumberOfRegisters(int courseId) async {
    print('fetching number of pre-registers');
    final response = await Supabase.instance.client
        .from('registration')
        .select('id')
        .eq('course_id', courseId)
        .eq('is_approved', true)
        .or('cert_status.eq.false,attend_status.eq.false,eval_status.eq.false')
        .count();

    print(response);

    return response.count;
  }

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DefaultTabController(
      length: 2, // Set the length according to the number of tabs (Income and Expenses)
      child: Scaffold(
        backgroundColor: const Color(0xfff1f5fb),
        appBar: AppBar(
          backgroundColor: const Color(0xfff1f5fb),
          actions: [imageButton(), SizedBox(width:50),],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming Courses'),
              Tab(text: 'Ongoing Courses'),
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // Replace with your appropriate widget builders
                  buildUpcomingCourses(),
                  buildOngoingCourses(),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       backgroundColor: const Color(0xfff1f5fb),
  //       body: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Text(
  //                 'Courses',
  //                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 30),
  //            Expanded(
  //           child: PageView(
  //             children: [
  //               buildUpcomingCourses(),
  //               buildOngoingCourses(),
  //             ],
  //           )
  //            )
  //         ],
  //       ));
  // }

  Widget buildUpcomingCourses() {
    return StreamBuilder(
      stream: courses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              child: const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator.adaptive(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xff153faa))),
                    SizedBox(
                      height: 23,
                    ),
                    Text(
                      'Please wait...',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ));
        }
        


        return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.3,
                childAspectRatio: 2.3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10),
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final course = snapshot.data![index];
              return buildCourseCard(course);
            });
      },
    );

    // }
    // );
  }

  Widget buildOngoingCourses() {
    return StreamBuilder(
      stream: onGoingCourses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              child: const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator.adaptive(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xff153faa))),
                    SizedBox(
                      height: 23,
                    ),
                    Text(
                      'Please wait...',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ));
        }
        


        return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.3,
                childAspectRatio: 2.3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10),
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final course = snapshot.data![index];
              return buildOngoingCourseCard(course);
            });
      },
    );

    // }
    // );
  }

  

  Widget buildCourseCard(Course course) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 1,
                    spreadRadius: 1)
              ]),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CourseDetails(course: course)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                Text(
                  course.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Schedule: ${DateFormat.yMMMMd().format(course.startDate!)} - ${DateFormat.yMMMMd().format(course.endDate!)} ",
                ),
                Text(
                  "Venue: ${course.venue}",
                ),
                

                const Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      ">> See More",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff153faa),
                          decoration: TextDecoration.underline),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Chip(
                elevation: 1,
                backgroundColor: const Color(0xff153faa),
                label: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: fetchNumberOfPreRegisters(course.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                              child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xff153faa)),
                            strokeWidth: 4,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          ));
                        }

                        return Text(
                          snapshot.data.toString(),
                          style: const TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'Archivo'),
                        );
                      },
                    ),
                    const SizedBox(height: 10, width: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

   Widget buildOngoingCourseCard(Course course) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 1,
                    spreadRadius: 1)
              ]),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CourseDetails(course: course)));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                Text(
                  course.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Schedule: ${DateFormat.yMMMMd().format(course.startDate!)} - ${DateFormat.yMMMMd().format(course.endDate!)} ",
                ),
                Text(
                  "Venue: ${course.venue}",
                ),
                

                const Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      ">> See More",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff153faa),
                          decoration: TextDecoration.underline),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Chip(
                elevation: 1,
                backgroundColor: const Color(0xff153faa),
                label: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: fetchNumberOfRegisters(course.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                              child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xff153faa)),
                            strokeWidth: 4,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          ));
                        }

                        return Text(
                          snapshot.data.toString(),
                          style: const TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'Archivo'),
                        );
                      },
                    ),
                    const Text(
                      "Students",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 7,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget imageButton()
  {
    return TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return imageDialog();
            },
          );
        },
        child: const Row(
          children: [
            Icon(
              Icons.image,
              size: 20,
              color: Color(0xff153faa),
            ),
            SizedBox(
              width: 5,
            ),
            Text("Advertisment Image"),
          ],
        ));
  }

  Widget imageDialog() {
    return AlertDialog(
      // shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(30))),
      contentPadding: const EdgeInsets.only(left: 20, right: 30, top: 40),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: FractionalOffset.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(imageDialog);
              },
              icon: const Icon(Icons.clear),
            ),
          ),
          const Text(
            "Advertistment Image",
            style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
      content: Flexible(
        flex: 2,
        child: SizedBox(
          width: 550,
          height: MediaQuery.of(context).size.height * 0.9,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AdsImageForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
