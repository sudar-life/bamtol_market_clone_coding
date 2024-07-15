import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 1),
            SizedBox(height: 20),
            AppFont(
              '로딩중...',
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
