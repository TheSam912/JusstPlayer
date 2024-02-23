import 'package:flutter/material.dart';

void showSystemStateOverlay(context, systemStateOverlayEntry, systemState) {
  systemStateOverlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.red,
        child: Text(
          'System State: $systemState',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    ),
  );
  Overlay.of(context).insert(systemStateOverlayEntry!);
}
