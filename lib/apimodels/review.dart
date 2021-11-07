import 'package:happen_link/apimodels/flashcard.dart';

class ReviewCommit {
  List<Flashcard> flashcards;
  List<FlahscardReviewFactor> reviews;

  ReviewCommit(this.flashcards, this.reviews);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.flashcards != null) {
      data['flashcards'] = this.flashcards.map((v) => v.toJson()).toList();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReviewList {
  List<Flashcard> flashcards;
  List<FlahscardReviewFactor> factors;

  ReviewList({this.flashcards, this.factors});

  ReviewList.fromJson(Map<String, dynamic> json) {
    if (json['flashcards'] != null) {
      flashcards = <Flashcard>[];
      json['flashcards'].forEach((v) {
        flashcards.add(new Flashcard.fromJson(v));
      });
    }
    if (json['factors'] != null) {
      factors = <FlahscardReviewFactor>[];
      json['factors'].forEach((v) {
        factors.add(new FlahscardReviewFactor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.flashcards != null) {
      data['flashcards'] = this.flashcards.map((v) => v.toJson()).toList();
    }
    if (this.factors != null) {
      data['factors'] = this.factors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FlahscardReviewFactor {
  DateTime dtLastReview;
  int interval;
  int repetitions;
  double easeFactor;

  FlahscardReviewFactor(
      {this.dtLastReview, this.interval, this.repetitions, this.easeFactor});

  FlahscardReviewFactor.fromJson(Map<String, dynamic> json) {
    dtLastReview = DateTime.parse(json['dtLastReview']);
    interval = json['interval'];
    repetitions = json['repetitions'];
    easeFactor = json['easeFactor'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dtLastReview'] = this.dtLastReview.toIso8601String();
    data['interval'] = this.interval;
    data['repetitions'] = this.repetitions;
    data['easeFactor'] = this.easeFactor;
    return data;
  }
}
