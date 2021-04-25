import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/hometoptabs.dart';
import '../providers/categories.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;

  @override
  Widget build(BuildContext context) {
    if (_isInit) {
      Provider.of<Categories>(context).fetchCategories();
    }
    _isInit = false;

    final catProvider = Provider.of<Categories>(context, listen: false);

    List loadedList = catProvider.items;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: loadedList.length,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: AppBar(
                    backgroundColor: Colors.grey[100],
                    bottom: TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.blue[700],
                      // height of line under tap
                      indicatorWeight: 4.0,

                      tabs:
                          List<Widget>.generate(loadedList.length, (int index) {
                        return new Tab(
                          child: Container(
                            child: Text(
                              loadedList[index].categoryName,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                body: TabBarView(
                    children: List<Widget>.generate(
                  loadedList.length,
                  (int index) {
                    return new HomeTopTabs(loadedList[index].id);
                  },
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
