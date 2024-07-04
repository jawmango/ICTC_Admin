import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ictc_admin/models/course.dart';
import 'package:ictc_admin/models/register.dart';
import 'package:ictc_admin/models/program_history.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:ictc_admin/pages/courses/register_forms.dart';
import 'package:ictc_admin/pages/courses/courses_page.dart';


class ProgramHistoryWidget extends StatefulWidget {
  const ProgramHistoryWidget({super.key});

  @override
  State<ProgramHistoryWidget> createState() => _ProgramHistoryWidgetState();
}

class _ProgramHistoryWidgetState extends State<ProgramHistoryWidget> {

  
  late Stream<List<ProgramHistory>> _history;
  late List<ProgramHistory> _allHistory;
  late List<ProgramHistory> _filteredHistory;
  String _searchQuery = "";

  @override
  void initState() {
    _history = Supabase.instance.client
        .from('program_history')
        .stream(primaryKey: ['id']).map((data) {
      final history = data.map((e) => ProgramHistory.fromJson(e)).toList();
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
  // Future<String> getEmail(String userId) async {
  //   final response = await Supabase.instance.client
  //   .from('auth.users')
  //   .select('email')
  //   .eq('id', userId)
  //   .single();

  //   final email = response['email'] as String;

  //   return email;

  // }

  void _filterHistory(String query) {
    final filtered = _allHistory.where((programHistory) {
      final programNameLower = programHistory.programName.toLowerCase();
      final searchLower = query.toLowerCase();
      return programNameLower.contains(searchLower);
    }).toList();

    setState(() {
      _searchQuery = query;
      _filteredHistory = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:15),
                      child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      ),
                    ),
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
                  ],
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
      ),
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
                  Text('No Logs found'),
                ],
              ),
              showBottomBorder: true,
              horizontalMargin: 30,
              isVerticalScrollBarVisible: true,
              columns: const [
                DataColumn2(label: Text('Program Name')),
                DataColumn2(label: Text('ACTION')),
                DataColumn2(label: Text('Time')),
                // DataColumn2(label: Text('Attended Trainees')),
                
                DataColumn2(label: Text('User Email'))
              ],
              // rows: snapshot.data!.map((e) => buildRow(e)).toList(),
              rows: _filteredHistory
                  .map((programHistory) => buildRow(programHistory))
                  .toList(),
            ),
          );
        });
  }

  DataRow2 buildRow(ProgramHistory programHistory) {
    return DataRow2(onSelectChanged: (selected) {}, cells: [
      DataCell(Text(programHistory.programName.toString())),
      DataCell(Text(programHistory.action.toString())),
      DataCell(Text(programHistory.occurredAt.toString())),
      DataCell(Text(programHistory.userEmail.toString())),
      

      // // const DataCell(Text('Advance Figma')),
      // const DataCell(Text('')),
      // DataCell(Row(
      //   children: [viewButton(trainee)],
      // )),
    ]);
  }

  Widget backButton() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: const Row(
          children: [
            Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.grey,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Back to Program Page",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ));
  }

}