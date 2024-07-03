import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ictc_admin/models/course.dart';
import 'package:ictc_admin/models/register.dart';
import 'package:ictc_admin/models/course_history.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:ictc_admin/pages/courses/register_forms.dart';
import 'package:ictc_admin/pages/courses/courses_page.dart';


class CourseHistoryWidget extends StatefulWidget {
  const CourseHistoryWidget({super.key});

  @override
  State<CourseHistoryWidget> createState() => _CourseHistoryWidgetState();
}

class _CourseHistoryWidgetState extends State<CourseHistoryWidget> {

  
  late Stream<List<CourseHistory>> _history;
  late List<CourseHistory> _allHistory;
  late List<CourseHistory> _filteredHistory;
  String _searchQuery = "";

  @override
  void initState() {
    _history = Supabase.instance.client
        .from('course_history')
        .stream(primaryKey: ['id']).map((data) {
      final history = data.map((e) => CourseHistory.fromJson(e)).toList();
      _allHistory = history;
      _filteredHistory = history;
      return history;
    });

    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  // onListRowTap(Trainee trainee) {
  //   setState(() => traineeProfileWidget =
  //       TraineeViewMore(trainee: trainee, key: ValueKey<Trainee>(trainee)));
  // }

  // void closeProfile() {
  //   setState(() => traineeProfileWidget = null);
  // }

  void _filterHistory(String query) {
    final filtered = _allHistory.where((courseHistory) {
      final courseNameLower = courseHistory.courseName.toLowerCase();
      final searchLower = query.toLowerCase();
      return courseNameLower.contains(searchLower);
    }).toList();

    setState(() {
      _searchQuery = query;
      _filteredHistory = filtered;
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
                // margin: EdgeInsets.symmetric(horizontal: 100),
                padding: const EdgeInsets.only(right: 5, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildSearchBar(),
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
        ),
        // traineeProfileWidget != null
        //     ? Flexible(
        //         flex: 1,
        //         child: Stack(
        //           children: [
        //             traineeProfileWidget!,
        //             Container(
        //               margin: const EdgeInsets.only(top: 45, right: 30),
        //               alignment: Alignment.topRight,
        //               child: IconButton(
        //                 splashRadius: 15,
        //                 onPressed: closeProfile,
        //                 icon: const Icon(Icons.close_outlined),
        //                 color: Colors.black87,
        //               ),
        //             ),
        //           ],
        //         ),
        //       )
        //     : Container(),
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
            hintText: "Search History",
            hintStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                height: 0,
                textBaseline: TextBaseline.alphabetic),
            prefixIcon: const Icon(
              CupertinoIcons.search,
              size: 16,
            ),
            prefixIconColor: Colors.black,
          ),
          onChanged: (query) => _filterHistory(query),
        ),
      ),
    );
  }

  Widget buildDataTable() {
    return StreamBuilder(
        stream: _history,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Expanded(
            child: DataTable2(
              showCheckboxColumn: false,
              sortAscending: false,empty: Column(
                children: [
                  Icon(CupertinoIcons.question_circle, size: 50, color: Colors.grey),
                  Text('Add a trainees to get started!'),
                ],
              ),
              showBottomBorder: true,
              horizontalMargin: 30,
              isVerticalScrollBarVisible: true,
              columns: const [
                DataColumn2(label: Text('Course Name')),
                DataColumn2(label: Text('ACTION')),
                DataColumn2(label: Text('Time')),
                // DataColumn2(label: Text('Attended Trainees')),
                DataColumn2(label: Text('User ID')),
              ],
              // rows: snapshot.data!.map((e) => buildRow(e)).toList(),
              rows: _filteredHistory
                  .map((courseHistory) => buildRow(courseHistory))
                  .toList(),
            ),
          );
        });
  }

  DataRow2 buildRow(CourseHistory courseHistory) {
    return DataRow2(onSelectChanged: (selected) {}, cells: [
      DataCell(Text(courseHistory.courseName.toString())),
      DataCell(Text(courseHistory.action.toString())),
      DataCell(Text(courseHistory.occurredAt.toString())),
      DataCell(Text(courseHistory.userId.toString())),
      // // const DataCell(Text('Advance Figma')),
      // const DataCell(Text('')),
      // DataCell(Row(
      //   children: [viewButton(trainee)],
      // )),
    ]);
  }

  

}