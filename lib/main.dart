import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iwallet_case_study/src/app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
