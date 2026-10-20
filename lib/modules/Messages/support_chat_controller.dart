import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/modules/Messages/socket_file.dart';
import 'package:taccontractor/routes/app_routes.dart';

import 'support_chat_models.dart';
import 'support_chat_service.dart';

class SupportChatController extends GetxController {
  final SupportChatService _service = SupportChatService();
  final SocketService _socket = SocketService();
  final UserController _user = Get.find<UserController>();

  final RxList<SupportTicket> tickets = <SupportTicket>[].obs;
  final Rxn<SupportTicket> currentTicket = Rxn<SupportTicket>();
  final RxBool isLoadingTickets = false.obs;
  final RxBool isLoadingThread = false.obs;
  final RxBool isLoadingOlder = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isSending = false.obs;
  final RxnString errorMessage = RxnString();
  final RxnString threadErrorMessage = RxnString();

  StreamSubscription<Map<String, dynamic>>? _socketSubscription;
  StreamSubscription<bool>? _connectionSubscription;
  int _ticketPage = 0;
  int _ticketTotalPages = 1;
  int _messagePage = 1;
  int _messageTotalPages = 1;
  String? _joinedTicketId;
  bool _wasSocketDisconnectedWhileInThread = false;
  String? _loadedAccountKey;

  String get _token {
    final value = _user.accessToken;
    if (value == null || value.isEmpty) {
      throw const SupportApiException(
        statusCode: 401,
        message: 'Your session has expired. Please sign in again.',
      );
    }
    return value;
  }

  bool get canLoadMoreTickets => _ticketPage < _ticketTotalPages;
  bool get canLoadOlderMessages => _messagePage < _messageTotalPages;

  @override
  void onInit() {
    super.onInit();
    _socketSubscription = _socket.supportEvents.listen(
      _handleSocketEvent,
      onError: (Object error) {
        debugPrint('Support socket stream failed: $error');
        errorMessage.value = 'Live support updates are unavailable.';
      },
    );
    _connectionSubscription = _socket.connectionEvents.listen(
      _handleConnectionChange,
    );
    _socket.initialize();
    loadTickets(refresh: true);
  }

  Future<void> loadTickets({bool refresh = false}) async {
    if (isLoadingTickets.value) return;
    final accountKey = '${_user.accountType}:${_user.accountId}';
    if (_loadedAccountKey != null && _loadedAccountKey != accountKey) {
      tickets.clear();
      _ticketPage = 0;
      _ticketTotalPages = 1;
    }
    _loadedAccountKey = accountKey;
    if (!refresh && !canLoadMoreTickets && _ticketPage != 0) return;
    isLoadingTickets.value = true;
    errorMessage.value = null;
    try {
      final requestedPage = refresh ? 1 : _ticketPage + 1;
      final result = await _service.fetchTickets(
        _token,
        page: requestedPage,
      );
      _ticketPage = result.page;
      _ticketTotalPages = result.totalPages;
      if (refresh) {
        tickets.assignAll(result.tickets);
      } else {
        for (final ticket in result.tickets) {
          _upsertTicket(ticket);
        }
      }
    } catch (error) {
      errorMessage.value = _errorText(error);
      debugPrint('Could not load support tickets: $error');
    } finally {
      isLoadingTickets.value = false;
    }
  }

