
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

  const ChatBubble({
    super.key,
    required this.fromMe,
    required this.message,
    required this.isRead,
    this.isVoice = false,
    this.voiceUrl,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  aw.PlayerController? waveformPlayer;
  ja.AudioPlayer? audioPlayer;
  bool isPlaying = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isVoice && widget.voiceUrl != null) {
      initVoicePlayer();
    }
  }

Future<void> initVoicePlayer() async {
  setState(() => isLoading = true);

  final localPath = await downloadVoiceFile(widget.voiceUrl!);

  waveformPlayer = aw.PlayerController();
  await waveformPlayer!.preparePlayer(
    path: localPath,
    shouldExtractWaveform: true,
  );

  audioPlayer = ja.AudioPlayer();
  await audioPlayer!.setFilePath(localPath, preload: true);
  await audioPlayer!.setLoopMode(ja.LoopMode.off);

  // waveform ready flag
  waveformPlayer!.onPlayerStateChanged.listen((state) {
    // You can setState here if you want to trigger UI after waveform ready
  });

  // Listen for audio finish
  audioPlayer!.processingStateStream.listen((state) {
    if (state == ja.ProcessingState.completed) {
      audioPlayer!.stop();
      audioPlayer!.seek(Duration.zero);
      waveformPlayer!.stopPlayer(); // reset waveform
      setState(() => isPlaying = false);
    }
  });

  // Listen to playing state for icon
  audioPlayer!.playingStream.listen((playing) {
    setState(() => isPlaying = playing);
  });

  setState(() => isLoading = false);
}

 
  Future<String> downloadVoiceFile(String url) async {
    final response = await http.get(Uri.parse(url));
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/tempVoice_${DateTime.now().millisecondsSinceEpoch}.mp3'); // ya wav
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  @override
  void dispose() {
    waveformPlayer?.dispose();
    audioPlayer?.dispose();
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
    if (isLoading) {
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
            child: widget.voiceUrl == null
                ? const Text("Invalid voice", style: TextStyle(color: Colors.red))
                : aw.AudioFileWaveforms(
                    size: const Size(double.infinity, 50),
                    playerController: waveformPlayer!,
                    playerWaveStyle: aw.PlayerWaveStyle(
                      fixedWaveColor: widget.fromMe ? Colors.white54 : Colors.black38,
                      liveWaveColor: widget.fromMe ? Colors.white : Colors.black87,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}


 
 