// Dice types and models for the SwitchPoint app

enum DiceType {
  coin('coin', '硬币', 2, 0.5, 1),
  d3('d3', '三角骰', 3, 0.333, 3),
  d6('d6', '六面骰', 6, 0.167, 6),
  d20('d20', '二十面骰', 20, 0.05, 20);

  final String id;
  final String displayName;
  final int faces;
  final double rewardProbability;
  final int rewardPoints;

  const DiceType(this.id, this.displayName, this.faces, this.rewardProbability, this.rewardPoints);

  static DiceType fromId(String id) {
    return DiceType.values.firstWhere(
      (d) => d.id == id,
      orElse: () => DiceType.d6,
    );
  }
}

class DiceRoll {
  final DiceType diceType;
  final int rolledValue;
  final bool isReward;
  final int pointsEarned;
  final DateTime timestamp;

  DiceRoll({
    required this.diceType,
    required this.rolledValue,
    required this.isReward,
    required this.pointsEarned,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isMaxRoll => rolledValue == diceType.faces;
}
