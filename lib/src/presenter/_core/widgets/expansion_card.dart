import 'package:flutter/material.dart';

class ExpansionCard extends StatefulWidget {
  final String title;
  final Widget body;
  final VoidCallback onAddTap;

  const ExpansionCard({
    super.key,
    required this.title,
    required this.body,
    required this.onAddTap,
  });

  @override
  State<ExpansionCard> createState() => _ExpansionCardState();
}

class _ExpansionCardState extends State<ExpansionCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final isExpandedNotifier = ValueNotifier<bool>(false);
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeInOut,
    );
  }

  void _toggleExpandCheck() {
    if (isExpandedNotifier.value) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: isExpandedNotifier,
      builder: (_, isExpanded, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                isExpandedNotifier.value = !isExpandedNotifier.value;
                _toggleExpandCheck();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          Text(
                            widget.title,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            onPressed: widget.onAddTap,
                            icon: Icon(
                              color: colorScheme.primary,
                              Icons.add,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        isExpandedNotifier.value = !isExpandedNotifier.value;
                        _toggleExpandCheck();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          key: Key(isExpanded.toString()),
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: animation,
              axisAlignment: 1.0,
              child: widget.body,
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
