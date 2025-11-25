import 'dart:math';
import 'id_type.dart';

class IDGenerator {
  final Random _random = Random(); 

  final Map<IDType, String> _prefixes = {
    IDType.computerScience: 'CS',
    IDType.engineering: 'ENG',
    IDType.mathematics: 'MATH',
    IDType.physics: 'PHY',
    IDType.biology: 'BIO',
  };

  String generateID(IDType major) {
    String prefix = _prefixes[major] ?? 'GEN'; 
    int randomNumber = _random.nextInt(900000) + 100000; 
    return "$prefix-$randomNumber"; 
  }
}

