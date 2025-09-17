void main() {
  // 1. List: Ordered collection of members
  List<String> members = ['Loc', 'Hoang', 'Khai', 'Truong'];
  print('List of members:');
  for (var i in members) {
    print("$i");
  }

  // 2. Set: Unordered collection of unique numbers​
  Set<int> numbers = {1, 2, 2, 3, 4}; // Duplicate 2 ignored​
  print('\nSet of Numbers:');
  for (var i in numbers) {
    print('$i');
  }

  // 3. Map: Key-value pairs of student scores​
  Map<String, int> scores = {
    'Loc': 76,
    'Truong': 81,
    'Chien': 36,
  };
  print('\nMap of Scores:');
  for (var entry in scores.entries) {
    print('${entry.key}: ${entry.value}');
  }

  // 4. String: Iterating over characters
  String text = 'Embedded';
  print('\nCharacters in String:');
  for (var char in text.split('')) {
    print('$char');
  }
}
