import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:whisp/core/network/api_endpoints.dart';
import 'package:whisp/core/services/session_manager.dart';

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
      debugPrint('[socket] Disposing existing socket before creating new one');
      socket?.disconnect();
      socket?.dispose();
      socket = null;
    }

    debugPrint('[socket] Initializing socket connection to $baseUrl');
    debugPrint(
      '[socket] Token provided: ${token.isNotEmpty ? "Yes (${token.substring(0, token.length > 10 ? 10 : token.length)}...)" : "No"}',
    );

    // Connect with token as query param for auth
    socket = IO.io(
      baseUrl,
      IO.OptionBuilder().setTransports(['websocket']).enableForceNew().setQuery(
        {'token': token},
      ) // server should accept token here
      .build(),
    );

    socket!.on('connect', (_) {
      debugPrint('[socket] connected ${socket!.id}');
      _connected.value = true;
    });

    socket!.on('connect_error', (data) {
      debugPrint('[socket] connect_error $data');
      _connected.value = false;
    });

    socket!.on('error', (data) {
      debugPrint('[socket] error event: $data');
    });

    socket!.on('disconnect', (reason) {
      debugPrint('[socket] disconnected. Reason: $reason');
      _connected.value = false;
    });

    // Generic server -> client events, we'll forward them via functions below
    return this;
  }

  // Event emitters:
  void readyForRandom() {
    if (socket?.connected ?? false) {
      socket!.emit('READY_FOR_RANDOM');
      debugPrint('[socket] READY_FOR_RANDOM emitted');
    } else {
      debugPrint('[socket] cannot emit READY_FOR_RANDOM: not connected');
    }
  }

  void cancelRandom() {
    if (socket?.connected ?? false) {
      socket!.emit('CANCEL_RANDOM');
      debugPrint('[socket] CANCEL_RANDOM emitted');
    }
  }
     // send msg to random partner
  void sendMessage(String body) {
    if (socket?.connected ?? false) {
      socket!.emit('SEND_MESSAGE', {'body': body});
    }
  }
  // send msg to friend

  void sendMessageToFriend(String toUserId, String body) {
  if (socket?.connected ?? false) {
    socket!.emit('SEND_MESSAGE_TO_FRIEND', {
      'toUserId': toUserId,
      'body': body,
    });
    debugPrint('[socket] SEND_MESSAGE_TO_FRIEND emitted to $toUserId with message: $body');
  } else {
    debugPrint('[socket] cannot emit SEND_MESSAGE_TO_FRIEND: not connected');
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

  void sendFriendRequest(String toUserId, void Function(Map) ackCb) {
    if (socket?.connected ?? false) {
      socket!.emitWithAck(
        'FRIEND_REQUEST_SEND',
        {'toUserId': toUserId},
        ack: (data) {
          ackCb(Map.from(data));
        },
      );
      debugPrint('[socket] FRIEND_REQUEST_SEND emitted to $toUserId');
    }
  }

void acceptFriend(String requestId, void Function(Map<String, dynamic>) ackCb) {
  if (socket == null) return;

  socket!.emitWithAck(
    'FRIEND_ACCEPT',
    {'requestId': requestId},
    ack: (data) {
      // safe check
      if (data is Map) {
        ackCb(Map<String, dynamic>.from(data));
      } else {
        ackCb({'ok': false, 'code': 'Invalid response'});
      }
    },
  );
}

void rejectFriend(String requestId, void Function(Map<String, dynamic>) ackCb) {
  if (socket == null) return;

  socket!.emitWithAck(
    'FRIEND_REJECT',
    {'requestId': requestId},
    ack: (data) {
      if (data is Map) {
        ackCb(Map<String, dynamic>.from(data));
      } else {
        ackCb({'ok': false, 'code': 'Invalid response'});
      }
    },
  );
}

  

  void cancelFriendRequest(String requestId, void Function(Map) ackCb) {
    socket?.emitWithAck(
      'FRIEND_REQUEST_CANCEL',
      {'requestId': requestId},
      ack: (data) {
        ackCb(Map.from(data));
      },
    );
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


 

   void onFriendRequestAccepted(void Function(Map) cb) {
    socket?.on('FRIEND_REQUEST_ACCEPTED', (data) {
      cb(Map.from(data));
      debugPrint('[socket] FRIEND_REQUEST_ACCEPTED: $data');
    });
  }

  void onFriendRequestRejected(void Function(Map) cb) {
    socket?.on('FRIEND_REQUEST_REJECTED', (data) {
      cb(Map.from(data));
      debugPrint('[socket] FRIEND_REQUEST_REJECTED: $data');
    });
  }

  void onFriendRequestCanceled(void Function(Map) cb) {
    socket?.on('FRIEND_REQUEST_CANCELED', (data) {
      cb(Map.from(data));
      debugPrint('[socket] FRIEND_REQUEST_CANCELED: $data');
    });
  }

  void onFriendAdded(void Function(Map) cb) {
    socket?.on('FRIEND_ADDED', (data) {
      cb(Map.from(data));
      debugPrint('[socket] FRIEND_ADDED: $data');
    });
  }    

  // Reconnect with new token (useful after login)
  Future<void> reconnectWithToken(String token) async {
    if (token.isEmpty) {
      debugPrint('[socket] Cannot reconnect: token is empty');
      return;
    }

    debugPrint('[socket] Reconnecting with new token');
    await init(baseUrl: ApiEndpoints.baseUrl, token: token);
  }

  //helper method
  Future<void> safeInitIfNeeded() async {
  if (socket != null && socket!.connected) {
    print('[socket] Already connected ✅');
    return;
  }

  final token = SessionController().user?.token;
  if (token == null || token.isEmpty) {
    print('[socket] ⚠️ No token found — will retry after login or session load.');
    return;
  }

  await init(baseUrl: ApiEndpoints.baseUrl, token: token);
  print('[socket] ✅ Reconnected successfully');
}


  // Disconnect
  void disposeSocket() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }
}
