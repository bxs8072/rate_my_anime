import 'package:flutter/material.dart';
import 'package:rate_my_anime/api/favorite_api.dart';
import 'package:rate_my_anime/custom_widgets/anime_tile/anime_tile.dart';
import 'package:rate_my_anime/models/favorite.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';

class ListUI extends StatefulWidget {
  final String status;
  final Person person;
  const ListUI({Key? key, required this.person, required this.status})
      : super(key: key);

  @override
  State<ListUI> createState() => _ListUIState();
}

class _ListUIState extends State<ListUI> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Favorite>?>(
        future: FavoriteApi()
            .retrieveAll(status: widget.status, userId: widget.person.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                key: widget.key,
                color: ThemeService.primary,
              ),
            );
          }
          List<Favorite> list = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    Favorite favorite = list[i];
                    return AnimeTile(
                        anime: favorite.anime, person: widget.person);
                  },
                  childCount: list.length,
                ),
              ),
            ],
          );
        });
  }
}
