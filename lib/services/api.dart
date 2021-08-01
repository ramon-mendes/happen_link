import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:happen_link/apimodels/deck.dart';
import 'package:happen_link/apimodels/flashcard.dart';
import 'package:happen_link/apimodels/gpslink.dart';
import 'package:happen_link/apimodels/procedure.dart';
import 'package:happen_link/apimodels/procedureitem.dart';
import 'package:happen_link/apimodels/review.dart';
import 'package:happen_link/apimodels/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const API_URL = 'happenlinkbackend.azurewebsites.net';
//const API_URL = '10.0.2.2:51388';
const PREFERENCES_KEY = 'logged_user';

enum ELoginResult {
  NO_INTERNET,
  LOGIN_INVALID,
  ERROR,
  OK,
}

class API {
  static String _token;
  static Map<String, String> _headers;
  BuildContext _context;
  static User loggedUser;

  API.of(this._context);

  static void _loadConfigs() {
    _token = loggedUser.token;
    _headers = {'Authorization': 'Bearer $_token'};
  }

  static Map<String, String> _jsonHeader() {
    var copy = Map<String, String>.from(_headers);
    copy['Content-Type'] = 'application/json';
    return copy;
  }

  Future<bool> _checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      final snackBar = SnackBar(
        content: Text('Não foi possível completar esta ação. Verifique sua conexão com a internet.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(_context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }

  void _catchException() {
    final snackBar = SnackBar(
      content: Text('Não foi possível completar esta ação.'),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
    throw Exception(); // so the Future don't resolves
  }

  static Future<bool> isLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(PREFERENCES_KEY)) {
      loggedUser = User.fromJson(jsonDecode(prefs.getString(PREFERENCES_KEY)));
      _loadConfigs();
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    _token = null;
    _headers = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<ELoginResult> login(String email, String pwd) async {
    if (!await _checkInternet()) return ELoginResult.NO_INTERNET;

    try {
      final queryParameters = {
        'email': email,
        'pwd': pwd,
      };
      final response = await http.get(Uri.https(API_URL, "api/user/login", queryParameters));

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(PREFERENCES_KEY, response.body);

        loggedUser = User.fromJson(jsonDecode(response.body));
        _loadConfigs();
        return ELoginResult.OK;
      } else {
        return ELoginResult.LOGIN_INVALID;
      }
    } catch (e) {}
    return ELoginResult.ERROR;
  }

  Future<List<Deck>> deckList() async {
    if (!await _checkInternet()) throw Exception();

    try {
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
    } catch (e) {
      _catchException();
    }
    return null;
  }

  Future<void> deckCreate(String title) async {
    if (!await _checkInternet()) throw Exception();

    try {
      Map<String, String> data = {
        "title": title,
      };
      final response = await http.post(
        Uri.https(API_URL, "api/deck/create"),
        headers: _jsonHeader(),
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
  }

  Future<void> deckRemove(String id) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response = await http.get(Uri.https(API_URL, "api/deck/remove", {'id': id}), headers: _headers);
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
  }

  Future<void> deckReset(String id) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response = await http.get(Uri.https(API_URL, "api/deck/reset", {'id': id}), headers: _headers);
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
  }

  Future<ReviewList> fcGetReviewList(String id) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response = await http.get(Uri.https(API_URL, "api/flashcard/getreviewlist", {'id': id}), headers: _headers);
      if (response.statusCode == 200) {
        print(response.body);
        return ReviewList.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
    return null;
  }

  Future<void> fcCommitReview(ReviewCommit commit) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response = await http.post(
        Uri.https(API_URL, "api/flashcard/commitreview"),
        headers: _jsonHeader(),
        body: jsonEncode(commit.toJson()),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
  }

  Future<void> fcCreate(Flashcard model) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final body = model.toJson();
      body.remove('id'); // fuck

      final response = await http.post(
        Uri.https(API_URL, "api/flashcard/create"),
        headers: _jsonHeader(),
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }

    return null;
  }

  Future<void> fcDelete(Flashcard model) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response = await http.get(Uri.https(API_URL, "api/flashcard/delete", {'id': model.id}), headers: _headers);
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
  }

  Future<List<Procedure>> procedureList() async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response = await http.get(Uri.https(API_URL, "api/procedure/list"), headers: _headers);
      if (response.statusCode == 200) {
        var all = jsonDecode(response.body);
        var list = <Procedure>[];
        for (var item in all) {
          list.add(Procedure.fromJson(item));
        }
        return list;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
    return null;
  }

  Future<List<ProcedureItem>> procedureListItens(String id) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response = await http.get(Uri.https(API_URL, "api/procedure/getitens", {'id': id}), headers: _headers);
      if (response.statusCode == 200) {
        var all = jsonDecode(response.body);
        var list = <ProcedureItem>[];
        for (var item in all) {
          list.add(ProcedureItem.fromJson(item));
        }
        return list;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
    return null;
  }

  Future<bool> procedureImportFlashcard(String id /*Flashcard id*/) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response =
          await http.get(Uri.https(API_URL, "api/procedure/import_flashcard", {'id': id}), headers: _headers);

      if (response.statusCode == 200) {
        var b = jsonDecode(response.body);
        return b;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
    return null;
  }

  Future<List<GPSLink>> gpslinkList() async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response = await http.get(Uri.https(API_URL, "api/gpslink/list"), headers: _headers);
      if (response.statusCode == 200) {
        var all = jsonDecode(response.body);
        var list = <GPSLink>[];
        for (var item in all) {
          list.add(GPSLink.fromJson(item));
        }
        return list;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
    return null;
  }

  Future<void> gpslinkRemove(String id) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response = await http.get(Uri.https(API_URL, "api/gpslink/remove", {'id': id}), headers: _headers);
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
  }

  Future<void> gpslinkCreate(GPSLink gpslink) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final body = gpslink.toJson();
      body.remove('id'); // fuck

      final response = await http.post(
        Uri.https(API_URL, "api/gpslink/create"),
        headers: _jsonHeader(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
  }

  Future<void> gpslinkEdit(GPSLink gpslink) async {
    if (!await _checkInternet()) throw Exception();

    try {
      final response = await http.post(
        Uri.https(API_URL, "api/gpslink/edit"),
        headers: _jsonHeader(),
        body: jsonEncode(gpslink.toJson()),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      _catchException();
    }
  }
}
