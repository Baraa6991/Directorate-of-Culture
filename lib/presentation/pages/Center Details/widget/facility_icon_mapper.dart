import 'package:flutter/material.dart';
abstract class FacilityIconMapper {
  static const Map<String, IconData> _icons = {
    'wifi': Icons.wifi,
    'cafe': Icons.local_cafe,
    'parking': Icons.local_parking,
    'accessibility': Icons.accessible,
    'ac': Icons.ac_unit,
    'security': Icons.security,
    'sound_system': Icons.speaker,
    'projector': Icons.videocam,
    'catering': Icons.restaurant,
    'default': Icons.check_circle_outline,
  };

  static IconData resolve(String key) {
    return _icons[key.toLowerCase()] ?? _icons['default']!;
  }
}