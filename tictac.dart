import 'dart:io'; // استدعاء مكتبة الإدخال/الإخراج للتعامل مع الكونسول

class TicTacToe {
  late List<List<String>> board; // لوحة اللعب 3x3
  String currentPlayer = 'X'; // اللاعب الحالي (يبدأ بـ X)
  bool gameOver = false; // حالة انتهاء اللعبة
  String winner = ''; // الفائز
  bool draw = false; // هل النتيجة تعادل؟
  int moveCount = 0; // عدد الحركات

  TicTacToe() {
    initializeBoard(); // تهيئة اللوحة عند إنشاء اللعبة
  }

  // دالة تهيئة اللوحة
  void initializeBoard() {
    board = List.generate(3, (_) => List.filled(3, ' ')); // إنشاء لوحة 3x3 فارغة
    currentPlayer = 'X'; // إعادة تعيين اللاعب الحالي
    gameOver = false; // إعادة تعيين حالة اللعبة
    winner = ''; // إعادة تعيين الفائز
    draw = false; // إعادة تعيين التعادل
    moveCount = 0; // إعادة تعيين عدد الحركات
  }

  // دالة طباعة لوحة اللعب
  void printBoard() {
    print('\n  0   1   2'); // طباعة أرقام الأعمدة
    for (int i = 0; i < 3; i++) {
      print('$i ${board[i][0]} | ${board[i][1]} | ${board[i][2]}'); // طباعة الصفوف
      if (i < 2) print('  ---------'); // طباعة الخطوط الفاصلة
    }
    print('');
  }

  // دالة تنفيذ الحركة
  bool makeMove(int row, int col) {
    // التحقق من صحة الحركة
    if (row < 0 || row > 2 || col < 0 || col > 2 || board[row][col] != ' ') {
      return false; // حركة غير صالحة
    }

    board[row][col] = currentPlayer; // تسجيل الحركة
    moveCount++; // زيادة عدد الحركات

    // التحقق من وجود فائز
    if (checkWin(row, col)) {
      gameOver = true;
      winner = currentPlayer;
    } else if (moveCount == 9) { // التحقق من التعادل
      gameOver = true;
      draw = true;
    } else {
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X'; // تبديل اللاعب
    }

    return true; // حركة صالحة
  }

  // دالة التحقق من الفوز
  bool checkWin(int row, int col) {
    // التحقق من الصف
    if (board[row][0] == currentPlayer &&
        board[row][1] == currentPlayer &&
        board[row][2] == currentPlayer) {
      return true;
    }

    // التحقق من العمود
    if (board[0][col] == currentPlayer &&
        board[1][col] == currentPlayer &&
        board[2][col] == currentPlayer) {
      return true;
    }

    // التحقق من القطر الرئيسي
    if (row == col &&
        board[0][0] == currentPlayer &&
        board[1][1] == currentPlayer &&
        board[2][2] == currentPlayer) {
      return true;
    }

    // التحقق من القطر الثانوي
    if (row + col == 2 &&
        board[0][2] == currentPlayer &&
        board[1][1] == currentPlayer &&
        board[2][0] == currentPlayer) {
      return true;
    }

    return false; // لا يوجد فوز
  }

  // دالة تشغيل اللعبة الرئيسية
  void play() {
    print('Welcome to Tic Tac Toe!');
    print('Player X goes first. Enter row and column numbers (0-2) separated by space.');

    while (!gameOver) {
      printBoard(); // عرض اللوحة
      print('Player $currentPlayer\'s turn:');

      try {
        var input = stdin.readLineSync()?.trim().split(' '); // قراءة الإدخال
        if (input == null || input.length != 2) {
          print('Invalid input. Please enter two numbers (0-2) separated by space.');
          continue;
        }

        int row = int.parse(input[0]);
        int col = int.parse(input[1]);

        if (!makeMove(row, col)) {
          print('Invalid move. Try again.');
        }
      } catch (e) {
        print('Invalid input. Please enter two numbers (0-2) separated by space.');
      }
    }

    printBoard();
    if (draw) {
      print('The game is a draw!'); // نتيجة التعادل
    } else {
      print('Player $winner wins!'); // إعلان الفائز
    }

    // السؤال عن إعادة اللعب
    print('\nPlay again? (y/n)');
    var playAgain = stdin.readLineSync()?.trim().toLowerCase();
    if (playAgain == 'y') {
      initializeBoard(); // إعادة تهيئة اللوحة
      play(); // إعادة اللعب
    } else {
      print('Thanks for playing!'); // إنهاء اللعبة
    }
  }
}

// الدالة الرئيسية لبدء البرنامج
void main() {
  var game = TicTacToe(); // إنشاء كائن اللعبة
  game.play(); // بدء اللعبة
}