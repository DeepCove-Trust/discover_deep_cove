import 'package:hci_v2/data/sample_data_fact_file.dart';

class Quiz {
  final int id;

  bool unlocked;

  final String unlockCode;

  final String title;

  final MediaFile image;

  int attempts;

  int highScore;

  final List<QuizQuestion> questions;

  Quiz(
      {this.id,
      this.unlocked,
      this.unlockCode,
      this.title,
      this.image,
      this.attempts,
      this.highScore,
      this.questions});
}

class QuizQuestion {
  final int id;

  final int quizId;

  /// This is the question
  final String text;

  /// this is the image for the question
  final MediaFile image;

  final MediaFile audio;

  ///if this is true it is a yes/no question
  final bool trueFalseAnswer;

  final List<QuizAnswer> answers;

  final int correctAnswerId;

  QuizQuestion(
      {this.id,
      this.quizId,
      this.text,
      this.image,
      this.audio,
      this.trueFalseAnswer,
      this.answers,
      this.correctAnswerId});
}

class QuizAnswer {
  final int id;

  final int questionId;

  final MediaFile image;

  final String text;

  QuizAnswer({this.id, this.questionId, this.image, this.text});
}

List<Quiz> quizzes = [
  Quiz(
    id: 1,
    unlocked: true,
    unlockCode: "654321",
    title: "Brasells Point Quiz",
    image: MediaFile(
      1,
      MediaFileType.jpg,
      "Quiz One",
      "assets/images/primary/kea.jpg",
    ),
    attempts: 0,
    highScore: 0,
    questions: brasellsPointQuizQuestions,
  ),
  Quiz(
    id: 2,
    unlocked: false,
    unlockCode: "123456",
    title: "Hanging Valley Quiz",
    image: MediaFile(
      1,
      MediaFileType.jpg,
      "Quiz Two",
      "assets/images/tertiary/powerStation.jpg",
    ),
    attempts: 0,
    highScore: 0,
    questions: hangingValleyQuizQuestions,
  ),
];

