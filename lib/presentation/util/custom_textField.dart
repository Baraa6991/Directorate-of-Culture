import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfield extends StatelessWidget {
  // ─── التحكم ───────────────────────────────────────────────
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final UndoHistoryController? undoController;

  // ─── الكيبورد ─────────────────────────────────────────────
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  // ─── الأسطر والحجم ────────────────────────────────────────
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;

  // ─── التنسيق ──────────────────────────────────────────────
  final double? inputTextSize;
  final Color? inputTextColor;
  final FontWeight? inputTextFontWeight;
  final TextAlign textAlign;
  final TextDirection? textDirection;

  // ─── الـ Cursor ────────────────────────────────────────────
  final Color? cursorColor;
  final bool? showCursor;

  // ─── الزخرفة ──────────────────────────────────────────────
  final String? hint;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefix;
  final String? suffix;
  final String? helperText;
  final String? errorText;
  final InputBorder? border;
  final Color? focusColor;

  // ─── السلوك ───────────────────────────────────────────────
  final bool obscureText;
  final String obscuringCharacter;
  final bool enableSuggestions;
  final bool enableInteractiveSelection;
  final bool autocorrect;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;

  // ─── الـ Callbacks ─────────────────────────────────────────
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;

  // ─── التمرير ──────────────────────────────────────────────
  final ScrollController? scrollController;

  const CustomTextfield({
    super.key,
    this.controller,
    this.focusColor, 
    this.focusNode,
    this.undoController,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.inputTextSize,
    this.inputTextColor,
    this.inputTextFontWeight,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.cursorColor,
    this.showCursor,
    this.hint,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.helperText,
    this.errorText,
    this.border,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.enableSuggestions = true,
    this.enableInteractiveSelection = true,
    this.autocorrect = true,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      undoController: undoController,
      keyboardType: obscureText ? TextInputType.visiblePassword : keyboardType,
      textInputAction: textInputAction,
      maxLines: obscureText ? 1 : (expands ? null : maxLines),
      minLines: expands ? null : minLines,
      expands: expands,
      maxLength: maxLength,
      style: TextStyle(
        fontSize: inputTextSize,
        color: inputTextColor,
        fontWeight: inputTextFontWeight,
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      cursorColor: cursorColor,
      showCursor: showCursor,
      selectionControls: MaterialTextSelectionControls(),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      scrollController: scrollController,
      decoration: InputDecoration(
        
        hintText: hint,
        labelText: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixText: prefix,
        suffixText: suffix,
        helperText: helperText,
        errorText: errorText,
        border: border,
        enabledBorder: border,
        focusedBorder: border?.copyWith(
          borderSide: BorderSide(
            color: focusColor!,
            width: 2,
          ),
        ),
      ),
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      enableSuggestions: obscureText ? false : enableSuggestions,
      autocorrect: obscureText ? false : autocorrect,
      enableInteractiveSelection: enableInteractiveSelection,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
    );
  }
}
