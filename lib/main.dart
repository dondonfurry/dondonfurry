import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> with SingleTickerProviderStateMixin {
  final GlobalKey _mainKey = GlobalKey();
  final GlobalKey _workKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoading = true;
  late AnimationController _loadingController;
  late Animation<Offset> _slideAnimation;

  // 이미지 뷰어 관련 변수
  bool _showImageViewer = false;
  int _currentImageIndex = 0;
  bool _isFromMainSection = false;
  int _workImageCount = 0;

  @override
  void initState() {
    super.initState();
    
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOutCubic,
    ));
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _loadingController.forward().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    });
  }

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero).dy;
    final currentScroll = _scrollController.offset;
    final targetScroll = currentScroll + position - 100;

    _scrollController.animateTo(
      targetScroll,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _openImageViewer(int index, bool isMainSection) {
    setState(() {
      _currentImageIndex = index;
      _isFromMainSection = isMainSection;
      _showImageViewer = true;
    });
  }

  void _closeImageViewer() {
    setState(() {
      _showImageViewer = false;
    });
  }

  void _nextImage() {
    setState(() {
      final totalCount = _isFromMainSection ? 3 : _workImageCount;
      _currentImageIndex = (_currentImageIndex + 1) % totalCount;
    });
  }

  void _previousImage() {
    setState(() {
      final totalCount = _isFromMainSection ? 3 : _workImageCount;
      _currentImageIndex = (_currentImageIndex - 1 + totalCount) % totalCount;
    });
  }

  void _setWorkImageCount(int count) {
    _workImageCount = count;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  static const double headerHeight = 44;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// 메인 컨텐츠
          Positioned.fill(
            child: Stack(
              children: [
                /// 스크롤 영역
                Positioned.fill(
                  child: ScrollConfiguration(
                    behavior: SmoothScrollBehavior(),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(top: headerHeight + 40),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1400),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  SectionMain(
                                    key: _mainKey,
                                    onImageTap: _openImageViewer,
                                  ),
                                  const SizedBox(height: 80),
                                  const DecorativeDivider(),
                                  const SizedBox(height: 80),
                                  SectionWork(
                                    key: _workKey,
                                    onImageTap: _openImageViewer,
                                    onImageCountLoaded: _setWorkImageCount,
                                  ),
                                  const SizedBox(height: 160),
                                  SectionAbout(key: _aboutKey),
                                  const SizedBox(height: 160),
                                  SectionContact(key: _contactKey),
                                  const SizedBox(height: 120),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// 고정 헤더
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: headerHeight,
                  child: Header(
                    onMain: () => _scrollTo(_mainKey),
                    onWork: () => _scrollTo(_workKey),
                    onAbout: () => _scrollTo(_aboutKey),
                    onContact: () => _scrollTo(_contactKey),
                  ),
                ),
              ],
            ),
          ),

          /// 로딩 슬라이드 오버레이
          if (_isLoading)
            SlideTransition(
              position: _slideAnimation,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF1a1a1a),
                      Color(0xFF333333),
                      Color(0xFF4d4d4d),
                    ],
                  ),
                ),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      
                      double mainFontSize = 84;
                      double subFontSize = 56;
                      double mainLetterSpacing = 1.5;
                      double subLetterSpacing = 3.0;
                      
                      if (width < 1200) {
                        mainFontSize = 64;
                        subFontSize = 42;
                        mainLetterSpacing = 1.2;
                        subLetterSpacing = 2.5;
                      }
                      if (width < 900) {
                        mainFontSize = 48;
                        subFontSize = 32;
                        mainLetterSpacing = 1.0;
                        subLetterSpacing = 2.0;
                      }
                      if (width < 600) {
                        mainFontSize = 36;
                        subFontSize = 24;
                        mainLetterSpacing = 0.8;
                        subLetterSpacing = 1.5;
                      }
                      if (width < 400) {
                        mainFontSize = 28;
                        subFontSize = 18;
                        mainLetterSpacing = 0.5;
                        subLetterSpacing = 1.0;
                      }
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'DONDON\'S PORTFOLIO',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: mainFontSize,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontFamily: 'Italiana',
                                letterSpacing: mainLetterSpacing,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: mainFontSize * 0.14),
                            Text(
                              'for fursuit',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: subFontSize,
                                fontWeight: FontWeight.w300,
                                color: Colors.white70,
                                fontFamily: 'Italiana',
                                letterSpacing: subLetterSpacing,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

          /// 이미지 뷰어 오버레이
          if (_showImageViewer)
            ImageViewerOverlay(
              currentIndex: _currentImageIndex,
              isMainSection: _isFromMainSection,
              onClose: _closeImageViewer,
              onNext: _nextImage,
              onPrevious: _previousImage,
              totalCount: _isFromMainSection ? 3 : _workImageCount,
            ),
        ],
      ),
    );
  }
}

