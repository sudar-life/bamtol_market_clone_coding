import 'package:bamtol_market_app/src/product/detail/controller/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ScrollAppbarWidget extends StatefulWidget {
  final Widget body;
  final List<Widget>? actions;
  final Widget? bottomNavBar;
  final Function() onBack;
  const ScrollAppbarWidget({
    super.key,
    required this.body,
    required this.onBack,
    this.bottomNavBar,
    this.actions,
  });

  @override
  State<ScrollAppbarWidget> createState() => _ScrollAppbarWidgetState();
}

class _ScrollAppbarWidgetState extends State<ScrollAppbarWidget> {
  ScrollController controller = ScrollController();
  int alpha = 0;
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        alpha = (controller.offset).clamp(0, 255).toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: widget.onBack,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/svg/icons/back.svg'),
          ),
        ),
        backgroundColor: const Color(0xff212123).withAlpha(alpha),
        elevation: 0,
        actions: widget.actions,
      ),
      backgroundColor: const Color(0xff212123),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: controller,
            child: widget.body,
          ),
          Container(
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff212123),
                  Color(0xff212123).withOpacity(0),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: widget.bottomNavBar,
    );
  }
}
