import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart' as aw;
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:whisp/config/constants/colors.dart';
import 'package:whisp/config/global/audio_manager.dart';

class ChatBubble extends StatefulWidget {
  final bool fromMe;
  final String message;
  final bool isRead;
  final bool isVoice;
  final String? voiceUrl;
  final String? localPath;
  final bool isSending;

  const ChatBubble({
    super.key,
    required this.fromMe,
    required this.message,
    required this.isRead,
    this.isVoice = false,
    this.voiceUrl,
    this.localPath,
    this.isSending = false,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  aw.PlayerController? player;
  bool isPlaying = false;
  bool isLoading = false;
  String? preparedPath;

  @override
  void initState() {
    super.initState();
    _initVoicePlayerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant ChatBubble oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isVoice) return;

    bool voiceChanged = oldWidget.voiceUrl != widget.voiceUrl;
    bool localChanged = oldWidget.localPath != widget.localPath;

    if (voiceChanged || localChanged) {
      _disposePlayer();
      _initVoicePlayerIfNeeded();
    }
  }

  void _initVoicePlayerIfNeeded() {
    if (!widget.isVoice) return;
    initVoicePlayer();
  }

  Future<void> initVoicePlayer() async {
    setState(() => isLoading = true);

    try {
      final path = await _resolveAudioPath();
      if (path == null) {
        setState(() => isLoading = false);
        return;
      }

      preparedPath = path;

      player = aw.PlayerController();

      await player!.preparePlayer(
        path: preparedPath!,
        shouldExtractWaveform: true,
      );

      // Listen to complete
      player!.onCompletion.listen((_) {
        if (mounted) {
          setState(() => isPlaying = false);
        }
        // No need to manually stop/seek — the package already stops.
        // But seeking to 0 helps visual feedback immediately
        player!.seekTo(0);
      });
      // player!.onCompletion.listen((_)  {
      //   player!.stopPlayer();
      //   player!.seekTo(0);

      //   if (mounted) {
      //     setState(() => isPlaying = false);
      //   }
      // });

      // Listen to state changes
      player!.onPlayerStateChanged.listen((state) {
        if (!mounted) return;

        setState(() {
          isPlaying = state == aw.PlayerState.playing;
        });
      });
    } catch (e) {
      debugPrint("Voice init error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<String?> _resolveAudioPath() async {
    // Local file first
    if (widget.localPath != null) {
      File f = File(widget.localPath!);
      if (await f.exists()) return f.path;
    }

    // Remote URL fallback
    if (widget.voiceUrl != null) {
      return await _downloadVoiceFile(widget.voiceUrl!);
    }

    return null;
  }

  Future<String> _downloadVoiceFile(String url) async {
    final response = await http.get(Uri.parse(url));

    final dir = await getTemporaryDirectory();

    final extension = p.extension(url).isNotEmpty ? p.extension(url) : ".wav";

    final file = File(
      "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}$extension",
    );

    await file.writeAsBytes(response.bodyBytes);

    return file.path;
  }

  void _disposePlayer() {
    player?.dispose();
    player = null;
    preparedPath = null;
    isPlaying = false;
    if (GlobalAudioManager.currentPlayer == player) {
      GlobalAudioManager.currentPlayer = null;
    }
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.7;

    return Align(
      alignment: widget.fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth, minWidth: 60),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: widget.fromMe ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: widget.isVoice ? _voiceWidget(maxWidth) : _textWidget(),
      ),
    );
  }

  Widget _textWidget() {
    return Text(
      widget.message,
      style: TextStyle(
        color: widget.fromMe ? Colors.white : Colors.black87,
        fontSize: 16,
      ),
    );
  }

  Widget _voiceWidget(double maxWidth) {
    if (isLoading || player == null) {
      return SizedBox(
        height: 50,
        child: Center(
          child: SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: widget.fromMe ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minWidth: 140,
        minHeight: 50,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: widget.fromMe ? Colors.white : Colors.black,
            ),
            onPressed: () async {
              // Always stop any other player first (before preparing)
              await GlobalAudioManager.stopCurrent();

              // Toggle pause
              if (isPlaying) {
                await player!.pausePlayer();
                return;
              }

              // Resume if paused
              if (player!.playerState == aw.PlayerState.paused) {
                await player!.startPlayer();
                return;
              }

              // 🔥 If audio finished → state becomes "stopped"
              // → MUST re-prepare
              if (player!.playerState == aw.PlayerState.stopped) {
                await player!.preparePlayer(
                  path: preparedPath!,
                  shouldExtractWaveform: false,
                );
              }

              // Set as active player
              GlobalAudioManager.setCurrent(player!);

              // Start playback
              await player!.startPlayer();
            },

             
          ),

          Expanded(
            child: aw.AudioFileWaveforms(
              size: const Size(double.infinity, 50),
              playerController: player!,
              playerWaveStyle: aw.PlayerWaveStyle(
                fixedWaveColor: widget.fromMe ? Colors.white54 : Colors.black38,
                liveWaveColor: widget.fromMe ? Colors.white : Colors.black87,
                showSeekLine: false,
              ),
            ),
          ),

          if (widget.isSending)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: widget.fromMe ? Colors.white : Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }


}
