import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:taccontractor/modules/Messages/support_chat_models.dart';
import 'package:taccontractor/modules/Messages/support_chat_service.dart';

void main() {
  group('SupportChatService', () {
    test('fetches and parses the contractor ticket list with auth', () async {
      late http.Request request;
      final client = MockClient((incoming) async {
        request = incoming;
        return http.Response(
          jsonEncode({
            'data': [
              {
                'id': 'ticket-1',
                'subject': 'Shift issue',
                'status': 'claimed',
                'requester': {
                  'id': 'contractor-1',
                  'type': 'contractor',
                  'name': 'North Gate Security',
                  'profileImage': null,
                },
                'claimedBy': {
                  'id': 'admin-1',
                  'name': 'Sara Ali',
                  'profileImage': null,
                },
                'lastMessageAt': '2026-10-19T12:00:00.000Z',
                'lastMessagePreview': 'Please check the roster',
                'requesterUnreadCount': 2,
                'adminUnreadCount': 0,
                'claimedAt': '2026-10-19T11:00:00.000Z',
                'closedAt': null,
                'closedByType': null,
                'createdAt': '2026-10-19T10:00:00.000Z',
              },
            ],
            'meta': {
              'pagination': {
                'total': 1,
                'page': 1,
                'limit': 20,
                'totalPages': 1,
              },
            },
          }),
          200,
        );
      });
      final service = SupportChatService(client: client);
      addTearDown(service.dispose);

      final result = await service.fetchTickets('test-jwt');

      expect(request.method, 'GET');
      expect(request.url.path, '/api/v1/support/tickets');
      expect(request.url.queryParameters, {'page': '1', 'limit': '20'});
      expect(request.headers['authorization'], 'Bearer test-jwt');
      expect(result.page, 1);
      expect(result.totalPages, 1);
      expect(result.tickets.single.claimedBy?.name, 'Sara Ali');
      expect(result.tickets.single.requesterUnreadCount, 2);
    });

    test('surfaces field validation errors from the API', () async {
      final client = MockClient((_) async {
        return http.Response(
          jsonEncode({
            'message': 'Validation failed',
            'status': 400,
            'data': [
              {'field': 'subject', 'message': 'Subject is required'},
            ],
          }),
          400,
        );
      });
      final service = SupportChatService(client: client);
      addTearDown(service.dispose);

      await expectLater(
        service.createTicket(
          'test-jwt',
          subject: '',
          text: 'Help',
          attachments: const [],
        ),
        throwsA(
          isA<SupportApiException>()
              .having((error) => error.statusCode, 'statusCode', 400)
              .having(
                (error) => error.validationErrors['subject'],
                'subject validation message',
                'Subject is required',
              ),
        ),
      );
    });

    test('rejects malformed successful ticket payloads', () {
      expect(
        () => SupportTicket.fromJson(const {}),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