/* ---------------- SMOOTH SCROLL BEHAVIOR (웹 전용) ---------------- */

class SmoothScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

/* ---------------- HEADER (FIXED) ---------------- */

class Header extends StatelessWidget {
  final VoidCallback onMain;
  final VoidCallback onWork;
  final VoidCallback onAbout;
  final VoidCallback onContact;

  const Header({
    super.key,
    required this.onMain,
    required this.onWork,
    required this.onAbout,
    required this.onContact,
  });

  Widget _menu(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 14,
      color: Colors.black.withOpacity(0.25),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            const Text(
              'DonDon\'s Portfolio',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            _menu('Main', onMain),
            _divider(),
            _menu('Work', onWork),
            _divider(),
            _menu('About', onAbout),
            _divider(),
            _menu('Contact', onContact),
          ],
        ),
      ),
    );
  }
}

/* ---------------- DECORATIVE DIVIDER ---------------- */

class DecorativeDivider extends StatelessWidget {
  const DecorativeDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.grey.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- MAIN ---------------- */

class SectionMain extends StatelessWidget {
  final Function(int, bool) onImageTap;

  const SectionMain({
    super.key,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int columns = 3;
        if (width < 900) columns = 2;
        if (width < 600) columns = 1;

        const gap = 24.0;
        final imageWidth = (width - gap * (columns - 1)) / columns;
        final imageHeight = imageWidth * 4 / 3;

        return Column(
          children: [
            const Text(
              'Hover Your Mouse!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: gap,
              runSpacing: gap,
              children: List.generate(3, (i) {
                return HoverImage(
                  index: i,
                  width: imageWidth.clamp(180, 420),
                  height: imageHeight.clamp(240, 560),
                  onTap: () => onImageTap(i, true),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

/* ---------------- HOVER IMAGE (메모리 최적화) ---------------- */

class HoverImage extends StatefulWidget {
  final int index;
  final double width;
  final double height;
  final VoidCallback onTap;

  const HoverImage({
    super.key,
    required this.index,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  State<HoverImage> createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 기본 이미지
                Image.asset(
                  'assets/res/beforeAfter/${widget.index + 1}.webp',
                  fit: BoxFit.cover,
                  cacheWidth: (widget.width * 1.5).toInt(),
                  gaplessPlayback: true,
                ),
                // 호버 이미지 - 항상 로드하되 불투명도로 제어
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isHovered ? 1.0 : 0.0,
                  curve: Curves.easeInOut,
                  child: Image.asset(
                    'assets/res/beforeAfter/${widget.index + 4}.webp',
                    fit: BoxFit.cover,
                    cacheWidth: (widget.width * 1.5).toInt(),
                    gaplessPlayback: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ---------------- WORK (메모리 최적화) ---------------- */

class SectionWork extends StatefulWidget {
  final Function(int, bool) onImageTap;
  final Function(int) onImageCountLoaded;

  const SectionWork({
    super.key,
    required this.onImageTap,
    required this.onImageCountLoaded,
  });

  @override
  State<SectionWork> createState() => _SectionWorkState();
}

class _SectionWorkState extends State<SectionWork> {
  Map<String, String> _imageNames = {};
  bool _isLoading = true;
  int _imageCount = 20;

  @override
  void initState() {
    super.initState();
    _loadImageNames();
  }

  Future<void> _loadImageNames() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/res/work/names.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      setState(() {
        _imageNames = jsonData.map((key, value) => MapEntry(key, value.toString()));
        _imageCount = _imageNames.length;
        _isLoading = false;
      });
      
      widget.onImageCountLoaded(_imageCount);
    } catch (e) {
      print('JSON 로드 실패: $e');
      setState(() {
        _isLoading = false;
      });
      widget.onImageCountLoaded(_imageCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        const Text(
          'Work',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 40),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth * 0.75;

            int crossAxisCount = 3;
            if (width < 675) crossAxisCount = 2;
            if (width < 450) crossAxisCount = 1;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: MasonryGridView.count(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: true,
                  itemCount: _imageCount,
                  itemBuilder: (context, index) {
                    final imageName = _imageNames['${index + 1}.webp'] ?? 'Work ${index + 1}';
                    
                    return WorkImageItem(
                      index: index,
                      imagePath: 'assets/res/work/${index + 1}.webp',
                      imageName: imageName,
                      onTap: () => widget.onImageTap(index, false),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/* ---------------- WORK IMAGE ITEM (메모리 최적화) ---------------- */

class WorkImageItem extends StatefulWidget {
  final int index;
  final String imagePath;
  final String imageName;
  final VoidCallback onTap;

  const WorkImageItem({
    super.key,
    required this.index,
    required this.imagePath,
    required this.imageName,
    required this.onTap,
  });

  @override
  State<WorkImageItem> createState() => _WorkImageItemState();
}

class _WorkImageItemState extends State<WorkImageItem> with AutomaticKeepAliveClientMixin {
  bool _isHovered = false;

  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cacheSize = (constraints.maxWidth * 1.2).toInt();
              
              return Stack(
                children: [
                  // 이미지
                  Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    cacheWidth: cacheSize > 0 ? cacheSize : null,
                    gaplessPlayback: true,
                  ),
                  // 검정 오버레이 + 이름
                  Positioned.fill(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isHovered ? 1.0 : 0.0,
                      curve: Curves.easeInOut,
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: Text(
                            widget.imageName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/* ---------------- ABOUT ---------------- */

class SectionAbout extends StatelessWidget {
  const SectionAbout({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      print('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'About',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 40),
        
        LayoutBuilder(
          builder: (context, constraints) {
            final containerWidth = constraints.maxWidth * 0.85;
            final isWide = containerWidth > 700;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: containerWidth),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: AspectRatio(
                                aspectRatio: 2048 / 1389,
                                child: Image.asset(
                                  'assets/res/about.jpg',
                                  fit: BoxFit.cover,
                                  cacheWidth: 800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            flex: 40,
                            child: _buildTextContent(context),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: AspectRatio(
                              aspectRatio: 2048 / 1389,
                              child: Image.asset(
                                'assets/res/about.jpg',
                                fit: BoxFit.cover,
                                cacheWidth: 800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          _buildTextContent(context),
                        ],
                      ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '돈돈 / DonDon',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        
        InkWell(
          onTap: () => _launchUrl('https://x.com/DonDon_Fur'),
          child: const Text(
            '@DonDon_Fur',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF1DA1F2),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        Container(
          height: 1,
          color: Colors.grey.withOpacity(0.3),
        ),
        const SizedBox(height: 24),
        
        Text(
          'Profile',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          '퍼슈트 사진을 찍습니다.\n밝고 선명한, 컬러풀한 사진을 주로 찍으며,\n세심함이 담긴 후보정으로 더욱 예쁜 사진을 만듭니다.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black87,
            height: 1.6,
          ),
        ),
        
        const SizedBox(height: 24),
        
        Text(
          'Gear',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          '[Nikon D750]',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black87,
            height: 1.6,
          ),
        ),
        const Text(
          '+ AF-S NIKKOR 50mm F1.8G\n+ Sigma 24-70mm f/2.8 EX Aspherical DG DF 35mm Zoom',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black87,
            height: 1.6,
          ),
        ),
        
        const SizedBox(height: 4),
        const Text(
          '자연스러운 화각과 부드러운 배경흐림 사진 위주입니다.\n역동적이거나 배경이 같이 담기는 사진까지도 촬영 가능합니다.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black45,
            height: 1.6,
          ),
        )
      ],
    );
  }
}

/* ---------------- CONTACT ---------------- */

class SectionContact extends StatelessWidget {
  const SectionContact({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      print('Could not launch $urlString');
    }
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('디스코드 아이디가 복사되었습니다!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Contact',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialIconButton(
              icon: FontAwesomeIcons.google,
              onTap: () => _launchUrl('https://mail.google.com/mail/?view=cm&fs=1&to=dondonfurry@gmail.com'),
            ),
            const SizedBox(width: 20),
            _SocialIconButton(
              icon: FontAwesomeIcons.xTwitter,
              onTap: () => _launchUrl('https://x.com/DonDon_Fur'),
            ),
            const SizedBox(width: 20),
            _SocialIconButton(
              icon: FontAwesomeIcons.discord,
              onTap: () => _copyToClipboard(context, 'dondonrondoncon'),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        const Text(
          '© 2026 DonDon_Fur. All rights reserved.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _isHovered 
                ? const Color(0xFF555555)
                : const Color(0xFF333333),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            widget.icon,
            size: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/* ---------------- IMAGE VIEWER OVERLAY (메모리 최적화) ---------------- */

class ImageViewerOverlay extends StatefulWidget {
  final int currentIndex;
  final bool isMainSection;
  final VoidCallback onClose;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final int totalCount;

  const ImageViewerOverlay({
    super.key,
    required this.currentIndex,
    required this.isMainSection,
    required this.onClose,
    required this.onNext,
    required this.onPrevious,
    required this.totalCount,
  });

  @override
  State<ImageViewerOverlay> createState() => _ImageViewerOverlayState();
}

class _ImageViewerOverlayState extends State<ImageViewerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideOutAnimation;
  late Animation<Offset> _slideInAnimation;
  int _displayIndex = 0;
  bool _isSliding = false;
  bool _slideRight = true;

  Future<void> _launchImageUrl(String imagePath) async {
    if (kIsWeb) {
      final imageUrl = 'assets/$imagePath';
      print('Opening URL: $imageUrl');
      html.window.open(imageUrl, '_blank');
    } else {
      print('Image opening is only supported on web');
    }
  }

  @override
  void initState() {
    super.initState();
    _displayIndex = widget.currentIndex;
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideOutAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-2.0, 0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInCubic),
    ));
    
    _slideInAnimation = Tween<Offset>(
      begin: const Offset(2.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
    ));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadAdjacentImages();
    });
  }

  @override
  void didUpdateWidget(ImageViewerOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _slideRight = widget.currentIndex > oldWidget.currentIndex ||
          (widget.currentIndex == 0 && oldWidget.currentIndex == widget.totalCount - 1);
      _updateAnimationDirection();
      _slideImage();
      
      _preloadAdjacentImages();
    }
  }

  void _preloadAdjacentImages() {
    final prevIndex = (_displayIndex - 1 + widget.totalCount) % widget.totalCount;
    final nextIndex = (_displayIndex + 1) % widget.totalCount;
    
    if (prevIndex != _displayIndex) {
      precacheImage(
        AssetImage(_getImagePath(prevIndex)),
        context,
      );
    }
    
    if (nextIndex != _displayIndex) {
      precacheImage(
        AssetImage(_getImagePath(nextIndex)),
        context,
      );
    }
  }

  void _updateAnimationDirection() {
    if (_slideRight) {
      _slideOutAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-2.0, 0),
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInCubic),
      ));
      
      _slideInAnimation = Tween<Offset>(
        begin: const Offset(2.0, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ));
    } else {
      _slideOutAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(2.0, 0),
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInCubic),
      ));
      
      _slideInAnimation = Tween<Offset>(
        begin: const Offset(-2.0, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ));
    }
  }

  void _slideImage() {
    if (_isSliding) return;
    
    setState(() => _isSliding = true);
    
    _slideController.forward(from: 0).then((_) {
      setState(() {
        _displayIndex = widget.currentIndex;
      });
      _slideController.reset();
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          setState(() => _isSliding = false);
        }
      });
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  String _getImagePath(int index) {
    if (widget.isMainSection) {
      return 'assets/res/beforeAfter/${index + 4}.webp';
    } else {
      return 'assets/res/work/${index + 1}.webp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: widget.onClose,
        child: Container(
          color: Colors.black.withOpacity(0.9),
          child: Stack(
            children: [
              // 이미지 영역
              Center(
                child: GestureDetector(
                  onTap: () {
                    final imagePath = _getImagePath(_displayIndex);
                    _launchImageUrl(imagePath);
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.85,
                      maxHeight: MediaQuery.of(context).size.height * 0.85,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 정지 상태 이미지
                        if (!_isSliding)
                          Image.asset(
                            _getImagePath(_displayIndex),
                            fit: BoxFit.contain,
                            cacheWidth: 1920,
                            gaplessPlayback: true,
                          ),
                        // 나가는 이미지 (애니메이션 중)
                        if (_isSliding)
                          SlideTransition(
                            position: _slideOutAnimation,
                            child: Image.asset(
                              _getImagePath(_displayIndex),
                              fit: BoxFit.contain,
                              cacheWidth: 1920,
                              gaplessPlayback: true,
                            ),
                          ),
                        // 들어오는 이미지 (애니메이션 중)
                        if (_isSliding)
                          SlideTransition(
                            position: _slideInAnimation,
                            child: Image.asset(
                              _getImagePath(widget.currentIndex),
                              fit: BoxFit.contain,
                              cacheWidth: 1920,
                              gaplessPlayback: true,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // 왼쪽 화살표
              Positioned(
                left: 40,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _ArrowButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: widget.onPrevious,
                    isEnabled: !_isSliding && widget.currentIndex > 0,
                  ),
                ),
              ),
              
              // 오른쪽 화살표
              Positioned(
                right: 40,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _ArrowButton(
                    icon: Icons.arrow_forward_ios,
                    onTap: widget.onNext,
                    isEnabled: !_isSliding && widget.currentIndex < widget.totalCount - 1,
                  ),
                ),
              ),
              
              // 닫기 버튼
              Positioned(
                top: 40,
                right: 40,
                child: GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 32,
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
}

class _ArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isEnabled;

  const _ArrowButton({
    required this.icon,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.isEnabled ? (_) => setState(() => _isHovered = true) : null,
      onExit: widget.isEnabled ? (_) => setState(() => _isHovered = false) : null,
      child: GestureDetector(
        onTap: widget.isEnabled ? widget.onTap : () {},
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Icon(
            widget.icon,
            color: widget.isEnabled
                ? (_isHovered ? Colors.white : Colors.white.withOpacity(0.7))
                : Colors.white.withOpacity(0.2),
            size: 40,
          ),
        ),
      ),
    );
  }
}