import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taccontractor/dataproviders/api_service.dart';

import 'support_chat_models.dart';

class SupportApiException implements Exception {
  const SupportApiException({
    required this.statusCode,
    required this.message,
    this.validationErrors = const {},
  });

  final int statusCode;
  final String message;
  final Map<String, String> validationErrors;

  @override
  String toString() => message;
}

class SupportChatService {
  SupportChatService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final String _baseUrl = '${MyApIService().baseurl}support';

  Future<SupportTicketPage> fetchTickets(
    String token, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _send(
      token,
      'GET',
      '/tickets',
      query: {'page': '$page', 'limit': '$limit'},
    );
    final rawTickets = response['data'];
    if (rawTickets is! List) {
      throw const FormatException('Support ticket list is missing.');
    }
    final tickets = rawTickets.map((item) {
      if (item is! Map) {
        throw const FormatException(
            'Support ticket list contains invalid data.');
      }
      return SupportTicket.fromJson(Map<String, dynamic>.from(item));
    }).toList();
    final pagination = _map(_map(response['meta'])['pagination']);
    return SupportTicketPage(
      tickets: tickets,
      page: _int(pagination['page'], page),
      totalPages: _int(pagination['totalPages'], 1),
    );
  }

  Future<SupportTicket> createTicket(
    String token, {
    required String subject,
    required String text,
    required List<String> attachments,
  }) async {
    final response = await _send(
      token,
      'POST',
      '/tickets',
      body: {
        'subject': subject,
        'text': text,
        'attachments': attachments,
      },
    );
    return SupportTicket.fromJson(_requiredMap(response['data']));
  }

  Future<SupportThreadPage> fetchThread(
    String token,
    String ticketId, {
    int? page,
    int limit = 50,
  }) async {
    final response = await _send(
      token,
      'GET',
      '/tickets/${Uri.encodeComponent(ticketId)}',
      query: {
        if (page != null) 'page': '$page',
        'limit': '$limit',
      },
    );
    final pagination = _map(_map(response['meta'])['pagination']);
    return SupportThreadPage(
      ticket: SupportTicket.fromJson(_requiredMap(response['data'])),
      page: _int(pagination['page'], page ?? 1),
      totalPages: _int(pagination['totalPages'], 1),
    );
  }

  Future<SupportMessage> sendMessage(
    String token,
    String ticketId, {
    required String text,
    required List<String> attachments,
  }) async {
    final response = await _send(
      token,
      'POST',
      '/tickets/${Uri.encodeComponent(ticketId)}/messages',
      body: {'text': text, 'attachments': attachments},
    );
    return SupportMessage.fromJson(
      _requiredMap(_requiredMap(response['data'])['message']),
    );
  }

  Future<SupportTicket> closeTicket(String token, String ticketId) async {
    final response = await _send(
      token,
      'POST',
      '/tickets/${Uri.encodeComponent(ticketId)}/close',
    );
    return SupportTicket.fromJson(_requiredMap(response['data']));
  }

  Future<Map<String, dynamic>> _send(
    String token,
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: query);
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };
    late final http.Response response;
    switch (method) {
      case 'GET':
        response = await _client.get(uri, headers: headers);
      case 'POST':
        response = await _client.post(
          uri,
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        );
      default:
        throw ArgumentError.value(method, 'method', 'Unsupported HTTP method');
    }

    final decoded =
        response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
    final payload = decoded is Map
        ? Map<String, dynamic>.from(decoded)
        : <String, dynamic>{};
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final errors = <String, String>{};
      final data = payload['data'];
      if (data is List) {
        for (final item in data.whereType<Map>()) {
          final field = item['field']?.toString();
          final message = item['message']?.toString();
          if (field != null && message != null) errors[field] = message;
        }
      }
      throw SupportApiException(
        statusCode: response.statusCode,
        message: payload['message']?.toString() ?? 'Support request failed',
        validationErrors: errors,
      );
    }
    return payload;
  }

  static Map<String, dynamic> _map(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

  static Map<String, dynamic> _requiredMap(dynamic value) {
    if (value is! Map) {
      throw const FormatException('Support response is missing required data.');
    }
    return Map<String, dynamic>.from(value);
  }

  static int _int(dynamic value, int fallback) =>
      int.tryParse(value?.toString() ?? '') ?? fallback;

  static String resolveUploadUrl(String path) {
    if (path.startsWith('http')) return path;
    final origin = Uri.parse(MyApIService().baseurl).origin;
    return '$origin/uploads/${path.startsWith('/') ? path.substring(1) : path}';
  }

  void dispose() => _client.close();
}
