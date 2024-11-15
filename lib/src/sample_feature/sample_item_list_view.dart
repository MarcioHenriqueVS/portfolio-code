import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _skillsKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _contactKey = GlobalKey();

  late AnimationController _fadeController;
  final Map<String, bool> _visibleSections = {};

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scrollController.addListener(_checkVisibility);
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Add your form submission logic here
      // For example, sending an email or saving to a database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mensagem enviada com sucesso!')),
      );
      _formKey.currentState!.reset();
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _checkVisibility() {
    void checkSection(GlobalKey key, String section) {
      final context = key.currentContext;
      if (context != null) {
        final renderObject = context.findRenderObject() as RenderBox;
        final position = renderObject.localToGlobal(Offset.zero);
        final visible = position.dy < MediaQuery.of(context).size.height * 0.85;

        if (visible && !(_visibleSections[section] ?? false)) {
          setState(() => _visibleSections[section] = true);
        }
      }
    }

    checkSection(_skillsKey, 'skills');
    checkSection(_projectsKey, 'projects');
    checkSection(_contactKey, 'contact');
  }

  Widget _buildSkillCard(IconData icon, String title, String description) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 1, end: 0),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 1 - (value * 0.05),
          child: MouseRegion(
            onEnter: (_) => setState(() {}),
            onExit: (_) => setState(() {}),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.identity()..translate(0, value * -8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: Colors.blue,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
      String title, String description, String imageUrl, String projectUrl) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 0.95 + (value * 0.05),
          child: MouseRegion(
            onEnter: (_) => setState(() {}),
            onExit: (_) => setState(() {}),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.identity()..translate(0, -4 * value),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imageUrl,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          const Color.fromARGB(255, 3, 18, 31)
                              .withOpacity(0.4), // changed to blue
                          const Color.fromARGB(255, 6, 39, 63)
                              .withOpacity(0.5), // changed to dark blue
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(),
    );
  }

  int _getGridColumns(double width) {
    if (width < 600) return 1;
    if (width < 900) return 2;
    return 3;
  }

  double _getTextScaleFactor(double width) {
    if (width < 600) return 0.8;
    if (width < 900) return 0.9;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final textScale = _getTextScaleFactor(width);
          final horizontalPadding = width < 600 ? 20.0 : 40.0;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Container(
                  width: width,
                  height: MediaQuery.of(context).size.height *
                      (width < 600 ? 0.86 : 0.99),
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/bg-portfolio.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color.fromARGB(255, 1, 10, 23)
                                  .withOpacity(0.5),
                              const Color.fromARGB(255, 1, 4, 10)
                                  .withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: horizontalPadding,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Bootstrap.linkedin,
                                size: 17,
                              ),
                              color: Colors.white,
                              onPressed: () => _launchURL(
                                  'https://www.linkedin.com/in/marcio-henrique-090103251/'),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(
                                Bootstrap.whatsapp,
                                size: 17,
                              ),
                              color: Colors.white,
                              onPressed: () =>
                                  _launchURL('https://wa.me/5524999823380'),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Bootstrap.google, size: 17),
                              color: Colors.white,
                              onPressed: () =>
                                  _launchURL('mailto:marciohvalin@gmail.com'),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: width < 600 ? 50 : 100,
                        left: horizontalPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Seja bem vindo!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48 * textScale,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Sou Marcio Henrique,',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24 * textScale,
                              ),
                            ),
                            Text(
                              'Desenvolvedor Web e Mobile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24 * textScale,
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _launchURL('link-para-seu-curriculo.pdf'),
                              icon: const Icon(
                                Icons.download,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Download CV',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                backgroundColor: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => _scrollToSection(_skillsKey),
                          child: Text('Habilidades',
                              style: TextStyle(fontSize: 16 * textScale)),
                        ),
                        SizedBox(width: 20),
                        TextButton(
                          onPressed: () => _scrollToSection(_projectsKey),
                          child: Text('Projetos',
                              style: TextStyle(fontSize: 16 * textScale)),
                        ),
                        SizedBox(width: 20),
                        TextButton(
                          onPressed: () => _scrollToSection(_contactKey),
                          child: Text('Contato',
                              style: TextStyle(fontSize: 16 * textScale)),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 500),
                  offset: _visibleSections['skills'] ?? false
                      ? Offset.zero
                      : const Offset(0, 0.2),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _visibleSections['skills'] ?? false ? 1 : 0,
                    child: Container(
                      key: _skillsKey,
                      padding: EdgeInsets.symmetric(
                        vertical: width < 600 ? 30 : 50,
                        horizontal: horizontalPadding,
                      ),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Habilidades ',
                                style: TextStyle(
                                    fontSize: 32 * textScale,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              Text(
                                '& Ferramentas',
                                style: TextStyle(
                                  fontSize: 32 * textScale,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: width < 600 ? 30 : 50),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: _getGridColumns(width),
                            mainAxisSpacing: width < 600 ? 8 : 10,
                            crossAxisSpacing: width < 600 ? 8 : 10,
                            childAspectRatio: width < 600 ? 2.5 : 2,
                            children: [
                              _buildSkillCard(
                                Icons.flutter_dash,
                                'Flutter',
                                'Desenvolvimento de aplicativos multiplataforma com Flutter e Dart',
                              ),
                              _buildSkillCard(
                                Icons.javascript,
                                'Node.js',
                                'Backend com Node.js, Express e bancos de dados',
                              ),
                              _buildSkillCard(
                                Bootstrap.database,
                                'Banco de Dados',
                                'Firebase Firestore, MySQL',
                              ),
                              _buildSkillCard(
                                Bootstrap.git,
                                'Git',
                                'Controle de versão e colaboração em equipe',
                              ),
                              _buildSkillCard(
                                Bootstrap.cloud,
                                'Cloud',
                                'Deploy e gerenciamento em ambientes cloud',
                              ),
                              _buildSkillCard(
                                Bootstrap.microsoft,
                                '.NET Core',
                                'Desenvolvimento backend com C# e .NET Core',
                              ),
                              _buildSkillCard(
                                Bootstrap.fire,
                                'Firebase',
                                'Desenvolvimento com Firebase Admin SDK, Authentication, Hosting, Real-time Database...',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 500),
                  offset: _visibleSections['projects'] ?? false
                      ? Offset.zero
                      : const Offset(0, 0.2),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _visibleSections['projects'] ?? false ? 1 : 0,
                    child: Container(
                      key: _projectsKey,
                      padding: EdgeInsets.symmetric(
                        vertical: width < 600 ? 30 : 50,
                        horizontal: horizontalPadding,
                      ),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Projetos ',
                                style: TextStyle(
                                    fontSize: 32 * textScale,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              Text(
                                'em Destaque',
                                style: TextStyle(
                                  fontSize: 32 * textScale,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: width < 600 ? 20 : 40),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: _getGridColumns(width),
                            childAspectRatio: width < 600 ? 1.1 : 1.3,
                            mainAxisSpacing: width < 600 ? 15 : 20,
                            crossAxisSpacing: width < 600 ? 15 : 20,
                            children: [
                              _buildProjectCard(
                                'App Delivery',
                                'Flutter • Firebase • Stripe',
                                'assets/images/bg-portfolio.jpg',
                                'https://github.com/your-username/project1',
                              ),
                              _buildProjectCard(
                                'Sistema de Gestão',
                                'React • Node.js • PostgreSQL',
                                'assets/images/bg-portfolio.jpg',
                                'https://github.com/your-username/project2',
                              ),
                              _buildProjectCard(
                                'E-commerce',
                                'Next.js • Prisma • MongoDB',
                                'assets/images/bg-portfolio.jpg',
                                'https://github.com/your-username/project3',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 500),
                  offset: _visibleSections['contact'] ?? false
                      ? Offset.zero
                      : const Offset(0, 0.2),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _visibleSections['contact'] ?? false ? 1 : 0,
                    child: Container(
                      key: _contactKey,
                      padding: EdgeInsets.symmetric(
                        vertical: width < 600 ? 30 : 50,
                        horizontal: horizontalPadding,
                      ),
                      color: Colors.grey[50],
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Entre ',
                                style: TextStyle(
                                    fontSize: 32 * textScale,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              Text(
                                'em Contato',
                                style: TextStyle(
                                  fontSize: 32 * textScale,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: width < 600 ? 30 : 50),
                          Container(
                            constraints: BoxConstraints(maxWidth: 600),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Nome',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, digite seu nome';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, digite seu email';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Por favor, digite um email válido';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    controller: _messageController,
                                    decoration: InputDecoration(
                                      labelText: 'Mensagem',
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 4,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, digite sua mensagem';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: _handleSubmit,
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 15,
                                      ),
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: Text(
                                      'Enviar Mensagem',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16 * textScale,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: width < 600 ? 20 : 30,
                    horizontal: horizontalPadding,
                  ),
                  color: const Color.fromARGB(255, 1, 10, 23),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Bootstrap.linkedin, size: 16),
                            color: Colors.white,
                            onPressed: () => _launchURL(
                                'https://www.linkedin.com/in/marcio-henrique-090103251/'),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Bootstrap.whatsapp, size: 16),
                            color: Colors.white,
                            onPressed: () =>
                                _launchURL('https://wa.me/5524999823380'),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Bootstrap.google, size: 16),
                            color: Colors.white,
                            onPressed: () =>
                                _launchURL('mailto:marciohvalin@gmail.com'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '© ${DateTime.now().year} Marcio Henrique. Todos os direitos reservados.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12 * textScale,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
