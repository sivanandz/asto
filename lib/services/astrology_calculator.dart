import 'dart:math' as math;
import '../utils/math_utils.dart' as math_utils;
import '../models/planet_position.dart';
import '../models/birth_chart.dart';
import '../models/user_profile.dart';

/// Astronomical calculation service for Vedic and Western astrology
/// Uses simplified Swiss Ephemeris-style calculations
class AstrologyCalculator {
  // Planet orbital periods in tropical years
  static const Map<PlanetType, double> _orbitalPeriods = {
    PlanetType.sun: 1.0,
    PlanetType.moon: 0.0748,
    PlanetType.mercury: 0.2408,
    PlanetType.venus: 0.6152,
    PlanetType.mars: 1.8808,
    PlanetType.jupiter: 11.8626,
    PlanetType.saturn: 29.4571,
    PlanetType.uranus: 84.0205,
    PlanetType.neptune: 164.8,
    PlanetType.pluto: 248.0,
  };

  // Ayanamsa values (Lahiri approximation)
  static const double _lahiriAyanamsa = 24.0; // Approximate for 2024
  static const double _ramanAyanamsa = 22.5;
  static const double _kpAyanamsa = 23.5;

  /// Calculate birth chart for a user
  static BirthChart calculateChart(
    UserProfile user, {
    ChartType type = ChartType.western,
    AyanamsaType? ayanamsa,
  }) {
    // Parse birth time
    final timeParts = user.birthTime.split(':');
    final birthHour = timeParts.isNotEmpty ? (int.tryParse(timeParts[0]) ?? 12) : 12;
    final birthMinute = timeParts.length > 1 ? (int.tryParse(timeParts[1]) ?? 0) : 0;

    // Calculate Julian Day (simplified)
    final jd = _calculateJulianDay(
      user.birthDate.year,
      user.birthDate.month,
      user.birthDate.day,
      birthHour + birthMinute / 60.0,
    );

    // Calculate planet positions
    final positions = <PlanetPosition>[];

    // Sun position (simplified - actual position based on date)
    final sunLongitude = _calculateSunLongitude(jd);
    positions.add(PlanetPosition(
      planet: PlanetType.sun,
      sign: _longitudeToSign(sunLongitude),
      degree: sunLongitude % 30,
      house: _calculateHouse(sunLongitude, sunLongitude),
    ));

    // Moon position
    final moonLongitude = _calculateMoonLongitude(jd);
    positions.add(PlanetPosition(
      planet: PlanetType.moon,
      sign: _longitudeToSign(moonLongitude),
      degree: moonLongitude % 30,
      house: _calculateHouse(moonLongitude, sunLongitude),
    ));

    // Calculate other planets
    for (final entry in _orbitalPeriods.entries) {
      if (entry.key == PlanetType.sun || entry.key == PlanetType.moon) continue;
      
      final longitude = _calculatePlanetLongitude(jd, entry.key, entry.value);
      final adjustedLongitude = type == ChartType.vedicNorthIndian || 
                                type == ChartType.vedicSouthIndian
          ? _applyAyanamsa(longitude, ayanamsa ?? AyanamsaType.lahiri)
          : longitude;

      positions.add(PlanetPosition(
        planet: entry.key,
        sign: _longitudeToSign(adjustedLongitude),
        degree: adjustedLongitude % 30,
        house: _calculateHouse(adjustedLongitude, sunLongitude),
        speed: _calculateRetrograde(jd, entry.key),
        isRetrograde: _calculateRetrograde(jd, entry.key) < 0,
      ));
    }

    // Ascendant calculation (simplified)
    final ascendantLongitude = _calculateAscendant(
      jd,
      user.latitude ?? 0,
      user.longitude ?? 0,
    );
    final adjustedAscendant = type == ChartType.vedicNorthIndian || 
                              type == ChartType.vedicSouthIndian
        ? _applyAyanamsa(ascendantLongitude, ayanamsa ?? AyanamsaType.lahiri)
        : ascendantLongitude;

    positions.add(PlanetPosition(
      planet: PlanetType.ascendant,
      sign: _longitudeToSign(adjustedAscendant),
      degree: adjustedAscendant % 30,
      house: 1,
    ));

    // Rahu and Ketu (simplified - always opposite)
    final rahuLongitude = (moonLongitude + 180) % 360;
    final adjustedRahu = type == ChartType.vedicNorthIndian || 
                         type == ChartType.vedicSouthIndian
        ? _applyAyanamsa(rahuLongitude, ayanamsa ?? AyanamsaType.lahiri)
        : rahuLongitude;

    positions.add(PlanetPosition(
      planet: PlanetType.rahu,
      sign: _longitudeToSign(adjustedRahu),
      degree: adjustedRahu % 30,
      house: _calculateHouse(adjustedRahu, sunLongitude),
      isRetrograde: true,
    ));

    final ketuLongitude = (adjustedRahu + 180) % 360;
    positions.add(PlanetPosition(
      planet: PlanetType.ketu,
      sign: _longitudeToSign(ketuLongitude),
      degree: ketuLongitude % 30,
      house: _calculateHouse(ketuLongitude, sunLongitude),
      isRetrograde: true,
    ));

    return BirthChart(
      userId: user.id,
      type: type,
      ayanamsa: ayanamsa,
      positions: positions,
    );
  }

