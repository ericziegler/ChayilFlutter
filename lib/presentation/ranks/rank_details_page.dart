import 'package:flutter/material.dart';
import 'package:chayil/domain/repositories/technique_repository.dart';
import 'package:chayil/domain/models/categories/category.dart';
import 'package:chayil/domain/models/ranks/rank.dart';
import 'package:chayil/utilities/components/alert_dialog.dart';
import 'package:chayil/domain/models/techniques/techniques_by_category.dart';
import 'package:chayil/domain/models/techniques/technique.dart';
import 'package:chayil/utilities/components/technique_header_row.dart';
import 'package:chayil/utilities/components/technique_row.dart';
import 'package:chayil/presentation/techniques/technique_page.dart';

class RankDetailsPage extends StatefulWidget {
  final Rank rank;
  const RankDetailsPage({Key? key, required this.rank}) : super(key: key);

  @override
  RankDetailsPageState createState() => RankDetailsPageState();
}

class RankDetailsPageState extends State<RankDetailsPage> {
  final _techniqueRepository = TechniqueRepository();
  bool _isLoading = false;
  TechniquesByCategory _techniquesByCategory =
      TechniquesByCategory(categories: []);

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
          await _techniqueRepository.getTechniquesByCategory(widget.rank.id);
      if (mounted) {
        setState(() {
          _techniquesByCategory = groups;
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

  List<Object> _generateItems(TechniquesByCategory data) {
    List<Object> items = [];
    for (var category in data.categories!) {
      items.add(category); // Adding category as a section header
      items.addAll(category.techniques!); // Adding techniques as rows
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    List<Object> items = _generateItems(_techniquesByCategory);

    return Scaffold(
      appBar: AppBar(title: Text(widget.rank.name)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                if (item is Category) {
                  return TechniqueHeaderRow(
                    text: item.name,
                    backgroundHex: widget.rank.primaryColor,
                    foregroundHex: widget.rank.secondaryColor,
                    borderHex: widget.rank.stripeColor,
                  ); // section header
                } else if (item is Technique) {
                  return TechniqueRow(
                      text: item.name,
                      colorHex: widget.rank.primaryColor,
                      stripeHex: widget.rank.stripeColor,
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
