import 'package:flutter/material.dart';

import 'details/detail.dart';

export 'details/detail.dart';

class Details extends StatelessWidget {
  final List<Detail> children;

  Details({
    @required this.children,
  }) : assert(children != null);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: children.length,

      itemBuilder: (context, index) {
        return children[index];
      },

      separatorBuilder: (context, index) {
        return const SizedBox(height: 20);
      },
    );
  }
}
