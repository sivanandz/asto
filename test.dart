import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lib/providers/app_provider.dart';
import 'lib/components/vedic_chart_widget.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  final provider = AppProvider();
  await provider.initialize();

  if (provider.vedicChartStyle != VedicChartStyle.northIndian) {
    print("FAILED: Default should be northIndian");
    return;
  }

  await provider.setVedicChartStyle(VedicChartStyle.southIndian);

  if (provider.vedicChartStyle != VedicChartStyle.southIndian) {
    print("FAILED: Did not update to southIndian");
    return;
  }

  print("SUCCESS!");
}
