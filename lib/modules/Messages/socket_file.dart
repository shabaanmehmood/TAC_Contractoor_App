// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// final String socketUrl = 'http://148.66.158.113:3006/'; // Replace with your server
// late IO.Socket socket;
//
// void connectAndStart() {
//   socket = IO.io(socketUrl, <String, dynamic>{
//     'transports': ['websocket'],
//   });
//
//   socket.connect();
//
//   socket.onConnect((_) {
//     print('connected');
//     sendMessage();
//   });
//
//   socket.on('receive_message', (data) {
//     print('New message: $data');
//   });
// }
//
// void sendMessage() {
//   Map<String, dynamic> message = {
//     "senderId": "58edc77a-91c6-4299-9c02-6fadb5668565",
//     "senderType": "Guard",
//     "receiverId": "f7fc8393-00bc-4cba-a72f-ecbdf8069d13",
//     "receiverType": "Contractor",
//     "text": "Hello from Postman simulation"
//   };
//   socket.emit('send_message', message);
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../controllers/user_controller.dart';

class SocketService {
  final String? userId = Get.find<UserController>().userData.value?.id;
  String? _currentUserType = "Contractor";
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  IO.Socket get socket => _socket!;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  static const Duration reconnectDelay = Duration(seconds: 3);

  final String socketUrl = 'https://api.control1security.com.au/';

  // Stream controller for chat list updates
  final StreamController<Map<String, dynamic>> _chatListController =
  StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get chatListStream => _chatListController.stream;

