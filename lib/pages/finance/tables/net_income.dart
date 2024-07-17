import 'dart:convert';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ictc_admin/models/course.dart';
import 'package:ictc_admin/models/payment.dart';
import 'package:ictc_admin/models/expense.dart';
import 'package:ictc_admin/models/program.dart';
import 'package:ictc_admin/models/seeds.dart';
import 'package:ictc_admin/models/trainee.dart';
import 'package:ictc_admin/pages/finance/forms/payment_form.dart';
import 'package:ictc_admin/pages/finance/forms/receipt_form.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:pluto_grid_plus_export/pluto_grid_plus_export.dart'
    as pluto_grid_plus_export;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ictc_admin/models/register.dart';


class NetIncomeTable extends StatefulWidget {
  const NetIncomeTable({super.key});

  @override
  State<NetIncomeTable> createState() => _NetIncomeTableState();
}

class _NetIncomeTableState extends State<NetIncomeTable> {
  late Stream<List<Course>> _courses;
  @override
  void initState() {
     _courses = Supabase.instance.client.from('course').stream(primaryKey: ['id']).map((data) {
      final courses = data.map((e) => Course.fromJson(e)).toList();
      return courses;
    });
    super.initState();
  }

   Future<String> fetchProgram(int programId) async {

  final programFetched = await Supabase.instance.client
      .from('program')
      .select('title')
      .eq('id', programId)
      .single()
      .then((response) {
              final programName = response['title'] as String;
              return programName;
            });

      final String title = programFetched;
      return title;
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

   Future<int> fetchIncome(int courseId) async {
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

   Future<int> fetchExpenses(int courseId) async {

  final expensesFetched = await Supabase.instance.client
      .from('expense')
      .select('total_amount')
      .eq('course_id', courseId)
      .withConverter((list) {
          return list.map((data) => data['total_amount'] as int).toList();
  });

 
  final int sumofExpenses = expensesFetched.fold(0, (sum, expensesFetched) => sum + expensesFetched);


  return sumofExpenses;
  }
  
  Future<List<PlutoRow>> _fetchRows(List<Course> courses) async {
  List<PlutoRow> rows = [];

  for (var course in courses) {
    var netIncome = await fetchPayments(course.id!);
    var totalIncome = await fetchIncome(course.id!);
    var totalExpenses = await fetchExpenses(course.id!);
    var programName = await fetchProgram(course.programId!);

    PlutoRow row = PlutoRow(
      cells: {
        'courseName': PlutoCell(value: course.title),
        'programName': PlutoCell(value: programName.toString()),
        'courseStart': PlutoCell(value: DateFormat('yyyy-MMM-dd').format(course.startDate)),
        'courseEnd': PlutoCell(value: DateFormat('yyyy-MMM-dd').format(course.endDate)),
        'totalIncome': PlutoCell(value: totalIncome.toString()),
        'totalExpenses':PlutoCell(value: totalExpenses.toString()),
        'amount': PlutoCell(value: netIncome.toString()),
      },
    );

    rows.add(row);
  }

  return rows;
}

  late PlutoGridStateManager stateManager;

void exportToPdf() async {
    final themeData = pluto_grid_plus_export.ThemeData.withFont(
      base: pluto_grid_plus_export.Font.ttf(
        await rootBundle.load('assets/fonts/Archivo-Regular.ttf'),
      ),
      bold: pluto_grid_plus_export.Font.ttf(
        await rootBundle.load('assets/fonts/Archivo-Bold.ttf'),
      ),
    );

    var plutoGridPdfExport = pluto_grid_plus_export.PlutoGridDefaultPdfExport(
      title: "ADNU ICTC Income Report",
      creator: "ICTC Office",
      format: pluto_grid_plus_export.PdfPageFormat.a4.landscape,
      themeData: themeData,
    );

    await pluto_grid_plus_export.Printing.sharePdf(
      bytes: await plutoGridPdfExport.export(stateManager),
      filename: plutoGridPdfExport.getFilename(),
    );
  }

  void _defaultExportGridAsCSV() async {
    String title = "pluto_grid_plus_export";
    var exported = const Utf8Encoder().convert(
        pluto_grid_plus_export.PlutoGridExport.exportCSV(stateManager));
    await FileSaver.instance
        .saveFile(name: "$title.csv", ext: ".csv", bytes: exported);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                // margin: EdgeInsets.symmetric(horizontal: 100),
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [csvButton(), pdfButton()],
                ),
              ),
              Expanded(child: buildInDataTable()),
            ],
          ),
        ),
      ],
    );
  }


  Widget csvButton() {
    return ElevatedButton(
        onPressed: _defaultExportGridAsCSV, child: const Text("Export to CSV"));
  }

  Widget pdfButton() {
    return ElevatedButton(
        onPressed: exportToPdf, child: const Text("Export to PDF"));
  }


  // IN (Income)
  List<PlutoColumn> inColumns = [
    PlutoColumn(
      title: 'Course Name',
      field: 'courseName',
      readOnly: true,
      filterHintText: 'Search Course',
      type: PlutoColumnType.text(),
      textAlign: PlutoColumnTextAlign.right,
      titleTextAlign: PlutoColumnTextAlign.center,
      enableEditingMode: false,
    ),
    PlutoColumn(
      title: 'Program Name',
      field: 'programName',
      readOnly: true,
      filterHintText: 'Search Course',
      type: PlutoColumnType.text(),
      textAlign: PlutoColumnTextAlign.right,
      titleTextAlign: PlutoColumnTextAlign.center,
      enableEditingMode: false,
    ),
    PlutoColumn(
      title: 'Course Start Date',
      field: 'courseStart',
      readOnly: true,
      filterHintText: 'Search Course',
      type: PlutoColumnType.text(),
      textAlign: PlutoColumnTextAlign.right,
      titleTextAlign: PlutoColumnTextAlign.center,
      enableEditingMode: false,
    ),
    PlutoColumn(
      title: 'Course End Date',
      field: 'courseEnd',
      readOnly: true,
      filterHintText: 'Search Course',
      type: PlutoColumnType.text(),
      textAlign: PlutoColumnTextAlign.right,
      titleTextAlign: PlutoColumnTextAlign.center,
      enableEditingMode: false,
    ),
    PlutoColumn(
      title: 'Total Income',
      field: 'totalIncome',
      readOnly: true,
      type: PlutoColumnType.number(),
      backgroundColor: Colors.yellow.withOpacity(0.1),
      filterWidget: Container(
        color: Colors.white,
      ),
      enableFilterMenuItem: false,
      footerRenderer: (rendererContext) {
        return PlutoAggregateColumnFooter(
          rendererContext: rendererContext,
          type: PlutoAggregateColumnType.sum,
          format: 'P#,###',
          alignment: Alignment.centerRight,
          titleSpanBuilder: (text) {
            return [
              const TextSpan(
                text: 'Total Income',
                style: TextStyle(color: Colors.yellow),
              ),
              const TextSpan(text: ' : '),
              TextSpan(
                  text: text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ];
          },
        );
      },
      textAlign: PlutoColumnTextAlign.right,
      titleTextAlign: PlutoColumnTextAlign.center,
      enableEditingMode: false,
      enableDropToResize: false,
    ),
    PlutoColumn(
      title: 'Total Expenses',
      field: 'totalExpenses',
      readOnly: true,
      type: PlutoColumnType.number(),
      backgroundColor: Colors.red.withOpacity(0.1),
      filterWidget: Container(
        color: Colors.white,
      ),
      enableFilterMenuItem: false,
      footerRenderer: (rendererContext) {
        return PlutoAggregateColumnFooter(
          rendererContext: rendererContext,
          type: PlutoAggregateColumnType.sum,
          format: 'P#,###',
          alignment: Alignment.centerRight,
          titleSpanBuilder: (text) {
            return [
              const TextSpan(
                text: 'Total Expenses',
                style: TextStyle(color: Colors.red),
              ),
              const TextSpan(text: ' : '),
              TextSpan(
                  text: text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ];
          },
        );
      },
      textAlign: PlutoColumnTextAlign.right,
      titleTextAlign: PlutoColumnTextAlign.center,
      enableEditingMode: false,
      enableDropToResize: false,
    ),
    PlutoColumn(
      title: 'Net Income',
      field: 'amount',
      readOnly: true,
      type: PlutoColumnType.number(),
      width: 235,
      backgroundColor: Colors.green.withOpacity(0.1),
      filterWidget: Container(
        color: Colors.white,
      ),
      enableFilterMenuItem: false,
      footerRenderer: (rendererContext) {
        return PlutoAggregateColumnFooter(
          rendererContext: rendererContext,
          type: PlutoAggregateColumnType.sum,
          format: 'P#,###',
          alignment: Alignment.centerRight,
          titleSpanBuilder: (text) {
            return [
              const TextSpan(
                text: 'Total Net Income',
                style: TextStyle(color: Colors.green),
              ),
              const TextSpan(text: ' : '),
              TextSpan(
                  text: text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ];
          },
        );
      },
      textAlign: PlutoColumnTextAlign.right,
      titleTextAlign: PlutoColumnTextAlign.center,
      enableEditingMode: false,
      enableDropToResize: false,
    ),
  ];

 

  Widget buildInDataTable() {
    return Flexible(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        child: StreamBuilder(
            stream: _courses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
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
                );
              }

              if (snapshot.data!.isEmpty) {
                return const Expanded(
                    child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: 50,
                        color: Colors.grey,
                      ),
                      Text("No entries found."),
                    ],
                  ),
                ));
              }

              return FutureBuilder(
                future: _fetchRows(snapshot.data!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator.adaptive(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xff153faa))),
                            SizedBox(
                              height: 23,
                            ),
                            Text(
                              'Crunching data for you...',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return PlutoGrid(
                      columns: inColumns,
                      rows: snapshot.data!,
                      onChanged: (PlutoGridOnChangedEvent event) {
                        print(event);
                      },
                      onLoaded: (PlutoGridOnLoadedEvent event) {
                        stateManager = event.stateManager;
                        stateManager.setShowColumnFilter(true);
                      },
                      rowColorCallback: (rowColorContext) {
                        if (rowColorContext.rowIdx % 2 != 0) {
                          return Colors.grey.withOpacity(0.1);
                        } else {
                          return Colors.transparent;
                        }
                      },
                      configuration: PlutoGridConfiguration(
                        columnFilter: PlutoGridColumnFilterConfig(
                          filters: const [
                            ...FilterHelper.defaultFilters,
                            // custom filter
                            ClassYouImplemented(),
                          ],
                          resolveDefaultColumnFilter: (column, resolver) {
                            if (column.field == 'text') {
                              return resolver<PlutoFilterTypeContains>()
                                  as PlutoFilterType;
                            } else if (column.field == 'number') {
                              return resolver<PlutoFilterTypeGreaterThan>()
                                  as PlutoFilterType;
                            } else if (column.field == 'date') {
                              return resolver<PlutoFilterTypeContains>()
                                  as PlutoFilterType;
                            } else if (column.field == 'select') {
                              return resolver<ClassYouImplemented>()
                                  as PlutoFilterType;
                            }

                            return resolver<PlutoFilterTypeContains>()
                                as PlutoFilterType;
                          },
                        ),
                      ));
                },
              );
            }),
      ),
    );
  }
}

class ClassYouImplemented implements PlutoFilterType {
  @override
  String get title => 'Custom contains';

  @override
  get compare => ({
        required String? base,
        required String? search,
        required PlutoColumn? column,
      }) {
        var keys = search!.split(',').map((e) => e.toUpperCase()).toList();

        return keys.contains(base!.toUpperCase());
      };

  const ClassYouImplemented();
}
