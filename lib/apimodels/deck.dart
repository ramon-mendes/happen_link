class Deck {
  String id;
  String companyId;
  String title;
  int cntNew;
  int cntOld;
  bool fromUser;
  bool allReview;

  Deck({this.id, this.companyId, this.title, this.cntNew, this.cntOld, this.fromUser});

  Deck.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['companyId'];
    title = json['title'];
    cntNew = json['cntNew'];
    cntOld = json['cntOld'];
    fromUser = json['fromUser'];
    allReview = json['allReview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['companyId'] = this.companyId;
    data['title'] = this.title;
    data['cntNew'] = this.cntNew;
    data['cntOld'] = this.cntOld;
    data['fromUser'] = this.fromUser;
    return data;
  }
}
