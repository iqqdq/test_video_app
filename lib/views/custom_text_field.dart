import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextViewWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String? placeholder;

  const TextViewWidget({
    Key? key,
    required this.textEditingController,
    required this.focusNode,
    this.placeholder,
  }) : super(key: key);

  @override
  State<TextViewWidget> createState() => _TextViewState();
}

class _TextViewState extends State<TextViewWidget> {
  @override
  Widget build(BuildContext context) {
    final textFormField = TextFormField(
      focusNode: widget.focusNode,
      controller: widget.textEditingController,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontSize: 14.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        counterText: '',
        hintText: widget.placeholder,
        hintStyle: const TextStyle(
          fontSize: 14.0,
          color: Color.fromRGBO(102, 102, 102, 1.0),
        ),
        icon: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: SvgPicture.asset('assets/search.svg'),
        ),
        suffixIcon: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () => {},
            icon: const Icon(Icons.clear, color: Colors.transparent)),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      onTap: () => setState(() {}),
      onEditingComplete: () => {
        setState(() {}),
        FocusScope.of(context).unfocus(),
      },
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            width: 1.0,
            color:
                widget.focusNode.hasFocus ? Colors.black : Colors.transparent),
        color: const Color.fromRGBO(245, 245, 245, 1.0),
      ),
      child: textFormField,
    );
  }
}
