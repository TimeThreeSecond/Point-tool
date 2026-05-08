// Dice service for the SwitchPoint app

import 'dart:math';
import '../models/dice.dart';

class DiceService {
  final Random _random = Random();

  DiceRoll roll(DiceType diceType) {
    final rolledValue = _random.nextInt(diceType.faces) + 1;
    final isReward = rolledValue == diceType.faces;
    final pointsEarned = isReward ? diceType.rewardPoints : 0;

    return DiceRoll(
      diceType: diceType,
      rolledValue: rolledValue,
      isReward: isReward,
      pointsEarned: pointsEarned,
    );
  }
}
