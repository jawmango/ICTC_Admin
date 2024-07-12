import 'dart:convert';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ictc_admin/models/course.dart';
import 'package:ictc_admin/models/payment.dart';
import 'package:ictc_admin/models/program.dart';
import 'package:ictc_admin/models/expense.dart';
import 'package:ictc_admin/models/net_income.dart';
import 'package:ictc_admin/models/seeds.dart';
import 'package:ictc_admin/models/trainee.dart';
import 'package:ictc_admin/pages/finance/forms/payment_form.dart';
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
  late NetIncome? netIncome;
  late Stream<List<Course>> netIncomeCourses;

  @override
  void initState() {
    netIncomeCourses = Supabase.instance.client
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
  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}