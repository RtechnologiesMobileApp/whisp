import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:whisp/core/network/api_endpoints.dart';

class SocketService extends GetxService {
  static SocketService get to => Get.find();

  IO.Socket? socket;

  final _connected = false.obs;
  bool get connected => _connected.value;

  Future<SocketService> init({
    required String baseUrl,
    required String token,
  }) async {
    // Dispose existing socket if any
    if (socket != null) {
      print('[socket] Disposing existing socket before creating new one');
      socket?.disconnect();
      socket?.dispose();
      socket = null;
    }

    print('[socket] Initializing socket connection to $baseUrl');
    print('[socket] Token provided: ${token.isNotEmpty ? "Yes (${token.substring(0, token.length > 10 ? 10 : token.length)}...)" : "No"}');
    
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


    socket!.on('connect_error', (data) {
      print('[socket] connect_error $data');
      _connected.value = false;
    });

    socket!.on('error', (data) {
      print('[socket] error event: $data');
    });

    socket!.on('disconnect', (reason) {
      print('[socket] disconnected. Reason: $reason');
      _connected.value = false;
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
  void onPartnerLeft(void Function() cb) {
    socket?.off('PARTNER_LEFT');
    socket?.on('PARTNER_LEFT', (_) => cb());
  }
  void onSessionEnded(void Function() cb) =>
      socket?.on('SESSION_ENDED', (_) => cb());
  void onError(void Function(Map) cb) =>
      socket?.on('ERROR', (data) => cb(Map.from(data)));

  // Reconnect with new token (useful after login)
  Future<void> reconnectWithToken(String token) async {
    if (token.isEmpty) {
      print('[socket] Cannot reconnect: token is empty');
      return;
    }
    
    print('[socket] Reconnecting with new token');
    await init(
      baseUrl: ApiEndpoints.baseUrl,
      token: token,
    );
  }

  // Disconnect
  void disposeSocket() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }
}
