import 'package:flutter/material.dart';

class Expandabletext extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const Expandabletext({
    super.key,
    required this.text,
    this.style,
  });

  @override
  State<Expandabletext> createState() => _ExpandabletextState();
}

class _ExpandabletextState extends State<Expandabletext> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller;
  late final Animation<double> _iconRotation;

  late final String _firstParagraph;
  late final bool _hasMore;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _iconRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Dividir el texto por doble salto de línea para encontrar el primer párrafo
    final parts = widget.text.split(RegExp(r'\n\s*\n'));
    _firstParagraph = parts.first.trim();
    _hasMore = parts.length > 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
    _expanded ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _expanded ? widget.text : _firstParagraph;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Text(
            displayText,
            style: widget.style,
            textAlign: TextAlign.justify,
          ),
        ),
        if (_hasMore)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _toggleExpanded,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _expanded ? 'Leer menos' : 'Leer más',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 4),
                    RotationTransition(
                      turns: _iconRotation,
                      child: const Icon(Icons.expand_more, size: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
