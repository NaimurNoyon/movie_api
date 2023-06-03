import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;

  Movie({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.type,
    required this.poster,
  });
}

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<Movie> movieList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final String apiUrl =
        'https://www.omdbapi.com/?i=tt3896198&apikey=ef1814ef&s=captain';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['Response'] == 'True') {
          List<dynamic> searchResults = jsonData['Search'];

          setState(() {
            movieList = searchResults.map((result) {
              return Movie(
                title: result['Title'],
                year: result['Year'],
                imdbID: result['imdbID'],
                type: result['Type'],
                poster: result['Poster'],
              );
            }).toList();
          });
        } else {
          print('Error: ${jsonData['Error']}');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie List'),
      ),
      body: ListView.builder(
        itemCount: movieList.length,
        itemBuilder: (BuildContext context, int index) {
          Movie movie = movieList[index];

          return ListTile(
            leading: Image.network(movie.poster),
            title: Text(movie.title),
            subtitle: Text(movie.year),
            trailing: Text(movie.type),
          );
        },
      ),
    );
  }
}
