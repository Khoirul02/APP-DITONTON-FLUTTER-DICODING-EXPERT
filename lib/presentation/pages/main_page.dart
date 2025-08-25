import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_show_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/provider/current_page_notifier.dart';
import 'package:ditonton/presentation/provider/header_title_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void _onDrawerItemTapped(Widget page, String title) {
    context.read<HeaderTitleNotifier>().changeHeaderTitle(title);
    context.read<CurrentPageNotifier>().changeCurrentPage(page);
    Navigator.pop(context); // Tutup drawer setelah memilih item
  }

  @override
  Widget build(BuildContext context) {
    String headerTitle = context.watch<HeaderTitleNotifier>().headerTitle;
    Widget currentPage = context.watch<CurrentPageNotifier>().currentPage;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            // Header drawer
            const UserAccountsDrawerHeader(
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                ),
              ),
            ),
            // Opsi untuk Serial TV
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('TV Show'),
              onTap: () => _onDrawerItemTapped(HomeTvShowPage(), 'TV Show'),
            ),
            // Opsi untuk Film
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () => _onDrawerItemTapped(HomeMoviePage(), 'Movies'),
            ),
            // Opsi untuk Watchlist (tetap navigasi ke halaman lain)
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
              },
            ),
            // Opsi untuk About
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(headerTitle),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: currentPage,
    );
  }
}
