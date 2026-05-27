import 'package:flutter/material.dart';

import 'core/app_info.dart';
import 'core/theme/app_theme.dart';
import 'database/database_platform.dart';
import 'modules/logistica/screens/logistica_home_page.dart';
import 'screens/login_page.dart';
import 'services/theme_mode_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configurarBancoPorPlataforma();
  final themeModeService = await ThemeModeService.carregar();
  runApp(ControleACEApp(themeModeService: themeModeService));
}

class ControleACEApp extends StatelessWidget {
  final ThemeModeService? themeModeService;
  final bool carregarDashboard;
  final bool mostrarLogin;

  const ControleACEApp({
    super.key,
    this.themeModeService,
    this.carregarDashboard = true,
    this.mostrarLogin = true,
  });

  @override
  Widget build(BuildContext context) {
    final service = themeModeService ?? ThemeModeService(ThemeMode.system);

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        return MaterialApp(
          title: AppInfo.nome,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          darkTheme: AppTheme.darkTheme,
          themeMode: service.themeMode,
          home: mostrarLogin
              ? LoginPage(
                  onEntrar: (context, operador, municipio) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LogisticaHomePage(
                          usuario: operador,
                          municipio: municipio,
                          themeModeService: service,
                        ),
                      ),
                    );
                  },
                )
              : LogisticaHomePage(themeModeService: service),
        );
      },
    );
  }
}
