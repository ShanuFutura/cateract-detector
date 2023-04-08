import 'dart:io';

class Report {
  Report({
    required this.image,
    required this.detection,
    required this.description,
  });
  File image;
  String detection;
  String description;
}



