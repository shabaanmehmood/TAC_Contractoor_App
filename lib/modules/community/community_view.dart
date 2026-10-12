import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/models/job_model.dart';
import 'package:taccontractor/models/myJobs_model.dart';
import 'package:taccontractor/models/userdata_model.dart';
import 'package:taccontractor/modules/Guards/job_details/job_details_screen.dart';
import 'package:taccontractor/modules/Messages/socket_file.dart';
import 'package:taccontractor/routes/app_routes.dart';

import 'community_service.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  final ScrollController _scrollController = ScrollController();
  late final Data? _user;
  late final UserController _userController;
  CommunityService? _service;
  List<Map<String, dynamic>> _topics = [];
  List<Map<String, dynamic>> _posts = [];
  final Set<String> _followedAccounts = {};
  final Set<String> _reportedTargets = {};
  final Set<String> _locallyCreatedPostIds = {};
  StreamSubscription<Map<String, dynamic>>? _socketSubscription;
  String _filter = 'everyone';
  String? _topicId;
  String? _nextCursor;
  String? _error;
  int _feedGeneration = 0;
  bool _loading = true;
  bool _loadingMore = false;
  bool _inactive = false;
  bool _postingBlockedByServer = false;

  String? get _accountType => _userController.accountType;

  bool get _canPost =>
      !_postingBlockedByServer &&
      _user?.isActive != false &&
      (_user?.isVerified == true || _accountType == 'admin');

  @override
  void initState() {
    super.initState();
    _userController = Get.find<UserController>();
    _user = _userController.userData.value;
    final token = _userController.accessToken;
    final accountId = _userController.accountId;
    final accountType = _userController.accountType;
    if (_tokenIsUsable(token)) {
      _service = CommunityService(
        token: token!,
        accountId: accountId ?? '',
        accountType: accountType ?? 'unknown',
      );
    }
    SocketService().initialize();
    _socketSubscription =
        SocketService().communityEvents.listen(_onCommunityEvent);
    _scrollController.addListener(_onScroll);
    _loadInitial();
  }

  bool _tokenIsUsable(String? token) => token != null && token.isNotEmpty;

  @override
  void dispose() {
    _scrollController.dispose();
    _socketSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    if (_user?.isActive == false) {
      setState(() {
        _inactive = true;
        _loading = false;
      });
      return;
    }
    if (_service == null) {
      setState(() {
        _error = 'Your session has expired. Please sign in again.';
        _loading = false;
      });
      return;
    }
    try {
      _topics = await _service!.fetchTopics();
      await _loadFollowing();
      await _loadFeed(reset: true);
    } on CommunityApiException catch (exception) {
      _handleApiError(exception);
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Could not load the community. Check your connection.';
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadFeed({bool reset = false}) async {
    if (_service == null || (!reset && _loadingMore)) return;
    if (!reset && _nextCursor == null) return;
    final generation = ++_feedGeneration;
    final filter = _filter;
    final topicId = _topicId;
    final cursor = reset ? null : _nextCursor;
    setState(() {
      if (reset) {
        _loading = true;
        _loadingMore = false;
        _error = null;
      } else {
        _loadingMore = true;
      }
    });
    try {
      final page = await _service!.fetchFeed(
        filter: filter,
        topicId: topicId,
        cursor: cursor,
      );
      if (!mounted || generation != _feedGeneration) return;
      setState(() {
        if (reset)
          _posts = page.posts;
        else
          _posts.addAll(page.posts);
        _nextCursor = page.nextCursor;
        _loading = false;
        _loadingMore = false;
      });
    } on CommunityApiException catch (exception) {
      if (mounted && generation == _feedGeneration) {
        setState(() {
          _loading = false;
          _loadingMore = false;
        });
      }
      _handleApiError(exception);
    } catch (_) {
      if (mounted && generation == _feedGeneration) {
        setState(() {
          _error = 'Could not load posts. Check your connection.';
          _loading = false;
          _loadingMore = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 360 &&
        !_loading &&
        !_loadingMore &&
        _nextCursor != null) {
      _loadFeed();
    }
  }

  void _onCommunityEvent(Map<String, dynamic> event) {
    if (!mounted) return;
    final name = event['event'] as String?;
    final payload = _mapValue(event['payload']);
    if (name == null || payload == null) return;
    setState(() {
      if (name == 'community:post-created') {
        final id = payload['id'] as String?;
        if (id == null || _locallyCreatedPostIds.remove(id)) return;
        if (_posts.any((post) => post['id'] == id)) return;
        final topic = _mapValue(payload['topic']);
        final author = _mapValue(payload['author']);
        if (_topicId != null && topic?['id'] != _topicId) return;
        if (_filter == 'following') {
          final key = _accountKey(
            author?['type'] as String? ?? '',
            author?['id'] as String? ?? '',
          );
          if (!_followedAccounts.contains(key)) return;
        }
        _posts.insert(0, payload);
      } else if (name == 'community:reaction-updated' &&
          payload['targetType'] == 'post') {
        final id = payload['targetId'];
        final post = _posts.firstWhereOrNull((item) => item['id'] == id);
        final counts = _mapValue(payload['counts']);
        if (post != null && counts != null) {
          final postCounts = _mapValue(post['counts']) ?? <String, dynamic>{};
          postCounts['reactions'] = counts['reactions'];
          post['counts'] = postCounts;
        }
      } else if (name == 'community:moderation' &&
          payload['targetType'] == 'post') {
        final status = payload['status'];
        if (status == 'hidden' || status == 'removed') {
          _posts.removeWhere((post) => post['id'] == payload['targetId']);
        }
      }
    });
  }

  void _handleApiError(CommunityApiException exception) {
    if (!mounted) return;
    if (exception.statusCode == 401) {
      Get.offAllNamed(AppRoutes.signIn);
      return;
    }
    setState(() {
      _loading = false;
      _loadingMore = false;
      if (exception.statusCode == 403 &&
          exception.message == 'Account is inactive') {
        _inactive = true;
      } else if (exception.statusCode == 403 &&
          exception.message == 'Only verified accounts can post') {
        _postingBlockedByServer = true;
      }
      _error = exception.message;
    });
  }

  Future<void> _changeFeed({
    String? filter,
    String? topicId,
    bool updateTopic = false,
  }) async {
    setState(() {
      if (filter != null) _filter = filter;
      if (updateTopic) _topicId = topicId;
      _nextCursor = null;
      _posts = [];
    });
    await _loadFeed(reset: true);
  }

  Future<void> _createPost() async {
    if (!_canPost || _service == null) return;
    final createdPost = await Get.to<Map<String, dynamic>>(
      () => CreatePostView(
        service: _service!,
        topics: _topics,
        onPostingDenied: () {
          if (mounted) setState(() => _postingBlockedByServer = true);
        },
        onInactive: () {
          if (mounted) setState(() => _inactive = true);
        },
      ),
    );
    if (createdPost != null && mounted) {
      setState(() {
        if (createdPost['id'] is String) {
          _locallyCreatedPostIds.add(createdPost['id'] as String);
        }
        _posts.removeWhere((post) => post['id'] == createdPost['id']);
        _posts.insert(0, createdPost);
      });
    }
  }

  void _showPostingEligibility() {
    Get.snackbar('Verification required', 'Only verified accounts can post.');
  }

  String _accountKey(String type, String id) => '$type:$id';

  bool _isAuthor(Map<String, dynamic>? author) =>
      author?['id'] == _userController.accountId &&
      author?['type'] == _userController.accountType;

  bool _canEdit(Map<String, dynamic> post) {
    final createdAt = DateTime.tryParse(post['createdAt'] as String? ?? '');
    if (createdAt == null || !_isAuthor(_mapValue(post['author'])))
      return false;
    final age = DateTime.now().toUtc().difference(createdAt.toUtc());
    return !age.isNegative && age <= const Duration(minutes: 15);
  }

  Future<void> _loadFollowing() async {
    if (_service == null) return;
    try {
      final followed = await _service!.fetchFollowing();
      if (!mounted) return;
      setState(() {
        _followedAccounts
          ..clear()
          ..addAll(followed.map((entry) {
            final author = _mapValue(entry['author']);
            if (author == null) return '';
            return _accountKey(
              author['type'] as String? ?? '',
              author['id'] as String? ?? '',
            );
          }).where((key) => key != ':'));
      });
    } catch (_) {}
  }

  Future<void> _toggleFollow(Map<String, dynamic> author) async {
    final type = author['type'] as String?;
    final id = author['id'] as String?;
    if (_service == null || id == null || type == null) return;
    if (type != 'guard' && type != 'contractor') return;
    final key = _accountKey(type, id);
    final follow = !_followedAccounts.contains(key);
    try {
      await _service!.follow(
        followingType: type,
        followingId: id,
        follow: follow,
      );
      if (!mounted) return;
      setState(() {
        if (follow)
          _followedAccounts.add(key);
        else
          _followedAccounts.remove(key);
      });
      final followingPage = await _service!.fetchFeed(filter: 'following');
      if (mounted && _filter == 'following' && _topicId == null) {
        setState(() {
          _posts = followingPage.posts;
          _nextCursor = followingPage.nextCursor;
        });
      }
      if (mounted) {
        Get.snackbar(follow ? 'Following' : 'Unfollowed',
            '${author['name'] ?? 'Account'}');
      }
    } on CommunityApiException catch (exception) {
      _handleApiError(exception);
    }
  }

  Future<void> _reactToPost(
      Map<String, dynamic> post, String reactionType) async {
    final id = post['id'] as String?;
    if (_service == null || id == null) return;
    try {
      final result = await _service!.react(
        targetType: 'post',
        targetId: id,
        type: reactionType,
      );
      if (!mounted) return;
      setState(() {
        final target = _posts.firstWhereOrNull((item) => item['id'] == id);
        if (target != null) _applyReaction(target, result);
      });
    } on CommunityApiException catch (exception) {
      _handleApiError(exception);
    }
  }

  void _applyReaction(
      Map<String, dynamic> target, Map<String, dynamic> result) {
    target['myReaction'] = result['myReaction'];
    final counts = _mapValue(target['counts']) ?? <String, dynamic>{};
    final responseCounts = _mapValue(result['counts']);
    if (responseCounts != null && responseCounts.containsKey('reactions')) {
      counts['reactions'] = responseCounts['reactions'];
    }
    target['counts'] = counts;
  }

  Future<void> _editPost(Map<String, dynamic> post) async {
    if (_service == null || !_canEdit(post)) return;
    final textController = TextEditingController(text: post['text'] as String?);
    final topic = _mapValue(post['topic']);
    String? selectedTopicId = topic?['id'] as String?;
    final updated = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                maxLength: 2000,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Post text'),
              ),
              DropdownButtonFormField<String?>(
                value: selectedTopicId,
                decoration: const InputDecoration(labelText: 'Topic'),
                items: [
                  const DropdownMenuItem<String?>(
                      value: null, child: Text('No topic')),
                  ..._topics.map((item) => DropdownMenuItem<String?>(
                        value: item['id'] as String?,
                        child: Text(item['name'] as String? ?? 'Topic'),
                      )),
                ],
                onChanged: (value) =>
                    setDialogState(() => selectedTopicId = value),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, {
                'text': textController.text.trim(),
                'topicId': selectedTopicId,
              }),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    textController.dispose();
    if (updated == null || updated['text'] == '') return;
    try {
      final response = await _service!.editPost(
        post['id'] as String,
        text: updated['text'] as String,
        topicId: updated['topicId'] as String?,
      );
      if (!mounted) return;
      setState(() {
        post['text'] = response['text'] ?? updated['text'];
        post['topic'] = response.containsKey('topic')
            ? response['topic']
            : _topics
                .cast<Map<String, dynamic>?>()
                .firstWhereOrNull((item) => item?['id'] == updated['topicId']);
        post['editedAt'] =
            response['editedAt'] ?? DateTime.now().toUtc().toIso8601String();
      });
    } on CommunityApiException catch (exception) {
      _handleApiError(exception);
    }
  }

  Future<void> _deletePost(Map<String, dynamic> post) async {
    if (_service == null || !_isAuthor(_mapValue(post['author']))) return;
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete post?'),
        content: const Text('This post will be removed from the feed.'),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _service!.deletePost(post['id'] as String);
      if (mounted)
        setState(() => _posts.removeWhere((item) => item['id'] == post['id']));
    } on CommunityApiException catch (exception) {
      _handleApiError(exception);
    }
  }

  Future<void> _reportTarget(String targetType, String targetId) async {
    if (_service == null || _reportedTargets.contains('$targetType:$targetId'))
      return;
    final reason = await Get.bottomSheet<String>(
      SafeArea(
        child: Container(
          color: AppColors.kDarkestBlue,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['spam', 'harassment', 'unsafe', 'other']
                .map((value) => ListTile(
                      title: Text(value[0].toUpperCase() + value.substring(1),
                          style: const TextStyle(color: Colors.white)),
                      onTap: () => Get.back(result: value),
                    ))
                .toList(),
          ),
        ),
      ),
    );
    if (reason == null) return;
    try {
      final result = await _service!.report(
        targetType: targetType,
        targetId: targetId,
        reason: reason,
      );
      if (!mounted) return;
      setState(() {
        _reportedTargets.add('$targetType:$targetId');
        if (result['hidden'] == true && targetType == 'post') {
          _posts.removeWhere((post) => post['id'] == targetId);
        }
      });
    } on CommunityApiException catch (exception) {
      if (exception.statusCode == 409) {
        setState(() => _reportedTargets.add('$targetType:$targetId'));
        Get.snackbar('Already reported', exception.message);
      } else {
        _handleApiError(exception);
      }
    }
  }

  Future<void> _openJob(Map<String, dynamic> job) async {
    final id = job['id'] as String?;
    if (id == null) return;
    Get.to<void>(() => JobDetailsScreen(
          jobData: JobData(
            id: id,
            title: job['title'] as String? ?? 'Job',
            description: '',
            responsibilities: '',
            location: job['location'] as String? ?? '',
            latitude: '',
            longitude: '',
            noOfGuardsRequired: 0,
            leaderRequired: 0,
            payPerHour: job['payPerHour']?.toString() ?? '',
            jobSOPs: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            contractorId: '',
            contractorName: '',
            categoryName: '',
            premisesTypeName: '',
            shifts: const [],
          ),
          bottomAction: const SizedBox.shrink(),
        ));
  }

  void _openThread(Map<String, dynamic> post) {
    final id = post['id'] as String?;
    if (id == null || _service == null) return;
    Get.to<void>(() => CommunityThreadView(
          service: _service!,
          postId: id,
          canComment: _canPost,
          onVerifiedPostDenied: () {
            if (mounted) setState(() => _postingBlockedByServer = true);
          },
          onHiddenPost: () {
            if (mounted)
              setState(() => _posts.removeWhere((item) => item['id'] == id));
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    final blocked = _inactive || _user == null || _service == null;
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: AppColors.kDarkBlue,
              foregroundColor: Colors.white,
              title: const Text('Community'),
              leading: IconButton(
                tooltip: 'Show map',
                icon: const Icon(Icons.map_outlined),
                onPressed: Get.back,
              ),
              actions: [
                IconButton(
                  tooltip: 'Refresh feed',
                  icon: const Icon(Icons.refresh),
                  onPressed: blocked ? null : () => _loadFeed(reset: true),
                ),
              ],
            )
          : null,
      body: blocked
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _inactive
                      ? 'Your account is inactive.'
                      : _error ?? 'Please sign in again to open the community.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            )
          : Column(
              children: [
                _feedControls(),
                Expanded(child: _feedBody()),
              ],
            ),
        floatingActionButton: !blocked
          ? FloatingActionButton(
            tooltip: _canPost ? 'Create post' : 'Posting requires verification',
            backgroundColor:
              _postingBlockedByServer ? Colors.grey : AppColors.kPrimary,
              foregroundColor: Colors.white,
            onPressed: _postingBlockedByServer
              ? null
              : _canPost
                ? _createPost
                : _showPostingEligibility,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _feedControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'everyone', label: Text('Everyone')),
              ButtonSegment(value: 'following', label: Text('Following')),
            ],
            selected: {_filter},
            onSelectionChanged: (selection) =>
                _changeFeed(filter: selection.first),
          ),
        ),
        if (_topics.isNotEmpty)
          SizedBox(
            height: 48,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: [
                _topicChip(null, 'All topics'),
                ..._topics.map((topic) => _topicChip(
                      topic['id'] as String?,
                      topic['name'] as String? ?? 'Topic',
                    )),
              ],
            ),
          ),
      ],
    );
  }

  Widget _topicChip(String? id, String label) {
    final selected = _topicId == id;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => _changeFeed(topicId: id, updateTopic: true),
        selectedColor: AppColors.kPrimary,
        backgroundColor: AppColors.kDarkestBlue,
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.white70),
      ),
    );
  }

  Widget _feedBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null && _posts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70)),
        ),
      );
    }
    if (_posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _loadFeed(reset: true),
        child: ListView(
          controller: _scrollController,
          children: const [
            SizedBox(height: 120),
            Center(
              child: Text('No posts yet',
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => _loadFeed(reset: true),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
        itemCount: _posts.length + (_loadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _posts.length) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return _postCard(_posts[index]);
        },
      ),
    );
  }

  Widget _postCard(Map<String, dynamic> post) {
    final author = post['author'] is Map
        ? Map<String, dynamic>.from(post['author'] as Map)
        : const <String, dynamic>{};
    final topic = post['topic'] is Map
        ? Map<String, dynamic>.from(post['topic'] as Map)
        : null;
    final counts = post['counts'] is Map
        ? Map<String, dynamic>.from(post['counts'] as Map)
        : const <String, dynamic>{};
    final imagePaths = post['images'] is List
        ? (post['images'] as List).whereType<String>().toList()
        : <String>[];
    final canFollow = !_isAuthor(author) &&
        (author['type'] == 'guard' || author['type'] == 'contractor');
    final accountKey = _accountKey(
      author['type'] as String? ?? '',
      author['id'] as String? ?? '',
    );
    final ownPost = _isAuthor(author);
    final actions = <PopupMenuEntry<String>>[
      if (ownPost && _canEdit(post))
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
      if (ownPost) const PopupMenuItem(value: 'delete', child: Text('Delete')),
      if (!_reportedTargets.contains('post:${post['id']}'))
        const PopupMenuItem(value: 'report', child: Text('Report')),
    ];
    return InkWell(
      onTap: () => _openThread(post),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.kDarkestBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _avatar(author['profileImage'] as String?),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(author['name'] as String? ?? 'Community member',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      Text(
                        '${_accountLabel(author['type'] as String?)} · ${_dateLabel(post['createdAt'] as String?)}${post['editedAt'] == null ? '' : ' · Edited'}',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (topic != null)
                  Text(topic['name'] as String? ?? '',
                      style: const TextStyle(color: Colors.lightBlueAccent)),
                if (canFollow)
                  IconButton(
                    tooltip: _followedAccounts.contains(accountKey)
                        ? 'Unfollow author'
                        : 'Follow author',
                    onPressed: () => _toggleFollow(author),
                    icon: Icon(
                      _followedAccounts.contains(accountKey)
                          ? Icons.person_remove_outlined
                          : Icons.person_add_alt_1_outlined,
                      color: Colors.white70,
                    ),
                  ),
                PopupMenuButton<String>(
                  tooltip: 'Post actions',
                  onSelected: (action) {
                    if (action == 'edit') _editPost(post);
                    if (action == 'delete') _deletePost(post);
                    if (action == 'report') {
                      _reportTarget('post', post['id'] as String);
                    }
                  },
                  itemBuilder: (_) => actions,
                ),
              ],
            ),
            if ((post['text'] as String? ?? '').isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(post['text'] as String,
                  style: const TextStyle(color: Colors.white, height: 1.4)),
            ],
            if (post['job'] is Map) ...[
              const SizedBox(height: 10),
              _jobLink(Map<String, dynamic>.from(post['job'] as Map)),
            ],
            if (imagePaths.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 190,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagePaths.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _service!.imageUrl(imagePaths[index]),
                      width: 240,
                      height: 190,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 240,
                        color: Colors.white10,
                        child: const Icon(Icons.broken_image_outlined,
                            color: Colors.white54),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _openThread(post),
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: Text('${counts['comments'] ?? 0}'),
                ),
                PopupMenuButton<String>(
                  tooltip: 'React to post',
                  onSelected: (reaction) => _reactToPost(post, reaction),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'like', child: Text('Like')),
                    PopupMenuItem(value: 'useful', child: Text('Useful')),
                    PopupMenuItem(value: 'support', child: Text('Support')),
                  ],
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_reactionIcon(post['myReaction'] as String?),
                          size: 18, color: Colors.white70),
                      const SizedBox(width: 6),
                      Text('${counts['reactions'] ?? 0}',
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobLink(Map<String, dynamic> job) => InkWell(
        onTap: () => _openJob(job),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.kDarkBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.work_outline, color: Colors.lightBlueAccent),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job['title'] as String? ?? 'Open job',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                    Text(
                      '${job['location'] ?? ''} · \$${job['payPerHour'] ?? ''}/hr',
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      );

  IconData _reactionIcon(String? reaction) => switch (reaction) {
        'like' => Icons.thumb_up,
        'useful' => Icons.lightbulb,
        'support' => Icons.volunteer_activism,
        _ => Icons.favorite_border,
      };

  Widget _avatar(String? path) {
    final image =
        path == null || path.isEmpty ? null : _service!.imageUrl(path);
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white12,
      backgroundImage: image == null ? null : NetworkImage(image),
      child: image == null
          ? const Icon(Icons.person_outline, color: Colors.white70)
          : null,
    );
  }

  String _accountLabel(String? type) {
    if (type == null || type.isEmpty) return 'Member';
    return '${type[0].toUpperCase()}${type.substring(1)}';
  }

  String _dateLabel(String? value) {
    final date = DateTime.tryParse(value ?? '')?.toLocal();
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }
}