List<QuizQuestion> brasellsPointQuizQuestions = [
  //true false
  QuizQuestion(
    id: 1,
    quizId: 1,
    text: "Is the Kea a troublemaker?",
    image: MediaFile(
      1,
      MediaFileType.jpg,
      "Kea",
      "assets/images/primary/kea.jpg",
    ),
    audio: null,
    trueFalseAnswer: true,
    answers: null,
    correctAnswerId: 1,
  ),
  //4 images
  QuizQuestion(
    id: 2,
    quizId: 1,
    text: "What bird is the Kea?",
    image: null,
    audio: null,
    trueFalseAnswer: false,
    answers: [
      QuizAnswer(
        id: 0,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Kea",
          "assets/images/primary/kea.jpg",
        ),
      ),
      QuizAnswer(
        id: 1,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Rifleman",
          "assets/images/primary/rifleman.jpg",
        ),
      ),
      QuizAnswer(
        id: 2,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Tomtit",
          "assets/images/primary/tomtit.jpg",
        ),
      ),
      QuizAnswer(
        id: 3,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "pekin Duck",
          "assets/images/primary/pekinDuck.jpg",
        ),
      ),
    ],
    correctAnswerId: 0,
  ),
  //4 images with captions
  QuizQuestion(
    id: 6,
    quizId: 1,
    text: "Which bird is the odd one out?",
    image: null,
    audio: null,
    trueFalseAnswer: false,
    answers: [
      QuizAnswer(
        id: 0,
        questionId: 3,
        text: "Kea",
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Kea",
          "assets/images/primary/kea.jpg",
        ),
      ),
      QuizAnswer(
        id: 1,
        questionId: 3,
        text: "Rifleman",
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Rifleman",
          "assets/images/primary/rifleman.jpg",
        ),
      ),
      QuizAnswer(
        id: 2,
        questionId: 3,
        text: "Tomtit",
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Tomtit",
          "assets/images/primary/tomtit.jpg",
        ),
      ),
      QuizAnswer(
        id: 3,
        questionId: 3,
        text: "pekin Duck",
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "pekin Duck",
          "assets/images/primary/pekinDuck.jpg",
        ),
      ),
    ],
    correctAnswerId: 3,
  ),
  //4 images with audio
  QuizQuestion(
    id: 3,
    quizId: 1,
    text: "What bird is this?",
    image: null,
    audio: MediaFile(
        1, MediaFileType.mp3, "KeaCall", "assets/audio/calls/kea.mp3"),
    trueFalseAnswer: false,
    answers: [
      QuizAnswer(
        id: 0,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Kea",
          "assets/images/primary/kea.jpg",
        ),
      ),
      QuizAnswer(
        id: 1,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Rifleman",
          "assets/images/primary/rifleman.jpg",
        ),
      ),
      QuizAnswer(
        id: 2,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Tomtit",
          "assets/images/primary/tomtit.jpg",
        ),
      ),
      QuizAnswer(
        id: 3,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "pekin Duck",
          "assets/images/primary/pekinDuck.jpg",
        ),
      ),
    ],
    correctAnswerId: 0,
  ),
  // 4 text
  QuizQuestion(
    id: 4,
    quizId: 1,
    text: "Which bird is the Kea?",
    image: MediaFile(
      1,
      MediaFileType.jpg,
      "Kea",
      "assets/images/primary/kea.jpg",
    ),
    audio: null,
    trueFalseAnswer: false,
    answers: [
      QuizAnswer(
        id: 0,
        questionId: 4,
        image: null,
        text: "Kea",
      ),
      QuizAnswer(
        id: 1,
        questionId: 4,
        image: null,
        text: "Tomtit",
      ),
      QuizAnswer(
        id: 2,
        questionId: 4,
        image: null,
        text: "Tui",
      ),
      QuizAnswer(
        id: 3,
        questionId: 4,
        image: null,
        text: "Bellbird",
      ),
    ],
    correctAnswerId: 0,
  ),
  //4 text with audio
  QuizQuestion(
    id: 5,
    quizId: 1,
    text: "What bird makes this call?",
    image: MediaFile(
      1,
      MediaFileType.jpg,
      "Kea",
      "assets/images/primary/kea.jpg",
    ),
    audio: MediaFile(
        1, MediaFileType.mp3, "KeaCall", "assets/audio/calls/kea.mp3"),
    trueFalseAnswer: false,
    answers: [
      QuizAnswer(
        id: 0,
        questionId: 5,
        image: null,
        text: "Kea",
      ),
      QuizAnswer(
        id: 1,
        questionId: 5,
        image: null,
        text: "Tomtit",
      ),
      QuizAnswer(
        id: 2,
        questionId: 5,
        image: null,
        text: "Tui",
      ),
      QuizAnswer(
        id: 3,
        questionId: 5,
        image: null,
        text: "Bellbird",
      ),
    ],
    correctAnswerId: 0,
  ),
];

