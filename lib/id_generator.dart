import 'dart:math';
import 'id_type.dart';

// This class is responsible for generating Student IDs
class IDGenerator {
  final Random _random = Random(); // Random number generator

  // Map each IDType (major) to a prefix
  final Map<IDType, String> _prefixes = {
    IDType.computerScience: 'CS',
    IDType.engineering: 'ENG',
    IDType.mathematics: 'MATH',
    IDType.physics: 'PHY',
    IDType.biology: 'BIO',
  };

  // This method generates the ID based on the selected major
  String generateID(IDType major) {
    String prefix = _prefixes[major] ?? 'GEN'; // fallback if something goes wrong
    int randomNumber = _random.nextInt(900000) + 100000; // 6-digit random number
    return "$prefix-$randomNumber"; // e.g., CS-738546
  }
}
