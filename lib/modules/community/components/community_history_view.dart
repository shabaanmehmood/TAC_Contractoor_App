import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/models/job_model.dart';
import 'package:taccontractor/modules/Guards/job_details/job_details_screen.dart';
import '../community_service.dart';
import 'post_card.dart';
import 'thread_view.dart';

class CommunityHistoryView extends StatefulWidget {
  const CommunityHistoryView({
    super.key,
    required this.service,
    required this.type,
    required this.personId,
    required this.canComment,
  });

  final CommunityService service;
  final String type;
  final String personId;
  final bool canComment;

  @override
  State<CommunityHistoryView> createState() => _CommunityHistoryViewState();
}

class _CommunityHistoryViewState extends State<CommunityHistoryView> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, List<Map<String, dynamic>>> _items = {
    'posts': [],
    'comments': [],
    'reactions': [],
    'following': [],
    'reports': [],
  };
  Map<String, dynamic> _person = const {};
  Map<String, dynamic> _summary = const {};
  Map<String, dynamic> _pagination = const {};
  String? _error;
  int _page = 1;
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasReports = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadHistory();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 350) {
      _loadNextPage();
    }
  }

  Future<void> _loadHistory({int page = 1}) async {
    try {
      final response = await widget.service.fetchHistory(
        type: widget.type,
        id: widget.personId,
        page: page,
      );
      if (!mounted) return;
      final person = _asMap(response['person']);
      final summary = _asMap(response['summary']);
      final hasReports = response.containsKey('reports');
      setState(() {
        _person = person;
        if (page == 1) _summary = summary;
        _hasReports = hasReports;
        for (final section in _items.keys) {
          if (section == 'reports' && !hasReports) continue;
          final sectionData = _asMap(response[section]);
          final newItems = _asMapList(sectionData['items']);
          if (page == 1) {
            _items[section] = newItems;
          } else {
            _appendUnique(_items[section]!, newItems);
          }
          if (sectionData['pagination'] is Map) {
            _pagination[section] =
                Map<String, dynamic>.from(sectionData['pagination'] as Map);
          }
        }
        _page = page;
        _loading = false;
        _loadingMore = false;
        _error = null;
      });
    } on CommunityApiException catch (exception) {
      if (exception.statusCode == 404 &&
          exception.message.toLowerCase().contains('account not found')) {
        if (mounted) Get.back<void>();
        return;
      }
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadingMore = false;
        _error = exception.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadingMore = false;
        _error = 'Could not load community history. Check your connection.';
      });
    }
  }

  bool get _hasNextPage => _items.keys
          .where((section) => section != 'reports' || _hasReports)
          .any((section) {
        final pagination = _asMap(_pagination[section]);
        final totalPages = (pagination['totalPages'] as num?)?.toInt() ?? 1;
        return _page < totalPages;
      });

  Future<void> _loadNextPage() async {
    if (_loading || _loadingMore || !_hasNextPage) return;
    setState(() => _loadingMore = true);
    await _loadHistory(page: _page + 1);
  }

  void _appendUnique(
    List<Map<String, dynamic>> current,
    List<Map<String, dynamic>> next,
  ) {
    final ids = current.map((item) => item['id']).toSet();
    current.addAll(next.where((item) => !ids.contains(item['id'])));
  }

  Future<void> _openPost(String? postId) async {
    if (postId == null || postId.isEmpty) return;
    Get.bottomSheet<void>(
      CommunityThreadView(
        service: widget.service,
        postId: postId,
        canComment: widget.canComment,
        onVerifiedPostDenied: () {},
        onHiddenPost: () {},
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  void _openAuthor(Map<String, dynamic>? author) {
    if (author == null) return;
    final type = author['type'] as String?;
    final id = author['id'] as String?;
    if (type != 'guard' && type != 'contractor' || id == null) return;
    Get.to<void>(() => CommunityHistoryView(
          service: widget.service,
          type: type!,
          personId: id,
          canComment: widget.canComment,
        ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      appBar: AppBar(
        title: const Text('Community History'),
        backgroundColor: AppColors.kDarkBlue,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.kSkyBlue),
            )
          : _error != null && _person.isEmpty
              ? _errorView()
              : RefreshIndicator(
                  onRefresh: () => _loadHistory(),
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                    children: [
                      _personHeader(),
                      const SizedBox(height: 12),
                      _summaryCard(),
                      const SizedBox(height: 16),
                      _postsSection(),
                      _commentsSection(),
                      _reactionsSection(),
                      _followingSection(),
                      if (_hasReports) _reportsSection(),
                      if (_loadingMore)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.kSkyBlue,
                            ),
                          ),
                        ),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _errorView() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error ?? 'Could not load community history.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() {
                    _loading = true;
                    _error = null;
                  });
                  _loadHistory();
                },
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );

  Widget _personHeader() {
    final imagePath = _person['profileImage'] as String?;
    final imageUrl = imagePath == null || imagePath.isEmpty
        ? null
        : widget.service.imageUrl(imagePath);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.kDarkBlue,
            backgroundImage:
                imageUrl == null ? null : CachedNetworkImageProvider(imageUrl),
            child: imageUrl == null
                ? const Icon(Icons.person, color: Colors.white70, size: 30)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _person['name'] as String? ?? 'Community member',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _accountLabel(_person['type'] as String?),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    if (_person['type'] == 'guard' &&
                        _person['professionalBadge'] != null) ...[
                      const SizedBox(width: 8),
                      _badge(_person['professionalBadge'].toString()),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() => Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            _summaryCount('Posts', 'posts'),
            _summaryCount('Comments', 'comments'),
            _summaryCount('Reactions', 'reactions'),
            _summaryCount('Following', 'following'),
            _summaryCount('Followers', 'followers'),
          ],
        ),
      );

  Widget _summaryCount(String label, String key) => Expanded(
        child: Column(
          children: [
            Text(
              '${(_summary[key] as num?)?.toInt() ?? 0}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ],
        ),
      );

  Widget _postsSection() => _section(
        'Posts',
        _items['posts']!,
        (post) => LinkedInPostCard(
          post: post,
          service: widget.service,
          accountLabel: _accountLabel,
          dateLabel: _dateLabel,
          isFollowed: false,
          canFollow: false,
          onFollowToggle: () {},
          onOpenThread: () => _openPost(post['id'] as String?),
          onReact: (_) {},
          onEdit: () {},
          onDelete: () {},
          onReport: () {},
          onOpenJob: _openJob,
          canEdit: false,
          ownPost: false,
          isReported: false,
          onOpenAuthor: _openAuthor,
        ),
      );

  Widget _commentsSection() => _section(
        'Comments',
        _items['comments']!,
        (comment) {
          final post = _asMap(comment['post']);
          final removed = comment['text'] == 'Comment removed';
          return InkWell(
            onTap: () => _openPost(post['id'] as String?),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment['text'] as String? ?? '',
                    style: TextStyle(
                      color: removed ? Colors.white54 : Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${post['author'] is Map ? _asMap(post['author'])['name'] ?? 'Community member' : 'Community member'} · ${post['text'] ?? ''}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  if (comment['parentCommentId'] != null)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        'Reply',
                        style: TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );

  Widget _reactionsSection() => _section(
        'Reactions',
        _items['reactions']!,
        (reaction) {
          final target =
              reaction['target'] is Map ? _asMap(reaction['target']) : null;
          final targetPost = _asMap(target?['post']);
          var postId =
              target?['postId'] as String? ?? targetPost['id'] as String?;
          if (postId == null && reaction['targetType'] == 'post') {
            postId = target?['id'] as String?;
          }
          final available = target != null;
          return InkWell(
            onTap: available ? () => _openPost(postId) : null,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  Icon(
                    _reactionIcon(reaction['type'] as String?),
                    color: AppColors.kSkyBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      available
                          ? '${_reactionLabel(reaction['type'] as String?)} · ${reaction['targetType'] == 'comment' ? 'Comment' : 'Post'}'
                          : 'Content no longer available',
                      style: TextStyle(
                        color: available ? Colors.white : Colors.white54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Widget _followingSection() => _section(
        'Following',
        _items['following']!,
        (entry) {
          final author = _asMap(entry['author']);
          final imagePath = author['profileImage'] as String?;
          final imageUrl = imagePath == null || imagePath.isEmpty
              ? null
              : widget.service.imageUrl(imagePath);
          return Card(
            color: AppColors.kJobCardColor,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: () => _openAuthor(author),
              leading: CircleAvatar(
                backgroundColor: AppColors.kDarkBlue,
                backgroundImage: imageUrl == null
                    ? null
                    : CachedNetworkImageProvider(imageUrl),
                child: imageUrl == null
                    ? const Icon(Icons.person, color: Colors.white70)
                    : null,
              ),
              title: Text(
                author['name'] as String? ?? 'Community member',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${_accountLabel(author['type'] as String?)} · ${_dateLabel(entry['followedAt'] as String?)}',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            ),
          );
        },
      );

  Widget _reportsSection() => _section(
        'Reports',
        _items['reports']!,
        (report) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                report['reason'] as String? ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                '${report['targetType'] ?? ''} · ${report['targetId'] ?? ''}',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                '${report['status'] ?? ''} · ${_dateLabel(report['createdAt'] as String?)}',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ),
      );

  Widget _section(
    String title,
    List<Map<String, dynamic>> items,
    Widget Function(Map<String, dynamic>) builder,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
            child: Text(
              'No ${title.toLowerCase()} yet.',
              style: const TextStyle(color: Colors.white54),
            ),
          )
        else
          ...items.map(builder),
      ],
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      );

  Widget _badge(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.kSkyBlue.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.kSkyBlue,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  String _accountLabel(String? type) {
    if (type == null || type.isEmpty) return 'Member';
    return '${type[0].toUpperCase()}${type.substring(1)}';
  }

  String _dateLabel(String? value) {
    final date = DateTime.tryParse(value ?? '')?.toLocal();
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _reactionLabel(String? type) => switch (type) {
        'useful' => 'Useful',
        'support' => 'Support',
        _ => 'Like',
      };

  IconData _reactionIcon(String? type) => switch (type) {
        'useful' => Icons.lightbulb_rounded,
        'support' => Icons.volunteer_activism_rounded,
        _ => Icons.thumb_up_rounded,
      };

  Map<String, dynamic> _asMap(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

  List<Map<String, dynamic>> _asMapList(dynamic value) {
    if (value is! List) return [];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
