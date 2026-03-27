// confetti_overlay.dart
import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettiOverlay {
  static OverlayEntry? _overlayEntry;
  static ConfettiController? _controller;

  static void show(BuildContext context) {
    _controller = ConfettiController(duration: const Duration(seconds: 2));

    _overlayEntry = OverlayEntry(
      builder: (context) => IgnorePointer(
        ignoring: true,
        child: Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller!,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.06,
              numberOfParticles: 30,
              gravity: 0.25,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);

    _controller!.play();

    Timer(const Duration(seconds: 2), () {
      hide();
    });
  }

  static void hide() {
    _controller?.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}