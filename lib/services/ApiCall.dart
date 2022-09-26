import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/model/VerifyOtp.dart';
import 'package:untitled/screen/login.dart';
import 'package:untitled/utils/CommomDialog.dart';
import 'package:untitled/utils/appconstant.dart';

class APICall {
  final apiBaseUri = "http://bltechno.atwebpages.com/index.php/Dashboard";

  Future<String> registerUrse(Map map, url) async {
    Map<String, String> mainheader = {
      "Content-type": "application/x-www-form-urlencoded",
    };
    var apiUrl = Uri.parse(AppConstant.BASE_URL + url);
    print(apiUrl);
    print(map);
    final response = await http.post(apiUrl, headers: mainheader, body: map);
    final body = json.decode(response.body);
print(response.statusCode);
    print(response.statusCode);

    print(response.statusCode);

    print(response.statusCode);

    print(response.statusCode);

    print(response.statusCode);

    print(response.statusCode);

    print(response.statusCode);

    print(response.statusCode);

    print(response.statusCode);


    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(response.statusCode);
       print(response.body);
      return jsonString;
    }else if(response.statusCode==403){
      SharedPreferences prefrences = await SharedPreferences.getInstance();
      await prefrences.remove("session");
      print(body["message"]);
      CommonDialog.showsnackbar(body["message"]);
      Get.offAll(LoginPage());
      return "null";
    }
    else {
      return "null";
    }
  }

  Future<String> postWithoutBody(url) async {
    Map<String, String> mainheader = {
      "Content-type": "application/x-www-form-urlencoded",
    };
    var apiUrl = Uri.parse(AppConstant.BASE_URL + url);
    print(apiUrl);
    final response = await http.post(
      apiUrl,
      headers: mainheader,
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(response.statusCode);
      // print(response.body);
      return jsonString;
    } else {
      return "null";
    }
  }

  Future<String> getMethod(Map map, url) async {
    Map<String, String> mainheader = {
      "Content-type": "application/x-www-form-urlencoded",
    };
    var apiUrl = Uri.parse(AppConstant.BASE_URL + url);
    print(apiUrl);
    print(map);
    final response = await http.get(
      apiUrl,
      headers: mainheader,
    );
    print("SDFDSFDFDFDF");
    print(response.body);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(response.statusCode);
      print("SDFDSFDFDFDF");
      print(response.body);
      return jsonString;
    } else {
      return "null";
    }
  }

  Future<String> registerUserMulti(referel_code,
      image, name, email, dob, gender, phone, device_type, device_token) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConstant.BASE_URL + AppConstant.REGISTER));

    request.files.add(http.MultipartFile.fromBytes(
        'image', File(image.path).readAsBytesSync(),
        filename: image.path.split("/").last));

    request.fields['name'] = name;
    request.fields['referel_code'] = referel_code+"";
    request.fields['email'] = email;
    request.fields['dob'] = "" + dob;
    request.fields['gender'] = gender;
    request.fields['device_type'] = device_type;
    request.fields['device_token'] = device_token;
    request.fields['phone'] = phone;
    print(request);
    http.Response response =
        await http.Response.fromStream(await request.send());
    print("SDF DSF SDF SDF SDF ");
    print("Result: ${response.body}");
    if (response.statusCode == 400) {
      print(response);
      return "null";
    } else {
      return response.body;
    }
  }

  Future<String> registerUpdateProfileMulti(session, image, name, email, dob,
      gender, phone, device_type, device_token) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(AppConstant.BASE_URL + AppConstant.UPDATE_PROFILE));
    if (image != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'image', File(image.path).readAsBytesSync(),
          filename: image.path.split("/").last));
    }

    request.fields["session_id"] = session;
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['dob'] = "" + dob;
    request.fields['gender'] = gender;
    request.fields['device_type'] = device_type;
    request.fields['device_token'] = device_token;
    request.fields['phone'] = phone;
    print(request);
    http.Response response =
        await http.Response.fromStream(await request.send());
    print("SDF DSF SDF SDF SDF ");
    print("Result: ${response.body}");
    if (response.statusCode == 400) {
      print(response);
      return "null";
    } else {
      return response.body;
    }
  }
}
