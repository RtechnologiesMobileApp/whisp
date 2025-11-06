import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  static SocketService get to => Get.find();

  IO.Socket? socket;

  final _connected = false.obs;
  bool get connected => _connected.value;

  Future<SocketService> init({
    required String baseUrl,
    required String token,
  }) async {
    // Connect with token as query param for auth
    socket = IO.io(
      baseUrl,
      IO.OptionBuilder().setTransports(['websocket']).enableForceNew().setQuery(
        {'token': token},
      ) // server should accept token here
      .build(),
    );

    socket!.on('connect', (_) {
      print('[socket] connected ${socket!.id}');
      _connected.value = true;
    });

    socket!.on('disconnect', (_) {
      print('[socket] disconnected');
      _connected.value = false;
    });

    socket!.on('connect_error', (data) {
      print('[socket] connect_error $data');
    });

    // Generic server -> client events, we'll forward them via functions below
    return this;
  }

  // Event emitters:
  void readyForRandom() {
    if (socket?.connected ?? false) {
      socket!.emit('READY_FOR_RANDOM');
      print('[socket] READY_FOR_RANDOM emitted');
    } else {
      print('[socket] cannot emit READY_FOR_RANDOM: not connected');
    }
  }

  void cancelRandom() {
    if (socket?.connected ?? false) {
      socket!.emit('CANCEL_RANDOM');
      print('[socket] CANCEL_RANDOM emitted');
    }
  }

  void sendMessage(String body) {
    if (socket?.connected ?? false) {
      socket!.emit('SEND_MESSAGE', {'body': body});
    }
  }

  void typing(bool isTyping) {
    if (socket?.connected ?? false) {
      socket!.emit('TYPING', {'isTyping': isTyping});
    }
  }

  void endSession() {
    if (socket?.connected ?? false) {
      socket!.emit('END_SESSION');
    }
  }

  // Event listeners: attach callback functions
  void onAuthOk(void Function(Map) cb) =>
      socket?.on('AUTH_OK', (data) => cb(Map.from(data)));
  void onMatchFound(void Function(Map) cb) =>
      socket?.on('MATCH_FOUND', (data) => cb(Map.from(data)));
  void onMessage(void Function(Map) cb) =>
      socket?.on('MESSAGE', (data) => cb(Map.from(data)));
  void onTyping(void Function(Map) cb) =>
      socket?.on('TYPING', (data) => cb(Map.from(data)));
  void onPartnerLeft(void Function() cb) =>
      socket?.on('PARTNER_LEFT', (_) => cb());
  void onSessionEnded(void Function() cb) =>
      socket?.on('SESSION_ENDED', (_) => cb());
  void onError(void Function(Map) cb) =>
      socket?.on('ERROR', (data) => cb(Map.from(data)));

  // Disconnect
  void disposeSocket() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }
}
