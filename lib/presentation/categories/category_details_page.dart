import 'package:flutter/material.dart';
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
  _CategoryDetailsPageState createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  bool _isLoading = false;
  TechniquesByRank _techniquesByRank = TechniquesByRank(ranks: []);

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
          await TechniqueRepository().loadTechniquesByRank(widget.category.id);
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
        for (var technique in rank.techniques!) {
          technique.rank = rank;
        }
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
                      text: item.belt,
                      backgroundHex: item.primaryColor,
                      foregroundHex: item.secondaryColor,
                      imageUrl: item.image); // section header
                } else if (item is Technique) {
                  return TechniqueRow(
                      text: item.name,
                      colorHex: item.rank?.stripeColor ??
                          item.rank?.primaryColor ??
                          'FF0000',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TechniquePage(id: item.id),
                        ));
                      });
                }
                return Container(); // Fallback for unrecognized item types
              },
            ),
    );
  }
}
