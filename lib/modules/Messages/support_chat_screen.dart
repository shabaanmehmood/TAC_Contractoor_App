import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';

import 'support_chat_controller.dart';
import 'support_chat_models.dart';
import 'support_chat_service.dart';

class SupportChatListScreen extends StatefulWidget {
  const SupportChatListScreen({super.key});

  @override
  State<SupportChatListScreen> createState() => _SupportChatListScreenState();
}

class _SupportChatListScreenState extends State<SupportChatListScreen> {
  late final SupportChatController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<SupportChatController>()
        ? Get.find<SupportChatController>()
        : Get.put(SupportChatController());
    controller.loadTickets(refresh: true);
  }

  Future<void> _startNewChat() async {
    final ticket = await Get.to<SupportTicket>(
      () => const SupportNewChatScreen(),
    );
    if (ticket == null || !mounted) return;
    await Get.to<void>(
      () => SupportChatThreadScreen(
        ticketId: ticket.id,
        initialTicket: ticket,
      ),
    );
    controller.loadTickets(refresh: true);
  }

  Future<void> _openTicket(SupportTicket ticket) async {
    await Get.to<void>(
      () => SupportChatThreadScreen(ticketId: ticket.id),
    );
    if (mounted) controller.loadTickets(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        title: const Text('Support chats'),
        backgroundColor: AppColors.kDarkestBlue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: Obx(() {
        final hasActiveTicket =
            controller.tickets.any((ticket) => ticket.isActive);
        if (hasActiveTicket) return const SizedBox.shrink();
        return FloatingActionButton.extended(
          onPressed: _startNewChat,
          backgroundColor: AppColors.kSkyBlue,
          foregroundColor: AppColors.kDarkestBlue,
          icon: const Icon(Icons.add),
          label: const Text('New chat'),
        );
      }),
      body: Obx(() {
        if (controller.isLoadingTickets.value && controller.tickets.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.kSkyBlue),
          );
        }
        if (controller.errorMessage.value != null &&
            controller.tickets.isEmpty) {
          return _ErrorPanel(
            message: controller.errorMessage.value!,
            onRetry: () => controller.loadTickets(refresh: true),
          );
        }
        if (controller.tickets.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => controller.loadTickets(refresh: true),
            child: ListView(
              children: const [
                SizedBox(height: 180),
                Icon(Icons.support_agent, color: Colors.white54, size: 58),
                SizedBox(height: 12),
                Center(
                  child: Text(
                    'No support chats yet',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
                SizedBox(height: 220),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.loadTickets(refresh: true),
          color: AppColors.kSkyBlue,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
            itemCount: controller.tickets.length +
                (controller.canLoadMoreTickets ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index == controller.tickets.length) {
                return TextButton(
                  onPressed: () => controller.loadTickets(),
                  child: const Text(
                    'Load more',
                    style: TextStyle(color: AppColors.kSkyBlue),
                  ),
                );
              }
              final ticket = controller.tickets[index];
              return _SupportTicketCard(
                ticket: ticket,
                onTap: () => _openTicket(ticket),
              );
            },
          ),
        );
      }),
    );
  }
}

class _SupportTicketCard extends StatelessWidget {
  const _SupportTicketCard({required this.ticket, required this.onTap});

  final SupportTicket ticket;
  final VoidCallback onTap;

  String get _statusText => switch (ticket.status) {
        'claimed' => '${ticket.claimedBy?.name ?? 'An admin'} is helping you',
        'closed' => 'Closed',
        _ => 'Waiting for an admin',
      };

