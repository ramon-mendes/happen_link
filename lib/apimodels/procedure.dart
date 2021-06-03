class Procedure {
  String id;
  String title;
  int stepCnt;

  Procedure({this.id, this.title, this.stepCnt});

  Procedure.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    stepCnt = json['stepCnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['stepCnt'] = this.stepCnt;
    return data;
  }
}
