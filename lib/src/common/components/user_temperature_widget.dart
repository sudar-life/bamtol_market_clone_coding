import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:flutter/material.dart';

class UserTemperatureWidget extends StatelessWidget {
  final double temperature;
  final bool isSimpled;
  const UserTemperatureWidget(
      {super.key, this.isSimpled = false, required this.temperature});
  final List<Color> colorTemp = const [
    Color(0xff7A8088),
    Color(0xff006CA5),
    Color(0xff0093E4),
    Color(0xff00C08D),
    Color(0xffFBB565),
    Color(0xffFF6229),
    Color.fromARGB(255, 254, 68, 0),
  ];
  final List<String> emojiTemp = const [
    '😨',
    '😟',
    '😶',
    '😊',
    '😀',
    '😄',
    '😄',
  ];

  @override
  Widget build(BuildContext context) {
    return isSimpled
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: colorTemp[(temperature / 15).toInt()].withOpacity(0.3),
            ),
            child: AppFont(
              '$temperature°C',
              fontWeight: FontWeight.bold,
              color: colorTemp[(temperature / 15).toInt()],
              size: 10,
            ))
        : Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppFont(
                    '$temperature°C',
                    fontWeight: FontWeight.bold,
                    size: 18,
                    color: colorTemp[(temperature / 15).toInt()],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 50,
                      height: 5,
                      color: Color(0xff34373C),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: temperature / 100 * 50,
                          height: 5,
                          color: colorTemp[(temperature / 15).toInt()],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 6),
              AppFont(
                emojiTemp[(temperature / 15).toInt()],
                fontWeight: FontWeight.bold,
                size: 30,
              )
            ],
          );
  }
}
