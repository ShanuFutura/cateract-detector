import 'dart:convert';
import 'dart:io';

import 'package:cateract_detector/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class HttpServices {
  // static postData(Map params, String endpoint) async {

  // }

  static Future<dynamic> postData({
    required String endPoint,
    Map? params,
    File? image,
    String? imageParameter,
  }) async {
    if (image != null && imageParameter != null) {
      var res;
    try{  var request =
          MultipartRequest("POST", Uri.parse(Constants.baseUrl + endPoint));

          // for(MapEntry<dynamic, dynamic>? element in params){

          // }
      if(params!=null){params.entries.forEach((element) {
        request.fields[element.key] = element.value;
      });}
      request.files.add(await MultipartFile.fromPath(
        imageParameter,
        image.path,
      ));
      final response = await request.send();

      if (response.statusCode == 200){ print("Uploaded!");}else{
        Fluttertoast.showToast(msg: 'Connection error');
      }
      final data = await Response.fromStream(response);
      print('image api response: ${data.body}');
      res = jsonDecode(data.body) ;
      }on Exception catch(err){
        Fluttertoast.showToast(msg: '$err');
      }

      return res;
    } else {
      try {
        Response res = await post(Uri.parse(Constants.baseUrl + endPoint));
        return jsonDecode(res.body)['result'] = true;
      } on HttpException catch (err) {
        Fluttertoast.showToast(msg: err.message);
        return {'exception': err.message, 'result': false};
      }
    }
  }
}