  void initialize() {
    if (_socket != null && _isConnected) {
      debugPrint('Socket already connected');
      return;
    }

    _socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionAttempts': maxReconnectAttempts,
      'reconnectionDelay': reconnectDelay.inMilliseconds,
    });

    _setupSocketListeners();
    _socket!.connect();
  }

  void _setupSocketListeners() {
    _socket!.onConnect((_) {
      debugPrint('✅ Socket connected successfully');
      _isConnected = true;
      _reconnectAttempts = 0;
      _reconnectTimer?.cancel();
    });

    _socket!.onDisconnect((_) {
      debugPrint('❌ Socket disconnected');
      _isConnected = false;
      _attemptReconnect();
    });

    _socket!.onConnectError((error) {
      debugPrint('⚠️ Socket connection error: $error');
      _isConnected = false;
      _attemptReconnect();
    });

    _socket!.onError((error) {
      debugPrint('⚠️ Socket error: $error');
    });

    // ✅ Fixed: Handle the response properly
    _socket!.on('chat-list', (data) {
      debugPrint('📬 Raw data received: $data');
      debugPrint('📬 Data type: ${data.runtimeType}');

      if (data != null) {
        Map<String, dynamic> responseData;

        // Handle different data formats
        if (data is Map<String, dynamic>) {
          responseData = data;
        } else if (data is List && data.isNotEmpty) {
          // Sometimes socket.io sends data as array
          if (data[0] is Map<String, dynamic>) {
            responseData = data[0] as Map<String, dynamic>;
          } else {
            debugPrint('⚠️ Unexpected data format in array: ${data[0].runtimeType}');
            return;
          }
        } else {
          debugPrint('⚠️ Unexpected data format: ${data.runtimeType}');
          return;
        }

        debugPrint('📬 Processed data: $responseData');
        _chatListController.add(responseData);
      } else {
        debugPrint('⚠️ Received null data');
      }
    });

    // Listen to new messages for real-time updates
    _socket!.on('receive_message', (data) {
      debugPrint('📨 New message received: $data');
    });
  }

  void _attemptReconnect() {
    if (_reconnectAttempts >= maxReconnectAttempts) {
      debugPrint('❌ Max reconnection attempts reached');
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(reconnectDelay, () {
      _reconnectAttempts++;
      debugPrint('🔄 Reconnection attempt $_reconnectAttempts/$maxReconnectAttempts');
      _socket?.connect();
    });
  }

  void getChatList({
    required String userId,
    required String userType,
  }) {
    if (!_isConnected) {
      debugPrint('⚠️ Socket not connected. Attempting to connect...');
      initialize();
      // Wait a bit for connection then emit
      Future.delayed(Duration(seconds: 2), () {
        if (_isConnected) {
          _emitChatList(userId, userType,);
        }
      });
      return;
    }

    _emitChatList(userId, userType);
  }

  void _emitChatList(String userId, String userType) {
    final payload = {
      "userId": userId,
      "userType": userType,
    };

    debugPrint('📤 Emitting get-chat-list: $payload');
    _socket!.emit('get-chat-list', payload);
  }

  void _autoRefreshChatList() {
    if (userId != null && _currentUserType != null && _isConnected) {
      debugPrint('🔄 Auto-refreshing chat list due to message activity');
      // Add a small delay to ensure message is processed on server
      Future.delayed(Duration(milliseconds: 500), () {
        if (_isConnected) {
          _emitChatList(userId!, _currentUserType!);
        }
      });
    }
  }

  // Method to manually refresh chat list
  void refreshChatList() {
    _autoRefreshChatList();
  }

  void disconnect() {
    debugPrint('🔌 Disconnecting socket');
    _reconnectTimer?.cancel();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
  }

  void dispose() {
    _chatListController.close();
    disconnect();
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketService {
//   static final SocketService _instance = SocketService._internal();
//   factory SocketService() => _instance;
//   SocketService._internal();
//
//   IO.Socket? _socket;
//   IO.Socket get socket => _socket!;
//
//   bool _isConnected = false;
//   bool get isConnected => _isConnected;
//
//   Timer? _reconnectTimer;
//   int _reconnectAttempts = 0;
//   static const int maxReconnectAttempts = 5;
//   static const Duration reconnectDelay = Duration(seconds: 3);
//
//   final String socketUrl = 'http://148.66.158.113:3006/';
//
//   // Store current user info for auto-refresh
//   String? _currentUserId;
//   String? _currentUserType;
//
//   // Stream controller for chat list updates
//   final StreamController<Map<String, dynamic>> _chatListController =
//   StreamController<Map<String, dynamic>>.broadcast();
//
//   Stream<Map<String, dynamic>> get chatListStream => _chatListController.stream;
//
//   void initialize() {
//     if (_socket != null && _isConnected) {
//       debugPrint('Socket already connected');
//       return;
//     }
//
//     _socket = IO.io(socketUrl, <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//       'reconnection': true,
//       'reconnectionAttempts': maxReconnectAttempts,
//       'reconnectionDelay': reconnectDelay.inMilliseconds,
//     });
//
//     _setupSocketListeners();
//     _socket!.connect();
//   }
//
//   void _setupSocketListeners() {
//     _socket!.onConnect((_) {
//       debugPrint('✅ Socket connected successfully');
//       _isConnected = true;
//       _reconnectAttempts = 0;
//       _reconnectTimer?.cancel();
//
//       // Auto-refresh chat list if user info is available
//       if (_currentUserId != null && _currentUserType != null) {
//         _emitChatList(_currentUserId!, _currentUserType!);
//       }
//     });
//
//     _socket!.onDisconnect((_) {
//       debugPrint('❌ Socket disconnected');
//       _isConnected = false;
//       _attemptReconnect();
//     });
//
//     _socket!.onConnectError((error) {
//       debugPrint('⚠️ Socket connection error: $error');
//       _isConnected = false;
//       _attemptReconnect();
//     });
//
//     _socket!.onError((error) {
//       debugPrint('⚠️ Socket error: $error');
//     });
//
//     // Handle chat list response
//     _socket!.on('chat-list', (data) {
//       debugPrint('📬 Raw data received: $data');
//       debugPrint('📬 Data type: ${data.runtimeType}');
//
//       if (data != null) {
//         Map<String, dynamic> responseData;
//
//         if (data is Map<String, dynamic>) {
//           responseData = data;
//         } else if (data is List && data.isNotEmpty) {
//           if (data[0] is Map<String, dynamic>) {
//             responseData = data[0] as Map<String, dynamic>;
//           } else {
//             debugPrint('⚠️ Unexpected data format in array: ${data[0].runtimeType}');
//             return;
//           }
//         } else {
//           debugPrint('⚠️ Unexpected data format: ${data.runtimeType}');
//           return;
//         }
//
//         debugPrint('📬 Processed data: $responseData');
//         _chatListController.add(responseData);
//       } else {
//         debugPrint('⚠️ Received null data');
//       }
//     });
//
//     // Listen to new messages and auto-refresh chat list
//     _socket!.on('receive_message', (data) {
//       debugPrint('📨 New message received: $data');
//       _autoRefreshChatList();
//     });
//
//     // Listen to message sent confirmation and auto-refresh chat list
//     _socket!.on('message_sent', (data) {
//       debugPrint('📤 Message sent confirmation: $data');
//       _autoRefreshChatList();
//     });
//
//     // Listen to any message status updates
//     _socket!.on('message_status_update', (data) {
//       debugPrint('📋 Message status updated: $data');
//       _autoRefreshChatList();
//     });
//   }
//
//   void _autoRefreshChatList() {
//     if (_currentUserId != null && _currentUserType != null && _isConnected) {
//       debugPrint('🔄 Auto-refreshing chat list due to message activity');
//       // Add a small delay to ensure message is processed on server
//       Future.delayed(Duration(milliseconds: 500), () {
//         if (_isConnected) {
//           _emitChatList(_currentUserId!, _currentUserType!);
//         }
//       });
//     }
//   }
//
//   void _attemptReconnect() {
//     if (_reconnectAttempts >= maxReconnectAttempts) {
//       debugPrint('❌ Max reconnection attempts reached');
//       return;
//     }
//
//     _reconnectTimer?.cancel();
//     _reconnectTimer = Timer(reconnectDelay, () {
//       _reconnectAttempts++;
//       debugPrint('🔄 Reconnection attempt $_reconnectAttempts/$maxReconnectAttempts');
//       _socket?.connect();
//     });
//   }
//
//   void getChatList({
//     required String userId,
//     required String userType,
//   }) {
//     // Store user info for auto-refresh
//     _currentUserId = userId;
//     _currentUserType = userType;
//
//     if (!_isConnected) {
//       debugPrint('⚠️ Socket not connected. Attempting to connect...');
//       initialize();
//       // Wait a bit for connection then emit
//       Future.delayed(Duration(seconds: 2), () {
//         if (_isConnected) {
//           _emitChatList(userId, userType);
//         }
//       });
//       return;
//     }
//
//     _emitChatList(userId, userType);
//   }
//
//   void _emitChatList(String userId, String userType) {
//     final payload = {
//       "userId": userId,
//       "userType": userType,
//     };
//
//     debugPrint('📤 Emitting get-chat-list: $payload');
//     _socket!.emit('get-chat-list', payload);
//   }
//
//   // Method to manually refresh chat list
//   void refreshChatList() {
//     _autoRefreshChatList();
//   }
//
//   void disconnect() {
//     debugPrint('🔌 Disconnecting socket');
//     _reconnectTimer?.cancel();
//     _socket?.disconnect();
//     _socket?.dispose();
//     _socket = null;
//     _isConnected = false;
//     _currentUserId = null;
//     _currentUserType = null;
//   }
//
//   void dispose() {
//     _chatListController.close();
//     disconnect();
//   }
// }