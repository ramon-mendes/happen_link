class FlashcardMedia {
  List<String> imagesFrontURL;
  List<String> imagesBackURL;
  List<String> audioBase64;

  FlashcardMedia();

  FlashcardMedia.fromJson(Map<String, dynamic> json) {
    imagesFrontURL = List<String>.from(json['imagesFrontURL']);
    imagesBackURL = List<String>.from(json['imagesBackURL']);
    audioBase64 = json['audioBase64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['audioBase64'] = this.audioBase64;
    data['imagesFrontURL'] = this.imagesFrontURL;
    data['imagesBackURL'] = this.imagesBackURL;
    return data;
  }
}

class Flashcard {
  String id;
  String deckId;
  String front;
  String back;
  FlashcardMedia media;

  Flashcard(this.id, this.deckId, this.front, this.back, this.media);
  Flashcard.fromDeckId(this.deckId) {
    this.media = FlashcardMedia();
    this.media.imagesFrontURL = <String>[];
    this.media.imagesBackURL = <String>[];
  }

  Flashcard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deckId = json['deckId'];
    front = json['front'];
    back = json['back'];
    media = FlashcardMedia.fromJson(json['media']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deckId'] = this.deckId;
    data['front'] = this.front;
    data['back'] = this.back;
    if (this.media != null) {
      data['media'] = this.media.toJson();
    }
    return data;
  }
}
