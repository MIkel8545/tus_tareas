import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tus_tareas/pages/home.dart';
import 'package:tus_tareas/pages/pages.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new _NavigationModel(),
      child: Scaffold(
        body: _Pages(),
        bottomNavigationBar: _Navigation(),
      ),
    );
  }
}

class _Pages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationModel = Provider.of<_NavigationModel>(context);
    return PageView(
      controller: navigationModel._pageController,
      physics: BouncingScrollPhysics(),
      children: <Widget>[Teams(), Home(), Calendar()],
      onPageChanged: (index) {
        navigationModel.actualPage = index;
      },
    );
  }
}

class _Navigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationModel = Provider.of<_NavigationModel>(context);
    return BottomNavigationBar(
      currentIndex: navigationModel.actualPage,
      onTap: (index) {
        navigationModel.actualPage = index;
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Equipos'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: 'Tareas'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month), label: 'Calendario'),
      ],
      selectedItemColor: Colors.indigo,
      backgroundColor: Colors.black,
    );
  }
}

class _NavigationModel extends ChangeNotifier {
  int _actualPage = 0;
  PageController _pageController = new PageController();
  int get actualPage => this._actualPage;

  set actualPage(int valor) {
    this._actualPage = valor;

    _pageController.animateToPage(valor,
        duration: Duration(milliseconds: 250), curve: Curves.easeOut);

    notifyListeners();
  }

  PageController get pageController => this.pageController;
}
