import 'package:studyspace/services/sm_response.dart';

class Sm {
  SmResponse calc({
    int quality = 4,
    int repetitions = 0,
    int previousInterval = 0,
    double previousEaseFactor = 2.5,
  }) {
    int interval;
    double easeFactor;
    if (quality >= 3) {
      switch (repetitions) {
        case 0:
          interval = 1;
          break;
        case 1:
          interval = 6;
          break;
        default:
          interval = (previousInterval * previousEaseFactor).round();
      }

      repetitions++;
      easeFactor = previousEaseFactor +
          (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    } else {
      repetitions = 0;
      interval = 1;
      easeFactor = previousEaseFactor;
    }

    if (easeFactor < 1.3) {
      easeFactor = 1.3;
    }

    return SmResponse(
        interval: interval, repetitions: repetitions, easeFactor: easeFactor);
  }
}
