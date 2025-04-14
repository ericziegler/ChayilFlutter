import 'package:flutter/material.dart';
import 'package:chayil/domain/repositories/technique_repository.dart';
import 'package:chayil/domain/models/categories/category.dart';
import 'package:chayil/domain/models/ranks/rank.dart';
import 'package:chayil/utilities/components/alert_dialog.dart';
import 'package:chayil/domain/models/techniques/techniques_by_rank.dart';
import 'package:chayil/domain/models/techniques/technique.dart';
import 'package:chayil/utilities/components/technique_header_row.dart';
import 'package:chayil/utilities/components/technique_row.dart';
import 'package:chayil/presentation/techniques/technique_page.dart';

class CategoryDetailsPage extends StatefulWidget {
  final Category category;
  const CategoryDetailsPage({Key? key, required this.category})
      : super(key: key);

  @override
  CategoryDetailsPageState createState() => CategoryDetailsPageState();
}

class CategoryDetailsPageState extends State<CategoryDetailsPage> {
  final _techniqueRepository = TechniqueRepository();
  bool _isLoading = false;
  TechniquesByRank _techniquesByRank = TechniquesByRank(ranks: []);
  final Map<String, Rank> _rankCache = {};

  @override
  void initState() {
    super.initState();
    _loadTechniques();
  }

  void _loadTechniques() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var groups =
          await _techniqueRepository.getTechniquesByRank(widget.category.id);
      if (mounted) {
        setState(() {
          _techniquesByRank = groups;
        });
      }
    } catch (e) {
      if (mounted) {
        showErrorAlert(
            context, "We were unable to load categories at this time.");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Object> _generateItems(TechniquesByRank data) {
    List<Object> items = [];
    for (var rank in data.ranks!) {
      items.add(rank); // Adding rank as a section header
      if (rank.techniques != null) {
        items.addAll(rank.techniques!); // Adding techniques as rows
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    List<Object> items = _generateItems(_techniquesByRank);

    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                if (item is Rank) {
                  return TechniqueHeaderRow(
                      text: item.name,
                      backgroundHex: item.primaryColor,
                      foregroundHex: item.secondaryColor,
                      borderHex: item.stripeColor,
                      imageAsset:
                          'assets/images/${item.imageAsset}'); // section header
                } else if (item is Technique) {
                  final rank = _rankCache[item.rankId];

                  if (rank != null) {
                    return TechniqueRow(
                      text: item.name,
                      colorHex: rank.primaryColor ?? 'FF0000',
                      stripeHex: rank.stripeColor,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TechniquePage(id: item.id),
                        ));
                      },
                    );
                  } else {
                    // Fetch the rank async, then rebuild
                    _techniqueRepository
                        .getRank(item.rankId)
                        .then((fetchedRank) {
                      if (mounted) {
                        setState(() {
                          _rankCache[item.rankId] = fetchedRank;
                        });
                      }
                    });

                    return const ListTile(
                      title: Text("Loading..."),
                      dense: true,
                    );
                  }
                }
                return Container(); // Fallback for unrecognized item types
              },
            ),
    );
  }
}