Map<String, dynamic>? _mapValue(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

class CreatePostView extends StatefulWidget {
  const CreatePostView({
    super.key,
    required this.service,
    required this.topics,
    required this.onPostingDenied,
    required this.onInactive,
  });

  final CommunityService service;
  final List<Map<String, dynamic>> topics;
  final VoidCallback onPostingDenied;
  final VoidCallback onInactive;

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _images = [];
  String? _topicId;
  String? _jobId;
  String? _error;
  bool _submitting = false;
  bool _loadingJobs = false;
  List<MyjobsModel> _openJobs = [];

  @override
  void initState() {
    super.initState();
    if (widget.service.accountType == 'contractor') _loadOpenJobs();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadOpenJobs() async {
    setState(() => _loadingJobs = true);
    try {
      final jobs = await widget.service.fetchOpenOwnedJobs();
      if (mounted) setState(() => _openJobs = jobs);
    } catch (_) {
      if (mounted) setState(() => _openJobs = []);
    } finally {
      if (mounted) setState(() => _loadingJobs = false);
    }
  }

  Future<void> _pickImages() async {
    final remaining = 4 - _images.length;
    if (remaining <= 0) return;
    final source = await Get.bottomSheet<ImageSource>(
      SafeArea(
        child: Container(
          color: AppColors.kDarkestBlue,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined,
                    color: Colors.white),
                title: const Text('Choose from gallery',
                    style: TextStyle(color: Colors.white)),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
              ListTile(
                leading:
                    const Icon(Icons.camera_alt_outlined, color: Colors.white),
                title: const Text('Take a photo',
                    style: TextStyle(color: Colors.white)),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null) return;
    final selected = source == ImageSource.gallery
        ? await _imagePicker.pickMultiImage(imageQuality: 85)
        : await _imagePicker
            .pickImage(source: ImageSource.camera, imageQuality: 85)
            .then((image) => image == null ? <XFile>[] : [image]);
    if (!mounted || selected.isEmpty) return;
    final accepted = <XFile>[];
    for (final image in selected) {
      final extension = image.name.split('.').last.toLowerCase();
      if (!{'jpg', 'jpeg', 'png', 'webp'}.contains(extension)) continue;
      if (accepted.length < remaining) accepted.add(image);
    }
    setState(() {
      _images.addAll(accepted);
      if (accepted.length < selected.length) {
        _error = 'Choose up to 4 JPEG, PNG, or WebP images.';
      } else {
        _error = null;
      }
    });
  }

  Future<void> _submit() async {
    final text = _textController.text.trim();
    if (text.isEmpty || text.length > 2000) {
      setState(
          () => _error = 'Post text must be between 1 and 2000 characters.');
      return;
    }
    if (_images.length > 4) {
      setState(() => _error = 'A post can include up to 4 images.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final dataUris = <String>[];
      for (final image in _images) {
        final extension = image.name.split('.').last.toLowerCase();
        final mimeType = switch (extension) {
          'jpg' || 'jpeg' => 'image/jpeg',
          'png' => 'image/png',
          'webp' => 'image/webp',
          _ => null,
        };
        if (mimeType == null) {
          throw const CommunityApiException(
              400, 'Each image must be a JPEG, PNG, or WebP.');
        }
        dataUris.add(
            'data:$mimeType;base64,${base64Encode(await image.readAsBytes())}');
      }
      final post = await widget.service.createPost(
        text: text,
        images: dataUris,
        topicId: _topicId,
        jobId: _jobId,
      );
      if (mounted) Get.back(result: post);
    } on CommunityApiException catch (exception) {
      if (!mounted) return;
      if (exception.statusCode == 401) {
        Get.offAllNamed(AppRoutes.signIn);
        return;
      }
      if (exception.statusCode == 403 &&
          exception.message == 'Account is inactive') {
        widget.onInactive();
        Get.back();
        return;
      }
      if (exception.statusCode == 403 &&
          exception.message == 'Only verified accounts can post') {
        widget.onPostingDenied();
        Get.back();
        return;
      }
      setState(() {
        _submitting = false;
        _error = exception.message;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _error = 'Could not create the post. Check your connection.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkBlue,
        foregroundColor: Colors.white,
        title: const Text('Create post'),
        actions: [
          TextButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Post'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _textController,
            autofocus: true,
            maxLength: 2000,
            maxLines: 7,
            minLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'What would you like to share?',
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: AppColors.kDarkestBlue,
              border: OutlineInputBorder(),
            ),
          ),
          if (widget.topics.isNotEmpty) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              value: _topicId,
              dropdownColor: AppColors.kDarkestBlue,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Topic',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String?>(
                    value: null, child: Text('No topic')),
                ...widget.topics.map((topic) => DropdownMenuItem<String?>(
                      value: topic['id'] as String?,
                      child: Text(topic['name'] as String? ?? 'Topic'),
                    )),
              ],
              onChanged: (value) => setState(() => _topicId = value),
            ),
          ],
          if (widget.service.accountType == 'contractor' &&
              (_loadingJobs || _openJobs.isNotEmpty)) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              value: _jobId,
              dropdownColor: AppColors.kDarkestBlue,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText:
                    _loadingJobs ? 'Loading open jobs' : 'Attach open job',
                labelStyle: const TextStyle(color: Colors.white70),
                border: const OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String?>(
                    value: null, child: Text('No job')),
                ..._openJobs.map((job) => DropdownMenuItem<String?>(
                      value: job.jobId,
                      child:
                          Text(job.jobTitle, overflow: TextOverflow.ellipsis),
                    )),
              ],
              onChanged: _loadingJobs
                  ? null
                  : (value) => setState(() => _jobId = value),
            ),
          ],
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _submitting || _images.length >= 4 ? null : _pickImages,
            icon: const Icon(Icons.image_outlined),
            label: Text('Add images (${_images.length}/4)'),
          ),
          if (_images.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_images.length, (index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: FutureBuilder(
                        future: _images[index].readAsBytes(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox(
                              width: 88,
                              height: 88,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return Image.memory(
                            snapshot.data!,
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        tooltip: 'Remove image',
                        onPressed: () =>
                            setState(() => _images.removeAt(index)),
                        icon: const Icon(Icons.cancel, color: Colors.white),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(_error!, style: const TextStyle(color: Colors.redAccent)),
          ],
        ],
      ),
    );
  }
}

class CommunityThreadView extends StatefulWidget {
  const CommunityThreadView({
    super.key,
    required this.service,
    required this.postId,
    this.commentId,
    required this.canComment,
    required this.onVerifiedPostDenied,
    required this.onHiddenPost,
  });

  final CommunityService service;
  final String postId;
  final String? commentId;
  final bool canComment;
  final VoidCallback onVerifiedPostDenied;
  final VoidCallback onHiddenPost;

  @override
  State<CommunityThreadView> createState() => _CommunityThreadViewState();
}

class _CommunityThreadViewState extends State<CommunityThreadView> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<String, String?> _replyCursors = {};
  final Map<String, GlobalKey> _commentKeys = {};
  final Set<String> _reportedTargets = {};
  final Set<String> _locallyCreatedCommentIds = {};
  StreamSubscription<Map<String, dynamic>>? _socketSubscription;
  Map<String, dynamic>? _post;
  List<Map<String, dynamic>> _comments = [];
  String? _commentsCursor;
  Map<String, dynamic>? _replyTarget;
  String? _error;
  bool _loading = true;
  bool _loadingOlder = false;
  bool _sending = false;
  bool _composerBlocked = false;
  bool _inactive = false;

  @override
  void initState() {
    super.initState();
    SocketService().initialize();
    _socketSubscription =
        SocketService().communityEvents.listen(_onCommunityEvent);
    _loadThread();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _socketSubscription?.cancel();
    super.dispose();
  }

  void _onCommunityEvent(Map<String, dynamic> event) {
    if (!mounted) return;
    final name = event['event'] as String?;
    final payload = _mapValue(event['payload']);
    if (name == null || payload == null) return;

    if (name == 'community:moderation' &&
        payload['targetType'] == 'post' &&
        payload['targetId'] == widget.postId) {
      if (payload['status'] == 'visible') {
        _loadThread();
      } else if (payload['status'] == 'hidden' ||
          payload['status'] == 'removed') {
        widget.onHiddenPost();
        Get.back();
      }
      return;
    }

    setState(() {
      if (name == 'community:comment-created' &&
          payload['postId'] == widget.postId) {
        final id = payload['id'] as String?;
        if (id == null || _locallyCreatedCommentIds.remove(id)) return;
        if (_comments.any((comment) => comment['id'] == id)) return;
        final parentId = payload['parentCommentId'] as String?;
        if (parentId == null) {
          _comments.add(payload);
          _incrementCount(_post, 'comments');
        } else {
          final parent = _comments
              .firstWhereOrNull((comment) => comment['id'] == parentId);
          if (parent == null) return;
          final replies = _mapList(parent['replies']);
          if (!replies.any((reply) => reply['id'] == id)) replies.add(payload);
          parent['replies'] = replies;
          _incrementCount(parent, 'replies');
        }
      } else if (name == 'community:reaction-updated') {
        final targetType = payload['targetType'];
        final targetId = payload['targetId'];
        final counts = _mapValue(payload['counts']);
        if (counts == null) return;
        if (targetType == 'post' && _post?['id'] == targetId) {
          _setReactionCount(_post!, counts['reactions']);
        } else if (targetType == 'comment') {
          final comment = _findComment(targetId);
          if (comment != null) {
            _setReactionCount(comment, counts['reactions']);
          }
        }
      } else if (name == 'community:moderation' &&
          payload['targetType'] == 'comment' &&
          (payload['status'] == 'hidden' || payload['status'] == 'removed')) {
        _comments
            .removeWhere((comment) => comment['id'] == payload['targetId']);
        for (final comment in _comments) {
          final replies = _mapList(comment['replies']);
          replies.removeWhere((reply) => reply['id'] == payload['targetId']);
          comment['replies'] = replies;
        }
      }
    });
  }

  Map<String, dynamic>? _findComment(dynamic id) {
    for (final comment in _comments) {
      if (comment['id'] == id) return comment;
      for (final reply in _mapList(comment['replies'])) {
        if (reply['id'] == id) return reply;
      }
    }
    return null;
  }

  void _setReactionCount(Map<String, dynamic> target, dynamic count) {
    final counts = _mapValue(target['counts']) ?? <String, dynamic>{};
    counts['reactions'] = count;
    target['counts'] = counts;
  }

  void _incrementCount(Map<String, dynamic>? target, String field) {
    if (target == null) return;
    final counts = _mapValue(target['counts']) ?? <String, dynamic>{};
    counts[field] = ((counts[field] as num?)?.toInt() ?? 0) + 1;
    target['counts'] = counts;
  }

  bool _isAuthor(Map<String, dynamic>? author) =>
      author?['id'] == widget.service.accountId &&
      author?['type'] == widget.service.accountType;

  bool _canEdit(Map<String, dynamic> comment) {
    final createdAt = DateTime.tryParse(comment['createdAt'] as String? ?? '');
    if (createdAt == null || !_isAuthor(_mapValue(comment['author']))) {
      return false;
    }
    final age = DateTime.now().toUtc().difference(createdAt.toUtc());
    return !age.isNegative && age <= const Duration(minutes: 15);
  }

  Future<void> _loadThread() async {
    try {
      final post = await widget.service.fetchPost(widget.postId);
      if (!mounted) return;
      setState(() {
        _post = post;
        _comments = _mapList(post['comments']);
        _commentsCursor = post['commentsCursor'] as String?;
        _loading = false;
      });
      if (widget.commentId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final commentContext = _commentKeys[widget.commentId]?.currentContext;
          if (commentContext != null) {
            Scrollable.ensureVisible(commentContext, alignment: 0.2);
          }
        });
      }
    } on CommunityApiException catch (exception) {
      _handleError(exception);
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Could not load this discussion.';
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadOlderComments() async {
    if (_commentsCursor == null || _loadingOlder) return;
    setState(() => _loadingOlder = true);
    try {
      final page = await widget.service.fetchComments(
        widget.postId,
        cursor: _commentsCursor,
      );
      if (!mounted) return;
      setState(() {
        _appendUnique(_comments, page.posts);
        _commentsCursor = page.nextCursor;
        _loadingOlder = false;
      });
    } on CommunityApiException catch (exception) {
      if (mounted) setState(() => _loadingOlder = false);
      _handleError(exception);
    }
  }

  Future<void> _loadReplies(Map<String, dynamic> comment) async {
    final commentId = comment['id'] as String?;
    if (commentId == null) return;
    try {
      final page = await widget.service.fetchReplies(
        commentId,
        cursor: _replyCursors[commentId],
      );
      if (!mounted) return;
      final replies = _mapList(comment['replies']);
      _appendUnique(replies, page.posts);
      setState(() {
        comment['replies'] = replies;
        _replyCursors[commentId] = page.nextCursor;
      });
    } on CommunityApiException catch (exception) {
      _handleError(exception);
    }
  }

  void _appendUnique(
    List<Map<String, dynamic>> target,
    List<Map<String, dynamic>> incoming,
  ) {
    final existingIds = target.map((item) => item['id']).toSet();
    target.addAll(incoming.where((item) => !existingIds.contains(item['id'])));
  }

  List<Map<String, dynamic>> _mapList(dynamic value) => value is List
      ? value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList()
      : <Map<String, dynamic>>[];

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || text.length > 1000 || _sending) return;
    final parentId = _replyTarget?['id'] as String?;
    if (_replyTarget != null && _replyTarget?['parentCommentId'] != null) {
      setState(() => _replyTarget = null);
      return;
    }
    setState(() => _sending = true);
    try {
      final comment = await widget.service.createComment(
        widget.postId,
        text: text,
        parentCommentId: parentId,
      );
      if (!mounted) return;
      setState(() {
        if (comment['id'] is String) {
          _locallyCreatedCommentIds.add(comment['id'] as String);
        }
        if (parentId == null) {
          final previousLength = _comments.length;
          _appendUnique(_comments, [comment]);
          if (_comments.length > previousLength) {
            _incrementCount(_post, 'comments');
          }
        } else {
          final parent =
              _comments.firstWhereOrNull((item) => item['id'] == parentId);
          if (parent != null) {
            final replies = _mapList(parent['replies']);
            final previousLength = replies.length;
            _appendUnique(replies, [comment]);
            parent['replies'] = replies;
            if (replies.length > previousLength) {
              _incrementCount(parent, 'replies');
            }
          }
        }
        _commentController.clear();
        _replyTarget = null;
        _sending = false;
      });
    } on CommunityApiException catch (exception) {
      if (mounted) setState(() => _sending = false);
      if (exception.statusCode == 403 &&
          exception.message == 'Only verified accounts can post') {
        widget.onVerifiedPostDenied();
        setState(() => _composerBlocked = true);
      }
      _handleError(exception);
    }
  }

  void _handleError(CommunityApiException exception) {
    if (exception.statusCode == 401) {
      Get.offAllNamed(AppRoutes.signIn);
      return;
    }
    if (exception.statusCode == 404) {
      Get.back();
      return;
    }
    if (!mounted) return;
    setState(() {
      _error = exception.message;
      if (exception.statusCode == 403 &&
          exception.message == 'Account is inactive') {
        _inactive = true;
      }
    });
    Get.snackbar('Community', exception.message);
  }

  Future<void> _react(
    Map<String, dynamic> target, {
    required String targetType,
    required String reaction,
  }) async {
    final id = target['id'] as String?;
    if (id == null) return;
    try {
      final result = await widget.service.react(
        targetType: targetType,
        targetId: id,
        type: reaction,
      );
      if (!mounted) return;
      setState(() {
        target['myReaction'] = result['myReaction'];
        final counts = _mapValue(target['counts']) ?? <String, dynamic>{};
        final resultCounts = _mapValue(result['counts']);
        if (resultCounts != null)
          counts['reactions'] = resultCounts['reactions'];
        target['counts'] = counts;
      });
    } on CommunityApiException catch (exception) {
      _handleError(exception);
    }
  }

  Future<void> _report(
    Map<String, dynamic> target, {
    required String targetType,
  }) async {
    final targetId = target['id'] as String?;
    if (targetId == null ||
        _reportedTargets.contains('$targetType:$targetId')) {
      return;
    }
    final reason = await Get.bottomSheet<String>(
      SafeArea(
        child: Container(
          color: AppColors.kDarkestBlue,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['spam', 'harassment', 'unsafe', 'other']
                .map((value) => ListTile(
                      title: Text(value,
                          style: const TextStyle(color: Colors.white)),
                      onTap: () => Get.back(result: value),
                    ))
                .toList(),
          ),
        ),
      ),
    );
    if (reason == null) return;
    try {
      final result = await widget.service.report(
        targetType: targetType,
        targetId: targetId,
        reason: reason,
      );
      if (!mounted) return;
      setState(() {
        _reportedTargets.add('$targetType:$targetId');
        if (result['hidden'] == true) {
          if (targetType == 'post') {
            widget.onHiddenPost();
            Get.back();
          } else {
            _comments.removeWhere((item) => item['id'] == targetId);
          }
        }
      });
    } on CommunityApiException catch (exception) {
      if (exception.statusCode == 409) {
        setState(() => _reportedTargets.add('$targetType:$targetId'));
      }
      _handleError(exception);
    }
  }

  Future<void> _editComment(Map<String, dynamic> comment) async {
    final controller = TextEditingController(text: comment['text'] as String?);
    final updatedText = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Edit comment'),
        content: TextField(
          controller: controller,
          maxLength: 1000,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Comment'),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (updatedText == null || updatedText.isEmpty) return;
    try {
      final response = await widget.service.editComment(
        comment['id'] as String,
        text: updatedText,
      );
      if (!mounted) return;
      setState(() {
        comment['text'] = response['text'] ?? updatedText;
        comment['editedAt'] =
            response['editedAt'] ?? DateTime.now().toUtc().toIso8601String();
      });
    } on CommunityApiException catch (exception) {
      _handleError(exception);
    }
  }

  Future<void> _deleteComment(Map<String, dynamic> comment) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete comment?'),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await widget.service.deleteComment(comment['id'] as String);
      if (mounted) {
        setState(() {
          comment['removed'] = true;
          comment['text'] = 'Comment removed';
        });
      }
    } on CommunityApiException catch (exception) {
      _handleError(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkBlue,
        foregroundColor: Colors.white,
        title: const Text('Discussion'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _inactive
              ? const Center(
                  child: Text('Your account is inactive.',
                      style: TextStyle(color: Colors.white70)))
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                        children: [
                          if (_post != null) _threadPost(_post!),
                          if (_commentsCursor != null)
                            Center(
                              child: TextButton(
                                onPressed:
                                    _loadingOlder ? null : _loadOlderComments,
                                child: Text(_loadingOlder
                                    ? 'Loading...'
                                    : 'Load older comments'),
                              ),
                            ),
                          ..._comments.map((comment) => _commentCard(comment)),
                          if (_comments.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(
                                child: Text('Be the first to comment',
                                    style: TextStyle(color: Colors.white60)),
                              ),
                            ),
                          if (_error != null)
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(_error!,
                                  style:
                                      const TextStyle(color: Colors.redAccent)),
                            ),
                        ],
                      ),
                    ),
                    if (widget.canComment && !_composerBlocked)
                      _commentComposer(),
                  ],
                ),
    );
  }

  Widget _threadPost(Map<String, dynamic> post) {
    final author = _mapValue(post['author']) ?? const <String, dynamic>{};
    final counts = _mapValue(post['counts']) ?? const <String, dynamic>{};
    final images = post['images'] is List
        ? (post['images'] as List).whereType<String>().toList()
        : <String>[];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kDarkestBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(author['name'] as String? ?? 'Community member',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text(post['text'] as String? ?? '',
              style: const TextStyle(color: Colors.white, height: 1.4)),
          if (images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(widget.service.imageUrl(images[index]),
                      width: 240, height: 190, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
          Row(
            children: [
              Text('${counts['comments'] ?? 0} comments',
                  style: const TextStyle(color: Colors.white60)),
              const Spacer(),
              _reactionMenu(post, 'post'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reactionMenu(Map<String, dynamic> target, String targetType) {
    final counts = _mapValue(target['counts']) ?? const <String, dynamic>{};
    return PopupMenuButton<String>(
      tooltip: 'React',
      onSelected: (reaction) => _react(
        target,
        targetType: targetType,
        reaction: reaction,
      ),
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'like', child: Text('Like')),
        PopupMenuItem(value: 'useful', child: Text('Useful')),
        PopupMenuItem(value: 'support', child: Text('Support')),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_border, color: Colors.white70, size: 18),
          const SizedBox(width: 5),
          Text('${counts['reactions'] ?? 0}',
              style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _commentCard(Map<String, dynamic> comment, {bool isReply = false}) {
    final author = _mapValue(comment['author']) ?? const <String, dynamic>{};
    final replies = _mapList(comment['replies']);
    final counts = _mapValue(comment['counts']) ?? const <String, dynamic>{};
    final removed = comment['removed'] == true;
    final id = comment['id'] as String? ?? '';
    final owner = _isAuthor(author);
    final actionItems = <PopupMenuEntry<String>>[
      if (owner && _canEdit(comment) && !removed)
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
      if (owner && !removed)
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
      if (!_reportedTargets.contains('comment:$id'))
        const PopupMenuItem(value: 'report', child: Text('Report')),
    ];
    return Padding(
      key: id.isEmpty ? null : _commentKeys.putIfAbsent(id, GlobalKey.new),
      padding: EdgeInsets.only(left: isReply ? 30 : 0, bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.kDarkestBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(author['name'] as String? ?? 'Community member',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                PopupMenuButton<String>(
                  onSelected: (action) {
                    if (action == 'edit') _editComment(comment);
                    if (action == 'delete') _deleteComment(comment);
                    if (action == 'report') {
                      _report(comment, targetType: 'comment');
                    }
                  },
                  itemBuilder: (_) => actionItems,
                ),
              ],
            ),
            Text(
              removed ? 'Comment removed' : (comment['text'] as String? ?? ''),
              style: TextStyle(
                color: removed ? Colors.white54 : Colors.white,
                fontStyle: removed ? FontStyle.italic : FontStyle.normal,
              ),
            ),
            Row(
              children: [
                _reactionMenu(comment, 'comment'),
                if (!isReply && comment['parentCommentId'] == null)
                  TextButton(
                    onPressed: () => setState(() => _replyTarget = comment),
                    child: const Text('Reply'),
                  ),
                if (!isReply &&
                    (counts['replies'] as num? ?? 0) > replies.length)
                  TextButton(
                    onPressed: () => _loadReplies(comment),
                    child: Text(_replyCursors.containsKey(id) &&
                            _replyCursors[id] != null
                        ? 'More replies'
                        : 'Load replies (${counts['replies']})'),
                  ),
              ],
            ),
            if (replies.isNotEmpty)
              ...replies.map((reply) => _commentCard(reply, isReply: true)),
          ],
        ),
      ),
    );
  }

  Widget _commentComposer() => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_replyTarget != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Replying to ${_mapValue(_replyTarget!['author'])?['name'] ?? 'comment'}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cancel reply',
                      onPressed: () => setState(() => _replyTarget = null),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      maxLength: 1000,
                      minLines: 1,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Write a comment',
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.kDarkestBlue,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Send comment',
                    onPressed: _sending ? null : _sendComment,
                    icon: _sending
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
