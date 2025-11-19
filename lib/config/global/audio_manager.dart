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
  static Future<void> pauseCurrent() async {
    if (currentPlayer != null) {
      try {
        await currentPlayer!.pausePlayer();
        // await currentPlayer!.seekTo(0);
      } catch (_) {}
    }
  }
}
 
// import 'package:audio_waveforms/audio_waveforms.dart';

// class GlobalAudioManager {
//   static PlayerController? activeController;

//   static Future<void> stopActive() async {
//     if (activeController != null) {
//       try {
//         await activeController!.stopPlayer();
//         await activeController!.seekTo(0);
//       } catch (_) {}
//     }
//   }

//   static void setActive(PlayerController controller) {
//     activeController = controller;
//   }
// }
