import 'dart:io';

class ScanReport{
  ScanReport({
    required this.accuracy,
    required this.detection,
    required this.remarks,
    required this.image,
  });
  File image;
  String detection;
  double accuracy;
  String remarks;
}