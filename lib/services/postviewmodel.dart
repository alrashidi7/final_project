import 'package:final_project/models/ticketModel.dart';
import 'package:final_project/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PostViewModel {
    String baseUrl = "https://alrashididiv.000webhostapp.com";
  // String baseUrl = "http://192.168.64.2/final-project";

  Future<String> sendEmail(String code, String email, String title) async {
    var response = await http.post(Uri.parse('$baseUrl/sendEmail.php'),
        body: {'code': code, 'title': title, 'email': email});
    if (response.statusCode == 200) {
      print("email ${response.body}");
      if (response.body.isNotEmpty) {
        return convert.json.decode(response.body);
      } else {
        return convert.json.decode(response.body);
      }
    } else {
      return convert.json.decode(response.body);
    }
  }

  Future<UserModel> forgetPassword(String email) async {
    var response =
        await http.post(Uri.parse('$baseUrl/forgetPassword.php'), body: {'email': email});
    if (response.statusCode == 200) {
      print('${UserModel.fromJson(convert.json.decode(response.body))}');
      return UserModel.fromJson(convert.json.decode(response.body));
    } else {
      return UserModel.fromJson(convert.json.decode(response.body));
    }
  }

  Future<String> activeAccount(String name) async {
    var response =
        await http.post(Uri.parse('$baseUrl/activeAccount.php'), body: {'name': name});
    if (response.statusCode == 200) {
      print('${convert.json.decode(response.body)}');
      return convert.json.decode(response.body);
    } else {
      return convert.json.decode(response.body);
    }
  }

  Future<String> resetPassword(String email, String password) async {
    var response = await http.post(Uri.parse('$baseUrl/resetPassword.php'),
        body: {'email': email, 'password': password});
    if (response.statusCode == 200) {
      return convert.json.decode(response.body);
    } else {
      return convert.json.decode(response.body);
    }
  }
  Future<List<TicketModel>> getAllTickets(
      String pickup,String destination,String date) async {
    List<TicketModel> ticketsList = <TicketModel>[];
    var response =
    await http.post(Uri.parse('$baseUrl/getAllTickets.php'), body: {
      'date': date,
      'pickupStation': pickup,
      'destinationStation': destination,
    });
    if (response.statusCode == 200) {
      List<dynamic> values = <dynamic>[];
      values = convert.json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            ticketsList.add(TicketModel.fromJson(map));

            print('Id-------${map['ticketId']}');
          } else {
            print('Id----- error');
          }
        }
      }

      return ticketsList;
    } else {
      return convert.json.decode(response.body);
    }
  }

  Future<UserModel> setUser(
      String name,
      String email,
      String phoneNum,
      String password,
      String playerID,
      String nationalID,
      String visaCard) async {
    print('object:::$name,$email,$phoneNum,$password,$playerID,$nationalID,$visaCard');
    var response = await http.post(Uri.parse('$baseUrl/register.php'), body: {
      'name': name,
      'email': email,
      'phone': phoneNum,
      'password': password,
      'playerID': playerID,
      'nationalID': nationalID,
      'visaCard': visaCard
    });
    String status = "";
    if (response.statusCode == 200) {
      status = UserModel.fromJson(convert.json.decode(response.body)).status;
      print('register:$status');
      return UserModel.fromJson(convert.json.decode(response.body));
    } else {
      status = "please check your connection";
      print('register:$status');
      return UserModel.fromJson(convert.json.decode(response.body));
    }
  }

  Future<UserModel> login(String name, String password) async {
    var response = await http.post(Uri.parse('$baseUrl/login.php'), body: {
      'name': name,
      'password': password,
    });
    if (response.statusCode == 200) {
      if (UserModel.fromJson(convert.json.decode(response.body)).status ==
          'active') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('name',
            UserModel.fromJson(convert.json.decode(response.body)).name);

        prefs.setString('email',
            UserModel.fromJson(convert.json.decode(response.body)).email);
        prefs.setString('password',
            UserModel.fromJson(convert.json.decode(response.body)).password);

        prefs.setString('playerID',
            UserModel.fromJson(convert.json.decode(response.body)).playerID);
        prefs.setString('visaCard',
            UserModel.fromJson(convert.json.decode(response.body)).visaCard);

        prefs.setString('nationalID',
            UserModel.fromJson(convert.json.decode(response.body)).nationalID);
        prefs.setString('phone',
            UserModel.fromJson(convert.json.decode(response.body)).phone);

        return UserModel.fromJson(convert.json.decode(response.body));
      } else {
        return UserModel.fromJson(convert.json.decode(response.body));
      }
    } else {
      return UserModel.fromJson(convert.json.decode(response.body));
    }
  }
}
