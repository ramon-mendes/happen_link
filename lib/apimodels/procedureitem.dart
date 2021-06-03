import 'package:happen_link/apimodels/flashcard.dart';

class ProcedureItem {
  String id;
  int type;
  Step step;
  Flashcard flashcard;
  bool flashcardIsSaved;

  ProcedureItem({this.id, this.type, this.step, this.flashcard, this.flashcardIsSaved});

  ProcedureItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    step = json['step'] != null ? new Step.fromJson(json['step']) : null;
    flashcard = json['flashcard'] != null ? new Flashcard.fromJson(json['flashcard']) : null;
    flashcardIsSaved = json['flashcardIsSaved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.step != null) {
      data['step'] = this.step.toJson();
    }
    if (this.flashcard != null) {
      data['flashcard'] = this.flashcard.toJson();
    }
    data['flashcardIsSaved'] = this.flashcardIsSaved;
    return data;
  }
}

class Step {
  String title;
  String html;
  int num;

  Step({this.title, this.html, this.num});

  Step.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    html = json['html'];
    num = json['num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['html'] = this.html;
    data['num'] = this.num;
    return data;
  }
}
