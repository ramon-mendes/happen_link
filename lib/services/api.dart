import 'dart:convert';

import 'package:happen_link/apimodels/deck.dart';
import 'package:happen_link/apimodels/review.dart';
import 'package:happen_link/apimodels/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const API_URL = 'happenlinkbackend.azurewebsites.net';
const PREFERENCES = 'logged_user';

class API {
  static String _token;
  static Map<String, String> _headers;

  static void logout() {}

  static Future<User> login(String email, String pwd) async {
    final queryParameters = {
      'email': email,
      'pwd': pwd,
    };
    final response = await http.get(Uri.https(API_URL, "api/user/login", queryParameters));

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(PREFERENCES, response.body);

      var user = User.fromJson(jsonDecode(response.body));
      _token = user.token;
      _headers = {'Authorization': 'Bearer $_token'};
      return user;
    } else {
      throw Exception('Failed to load');
    }
  }

  static Map<String, String> jsonHeader() {
    var copy = Map<String, String>.from(_headers);
    copy['Content-Type'] = 'application/json';
    return copy;
  }

  static Future<List<Deck>> deckList() async {
    final response = await http.get(Uri.https(API_URL, "api/deck/list"), headers: _headers);
    if (response.statusCode == 200) {
      var all = jsonDecode(response.body);
      var list = <Deck>[];
      for (var item in all) {
        list.add(Deck.fromJson(item));
      }
      return list;
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future<void> deckCreate(String title) async {
    Map<String, String> data = {
      "title": title,
    };
    final response = await http.post(
      Uri.https(API_URL, "api/deck/create"),
      headers: jsonHeader(),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future<void> deckRemove(String id) async {
    final response = await http.get(Uri.https(API_URL, "api/deck/remove", {'id': id}), headers: _headers);
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future<ReviewList> fcGetReviewList(String id) async {
    final response = await http.get(Uri.https(API_URL, "api/flashcard/getreviewlist", {'id': id}), headers: _headers);
    if (response.statusCode == 200) {
      return ReviewList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future<ReviewList> fcCommitReview(ReviewCommit commit) async {
    final response = await http.post(
      Uri.https(API_URL, "api/flashcard/commitreview"),
      headers: jsonHeader(),
      body: jsonEncode(commit.toJson()),
    );
    if (response.statusCode == 200) {
      return ReviewList.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }

  //static Future<List<Deck>> flashcardUpdateCreate() async {}
}