  Future<SupportTicket?> createTicket({
    required String subject,
    required String text,
    required List<String> attachments,
  }) async {
    isCreating.value = true;
    errorMessage.value = null;
    try {
      final ticket = await _service.createTicket(
        _token,
        subject: subject,
        text: text,
        attachments: attachments,
      );
      _upsertTicket(ticket);
      return ticket;
    } catch (error) {
      errorMessage.value = _errorText(error);
      rethrow;
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> openThread(
    String ticketId, {
    SupportTicket? createdTicket,
  }) async {
    if (_joinedTicketId != null && _joinedTicketId != ticketId) {
      _socket.leaveSupportTicket(_joinedTicketId!);
    }
    isLoadingThread.value = true;
    threadErrorMessage.value = null;
    try {
      if (createdTicket != null) {
        currentTicket.value = createdTicket;
        _messagePage = 1;
        _messageTotalPages = 1;
      } else {
        final result = await _service.fetchThread(_token, ticketId);
        currentTicket.value = result.ticket;
        _messagePage = result.page;
        _messageTotalPages = result.totalPages;
        _upsertTicket(result.ticket);
      }
      _socket.initialize();
      _wasSocketDisconnectedWhileInThread = !_socket.isConnected;
      _socket.joinSupportTicket(ticketId);
      _joinedTicketId = ticketId;
      _markTicketRead(ticketId);
    } catch (error) {
      threadErrorMessage.value = _errorText(error);
      debugPrint('Could not open support thread: $error');
      if (error is SupportApiException && error.statusCode == 404) {
        if (Get.key.currentState?.canPop() == true) Get.back<void>();
      }
    } finally {
      isLoadingThread.value = false;
    }
  }

  void leaveThread() {
    final ticketId = _joinedTicketId;
    if (ticketId != null) {
      _socket.leaveSupportTicket(ticketId);
      _joinedTicketId = null;
    }
    currentTicket.value = null;
  }

  Future<void> loadOlderMessages() async {
    final ticket = currentTicket.value;
    if (ticket == null || !canLoadOlderMessages || isLoadingOlder.value) return;
    isLoadingOlder.value = true;
    threadErrorMessage.value = null;
    try {
      final result = await _service.fetchThread(
        _token,
        ticket.id,
        page: _messagePage - 1,
      );
      _messagePage = result.page;
      _messageTotalPages = result.totalPages;
      final latestMessages = currentTicket.value?.id == ticket.id
          ? currentTicket.value!.messages
          : ticket.messages;
      final knownIds = latestMessages.map((message) => message.id).toSet();
      final older = result.ticket.messages
          .where((message) => !knownIds.contains(message.id))
          .toList();
      currentTicket.value = result.ticket.withMessages([
        ...older,
        ...latestMessages,
      ]);
    } catch (error) {
      threadErrorMessage.value = _errorText(error);
      debugPrint('Could not load older support messages: $error');
    } finally {
      isLoadingOlder.value = false;
    }
  }

  Future<void> sendMessage({
    required String text,
    required List<String> attachments,
  }) async {
    final ticket = currentTicket.value;
    if (ticket == null || !ticket.isActive || isSending.value) return;
    isSending.value = true;
    threadErrorMessage.value = null;
    try {
      final message = await _service.sendMessage(
        _token,
        ticket.id,
        text: text,
        attachments: attachments,
      );
      _appendMessage(message, requesterUnreadCount: 0);
    } catch (error) {
      if (error is SupportApiException &&
          error.statusCode == 400 &&
          error.message == 'This chat is closed') {
        currentTicket.value = ticket.copyWith(status: 'closed');
        _upsertTicket(currentTicket.value!);
      }
      threadErrorMessage.value = _errorText(error);
      debugPrint('Could not send support message: $error');
      rethrow;
    } finally {
      isSending.value = false;
    }
  }

  Future<void> closeTicket() async {
    final ticket = currentTicket.value;
    if (ticket == null || !ticket.isActive) return;
    threadErrorMessage.value = null;
    try {
      final updated = await _service.closeTicket(_token, ticket.id);
      final latestMessages = currentTicket.value?.id == ticket.id
          ? currentTicket.value!.messages
          : ticket.messages;
      currentTicket.value = updated.withMessages(latestMessages);
      _upsertTicket(currentTicket.value!);
    } catch (error) {
      if (error is SupportApiException &&
          error.statusCode == 400 &&
          error.message == 'This chat is closed') {
        final latest = currentTicket.value?.id == ticket.id
            ? currentTicket.value!
            : ticket;
        currentTicket.value = latest.copyWith(status: 'closed');
        _upsertTicket(currentTicket.value!);
      }
      threadErrorMessage.value = _errorText(error);
      debugPrint('Could not close support ticket: $error');
      rethrow;
    }
  }

  void _handleSocketEvent(Map<String, dynamic> eventData) {
    final event = eventData['event']?.toString();
    final payload = _asMap(eventData['payload']);
    if (event == 'support:error') {
      final message = payload['error']?.toString() ??
          'A support connection error occurred.';
      errorMessage.value = message;
      threadErrorMessage.value = message;
      return;
    }

    if (event == 'support:ticket-updated') {
      final rawTicket = _asMap(payload['ticket']);
      if (rawTicket.isEmpty) return;
      final ticket = SupportTicket.fromJson(rawTicket);
      if (ticket.requester.id != _user.accountId) return;
      final existing = _findTicket(ticket.id);
      final updated =
          existing == null ? ticket : ticket.withMessages(existing.messages);
      _upsertTicket(updated);
      if (currentTicket.value?.id == updated.id) {
        currentTicket.value = updated.copyWith(requesterUnreadCount: 0);
      }
      return;
    }

    if (event == 'support:message') {
      final rawMessage = _asMap(payload['message']);
      if (rawMessage.isEmpty) return;
      final message = SupportMessage.fromJson(rawMessage);
      final ticketId = payload['ticketId']?.toString();
      if (ticketId == null) return;
      final onScreen = currentTicket.value?.id == ticketId;
      if (onScreen) {
        _appendMessage(message, requesterUnreadCount: 0);
      } else {
        final existing = _findTicket(ticketId);
        if (existing != null) {
          _upsertTicket(existing.copyWith(
            requesterUnreadCount: _asInt(payload['requesterUnreadCount'], 0),
            lastMessageAt: message.createdAt,
            lastMessagePreview: message.text,
          ));
        }
      }
    }
  }

  void _handleConnectionChange(bool isConnected) {
    if (!isConnected) {
      if (_joinedTicketId != null) {
        _wasSocketDisconnectedWhileInThread = true;
      }
      return;
    }
    final ticketId = _joinedTicketId;
    if (ticketId == null) return;
    _socket.joinSupportTicket(ticketId);
    if (_wasSocketDisconnectedWhileInThread) {
      _wasSocketDisconnectedWhileInThread = false;
      _refreshThreadAfterReconnect(ticketId);
    }
  }

  Future<void> _refreshThreadAfterReconnect(String ticketId) async {
    try {
      final result = await _service.fetchThread(_token, ticketId);
      final current = currentTicket.value;
      if (current == null || current.id != ticketId) return;
      final messagesById = <String, SupportMessage>{
        for (final message in current.messages) message.id: message,
        for (final message in result.ticket.messages) message.id: message,
      };
      final messages = messagesById.values.toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      currentTicket.value = result.ticket.withMessages(messages);
      _upsertTicket(currentTicket.value!);
    } catch (error) {
      threadErrorMessage.value = _errorText(error);
      debugPrint('Could not refresh support thread after reconnect: $error');
    }
  }

  void _appendMessage(
    SupportMessage message, {
    required int requesterUnreadCount,
  }) {
    final ticket = currentTicket.value;
    if (ticket == null) return;
    final messages = [...ticket.messages];
    if (!messages.any((item) => item.id == message.id)) {
      messages.add(message);
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    final updated = ticket.copyWith(
      messages: messages,
      lastMessageAt: message.createdAt,
      lastMessagePreview: message.text,
      requesterUnreadCount: requesterUnreadCount,
    );
    currentTicket.value = updated;
    _upsertTicket(updated);
  }

  void _markTicketRead(String ticketId) {
    final index = tickets.indexWhere((ticket) => ticket.id == ticketId);
    if (index >= 0) {
      tickets[index] = tickets[index].copyWith(requesterUnreadCount: 0);
    }
  }

  void _upsertTicket(SupportTicket ticket) {
    final index = tickets.indexWhere((item) => item.id == ticket.id);
    if (index < 0) {
      tickets.insert(0, ticket);
    } else {
      tickets[index] = ticket;
    }
    tickets.sort((a, b) => (b.lastMessageAt ??
            b.createdAt ??
            DateTime.fromMillisecondsSinceEpoch(0))
        .compareTo(a.lastMessageAt ??
            a.createdAt ??
            DateTime.fromMillisecondsSinceEpoch(0)));
  }

  SupportTicket? _findTicket(String id) {
    for (final ticket in tickets) {
      if (ticket.id == id) return ticket;
    }
    return null;
  }

  static Map<String, dynamic> _asMap(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

  static int _asInt(dynamic value, int fallback) =>
      int.tryParse(value?.toString() ?? '') ?? fallback;

  String _errorText(Object error) {
    if (error is SupportApiException) {
      if (error.validationErrors.isNotEmpty) {
        return error.validationErrors.entries
            .map((entry) => '${entry.key}: ${entry.value}')
            .join('\n');
      }
      if (error.statusCode == 401) {
        _user.clearUser();
        Get.offAllNamed<void>(AppRoutes.signIn);
        return 'Your session has expired. Please sign in again.';
      }
      if (error.statusCode == 403 && error.message == 'Account is inactive') {
        return 'Support is unavailable because this account is inactive.';
      }
      return error.message;
    }
    if (error is FormatException) {
      return 'Support returned an unexpected response. Please try again.';
    }
    return 'Could not connect to support. Check your connection and try again.';
  }

  @override
  void onClose() {
    leaveThread();
    _socketSubscription?.cancel();
    _connectionSubscription?.cancel();
    _service.dispose();
    super.onClose();
  }
}
