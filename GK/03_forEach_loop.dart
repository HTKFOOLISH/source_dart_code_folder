void main() {
  // Using forEach with a List
  List<String> students = ['Loc', 'Khai', 'Hoang', 'Truong'];
  students.forEach((name) {
    print('Hello, $name!');
  });

  // Using forEach with a Map
  Map<String, int> scores = {
    'Loc': 90,
    'Minh': 85,
    'An': 78,
  };
  scores.forEach((name, score) {
    print('$name has a score of $score');
  });
}