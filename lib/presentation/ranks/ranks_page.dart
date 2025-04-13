import 'package:flutter/material.dart';
import 'package:chayil/domain/models/ranks/rank.dart';
import '../../utilities/components/alert_dialog.dart';
import 'package:chayil/utilities/styles/colors.dart';
import 'package:chayil/utilities/components/loading_widget.dart';
import 'package:chayil/utilities/components/menu_item.dart';
import 'package:chayil/presentation/ranks/rank_details_page.dart';

class RanksPage extends StatefulWidget {
  const RanksPage({Key? key}) : super(key: key);

  @override
  _RanksPageState createState() => _RanksPageState();
}

class _RanksPageState extends State<RanksPage>
    with AutomaticKeepAliveClientMixin {
  List<Rank> _ranks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRanks();
  }

  void _loadRanks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var list = await MenuRepository().loadRanks();
      if (mounted) {
        setState(() {
          _ranks = list.ranks;
        });
      }
    } catch (e) {
      if (mounted) {
        showErrorAlert(
            context, "We were unable to load belt ranks at this time.");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Belts"),
        ),
        body: Stack(children: [
          ListView.separated(
              itemBuilder: (context, index) {
                return MenuItem(
                  text: _ranks[index].belt,
                  imageUrl: _ranks[index].image,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          RankDetailsPage(rank: _ranks[index]),
                    ));
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(color: separatorColor);
              },
              itemCount: _ranks.length),
          if (_isLoading) const LoadingWidget(),
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}
