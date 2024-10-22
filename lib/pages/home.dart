import 'package:flutter/material.dart';
import 'package:quickup_app/backend/functions.dart';
import 'package:quickup_app/components/appbar.dart';
import 'package:quickup_app/components/newsbox.dart';
import 'package:quickup_app/components/searchbar.dart' as CustomSearchBar;
import 'package:quickup_app/utils/colors.dart';
import 'package:quickup_app/utils/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List> news;

  @override
  void initState() {
    super.initState();
    news = fetchnews(); // Initially fetch top headlines with no specific query
  }

  // This function will be called by the SearchBar when the search button is pressed
  void handleSearch() {
    setState(() {
      news = fetchnews(); // Re-fetch the news, assuming fetchnews already considers SearchBar state
    });
  }

  // Intercept back button press to clear the search and refetch news
  Future<bool> _onWillPop() async {
    if (CustomSearchBar.SearchBar.searchcontroller.text.isNotEmpty) {
      setState(() {
        CustomSearchBar.SearchBar.searchcontroller.clear(); // Clear the search text
        news = fetchnews(); // Re-fetch news with empty search text
      });
      return false; // Prevent default back navigation
    }
    return true; // Allow normal back navigation if search is already empty
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop, // Intercept the back button press
      child: Scaffold(
        appBar: appbar(), // Re-added your appbar
        body: Container(
          // Apply gradient background
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 21, 15, 23), // Darker shade at the top
                Color(0xFF000000), // Black at the bottom
              ],
            ),
          ),
          child: Column(
            children: [
              // Pass the handleSearch function as a callback to SearchBar
              CustomSearchBar.SearchBar(onSearch: handleSearch),
              Expanded(
                child: Container(
                  width: w,
                  child: FutureBuilder<List>(
                    future: news, // Use the news future variable
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return NewsBox(
                              url: snapshot.data![index]['url'],
                              imageurl: snapshot.data![index]['urlToImage'] != null
                                  ? snapshot.data![index]['urlToImage']
                                  : Constants.imageurl,
                              title: snapshot.data![index]['title'],
                              time: snapshot.data![index]['publishedAt'],
                              description: snapshot.data![index]['description'].toString(),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      // By default, show a loading spinner.
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
