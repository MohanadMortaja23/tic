import "dart:io";

// عدد الخانات التي تم تعبئتها
int filledCellsCount = 0;

// حجم اللوحة (3×3)
int boardSize = 3;

// مصفوفة تمثل اللوحة
List<List<String>> board = [];

// تحديد دور اللاعب الحالي
Turn? currentTurn;

// رسالة تعليمات للمستخدم
String? instructionMessage;

// الرموز المستخدمة من قبل اللاعبين
String playerSigns = "XO";

void main() {
  currentTurn = Turn.Player1;
  initializeBoard();
  while (true) {
    displayBoard();
    checkDraw(currentTurn == Turn.Player1 ? Turn.Player2 : Turn.Player1);
    checkWin(currentTurn == Turn.Player1 ? Turn.Player2 : Turn.Player1);
    showMoveInstructions();
    switchTurn();
  }
}

// دالة لإنشاء مصفوفة اللوحة بالأرقام
void initializeBoard() {
  for (int i = 0; i < boardSize; i++) {
    List<String> row = [];
    for (int j = 1; j <= boardSize; j++) {
      int cellNumber = i * boardSize + j;
      row.add("$cellNumber");
    }
    board.add(row);
  }
}

// دالة لطباعة مصفوفة اللوحة بشكل منسق
void displayBoard() {
  for (int i = 0; i < boardSize; i++) {
    for (int j = 0; j < boardSize; j++) {
      stdout.write(" ${board[i][j]} ");
      if (j < boardSize - 1) stdout.write("|");
    }
    print("");
    if (i < boardSize - 1) print("---+---+---");
  }
}

// تبديل الدور بين اللاعبين
void switchTurn() {
  if (currentTurn == Turn.Player1)
    currentTurn = Turn.Player2;
  else
    currentTurn = Turn.Player1;
}

// طباعة رسالة الدور الحالي وأخذ حركة اللاعب
void showMoveInstructions() {
  instructionMessage =
      (currentTurn == Turn.Player1 ? "Player 1" : "Player 2") +
      ", please enter the number of the square to place your ";

  instructionMessage =
      instructionMessage! + (currentTurn == Turn.Player1 ? "X:" : "O:");
  instructionMessage = instructionMessage! + " (or 'X' to end the game)";

  print(instructionMessage);

  String inputOption = stdin.readLineSync()!;
  if (inputOption == 'X') {
    print("Game is ENDED!!");
    exit(0);
  }

  int selectedCell = int.parse(inputOption);

  while (!isValidMove(selectedCell, currentTurn)) {
    print("Invalid move. Try again:");
    selectedCell = int.parse(stdin.readLineSync()!);
  }
}

// التأكد من صحة اختيار اللاعب
bool isValidMove(int cellNumber, Turn? playerTurn) {
  int row = ((cellNumber - 1) / boardSize).toInt();
  int col = (cellNumber - 1) % boardSize;

  if (board[row][col] == "$cellNumber") {
    filledCellsCount++;
    board[row][col] = playerTurn == Turn.Player1 ? 'X' : 'O';
    return true;
  }
  return false;
}

// التحقق من التعادل
void checkDraw(Turn playerTurn) {
  if (filledCellsCount == boardSize * boardSize) {
    print("Game ended in a draw!");
    exit(0);
  }
}

// دالة طباعة اللاعب الفائز
void printWinner(Turn winner) {
  print(
    "Congrats " + (winner == Turn.Player1 ? "Player 1" : "Player 2") + " wins!",
  );
}

// دوال فحص الفوز
bool checkRows() {
  for (int i = 0; i < boardSize; i++) {
    bool match = true;
    for (int j = 1; j < boardSize; j++) {
      if (board[i][j] != board[i][j - 1]) {
        match = false;
        break;
      }
    }
    if (match) return true;
  }
  return false;
}

bool checkColumns() {
  for (int i = 0; i < boardSize; i++) {
    bool match = true;
    for (int j = 1; j < boardSize; j++) {
      if (board[j][i] != board[j - 1][i]) {
        match = false;
        break;
      }
    }
    if (match) return true;
  }
  return false;
}

bool checkMainDiagonal() {
  bool match = true;
  for (int i = 1; i < boardSize; i++) {
    if (board[i][i] != board[i - 1][i - 1]) {
      match = false;
      break;
    }
  }
  return match;
}

bool checkSecondaryDiagonal() {
  bool match = true;
  for (int i = 1; i < boardSize; i++) {
    if (board[i][boardSize - i - 1] != board[i - 1][boardSize - (i - 1) - 1]) {
      match = false;
      break;
    }
  }
  return match;
}

// التحقق من وجود فائز بعد كل حركة
void checkWin(Turn playerTurn) {
  List<Function> winCheckers = [
    checkRows,
    checkColumns,
    checkMainDiagonal,
    checkSecondaryDiagonal,
  ];

  for (var check in winCheckers) {
    if (check()) {
      printWinner(playerTurn);
      exit(0);
    }
  }
}

// Enum يمثل دور اللاعب
enum Turn { Player1, Player2 }
