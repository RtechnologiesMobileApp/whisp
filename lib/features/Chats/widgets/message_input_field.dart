import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whisp/features/Chats/controllers/chat_controller.dart';
import 'package:whisp/config/constants/colors.dart';

class MessageInputField extends StatefulWidget {
  final ChatController controller;

  const MessageInputField({super.key, required this.controller});

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final RecorderController recorder = RecorderController();
  bool isRecording = false;
  String? filePath;

  @override
  void initState() {
    super.initState();
    recorder
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  Future<void> startRecording() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) return;

    Directory dir = await getTemporaryDirectory();
    filePath = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a";

    await recorder.record(path: filePath!);

    setState(() => isRecording = true);
  }

  Future<void> stopRecording() async {
    await recorder.stop();
    setState(() => isRecording = false);

    if (filePath != null) {
      widget.controller.sendVoice(File(filePath!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            // 🎤 RECORD BUTTON
            GestureDetector(
              onLongPress: startRecording,
              onLongPressUp: stopRecording,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(
                  isRecording ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // 🔊 WAVEFORM WHILE RECORDING
            if (isRecording)
              Expanded(
                child: AudioWaveforms(
                  enableGesture: false,
                  size: Size(MediaQuery.of(context).size.width / 2, 50),
                  recorderController: recorder,
                  waveStyle: const WaveStyle(
                    waveColor: Colors.red,
                    showMiddleLine: false,
                  ),
                ),
              )
            else
              Expanded(
                child: TextField(
                  controller: widget.controller.messageController,
                  onChanged: (text) {
  widget.controller.sendTyping(true);
    
},

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
              ),

            const SizedBox(width: 8),

            // SEND BUTTON
            GestureDetector(
              onTap: widget.controller.sendMessage,
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.send, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:whisp/config/constants/colors.dart';
// import 'package:whisp/features/Chats/controllers/chat_controller.dart';

// class MessageInputField extends StatefulWidget {
//   final ChatController controller;

//   const MessageInputField({super.key, required this.controller});

//   @override
//   State<MessageInputField> createState() => _MessageInputFieldState();
// }

// class _MessageInputFieldState extends State<MessageInputField> {
//   Timer? _typingTimer;

//   void _onTextChanged(String value) {
//     widget.controller.sendTyping(true); // start typing

//     // reset timer
//     _typingTimer?.cancel();
//     _typingTimer = Timer(const Duration(seconds: 1), () {
//       widget.controller.sendTyping(false); // stop typing
//     });
//   }

//   @override
//   void dispose() {
//     _typingTimer?.cancel(); // cleanup
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         color: Colors.white,
//         child: Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: widget.controller.messageController,
//                 onChanged: _onTextChanged, // ⬅ typing detect here
//                 decoration: InputDecoration(
//                   hintText: "Write a message",
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                     borderSide: BorderSide.none,
//                   ),
//                   hintStyle: const TextStyle(color: Colors.grey),
//                   filled: true,
//                   fillColor: const Color(0xffF1F2F5),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             GestureDetector(
//               onTap: widget.controller.sendMessage,
//               child: CircleAvatar(
//                 backgroundColor: AppColors.primary,
//                 child: const Icon(Icons.send, color: Colors.white, size: 20),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

 