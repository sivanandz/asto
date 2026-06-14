enum PlanetType {
  sun,
  moon,
  mercury,
  venus,
  mars,
  jupiter,
  saturn,
  uranus,
  neptune,
  pluto,
  rahu,
  ketu,
  ascendant,
}

enum ZodiacSign {
  aries,
  taurus,
  gemini,
  cancer,
  leo,
  virgo,
  libra,
  scorpio,
  sagittarius,
  capricorn,
  aquarius,
  pisces,
}

class PlanetPosition {
  final PlanetType planet;
  final ZodiacSign sign;
  final double degree;
  final int house;
  final bool isRetrograde;
  final double? speed;

  const PlanetPosition({
    required this.planet,
    required this.sign,
    required this.degree,
    required this.house,
    this.isRetrograde = false,
    this.speed,
  });

  Map<String, dynamic> toMap() {
    return {
      'planet': planet.name,
      'sign': sign.name,
      'degree': degree,
      'house': house,
      'isRetrograde': isRetrograde ? 1 : 0,
      'speed': speed,
    };
  }

  factory PlanetPosition.fromMap(Map<String, dynamic> map) {
    return PlanetPosition(
      planet: PlanetType.values.byName(map['planet']),
      sign: ZodiacSign.values.byName(map['sign']),
      degree: map['degree'],
      house: map['house'],
      isRetrograde: map['isRetrograde'] == 1,
      speed: map['speed'],
    );
  }

  String get formattedDegree {
    final deg = degree.floor();
    final min = ((degree - deg) * 60).floor();
    return '$deg° $min\'';
  }

  String get symbol {
    const symbols = {
      ZodiacSign.aries: '♈',
      ZodiacSign.taurus: '♉',
      ZodiacSign.gemini: '♊',
      ZodiacSign.cancer: '♋',
      ZodiacSign.leo: '♌',
      ZodiacSign.virgo: '♍',
      ZodiacSign.libra: '♎',
      ZodiacSign.scorpio: '♏',
      ZodiacSign.sagittarius: '♐',
      ZodiacSign.capricorn: '♑',
      ZodiacSign.aquarius: '♒',
      ZodiacSign.pisces: '♓',
    };
    return symbols[sign] ?? '';
  }
}
