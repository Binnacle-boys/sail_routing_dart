import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
// Polar plot class generated through csv polar plot files
class PolarPlot {

  Future init (String filepath) async {
    final input = new File(filepath).openRead();
    final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
    print(fields.toString());
  }
  void hello() {
    print("Working");
  }
}