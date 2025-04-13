import 'package:flutter/material.dart';
import 'package:chayil/domain/models/categories/category.dart';
import 'package:chayil/domain/repositories/menu_repository.dart';
import 'package:chayil/utilities/components/alert_dialog.dart';
import 'package:chayil/utilities/components/loading_widget.dart';
import 'package:chayil/utilities/components/menu_item.dart';
import 'package:chayil/utilities/styles/colors.dart';
import 'package:chayil/presentation/categories/category_details_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin {
  List<Category> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var list = await MenuRepository().loadCategories();
      if (mounted) {
        setState(() {
          _categories = list.categories;
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Categories"),
        ),
        body: Stack(children: [
          ListView.separated(
              itemBuilder: (context, index) {
                return MenuItem(
                  text: _categories[index].name,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CategoryDetailsPage(category: _categories[index]),
                    ));
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(color: separatorColor);
              },
              itemCount: _categories.length),
          if (_isLoading) const LoadingWidget(),
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}
