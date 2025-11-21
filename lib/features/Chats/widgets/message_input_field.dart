import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whisp/core/services/socket_service.dart';
import 'package:whisp/features/Chats/controllers/chat_controller.dart';
import 'package:whisp/config/constants/colors.dart';

class MessageInputField extends StatefulWidget {
  final ChatController controller;
   final bool isFriend; 

  const MessageInputField({super.key, required this.controller, required this.isFriend});

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final RecorderController recorder = RecorderController();
  final SocketService socketService = Get.find<SocketService>();
  bool isRecording = false;
  String? filePath;
  int seconds = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    recorder
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  void startTimer() {
    seconds = 0;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => seconds++);
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  String formatTime(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }
void cancelRecording() async {
  stopTimer();
  await recorder.stop();
   socketService.recording(false, toUserId: widget.controller.friendId);
  debugPrint("❌ Recording cancelled event emitted");
  setState(() {
    isRecording = false;
    filePath = null; // delete recorded file
  });
}

  Future<void> startRecording() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) return;
socketService.recording(true, toUserId: widget.controller.friendId);
 debugPrint("🎤 Recording started event emitted");
    Directory dir = await getTemporaryDirectory();
    filePath = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.wav";

    await recorder.record(path: filePath!);
    startTimer();

    setState(() => isRecording = true);
  }

  Future<void> stopRecording() async {
    setState(() => isRecording = false);
      socketService.recording(false, toUserId: widget.controller.friendId);
  debugPrint("🛑 Recording stopped event emitted");


    // show processing overlay
    widget.controller.isProcessingAudio.value = true;

    await recorder.stop();
    stopTimer();
    widget.controller.isProcessingAudio.value = false;

    if (filePath != null) {
      widget.controller.sendVoice(File(filePath!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child:Row(
              crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    !isRecording ?
    Expanded(
      child:  TextField(
        controller: widget.controller.messageController,
        onChanged: (text) => widget.controller.sendTyping(),
        decoration: InputDecoration(
          hintText: "Write a message",
          filled: true,
          fillColor: const Color(0xffF1F2F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ):
       
            Expanded(
              child: SizedBox(
                width: 60,
                height: 40,
                child: AudioWaveforms(
                  enableGesture: false,
                  size: const Size(60, 40),
                  recorderController: recorder,
                  waveStyle: const WaveStyle(
                    waveColor: Colors.red,
                    showMiddleLine: false,
                  ),
                ),
              ),
            ),
    const SizedBox(width: 8),

    // 👇 MIC only if user is friend
    // 👇 MIC only if user is friend
if (widget.isFriend)
  Row(
    children: [
      // Timer text
      if (isRecording)
        Text(
          formatTime(seconds),
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),

      const SizedBox(width: 8),

      // ❌ Delete / Cancel Recording Button
      if (isRecording)
        GestureDetector(
          onTap: cancelRecording,
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey,
            child: Icon(Icons.close, color: Colors.white),
          ),
        ),

      if (isRecording) const SizedBox(width: 8),

      // 🎙️ Mic / Stop Button
      GestureDetector(
        onTap: isRecording ? stopRecording : startRecording,
        child: Obx(
          () => CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            child: widget.controller.isProcessingAudio.value
                ? const CircularProgressIndicator(color: Colors.white)
                : Icon(
                    isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    ],
  ),
     const SizedBox(width: 8),

    // Send button
    GestureDetector(
      onTap: widget.controller.sendMessage,
      child: CircleAvatar(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.send, color: Colors.white),
      ),
    ),
  ],
 
 
            ),
            
          ),
          // Waveform & timer overlay
          if (isRecording && filePath != null)
            Positioned(
              bottom: 70,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Text(
                    formatTime(seconds),
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AudioWaveforms(
                    enableGesture: false,
                    size: Size(MediaQuery.of(context).size.width - 32, 50),
                    recorderController: recorder,
                    waveStyle: const WaveStyle(
                      waveColor: Colors.red,
                      showMiddleLine: false,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