  /// Calculate Julian Day number (simplified algorithm)
  static double _calculateJulianDay(int year, int month, int day, double hour) {
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    final a = (year / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (year + 4716)).floor() +
           (30.6001 * (month + 1)).floor() +
           day + hour / 24.0 + b - 1524.5;
  }

  /// Calculate Sun's ecliptic longitude (simplified)
  static double _calculateSunLongitude(double jd) {
    // Days since J2000.0
    final d = jd - 2451545.0;
    // Mean longitude
    var l = (280.460 + 0.9856474 * d) % 360;
    // Mean anomaly
    final g = math_utils.radians((357.528 + 0.9856003 * d) % 360);
    // Ecliptic longitude
    l = l + 1.915 * math.sin(g) + 0.020 * math.sin(2 * g);
    return l % 360;
  }

  /// Calculate Moon's ecliptic longitude (simplified)
  static double _calculateMoonLongitude(double jd) {
    // Days since J2000.0
    final d = jd - 2451545.0;
    // Mean longitude
    var l = (218.316 + 13.176396 * d) % 360;
    // Mean anomaly
    final m = math_utils.radians((134.963 + 13.064993 * d) % 360);
    // Ecliptic longitude (simplified)
    l = l + 6.289 * math.sin(m);
    return l % 360;
  }

  /// Calculate planet longitude (simplified heliocentric approximation)
  static double _calculatePlanetLongitude(
    double jd,
    PlanetType planet,
    double period,
  ) {
    // Use base longitude with orbital period
    final daysSinceEpoch = jd - 2451545.0;
    final meanLongitude = (daysSinceEpoch / (period * 365.25) * 360) % 360;
    
    // Add some variation based on planet
    final variation = planet.hashCode % 30;
    return (meanLongitude + variation) % 360;
  }

  /// Calculate retrograde status (simplified)
  static double _calculateRetrograde(double jd, PlanetType planet) {
    // Simplified: outer planets retrograde roughly 30% of the time
    final cycle = (jd / 365.25) % 3;
    final isRetro = cycle < 0.9; // Roughly 30% retrograde
    return isRetro ? -1.0 : 1.0;
  }

  /// Calculate ascendant (simplified)
  static double _calculateAscendant(
    double jd,
    double latitude,
    double longitude,
  ) {
    // Simplified ascendant calculation
    final lst = _calculateLocalSiderealTime(jd, longitude);
    final obliquity = 23.44; // Earth's axial tilt
    
    // Simplified formula
    var asc = math_utils.degrees(math.atan2(
      -math.cos(math_utils.radians(lst)),
      math.tan(math_utils.radians(latitude)) * math.sin(math_utils.radians(obliquity)) -
      math.sin(math_utils.radians(lst)) * math.cos(math_utils.radians(obliquity)),
    ));
    
    if (asc < 0) asc += 360;
    return asc;
  }

  /// Calculate Local Sidereal Time (simplified)
  static double _calculateLocalSiderealTime(double jd, double longitude) {
    final d = jd - 2451545.0;
    final gmst = (18.697374558 + 24.06570982441908 * d) % 24;
    final lst = (gmst + longitude / 15.0) % 24;
    return lst * 15.0; // Convert to degrees
  }

  /// Apply ayanamsa correction for Vedic calculations
  static double _applyAyanamsa(double longitude, AyanamsaType type) {
    final ayanamsaValue = switch (type) {
      AyanamsaType.lahiri => _lahiriAyanamsa,
      AyanamsaType.raman => _ramanAyanamsa,
      AyanamsaType.krishnamurti => _kpAyanamsa,
    };
    return (longitude - ayanamsaValue + 360) % 360;
  }

  /// Convert longitude to zodiac sign
  static ZodiacSign _longitudeToSign(double longitude) {
    final signIndex = (longitude / 30).floor() % 12;
    return ZodiacSign.values[signIndex];
  }

  /// Calculate house number from longitude
  static int _calculateHouse(double longitude, double ascendant) {
    final relativeLon = (longitude - ascendant + 360) % 360;
    return (relativeLon / 30).floor() + 1;
  }

  /// Get house lord for a given house number
  static PlanetType? getHouseLord(int house) {
    final signLords = {
      0: PlanetType.mars,      // Aries
      1: PlanetType.venus,     // Taurus
      2: PlanetType.mercury,   // Gemini
      3: PlanetType.moon,      // Cancer
      4: PlanetType.sun,       // Leo
      5: PlanetType.mercury,   // Virgo
      6: PlanetType.venus,     // Libra
      7: PlanetType.mars,      // Scorpio
      8: PlanetType.jupiter,   // Sagittarius
      9: PlanetType.saturn,    // Capricorn
      10: PlanetType.saturn,   // Aquarius
      11: PlanetType.jupiter,  // Pisces
    };
    return signLords[(house - 1) % 12];
  }
}
