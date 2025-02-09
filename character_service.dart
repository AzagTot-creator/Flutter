import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class CharacterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  final String _charactersCollection = 'characters';

  Future<QuerySnapshot> checkNameExists(String name) {
    return _firestore
        .collection(_charactersCollection)
        .where('name', isEqualTo: name)
        .get();
  }

  Future<DocumentSnapshot?> getCharacterByUserId(String userId) async {
    final result = await _firestore
        .collection(_charactersCollection)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    return result.docs.isEmpty ? null : result.docs.first;
  }

  Future<String> saveCharacter(String userId, Map<String, dynamic> characterData) async {
    try {
      final name = characterData['name'] as String;
      final nameQuery = await checkNameExists(name);
      if (nameQuery.docs.isNotEmpty) {
        throw Exception('Character name "$name" is already taken');
      }

      final existingCharacter = await getCharacterByUserId(userId);
      if (existingCharacter != null) {
        throw Exception('User already has a character');
      }

      final docRef = await _firestore.collection(_charactersCollection).add({
        ...characterData,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'level': 1,
        'experience': 0,
        'adena': 0,
        'attributes': {
          'strength': 10,
          'agility': 10,
          'intelligence': 10,
          'endurance': 10,
          'luck': 10,
        },
        'characteristics': {
          'health': 100,
          'currentHealth': 100,
          'mana': 50,
          'currentMana': 50,
        }
      });

      _logger.i("Character created with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      _logger.e("Error saving character: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCharacterData(String characterId) async {
    try {
      final doc = await _firestore.collection(_charactersCollection).doc(characterId).get();
      return doc.data();
    } catch (e) {
      _logger.e("Error getting character data: $e");
      return null;
    }
  }

  Future<void> updateCharacterField(String characterId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_charactersCollection).doc(characterId).update(updates);
    } catch (e) {
      _logger.e("Error updating character field: $e");
      rethrow;
    }
  }

  Future<void> saveLevel(String characterId, int level) async {
    await updateCharacterField(characterId, {'level': level});
  }

  Future<int> getLevel(String characterId) async {
    final data = await getCharacterData(characterId);
    return data?['level'] ?? 1;
  }

  Future<void> saveExperience(String characterId, int experience) async {
    await updateCharacterField(characterId, {'experience': experience});
  }

  Future<int> getExperience(String characterId) async {
    final data = await getCharacterData(characterId);
    return data?['experience'] ?? 0;
  }

  Future<void> saveAttributes(String characterId, Map<String, int> attributes) async {
    await updateCharacterField(characterId, {'attributes': attributes});
  }

  Future<Map<String, int>> getAttributes(String characterId) async {
    final data = await getCharacterData(characterId);
    return Map<String, int>.from(data?['attributes'] ?? {
      'strength': 10,
      'agility': 10,
      'intelligence': 10,
      'endurance': 10,
      'luck': 10,
    });
  }

  Future<void> saveCharacteristics(String characterId, Map<String, int> characteristics) async {
    await updateCharacterField(characterId, {'characteristics': characteristics});
  }

  Future<Map<String, int>> getCharacteristics(String characterId) async {
    final data = await getCharacterData(characterId);
    return Map<String, int>.from(data?['characteristics'] ?? {
      'health': 100,
      'currentHealth': 100,
      'mana': 50,
      'currentMana': 50,
    });
  }

  Future<void> saveAdena(String characterId, int amount) async {
    await updateCharacterField(characterId, {'adena': amount});
  }

  Future<int> getAdena(String characterId) async {
    final data = await getCharacterData(characterId);
    return data?['adena'] ?? 0;
  }

  Future<void> resetProgress(String characterId) async {
    try {
      await _firestore.collection(_charactersCollection).doc(characterId).update({
        'level': 1,
        'experience': 0,
        'adena': 0,
        'attributes': {
          'strength': 10,
          'agility': 10,
          'intelligence': 10,
          'endurance': 10,
          'luck': 10,
        },
        'characteristics': {
          'health': 100,
          'currentHealth': 100,
          'mana': 50,
          'currentMana': 50,
        },
      });
    } catch (e) {
      _logger.e("Error resetting progress: $e");
    }
  }
}
