class SupportRequester {
  const SupportRequester({
    required this.id,
    required this.type,
    required this.name,
    this.profileImage,
  });

  final String id;
  final String type;
  final String name;
  final String? profileImage;

  factory SupportRequester.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString();
    final type = json['type']?.toString();
    final name = json['name']?.toString();
    if (id == null || type == null || name == null) {
      throw const FormatException('Support requester details are incomplete.');
    }
    return SupportRequester(
      id: id,
      type: type,
      name: name,
      profileImage: json['profileImage']?.toString(),
    );
  }
}

class SupportAdmin {
  const SupportAdmin({
    required this.id,
    required this.name,
    this.profileImage,
  });

  final String id;
  final String name;
  final String? profileImage;

  factory SupportAdmin.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString();
    final name = json['name']?.toString();
    if (id == null || name == null) {
      throw const FormatException('Support admin details are incomplete.');
    }
    return SupportAdmin(
      id: id,
      name: name,
      profileImage: json['profileImage']?.toString(),
    );
  }
}

class SupportMessage {
  const SupportMessage({
    required this.id,
    required this.senderType,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.attachments,
    required this.createdAt,
  });

  final String id;
  final String senderType;
  final String? senderId;
  final String? senderName;
  final String text;
  final List<String> attachments;
  final DateTime createdAt;

  bool get isSystem => senderType == 'system';

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString();
    final senderType = json['senderType']?.toString();
    final createdAt = DateTime.tryParse(json['createdAt']?.toString() ?? '');
    if (id == null || senderType == null || createdAt == null) {
      throw const FormatException('Support message details are incomplete.');
    }
    final rawAttachments = json['attachments'];
    if (rawAttachments != null && rawAttachments is! List) {
      throw const FormatException('Support message attachments are invalid.');
    }
    return SupportMessage(
      id: id,
      senderType: senderType,
      senderId: json['senderId']?.toString(),
      senderName: json['senderName']?.toString(),
      text: json['text']?.toString() ?? '',
      attachments: rawAttachments is List
          ? rawAttachments.map((value) => value.toString()).toList()
          : const [],
      createdAt: createdAt,
    );
  }
}

class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.subject,
    required this.status,
    required this.requester,
    required this.lastMessageAt,
    required this.lastMessagePreview,
    required this.requesterUnreadCount,
    required this.createdAt,
    this.claimedBy,
    this.adminUnreadCount = 0,
    this.claimedAt,
    this.closedAt,
    this.closedByType,
    this.messages = const [],
  });

  final String id;
  final String subject;
  final String status;
  final SupportRequester requester;
  final SupportAdmin? claimedBy;
  final DateTime? lastMessageAt;
  final String lastMessagePreview;
  final int requesterUnreadCount;
  final int adminUnreadCount;
  final DateTime? claimedAt;
  final DateTime? closedAt;
  final String? closedByType;
  final DateTime? createdAt;
  final List<SupportMessage> messages;

  bool get isActive => status == 'open' || status == 'claimed';

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString();
    final subject = json['subject']?.toString();
    final status = json['status']?.toString();
    final createdAt = DateTime.tryParse(json['createdAt']?.toString() ?? '');
    final requesterJson = json['requester'];
    final claimedByJson = json['claimedBy'];
    final rawMessages = json['messages'];
    if (id == null ||
        subject == null ||
        status == null ||
        createdAt == null ||
        requesterJson is! Map) {
      throw const FormatException('Support ticket details are incomplete.');
    }
    if (claimedByJson != null && claimedByJson is! Map) {
      throw const FormatException('Support admin details are invalid.');
    }
    if (rawMessages != null && rawMessages is! List) {
      throw const FormatException('Support ticket messages are invalid.');
    }
    return SupportTicket(
      id: id,
      subject: subject,
      status: status,
      requester: SupportRequester.fromJson(
        Map<String, dynamic>.from(requesterJson),
      ),
      claimedBy: claimedByJson is Map
          ? SupportAdmin.fromJson(Map<String, dynamic>.from(claimedByJson))
          : null,
      lastMessageAt: DateTime.tryParse(json['lastMessageAt']?.toString() ?? ''),
      lastMessagePreview: json['lastMessagePreview']?.toString() ?? '',
      requesterUnreadCount:
          int.tryParse(json['requesterUnreadCount']?.toString() ?? '') ?? 0,
      adminUnreadCount:
          int.tryParse(json['adminUnreadCount']?.toString() ?? '') ?? 0,
      claimedAt: DateTime.tryParse(json['claimedAt']?.toString() ?? ''),
      closedAt: DateTime.tryParse(json['closedAt']?.toString() ?? ''),
      closedByType: json['closedByType']?.toString(),
      createdAt: createdAt,
      messages: rawMessages is List
          ? rawMessages.map((message) {
              if (message is! Map) {
                throw const FormatException(
                  'Support ticket contains an invalid message.',
                );
              }
              return SupportMessage.fromJson(
                Map<String, dynamic>.from(message),
              );
            }).toList()
          : const [],
    );
  }

  SupportTicket withMessages(List<SupportMessage> value) {
    return SupportTicket(
      id: id,
      subject: subject,
      status: status,
      requester: requester,
      claimedBy: claimedBy,
      lastMessageAt: lastMessageAt,
      lastMessagePreview: lastMessagePreview,
      requesterUnreadCount: requesterUnreadCount,
      adminUnreadCount: adminUnreadCount,
      claimedAt: claimedAt,
      closedAt: closedAt,
      closedByType: closedByType,
      createdAt: createdAt,
      messages: value,
    );
  }

  SupportTicket copyWith({
    String? status,
    SupportAdmin? claimedBy,
    bool clearClaimedBy = false,
    DateTime? lastMessageAt,
    String? lastMessagePreview,
    int? requesterUnreadCount,
    DateTime? closedAt,
    List<SupportMessage>? messages,
  }) {
    return SupportTicket(
      id: id,
      subject: subject,
      status: status ?? this.status,
      requester: requester,
      claimedBy: clearClaimedBy ? null : claimedBy ?? this.claimedBy,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      requesterUnreadCount: requesterUnreadCount ?? this.requesterUnreadCount,
      adminUnreadCount: adminUnreadCount,
      claimedAt: claimedAt,
      closedAt: closedAt ?? this.closedAt,
      closedByType: closedByType,
      createdAt: createdAt,
      messages: messages ?? this.messages,
    );
  }
}

class SupportTicketPage {
  const SupportTicketPage({
    required this.tickets,
    required this.page,
    required this.totalPages,
  });

  final List<SupportTicket> tickets;
  final int page;
  final int totalPages;
}

class SupportThreadPage {
  const SupportThreadPage({
    required this.ticket,
    required this.page,
    required this.totalPages,
  });

  final SupportTicket ticket;
  final int page;
  final int totalPages;
}
