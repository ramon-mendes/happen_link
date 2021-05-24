class FlashcardMedia {
  String imageFrontURL;
  String imageBackURL;
  String audio1Base64;
  String audio2Base64;

  FlashcardMedia.fromJson(Map<String, dynamic> json) {
    imageFrontURL = json['imageFrontURL'];
    imageBackURL = json['imageBackURL'];
    audio1Base64 = json['audio1Base64'];
    audio2Base64 = json['audio2Base64'];
  }
}

class Flashcard {
  String id;
  String deckId;
  String front;
  String back;
  FlashcardMedia media;

  Flashcard(this.id, this.deckId, this.front, this.back, this.media);

  Flashcard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deckId = json['deckId'];
    front = json['front'];
    back = json['back'];
    media = FlashcardMedia.fromJson(json['media']);
  }
}
