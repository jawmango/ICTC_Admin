import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:ictc_admin/models/course.dart';
import 'package:ictc_admin/models/payment.dart';
import 'package:ictc_admin/pages/Courses/courseImage_forms.dart';
import 'package:ictc_admin/pages/Courses/course_details.dart';
import 'package:ictc_admin/pages/courses/course_viewMore.dart';
import 'package:ictc_admin/pages/courses/course_forms.dart';
import 'package:ictc_admin/pages/courses/registration_forms.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ictc_admin/pages/Courses/course_history.dart';

class NetIncomePage extends StatefulWidget {
  const NetIncomePage({super.key});

  @override
  State<NetIncomePage> createState() => _NetIncomePageState();
}

class _NetIncomePageState extends State<NetIncomePage> {
  CourseViewMore? courseProfileWidget;

  late Payment? payment;
  late Stream<List<Course>> _courses;
  late List<Course> _allCourses;
  late List<Course> _filteredCourses;
  String _searchQuery = "";
  bool _sortAscendingTitle = false;
  bool _sortAscendingCost = false;
  bool _sortAscendingStart = false;
  bool _sortAscendingEnd = false;// Track current sorting order

  @override
  void initState() {
    _courses = Supabase.instance.client.from('course').stream(primaryKey: ['id']).map((data) {
      final courses = data.map((e) => Course.fromJson(e)).toList();
      _allCourses = courses;
      _filteredCourses = courses;
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
        .count();

    print(response);

    return response.count;
  }

  Future<int> fetchPayments(int courseId) async {
  final paymentsFetched = await Supabase.instance.client
      .from('payment')
      .select('total_amount')
      .eq('course_id', courseId)
      .withConverter((list) {
          return list.map((data) => data['total_amount'] as int).toList();
  });

  final expensesFetched = await Supabase.instance.client
      .from('expense')
      .select('total_amount')
      .eq('course_id', courseId)
      .withConverter((list) {
          return list.map((data) => data['total_amount'] as int).toList();
  });

  final int sumofPayments = paymentsFetched.fold(0, (sum, paymentsFetched) => sum + paymentsFetched);
  final int sumofExpenses = expensesFetched.fold(0, (sum, expensesFetched) => sum + expensesFetched);
  final int net = sumofPayments - sumofExpenses;

  return net;
  }

  Future<int> fetchExpenses(int courseId) async {
  final paymentsFetched = await Supabase.instance.client
      .from('payment')
      .select('total_amount')
      .eq('course_id', courseId)
      .withConverter((list) {
          return list.map((data) => data['total_amount'] as int).toList();
  });

  final int sumofPayments = paymentsFetched.fold(0, (sum, paymentsFetched) => sum + paymentsFetched);

  return sumofPayments;
  }


//   Future<Map<String, dynamic>> fetchTotalIncome(int courseId) async {
//   print('fetching total income');
  
//   // Fetching registrations
//   final response = await Supabase.instance.client
//       .from('payment')
//       .select('total_amount')
//       .eq('course_id', courseId)
//       .withConverter(
//                     (data) => data.map((e) => Payment.fromJson(e)).toList())

//   // Extracting ids and calculating sum
//   final List<dynamic>? data = response.data;
//   final List<int> income = data?.map((item) => item['total_amount'] as int).toList() ?? [];
//   final int sumOfIds = income.fold(0, (sum, income) => sum + income);

//   // Printing the response
//   print('Sum of IDs: $sumOfIds');

//   // Returning a map with count and sum of ids
//   return {
//     'sumOfIds': sumOfIds,
//   };
// }

  


  void _filterCourses(String query) {
    final filtered = _allCourses.where((courses) {
      final titleLower = courses.title.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      _searchQuery = query;
      _filteredCourses = filtered;
    });
  }

  void _sortCoursesByTitle() {
    setState(() {
      _sortAscendingTitle = !_sortAscendingTitle; // Toggle the sorting order
      // Sort _filteredCourses based on title
      _filteredCourses.sort((a, b) => _sortAscendingTitle
          ? a.title.compareTo(b.title)
          : b.title.compareTo(a.title));
    });
  }
  void _sortCoursesByCost() {
    setState(() {
      _sortAscendingCost = !_sortAscendingCost; // Toggle the sorting order
      // Sort _filteredCourses based on cost
      _filteredCourses.sort((a, b) => _sortAscendingCost
          ? a.cost.compareTo(b.cost)
          : b.cost.compareTo(a.cost));
    });
  }
  void _sortCoursesByStart() {
    setState(() {
      _sortAscendingStart = !_sortAscendingStart; // Toggle the sorting order
      // Sort _filteredCourses based on start Date
      _filteredCourses.sort((a, b) => _sortAscendingStart
          ? a.startDate.compareTo(b.startDate)
          : b.startDate.compareTo(a.startDate));
    });
  }
  void _sortCoursesByEnd() {
    setState(() {
      _sortAscendingEnd = !_sortAscendingEnd; // Toggle the sorting order
      // Sort _filteredCourses based on start Date
      _filteredCourses.sort((a, b) => _sortAscendingEnd
          ? a.endDate.compareTo(b.endDate)
          : b.endDate.compareTo(a.endDate));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 5, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    buildSearchBar(),
                   
                    const SizedBox(width: 3),
                   
                    
                  ],
                ),
              ),
              buildDataTable(),
            ],
          ),
        ),
        const VerticalDivider(
          color: Colors.black87,
          thickness: 0.1,
        )
      ],
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 350,
        height: 40,
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            hintText: "Search a Course...",
            hintStyle: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              height: 0,
              textBaseline: TextBaseline.alphabetic,
            ),
            prefixIcon: const Icon(
              CupertinoIcons.search,
              size: 16,
            ),
            prefixIconColor: Colors.black,
          ),
          onChanged: (query) => _filterCourses(query),
        ),
      ),
    );
  }

  Widget buildDataTable() {
    return StreamBuilder(
      stream: _courses,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        List<Course> reversedCourses = _filteredCourses.reversed.toList();
        return Expanded(
          child: DataTable2(
            empty: Column(
              children: [
                Icon(CupertinoIcons.question_circle, size: 50, color: Colors.grey),
                Text('Add a course to get started!'),
              ],
            ),
            showCheckboxColumn: false,
            showBottomBorder: true,
            horizontalMargin: 30,
            isVerticalScrollBarVisible: true,
            columns: [
              DataColumn2(
                label: Row(
                  children: [
                    Text('Title'),
                    sortButton(),
                  ],
                ),
                onSort: (columnIndex, ascending) {
                  _sortCoursesByTitle(); // Sort by title when column header is tapped
                },
              ),
              DataColumn2(
                label: 
                Row(
                  children: [
                    Text('Cost'),
                    sortButtonCost(),
                  ],
                ),
                onSort: (columnIndex, ascending) {
                  _sortCoursesByCost();
                },
                ),
              DataColumn2(
                label: 
                Row(
                  children: [
                    Text('Start Date'),
                    sortButtonStart(),
                  ],
                )
                ),
              DataColumn2(
                label: 
                Row(
                  children: [
                    Text('End Date'),
                    sortButtonEnd(),
                  ],
                ),
                onSort: (columnIndex, ascending) {
                  _sortCoursesByEnd();
                },
                ),
              DataColumn2(label: Text('Total Students')),
              DataColumn2(label: Text('Net Income')),
            ],
            rows: reversedCourses.map((course) => buildRow(course)).toList(),
          ),
        );
      },
    );
  }

  DataRow2 buildRow(Course course) {
    return DataRow2(
      onSelectChanged: (selected) {},
      cells: [
        DataCell(Text(course.title.toString())),
        DataCell(Text(course.cost.toString())),
        DataCell(Text("${DateFormat.yMMMMd().format(course.startDate!)}")),
        DataCell(Text("${DateFormat.yMMMMd().format(course.endDate!)}")),
        DataCell(
          FutureBuilder(
            future: fetchNumberOfPreRegisters(course.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: 12,
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xff153faa)),
                  ),
                );
              }
              return Text(
                snapshot.data.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  fontFamily: 'Archivo',
                ),
              );
            },
          ),
        ),
        DataCell(
          FutureBuilder(
            future: fetchPayments(course.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: 12,
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xff153faa)),
                  ),
                );
              }
              return Text(
                snapshot.data.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  fontFamily: 'Archivo',
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  Widget sortButton() {
    return IconButton(
      onPressed: () {
        _sortCoursesByTitle(); // Trigger sorting when sort button is tapped
      },
      icon: Icon(
            _sortAscendingTitle ? Icons.arrow_upward : Icons.arrow_downward,
            size: 25,
            color: Colors.white,
          ),
    );
  }
  Widget sortButtonCost() {
    return IconButton(
      onPressed: () {
        _sortCoursesByCost(); // Trigger sorting when sort button is tapped
      },
      icon: Icon(
            _sortAscendingCost ? Icons.arrow_upward : Icons.arrow_downward,
            size: 25,
            color: Colors.white,
          ),
    );
  }
  Widget sortButtonStart() {
    return IconButton(
      onPressed: () {
        _sortCoursesByStart(); // Trigger sorting when sort button is tapped
      },
      icon: Icon(
            _sortAscendingStart ? Icons.arrow_upward : Icons.arrow_downward,
            size: 25,
            color: Colors.white,
          ),
    );
  }
  Widget sortButtonEnd() {
    return IconButton(
      onPressed: () {
        _sortCoursesByEnd(); // Trigger sorting when sort button is tapped
      },
      icon: Icon(
            _sortAscendingEnd ? Icons.arrow_upward : Icons.arrow_downward,
            size: 25,
            color: Colors.white,
          ),
    );
  }

}
