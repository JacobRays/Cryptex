import 'package:flutter/material.dart';
import 'package:cryptex_malawi/theme/app_colors.dart';

class PinModal {
  static void show(
    BuildContext context, {
    String title = 'Enter PIN to Confirm',
    int minLength = 4,
    int maxLength = 6,
    required void Function(String pin) onSubmit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _PinModalContent(
          title: title,
          minLength: minLength,
          maxLength: maxLength,
          onSubmit: onSubmit,
        ),
      ),
    );
  }
}

class _PinModalContent extends StatefulWidget {
  final String title;
  final int minLength;
  final int maxLength;
  final void Function(String pin) onSubmit;

  const _PinModalContent({
    Key? key,
    required this.title,
    required this.minLength,
    required this.maxLength,
    required this.onSubmit,
  }) : super(key: key);

  @override
  __PinModalContentState createState() => __PinModalContentState();
}

class __PinModalContentState extends State<_PinModalContent> {
  String _pin = '';

  void _append(String d) {
    if (_pin.length < widget.maxLength) {
      setState(() {
        _pin += d;
      });
    }
  }

  void _back() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  bool get _isValid => _pin.length >= widget.minLength;

  @override
  Widget build(BuildContext context) {
    final max = widget.maxLength;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(max, (idx) {
              bool filled = idx < _pin.length;
              return Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: filled ? AppColors.primary : AppColors.border,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          _buildKeypad(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isValid
                      ? () {
                          Navigator.pop(context);
                          widget.onSubmit(_pin);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Confirm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    final digits = ['1','2','3','4','5','6','7','8','9','0'];
    return SizedBox(
      height: 260,
      child: GridView.builder(
        itemCount: digits.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.5,
        ),
        itemBuilder: (context, index) {
          if (index < digits.length) {
            final d = digits[index];
            return ElevatedButton(
              onPressed: () => _append(d),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text(d, style: const TextStyle(color: Colors.white, fontSize: 20)),
            );
          } else {
            // Backspace button
            return ElevatedButton(
              onPressed: _pin.isNotEmpty ? _back : null,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.surface),
              child: const Icon(Icons.backspace, color: Colors.white),
            );
          }
        },
      ),
    );
  }
}
