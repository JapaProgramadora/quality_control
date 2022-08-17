import 'package:control/components/item_widget.dart';
import 'package:control/models/method_list.dart';
import 'package:control/models/stage_item.dart';
import 'package:control/models/stages_item_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StageItemGrid extends StatefulWidget {
  final String matchmakingId;
  const StageItemGrid({ Key? key, required this.matchmakingId}) : super(key: key);

  @override
  State<StageItemGrid> createState() => _StageItemGridState();
}

class _StageItemGridState extends State<StageItemGrid> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<MethodList>(
      context,
      listen: false,
    ).loadMethod().then((value) {
      setState(() {
       _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StagesList>(context);
    final List<Items> item = provider.testItems(widget.matchmakingId);

    return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: item.length,
          itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
            value: item[i],
            child: const ItemWidget(),
          ),
        ),
    );
  }
}