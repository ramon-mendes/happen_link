class SMResponse {
  int interval;
  int repetitions;
  double easeFactor;

  SMResponse(this.interval, this.repetitions, this.easeFactor);
}

class SM {
  static SMResponse calc(int quality, int repetitions, int previousInterval, double previousEaseFactor) {
    int interval;
    double easeFactor;

    if (quality >= 3) {
      switch (repetitions) {
        case 0:
          interval = 0;
          break;
        case 1:
          interval = 1;
          break;
        default:
          interval = (previousInterval * previousEaseFactor).round();
          break;
      }

      repetitions++;
      easeFactor = previousEaseFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    } else {
      repetitions = 0;
      interval = 0;
      easeFactor = previousEaseFactor;
    }

    if (easeFactor < 1.3) {
      easeFactor = 1.3;
    }

    return new SMResponse(interval, repetitions, easeFactor);
  }
}
