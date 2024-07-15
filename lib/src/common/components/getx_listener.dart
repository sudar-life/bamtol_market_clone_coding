import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetxListener<T> extends StatefulWidget {
  final Rx<T> stream;
  final Widget child;
  final Function(T) listen;
  final Function()? initCall;
  const GetxListener({
    super.key,
    this.initCall,
    required this.stream,
    required this.listen,
    required this.child,
  });

  @override
  State<GetxListener> createState() {
    stream.listen(listen);
    return _GetxListenerState();
  }
}

class _GetxListenerState extends State<GetxListener> {
  @override
  void initState() {
    super.initState();

    if (widget.initCall != null) {
      widget.initCall!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
