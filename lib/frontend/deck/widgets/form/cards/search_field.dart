import 'package:flutter/material.dart';

class CardSearchField extends StatefulWidget {
  final void Function(String) onChanged;

  CardSearchField({
    @required this.onChanged,
  }) : assert(onChanged != null);

  @override
  _CardSearchFieldState createState() {
    return _CardSearchFieldState();
  }
}

class _CardSearchFieldState extends State<CardSearchField> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: TextFormField(
        controller: searchController,

        decoration: const InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Szukaj wśród fiszek...',

          alignLabelWithHint: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      widget.onChanged(
        searchController.text.trim(),
      );
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }
}