List<QuizQuestion> hangingValleyQuizQuestions = [
  //true false
  QuizQuestion(
    id: 1,
    quizId: 1,
    text: "Is the Kea a troublemaker?",
    image: MediaFile(
      1,
      MediaFileType.jpg,
      "Kea",
      "assets/images/primary/kea.jpg",
    ),
    audio: null,
    trueFalseAnswer: true,
    answers: null,
    correctAnswerId: null,
  ),
  //4 images
  QuizQuestion(
    id: 2,
    quizId: 1,
    text: "What bird is the Kea?",
    image: null,
    audio: null,
    trueFalseAnswer: false,
    answers: [
      QuizAnswer(
        id: 1,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Kea",
          "assets/images/primary/kea.jpg",
        ),
      ),
      QuizAnswer(
        id: 2,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Rifleman",
          "assets/images/primary/rifleman.jpg",
        ),
      ),
      QuizAnswer(
        id: 3,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Tomtit",
          "assets/images/primary/tomtit.jpg",
        ),
      ),
      QuizAnswer(
        id: 4,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "pekin Duck",
          "assets/images/primary/pekinDuck.jpg",
        ),
      ),
    ],
    correctAnswerId: 1,
  ),
  //4 images with captions
  QuizQuestion(
    id: 6,
    quizId: 1,
    text: "Which bird is the odd one out?",
    image: null,
    audio: null,
    trueFalseAnswer: false,
    answers: [
      QuizAnswer(
        id: 1,
        questionId: 3,
        text: "Kea",
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Kea",
          "assets/images/primary/kea.jpg",
        ),
      ),
      QuizAnswer(
        id: 2,
        questionId: 3,
        text: "Rifleman",
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Rifleman",
          "assets/images/primary/rifleman.jpg",
        ),
      ),
      QuizAnswer(
        id: 3,
        questionId: 3,
        text: "Tomtit",
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Tomtit",
          "assets/images/primary/tomtit.jpg",
        ),
      ),
      QuizAnswer(
        id: 4,
        questionId: 3,
        text: "pekin Duck",
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "pekin Duck",
          "assets/images/primary/pekinDuck.jpg",
        ),
      ),
    ],
    correctAnswerId: 4,
  ),
  //4 images with audio
  QuizQuestion(
    id: 3,
    quizId: 1,
    text: "What bird is this?",
    image: null,
    audio: MediaFile(
        1, MediaFileType.mp3, "KeaCall", "assets/audio/calls/kea.mp3"),
    trueFalseAnswer: false,
    answers: [
      QuizAnswer(
        id: 1,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Kea",
          "assets/images/primary/kea.jpg",
        ),
      ),
      QuizAnswer(
        id: 2,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Rifleman",
          "assets/images/primary/rifleman.jpg",
        ),
      ),
      QuizAnswer(
        id: 3,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "Tomtit",
          "assets/images/primary/tomtit.jpg",
        ),
      ),
      QuizAnswer(
        id: 4,
        questionId: 3,
        text: null,
        image: MediaFile(
          1,
          MediaFileType.jpg,
          "pekin Duck",
          "assets/images/primary/pekinDuck.jpg",
        ),
      ),
    ],
    correctAnswerId: 1,
  ),
  // 4 text
  QuizQuestion(
    id: 4,
    quizId: 1,
    text: "What bird makes this call?",
    image: null,
    audio: null,
    trueFalseAnswer: false,
    answers: [
      QuizAnswer(
        id: 1,
        questionId: 4,
        image: null,
        text: "Kea",
      ),
      QuizAnswer(
        id: 2,
        questionId: 4,
        image: null,
        text: "Tomtit",
      ),
      QuizAnswer(
        id: 3,
        questionId: 4,
        image: null,
        text: "Tui",
      ),
      QuizAnswer(
        id: 4,
        questionId: 4,
        image: null,
        text: "Bellbird",
      ),
    ],
    correctAnswerId: 1,
  ),
  //4 text with audio
  QuizQuestion(
    id: 5,
    quizId: 1,
    text: "What bird makes this call?",
    image: null,
    audio: MediaFile(
        1, MediaFileType.mp3, "KeaCall", "assets/audio/calls/kea.mp3"),
    trueFalseAnswer: false,
    answers: [
      QuizAnswer(
        id: 1,
        questionId: 5,
        image: null,
        text: "Kea",
      ),
      QuizAnswer(
        id: 2,
        questionId: 5,
        image: null,
        text: "Tomtit",
      ),
      QuizAnswer(
        id: 3,
        questionId: 5,
        image: null,
        text: "Tui",
      ),
      QuizAnswer(
        id: 4,
        questionId: 5,
        image: null,
        text: "Bellbird",
      ),
    ],
    correctAnswerId: 1,
  ),
];
