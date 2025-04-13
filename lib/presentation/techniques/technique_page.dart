import 'package:chayil/utilities/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:chayil/utilities/components/alert_dialog.dart';
import 'package:chayil/utilities/components/loading_widget.dart';
import 'package:chayil/utilities/styles/colors.dart';
import 'package:chayil/domain/repositories/technique_repository.dart';
import 'package:chayil/domain/models/techniques/technique.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class TechniquePage extends StatefulWidget {
  final String id;
  const TechniquePage({Key? key, required this.id}) : super(key: key);

  @override
  _TechniquePageState createState() => _TechniquePageState();
}

class _TechniquePageState extends State<TechniquePage> {
  bool _isLoading = false;
  static const _horizontalInset = 16.0;
  static const _verticalPadding = 16.0;
  Technique _technique = Technique(id: '', name: '');
  List<VideoPlayerController> _videoPlayerControllers = [];
  List<ChewieController> _chewieControllers = [];
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

    try {
      var loadedTechnique =
          await TechniqueRepository().loadTechnique(widget.id);
      if (mounted) {
        setState(() {
          _technique = loadedTechnique;
          _loadVideos();
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

  void _loadVideos() {
    if (_technique.videos != null) {
      for (var video in _technique.videos!) {
        var videoPlayerController = VideoPlayerController.network(video.url);
        videoPlayerController.initialize().then((_) {
          var chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: false,
            looping: false,
          );

          _videoPlayerControllers.add(videoPlayerController);
          _chewieControllers.add(chewieController);

          setState(() {});
        });
      }
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
                if (_technique.videos != null && _technique.videos!.isNotEmpty)
                  _buildVideoCarousel(),
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
                  child: Text(_technique.rank?.belt.toUpperCase() ?? '',
                      style: techniqueRankStyle),
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
                if (_technique.formattedInstructorNotes() != null &&
                    _technique.formattedInstructorNotes()!.isNotEmpty) ...[
                  const SizedBox(height: _verticalPadding),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: _horizontalInset),
                    child: Text('INSTRUCTOR NOTES', style: techniqueRankStyle),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: _horizontalInset),
                    child: Text(_technique.formattedInstructorNotes()!,
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
        if (_technique.videos != null && _technique.videos!.length > 1)
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
