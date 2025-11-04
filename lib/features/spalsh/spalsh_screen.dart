import 'dart:async';
import 'package:flutter/material.dart';
 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Request microphone permission and then navigate
    _requestPermissionsAndNavigate();
  }

  Future<void> _requestPermissionsAndNavigate() async {
    try {
      print('🎤 Requesting all necessary permissions...');
      
      // Request all necessary permissions
      final permissions = await [
        Permission.microphone,
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();
      
      // Check microphone permission (most important)
      final micPermission = permissions[Permission.microphone];
      if (micPermission?.isGranted == true) {
        print('✅ Microphone permission granted');
      } else {
        print('⚠️ Microphone permission denied - speech recognition may not work');
      }
      
      // Check storage permissions
      final storagePermission = permissions[Permission.storage];
      if (storagePermission?.isGranted == true) {
        print('✅ Storage permission granted');
      } else {
        print('⚠️ Storage permission denied - audio files may not be saved');
      }
      
      // Check external storage permission
      final externalStoragePermission = permissions[Permission.manageExternalStorage];
      if (externalStoragePermission?.isGranted == true) {
        print('✅ External storage permission granted');
      } else {
        print('⚠️ External storage permission denied - limited file access');
      }
      
      // Wait a bit for user to see the splash screen
      await Future.delayed(Duration(seconds: 3));
      
      // Navigate to HomeScreen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  HomeScreen()),
        );
      }
    } catch (e) {
      print('❌ Permission request error: $e');
      // Navigate anyway after delay
      await Future.delayed(Duration(seconds: 3));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>   HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0), // margin around the edges
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/splash_4.png',
                  fit: BoxFit.contain, // fills full screen nicely
                  alignment: Alignment.center,
                ),
              ),
              // Permission request info
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Grant Permissions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'This app needs microphone and storage access for voice chat functionality.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}