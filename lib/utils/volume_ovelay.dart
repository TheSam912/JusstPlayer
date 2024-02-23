import 'package:flutter/material.dart';

void showVolumeOverlay(context, volumeOverlayEntry, volume) {
  volumeOverlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          child: Text(
            'Vol: ${volume.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  );
  Overlay.of(context).insert(volumeOverlayEntry!);
  Future.delayed(const Duration(seconds: 3), () {
    volumeOverlayEntry?.remove();
  });
}