  String _formatTime(DateTime timestamp) {
    final local = timestamp.toLocal();
    final now = DateTime.now();
    if (local.year == now.year &&
        local.month == now.month &&
        local.day == now.day) {
      return DateFormat('h:mm a').format(local);
    }
    return DateFormat('M/d/yy').format(local);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.kJobCardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.kDarkBlue,
                foregroundColor: AppColors.kSkyBlue,
                child: Icon(Icons.support_agent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.subject,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ticket.lastMessagePreview.isEmpty
                          ? _statusText
                          : ticket.lastMessagePreview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _statusText,
                      style: const TextStyle(
                        color: AppColors.kSkyBlue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (ticket.lastMessageAt != null)
                    Text(
                      _formatTime(ticket.lastMessageAt!),
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  if (ticket.requesterUnreadCount > 0) ...[
                    const SizedBox(height: 8),
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: AppColors.kSkyBlue,
                      child: Text(
                        ticket.requesterUnreadCount > 99
                            ? '99+'
                            : '${ticket.requesterUnreadCount}',
                        style: const TextStyle(
                          color: AppColors.kDarkestBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SupportNewChatScreen extends StatefulWidget {
  const SupportNewChatScreen({super.key});

  @override
  State<SupportNewChatScreen> createState() => _SupportNewChatScreenState();
}

class _SupportNewChatScreenState extends State<SupportNewChatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final List<_PendingSupportFile> _attachments = [];
  late final SupportChatController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<SupportChatController>();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _addAttachments() async {
    try {
      final files = await _pickSupportAttachments(_attachments.length);
      if (mounted) setState(() => _attachments.addAll(files));
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _controller.isCreating.value) {
      return;
    }
    try {
      final ticket = await _controller.createTicket(
        subject: _subjectController.text.trim(),
        text: _messageController.text.trim(),
        attachments: _attachments.map((file) => file.dataUri).toList(),
      );
      if (mounted && ticket != null) Get.back(result: ticket);
    } catch (error) {
      if (error is SupportApiException &&
          error.statusCode == 409 &&
          error.message == 'You already have an active support chat') {
        await _controller.loadTickets(refresh: true);
        final activeTicket = _controller.tickets.firstWhereOrNull(
          (ticket) => ticket.isActive,
        );
        if (mounted && activeTicket != null) {
          Get.back(result: activeTicket);
          return;
        }
      }
      if (mounted)
        _showMessage(_controller.errorMessage.value ?? error.toString());
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        title: const Text('New support chat'),
        backgroundColor: AppColors.kDarkestBlue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const Text(
              'Tell us what you need help with.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 18),
            _SupportTextField(
              controller: _subjectController,
              label: 'Subject',
              maxLength: 120,
              maxLines: 1,
              validator: (value) {
                final length = value?.trim().length ?? 0;
                if (length == 0) return 'Subject is required';
                if (length > 120) return 'Maximum 120 characters';
                return null;
              },
            ),
            const SizedBox(height: 14),
            _SupportTextField(
              controller: _messageController,
              label: 'Message',
              maxLength: 2000,
              maxLines: 6,
              validator: (value) {
                final length = value?.trim().length ?? 0;
                if (length == 0) return 'Message is required';
                if (length > 2000) return 'Maximum 2000 characters';
                return null;
              },
            ),
            const SizedBox(height: 8),
            _AttachmentPicker(
              attachments: _attachments,
              onAdd: _addAttachments,
              onRemove: (index) => setState(() => _attachments.removeAt(index)),
            ),
            const SizedBox(height: 24),
            Obx(
              () => FilledButton(
                onPressed: _controller.isCreating.value ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                  foregroundColor: AppColors.kDarkestBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _controller.isCreating.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Start chat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupportChatThreadScreen extends StatefulWidget {
  const SupportChatThreadScreen({
    required this.ticketId,
    this.initialTicket,
    super.key,
  });

  final String ticketId;
  final SupportTicket? initialTicket;

  @override
  State<SupportChatThreadScreen> createState() =>
      _SupportChatThreadScreenState();
}

class _SupportChatThreadScreenState extends State<SupportChatThreadScreen> {
  final _messageController = TextEditingController();
  final List<_PendingSupportFile> _attachments = [];
  late final SupportChatController _controller;
  late final UserController _userController;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<SupportChatController>()
        ? Get.find<SupportChatController>()
        : Get.put(SupportChatController());
    _userController = Get.find<UserController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.openThread(
        widget.ticketId,
        createdTicket: widget.initialTicket,
      );
    });
  }

  @override
  void dispose() {
    _controller.leaveThread();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _addAttachments() async {
    try {
      final files = await _pickSupportAttachments(_attachments.length);
      if (mounted) setState(() => _attachments.addAll(files));
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (_controller.isSending.value) return;
    if (text.isEmpty) {
      _showMessage('Enter a message before sending.');
      return;
    }
    try {
      await _controller.sendMessage(
        text: text,
        attachments: _attachments.map((file) => file.dataUri).toList(),
      );
      _messageController.clear();
      setState(_attachments.clear);
    } catch (error) {
      _showMessage(_controller.threadErrorMessage.value ?? error.toString());
    }
  }

  Future<void> _closeTicket() async {
    final shouldClose = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close this chat?'),
        content: const Text('You will not be able to send more messages.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Close chat'),
          ),
        ],
      ),
    );
    if (shouldClose != true) return;
    try {
      await _controller.closeTicket();
    } catch (error) {
      _showMessage(_controller.threadErrorMessage.value ?? error.toString());
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        title: Obx(() => Text(
              _controller.currentTicket.value?.subject ?? 'Support chat',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
        backgroundColor: AppColors.kDarkestBlue,
        foregroundColor: Colors.white,
        actions: [
          Obx(() {
            final ticket = _controller.currentTicket.value;
            if (ticket == null || !ticket.isActive) {
              return const SizedBox.shrink();
            }
            return IconButton(
              tooltip: 'Close chat',
              onPressed: _closeTicket,
              icon: const Icon(Icons.check_circle_outline),
            );
          }),
        ],
      ),
      body: Obx(() {
        final ticket = _controller.currentTicket.value;
        if (_controller.isLoadingThread.value && ticket == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.kSkyBlue),
          );
        }
        if (ticket == null) {
          return _ErrorPanel(
            message: _controller.threadErrorMessage.value ??
                'Support chat could not be opened.',
            onRetry: () => _controller.openThread(widget.ticketId),
          );
        }
        final statusText = switch (ticket.status) {
          'claimed' =>
            '${ticket.claimedBy?.name ?? 'An admin'} is helping you.',
          'closed' => 'This chat is closed.',
          _ => 'Waiting for an admin. You can keep writing.',
        };
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.kJobCardColor,
              child: Text(
                statusText,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            if (_controller.canLoadOlderMessages)
              TextButton(
                onPressed: _controller.isLoadingOlder.value
                    ? null
                    : _controller.loadOlderMessages,
                child: Text(
                  _controller.isLoadingOlder.value
                      ? 'Loading...'
                      : 'Load older messages',
                  style: const TextStyle(color: AppColors.kSkyBlue),
                ),
              ),
            if (_controller.threadErrorMessage.value != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _controller.threadErrorMessage.value!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(14),
                itemCount: ticket.messages.length,
                itemBuilder: (context, index) {
                  final message =
                      ticket.messages[ticket.messages.length - index - 1];
                  return _SupportMessageBubble(
                    message: message,
                    isMine: message.senderId == _userController.accountId,
                  );
                },
              ),
            ),
            if (ticket.isActive)
              SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_attachments.isNotEmpty)
                      _AttachmentPicker(
                        attachments: _attachments,
                        onAdd: _addAttachments,
                        onRemove: (index) =>
                            setState(() => _attachments.removeAt(index)),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: _attachments.length >= 4
                                ? null
                                : _addAttachments,
                            icon: const Icon(
                              Icons.attach_file,
                              color: AppColors.kSkyBlue,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              minLines: 1,
                              maxLines: 4,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: AppColors.kJobCardColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Obx(
                            () => IconButton(
                              onPressed:
                                  _controller.isSending.value ? null : _send,
                              icon: _controller.isSending.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.kSkyBlue,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.send,
                                      color: AppColors.kSkyBlue,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (!ticket.isActive)
              const Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'This chat is closed',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _SupportMessageBubble extends StatelessWidget {
  const _SupportMessageBubble({required this.message, required this.isMine});

  final SupportMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    if (message.isSystem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Text(
            message.text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ),
      );
    }
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width * 0.78),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMine ? AppColors.kChat : AppColors.kJobCardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMine && message.senderName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.senderName!,
                  style: const TextStyle(
                    color: AppColors.kSkyBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (message.text.isNotEmpty)
              Text(message.text, style: const TextStyle(color: Colors.white)),
            for (final attachment in message.attachments)
              _MessageAttachment(path: attachment),
            const SizedBox(height: 4),
            Text(
              DateFormat('h:mm a').format(message.createdAt.toLocal()),
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageAttachment extends StatelessWidget {
  const _MessageAttachment({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    final url = SupportChatService.resolveUploadUrl(path);
    final isImage =
        RegExp(r'\.(png|jpe?g|gif|webp)(\?.*)?$', caseSensitive: false)
            .hasMatch(path);
    if (isImage) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: CachedNetworkImage(
          imageUrl: url,
          width: 200,
          height: 150,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _fileLabel(path),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: _fileLabel(path),
    );
  }

  Widget _fileLabel(String value) {
    final name = value.split('/').last;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.attach_file, color: AppColors.kSkyBlue, size: 18),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            name,
            style: const TextStyle(color: Colors.white70),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _SupportTextField extends StatelessWidget {
  const _SupportTextField({
    required this.controller,
    required this.label,
    required this.maxLength,
    required this.maxLines,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final int maxLength;
  final int maxLines;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        counterStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: AppColors.kJobCardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
        ),
      ),
    );
  }
}

class _AttachmentPicker extends StatelessWidget {
  const _AttachmentPicker({
    required this.attachments,
    required this.onAdd,
    required this.onRemove,
  });

  final List<_PendingSupportFile> attachments;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (var index = 0; index < attachments.length; index++)
          InputChip(
            label: Text(
              attachments[index].name,
              overflow: TextOverflow.ellipsis,
            ),
            onDeleted: () => onRemove(index),
          ),
        if (attachments.isNotEmpty && attachments.length < 4)
          ActionChip(
            label: const Text('Add file'),
            onPressed: onAdd,
          ),
      ],
    );
  }
}

class _PendingSupportFile {
  const _PendingSupportFile(this.name, this.dataUri);

  final String name;
  final String dataUri;
}

Future<List<_PendingSupportFile>> _pickSupportAttachments(int count) async {
  final remaining = 4 - count;
  if (remaining <= 0) return const [];
  final selection = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    withData: true,
    type: FileType.any,
  );
  if (selection == null) return const [];
  final files = <_PendingSupportFile>[];
  for (final file in selection.files.take(remaining)) {
    final bytes = file.bytes;
    if (bytes == null) {
      throw Exception('Could not read ${file.name}. Please select it again.');
    }
    final mime = lookupMimeType(file.name) ?? 'application/octet-stream';
    final prefix = 'data:$mime;base64,';
    final encodedLength = ((bytes.length + 2) ~/ 3) * 4;
    if (prefix.length + encodedLength > 15000000) {
      throw Exception('${file.name} exceeds the 15 MB upload limit.');
    }
    files.add(_PendingSupportFile(file.name, '$prefix${base64Encode(bytes)}'));
  }
  return files;
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
