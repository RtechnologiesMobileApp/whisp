import 'package:audio_waveforms/audio_waveforms.dart';

class GlobalAudioManager {
  static PlayerController? currentPlayer;

  /// Stop currently playing audio
  static Future<void> stopCurrent() async {
    if (currentPlayer != null) {
      try {
        await currentPlayer!.stopPlayer();
        await currentPlayer!.seekTo(0);
      } catch (_) {}
    }
  }

  /// Register a new playing controller
  static void setCurrent(PlayerController controller) {
    currentPlayer = controller;
  }
}
