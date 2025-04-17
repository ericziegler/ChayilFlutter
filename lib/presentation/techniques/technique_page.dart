import 'package:chayil/utilities/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:chayil/domain/repositories/technique_repository.dart';
import 'package:chayil/domain/repositories/user_repository.dart';
import 'package:chayil/utilities/components/alert_dialog.dart';
import 'package:chayil/utilities/components/loading_widget.dart';
import 'package:chayil/utilities/styles/colors.dart';
import 'package:chayil/domain/models/techniques/technique.dart';
import 'package:chayil/domain/models/ranks/rank.dart';
import 'package:chayil/domain/models/users/user.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class TechniquePage extends StatefulWidget {
  final String id;
  const TechniquePage({Key? key, required this.id}) : super(key: key);

  @override
  TechniquePageState createState() => TechniquePageState();
}

class TechniquePageState extends State<TechniquePage> {
  final _techniqueRepository = TechniqueRepository();
  final _userRepository = UserRepository();
  UserRole _userRole = UserRole.student;
  bool _isLoading = false;
  static const _horizontalInset = 16.0;
  static const _verticalPadding = 16.0;
  Technique _technique = Technique(
      id: '',
      name: '',
      details: '',
      advancedNotes: '',
      rankId: '',
      categoryId: '',
      sortOrder: 0);
  Rank _rank = Rank(
      id: '',
      name: '',
      imageAsset: '',
      primaryColor: '',
      secondaryColor: '',
      stripeColor: '',
      sortOrder: 0);
  List<String> _videoUrls = [];

  final List<VideoPlayerController> _videoPlayerControllers = [];
  final List<ChewieController> _chewieControllers = [];
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTechnique();
  }

  @override
  void dispose() {
    for (var controller in _videoPlayerControllers) {
      controller.dispose();
    }
    for (var chewieController in _chewieControllers) {
      chewieController.dispose();
    }
    super.dispose();
  }

  void _loadTechnique() async {
    setState(() {
      _isLoading = true;
    });

    await _loadUserRole();

    try {
      final loadedTechnique =
          await _techniqueRepository.getTechnique(widget.id);
      final loadedRank =
          await _techniqueRepository.getRank(loadedTechnique.rankId);

      List<String> videos = [];
      if (_userRole == UserRole.admin ||
          _userRole == UserRole.school ||
          _userRole == UserRole.instructor ||
          _userRole == UserRole.demo) {
        videos = await _techniqueRepository.getTechniqueVideos(widget.id);
      }

      if (mounted) {
        setState(() {
          _technique = loadedTechnique;
          _rank = loadedRank;
          if (_userRole == UserRole.admin ||
              _userRole == UserRole.school ||
              _userRole == UserRole.instructor ||
              _userRole == UserRole.demo) {
            _videoUrls = videos;
            _loadVideos();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        showErrorAlert(context,
            "We were unable to load the selected technique at this time.");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadUserRole() async {
    User? user = await _userRepository.loadCachedUser();
    if (user != null) {
      _userRole = user.role;
    }
  }

  void _loadVideos() {
    for (var url in _videoUrls) {
      final videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(url));
      videoPlayerController.initialize().then((_) {
        final chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: false,
          looping: false,
        );

        _videoPlayerControllers.add(videoPlayerController);
        _chewieControllers.add(chewieController);

        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Technique Details')),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (_videoUrls.isNotEmpty) _buildVideoCarousel(),
                const SizedBox(height: _verticalPadding),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: _horizontalInset),
                  child: Text(_technique.name, style: techniqueTitleStyle),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: _horizontalInset),
                  child:
                      Text(_rank.name.toUpperCase(), style: techniqueRankStyle),
                ),
                const SizedBox(height: _verticalPadding),
                const Divider(color: separatorColor),
                if (_technique.formattedDetails() != null &&
                    _technique.formattedDetails()!.isNotEmpty) ...[
                  const SizedBox(height: _verticalPadding),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: _horizontalInset),
                    child: Text('DETAILS', style: techniqueRankStyle),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: _horizontalInset),
                    child: Text(_technique.formattedDetails()!,
                        style: techniqueDetailsStyle),
                  ),
                  const SizedBox(height: _verticalPadding),
                  const Divider(color: separatorColor),
                ],
                if ((_userRole == UserRole.admin ||
                        _userRole == UserRole.school ||
                        _userRole == UserRole.demo) &&
                    _technique.formattedAdvancedNotes() != null &&
                    _technique.formattedAdvancedNotes()!.isNotEmpty) ...[
                  const SizedBox(height: _verticalPadding),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: _horizontalInset),
                    child: Text('ADVANCED NOTES', style: techniqueRankStyle),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: _horizontalInset),
                    child: Text(_technique.formattedAdvancedNotes()!,
                        style: techniqueDetailsStyle),
                  ),
                  const SizedBox(height: _verticalPadding),
                  const Divider(color: separatorColor),
                ],
              ],
            ),
          ),
          if (_isLoading) const LoadingWidget(),
        ]));
  }

  Widget _buildVideoCarousel() {
    var screenWidth = MediaQuery.of(context).size.width;
    var videoAspectRatio = screenWidth / (screenWidth / (16 / 9));

    return Column(
      children: [
        AspectRatio(
          aspectRatio: videoAspectRatio,
          child: PageView.builder(
            controller:
                PageController(viewportFraction: 1), // 1 for full page width
            itemCount: _chewieControllers.length,
            itemBuilder: (context, index) {
              return Chewie(controller: _chewieControllers[index]);
            },
            onPageChanged: (int page) {
              setState(() {
                _currentPageIndex = page;
              });
            },
          ),
        ),
        if (_videoUrls.length > 1)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Video ${_currentPageIndex + 1} of ${_chewieControllers.length}",
                style: paragraphTextStyle,
              ),
            ),
          ),
      ],
    );
  }
}
