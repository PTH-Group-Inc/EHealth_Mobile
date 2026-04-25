import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;
  double _verticalDragOffset = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _verticalDragOffset += details.primaryDelta!;
      _isDragging = true;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_verticalDragOffset.abs() > 150) {
      Navigator.pop(context);
    } else {
      setState(() {
        _verticalDragOffset = 0;
        _isDragging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Opacity based on drag distance
    final double opacity = (1 - (_verticalDragOffset.abs() / 500)).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
        ),
        child: GestureDetector(
          onVerticalDragUpdate: _onVerticalDragUpdate,
          onVerticalDragEnd: _onVerticalDragEnd,
          child: Stack(
            children: [
              // Immersive Background with Blur for Premium feel
              Positioned.fill(
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    color: Colors.black,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(color: Colors.black.withValues(alpha: 0.8)),
                    ),
                  ),
                ),
              ),

              // Image Content with Translation & Scale effect when dragging
              Transform.translate(
                offset: Offset(0, _verticalDragOffset),
                child: Transform.scale(
                  scale: (1 - (_verticalDragOffset.abs() / 2000)).clamp(0.8, 1.0),
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentIndex = index),
                    itemCount: widget.imageUrls.length,
                    itemBuilder: (context, index) {
                      final TransformationController transformationController =
                          TransformationController();
                      TapDownDetails? tapDownDetails;

                      return GestureDetector(
                        onDoubleTapDown: (details) => tapDownDetails = details,
                        onDoubleTap: () {
                          if (transformationController.value !=
                              Matrix4.identity()) {
                            transformationController.value = Matrix4.identity();
                          } else {
                            final position = tapDownDetails!.localPosition;
                            // Zoom to 3x
                            transformationController.value = Matrix4.identity()
                              ..setTranslationRaw(-position.dx * 2, -position.dy * 2, 0.0)
                              ..setEntry(0, 0, 3.0)
                              ..setEntry(1, 1, 3.0);
                          }
                        },
                        child: InteractiveViewer(
                          transformationController: transformationController,
                          minScale: 1.0,
                          maxScale: 4.0,
                          child: Center(
                            child: Hero(
                              tag: "avatar_$index",
                              child: CachedNetworkImage(
                                imageUrl: widget.imageUrls[index],
                                fit: BoxFit.contain,
                                width: MediaQuery.of(context).size.width,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.white54,
                                      size: 80,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Glassmorphism Header Controls
              if (!_isDragging)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildGlassButton(
                          icon: Icons.close_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        
                        // Index Indicator Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Text(
                            "${_currentIndex + 1} / ${widget.imageUrls.length}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        
                        _buildGlassButton(
                          icon: Icons.share_outlined,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),

              // Swipe Hint
              if (!_isDragging && widget.imageUrls.length > 1)
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Vuốt ngang để xem thêm",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton({required IconData icon, required VoidCallback onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}
