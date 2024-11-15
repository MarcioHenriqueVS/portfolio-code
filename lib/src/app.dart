import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF334155), // Cinza azulado sofisticado
              brightness: Brightness.light,
            ).copyWith(
              primary: const Color.fromARGB(255, 6, 38, 84), // Cinza azulado principal
              secondary: const Color(0xFF3B82F6), // Azul vibrante
              tertiary: const Color(0xFF8B5CF6), // Roxo vibrante
              surface: Colors.white,
              background: const Color(0xFFFAFAFA), // Quase branco
              // Ajustando cores de texto para melhor contraste
              onBackground: Colors.black, // Preto puro para máximo contraste
              onSurface: Colors.black, // Preto puro para máximo contraste
              onPrimary:
                  Colors.white, // Branco para texto em elementos primários
              onSecondary:
                  Colors.white, // Branco para texto em elementos secundários
              onTertiary:
                  Colors.white, // Branco para texto em elementos terciários
              // Mantendo as cores dos containers
              primaryContainer:
                  const Color(0xFFE0E7FF), // Azul claro para containers
              secondaryContainer:
                  const Color(0xFFF0DBFF), // Roxo claro para containers
              tertiaryContainer:
                  const Color(0xFFFFEDF0), // Rosa claro para containers
            ),
            scaffoldBackgroundColor: const Color(0xFFFAFAFA),
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 56,
                letterSpacing: -1.5,
              ),
              displayMedium: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 45,
                letterSpacing: -0.5,
              ),
              displaySmall: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                letterSpacing: -0.5,
              ),
              bodyLarge:
                  TextStyle(color: Colors.black), // Adicionando cor explícita
              bodyMedium:
                  TextStyle(color: Colors.black), // Adicionando cor explícita
              bodySmall:
                  TextStyle(color: Colors.black), // Adicionando cor explícita
            ),
            cardTheme: CardTheme(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF334155),
              brightness: Brightness.dark,
            ).copyWith(
              background: const Color(0xFF1A1A1A), // Quase preto
              surface: const Color(0xFF262626), // Cinza escuro
            ),
            scaffoldBackgroundColor: const Color(0xFF1A1A1A),
          ),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case SampleItemDetailsView.routeName:
                    return const SampleItemDetailsView();
                  case HomePage.routeName:
                  default:
                    return const HomePage();
                }
              },
            );
          },
        );
      },
    );
  }
}
