import 'package:corremundos/common/widgets/skeleton.dart';
import 'package:flutter/cupertino.dart';

class TripsCardSkeleton extends StatelessWidget {
  const TripsCardSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Skeleton(height: 200, width: 170),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 16 / 2),
              Skeleton(width: 120),
              SizedBox(height: 100),
              Skeleton(width: 120),
              SizedBox(height: 16 / 2),
              Skeleton(width: 180),
              SizedBox(height: 16 / 2),
            ],
          ),
        )
      ],
    );
  }
}
