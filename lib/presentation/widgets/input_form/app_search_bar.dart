import 'package:e_health/app/helper/debounce.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppSearchBar extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final TextEditingController? controller;
  final VoidCallback? onClear;
  final EdgeInsetsGeometry? padding;

  const AppSearchBar({
    super.key,
    this.hintText = "Tìm kiếm...",
    required this.onChanged,
    this.controller,
    this.onClear,
    this.padding,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late TextEditingController _controller;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          _debouncer.run(() => widget.onChanged(value));
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: AppColors.textLight,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textSlate,
            size: 20,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged("");
                    widget.onClear?.call();
                    setState(() {});
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
