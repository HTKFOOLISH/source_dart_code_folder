import 'dart:io'; // to read input from user
import 'dart:math'; // to generate random choice for computer

// List of possible choices
List<String> choices = ['rock', 'paper', 'scissors'];
Map<String, String> rulesMap = {
  'rock': 'scissors',
  'paper': 'rock',
  'scissors': 'paper'
}; // map for the rules of the game

// normal function (no generic, no typedef)
int checkResult(String playerChoice, String computerChoice) {
  if (playerChoice == computerChoice) return 0; // draw

  if (rulesMap[playerChoice] == computerChoice) {
    return 1; // win
  } else {
    return -1; // lose
  }
}

void menu() {
  print("=== Rock - Paper - Scissors Game ===");
  print("Type 'q' to quit.");
}

void main() {
  Random random = Random();
  int score = 0;

  while (true) { // loop to play continuously
    menu();
    stdout.write("Enter your choice (rock/paper/scissors): ");
    String? input = stdin.readLineSync();

    if (input == null || input.toLowerCase() == 'q') {
      print("Game over. Your final score: $score");
      break; // exit loop
    }

    String playerChoice = input.toLowerCase(); // convert input to lowercase
    if (!choices.contains(playerChoice)) {
      print("Invalid choice, please try again.");
      continue; // back to loop
    }

    String computerChoice = choices[random.nextInt(3)]; // random choice from choices[0] to choices[2]
    print("Computer chose: $computerChoice");

    // use normal function instead of generic
    int result = checkResult(playerChoice, computerChoice);

    if (result == 0) {
      print("It's a draw!");
    } else if (result == 1) {
      score++; // add score
      print("You win!");
    } else {
      score--; // subtract score
      print("You lose!");
    }

    print("Current score: $score");
    print("---------------------------");
  }
}
