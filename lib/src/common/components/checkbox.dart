import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CheckBox extends StatelessWidget {
  final String label;
  final bool isChecked;
  final Function() toggleCallBack;
  const CheckBox({
    super.key,
    required this.label,
    required this.toggleCallBack,
    this.isChecked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleCallBack,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: isChecked
                      ? const Color(0xffFD6F1F)
                      : const Color(0xff3C3C3E),
                ),
                color: isChecked
                    ? const Color(0xffFD6F1F)
                    : const Color(0xff3C3C3E).withOpacity(0)),
            width: 24,
            height: 24,
            child: isChecked
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset('assets/svg/icons/checked.svg'),
                  )
                : Container(),
          ),
          const SizedBox(width: 7),
          AppFont(
            label,
            color: Colors.white,
            size: 16,
          )
        ],
      ),
    );
  }
}
