import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plans_gastos/screens/home.dart';
import 'package:plans_gastos/theme/app_colors.dart';
import 'package:plans_gastos/theme/app_text_styles.dart';
import 'package:plans_gastos/utils/imagens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    Timer(
        const Duration(milliseconds: 2000),
        () => {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(builder: (context) => const HomeScreen()),
              )
            });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Image.asset(
              ImagesAssets.logo,
              width: 105,
              height: 105,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('PLANS', style: AppTextStyles.h3Regular()),
                Text('Gastos', style: AppTextStyles.h3SemiBold()),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.25),
              height: 1,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Simples controle', style: AppTextStyles.h6Regular()),
                const SizedBox(height: 5),
                Text('financeiro', style: AppTextStyles.h6Regular()),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          )
        ],
      ),
    );
  }
}
