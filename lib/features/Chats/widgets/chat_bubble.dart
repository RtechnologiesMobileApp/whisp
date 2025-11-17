
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart' as aw;
import 'package:just_audio/just_audio.dart' as ja;
 
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:whisp/config/constants/colors.dart';

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
  aw.PlayerController? waveformPlayer;
  ja.AudioPlayer? audioPlayer;
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

    final voiceChanged = oldWidget.voiceUrl != widget.voiceUrl;
    final localChanged = oldWidget.localPath != widget.localPath;

    if (voiceChanged || localChanged) {
      _disposePlayers();
      _initVoicePlayerIfNeeded();
    }
  }

  void _initVoicePlayerIfNeeded() {
    if (!widget.isVoice) return;
    if (widget.voiceUrl == null && widget.localPath == null) return;
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

      waveformPlayer = aw.PlayerController();
      await waveformPlayer!.preparePlayer(
        path: preparedPath!,
        shouldExtractWaveform: true,
      );

      audioPlayer = ja.AudioPlayer();
      await audioPlayer!.setFilePath(preparedPath!, preload: true);
      await audioPlayer!.setLoopMode(ja.LoopMode.off);

      waveformPlayer!.onPlayerStateChanged.listen((state) {});

      audioPlayer!.processingStateStream.listen((state) {
        if (state == ja.ProcessingState.completed) {
          audioPlayer!.stop();
          audioPlayer!.seek(Duration.zero);
          waveformPlayer!.stopPlayer();
          if (mounted) {
            setState(() => isPlaying = false);
          }
        }
      });

      audioPlayer!.playingStream.listen((playing) {
        if (mounted) {
          setState(() => isPlaying = playing);
        }
      });
    } catch (e) {
      debugPrint('Failed to init voice player: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<String?> _resolveAudioPath() async {
    if (widget.localPath != null) {
      final file = File(widget.localPath!);
      if (await file.exists()) {
        return file.path;
      }
    }

    if (widget.voiceUrl == null) return null;
    return await downloadVoiceFile(widget.voiceUrl!);
  }

  Future<String> downloadVoiceFile(String url) async {
    final response = await http.get(Uri.parse(url));
    final dir = await getTemporaryDirectory();
    final file = File(
        '${dir.path}/tempVoice_${DateTime.now().millisecondsSinceEpoch}.mp3'); // ya wav
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  void _disposePlayers() {
    waveformPlayer?.dispose();
    waveformPlayer = null;
    audioPlayer?.dispose();
    audioPlayer = null;
    preparedPath = null;
    isPlaying = false;
  }

  @override
  void dispose() {
    _disposePlayers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.7;

    return Align(
      alignment: widget.fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          minWidth: 60,
        ),
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
    if (isLoading || waveformPlayer == null || audioPlayer == null) {
      return SizedBox(
        height: 50,
        child: Center(
          child: CircularProgressIndicator(color: widget.fromMe ? Colors.white : Colors.black),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth, minWidth: 140, minHeight: 50),
      child: Row(
        children: [
   IconButton(
  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
      color: widget.fromMe ? Colors.white : Colors.black),
  onPressed: () async {
    if (!isPlaying) {
      // Start waveform animation
       waveformPlayer!.stopPlayer();
      waveformPlayer!.startPlayer( ); // waveform starts properly

      // Start audio
      await audioPlayer!.play();
    } else {
      await audioPlayer!.pause();
      waveformPlayer!.pausePlayer();
    }
  },
),

          Expanded(
            child: preparedPath == null
                ? const Text("Voice unavailable", style: TextStyle(color: Colors.red))
                : aw.AudioFileWaveforms(
                    size: const Size(double.infinity, 50),
                    playerController: waveformPlayer!,
                    playerWaveStyle: aw.PlayerWaveStyle(
                      fixedWaveColor: widget.fromMe ? Colors.white54 : Colors.black38,
                      liveWaveColor: widget.fromMe ? Colors.white : Colors.black87,
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