import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rate_my_anime/api/reply_api.dart';
import 'package:rate_my_anime/api/review_api.dart';
import 'package:rate_my_anime/models/person.dart';
import 'package:rate_my_anime/models/reply.dart';
import 'package:rate_my_anime/models/review.dart';
import 'package:rate_my_anime/services/size_services/size_service.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';
import 'package:rate_my_anime/uis/reply_ui/reply_bloc.dart';

class ReplyUI extends StatefulWidget {
  final Person person;
  final Review review;
  const ReplyUI({
    Key? key,
    required this.person,
    required this.review,
  }) : super(key: key);

  @override
  State<ReplyUI> createState() => _ReplyUIState();
}

class _ReplyUIState extends State<ReplyUI> {
  TextEditingController textEditingController = TextEditingController();
  ReplyBloc replyBloc = ReplyBloc();

  List<Reply> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    replyBloc.update(widget.review.id, "0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              key: widget.key,
              slivers: [
                SliverAppBar(
                  key: widget.key,
                  pinned: true,
                  title: Text(
                    "Review",
                    key: widget.key,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        widget.review.person.displayImage!
                                                .isEmpty
                                            ? CircleAvatar(
                                                backgroundColor:
                                                    ThemeService.primary,
                                                child: Text(
                                                  widget.review.person
                                                      .firstName[0]
                                                      .toUpperCase(),
                                                  style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w900,
                                                    color: ThemeService.light,
                                                  ),
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    widget.review.person
                                                        .displayImage!),
                                              ),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          "${widget.review.person.firstName} ${widget.review.person.lastName}",
                                          style: GoogleFonts.lato(
                                            fontSize: 14.0,
                                            color:
                                                ThemeService.isDarkMode(context)
                                                    ? ThemeService.light
                                                    : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      Intl()
                                          .date("MM/dd/yyyy hh:mm")
                                          .format(widget.review.createdAt),
                                      style: GoogleFonts.lato(
                                        fontSize: 10.0,
                                        color: ThemeService.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          isThreeLine: true,
                          subtitle: Text(
                            widget.review.message,
                            style: GoogleFonts.lato(
                              fontSize: 14.0,
                              color: ThemeService.isDarkMode(context)
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () async {
                                    await ReviewApi()
                                        .handleLikes(
                                            userId: widget.person.id,
                                            reviewId: widget.review.id)
                                        .then((value) async {
                                      setState(() {
                                        widget.review.likes!
                                                .contains(widget.person.id)
                                            ? widget.review.likes!
                                                .remove(widget.person.id)
                                            : widget.review.likes!
                                                .add(widget.person.id);
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: widget.review.likes!
                                            .contains(widget.person.id)
                                        ? ThemeService.primary
                                        : ThemeService.secondary,
                                  ),
                                  label: Text(
                                    widget.review.likes!.length.toString(),
                                    style: GoogleFonts.lato(
                                      color: widget.review.likes!
                                              .contains(widget.person.id)
                                          ? ThemeService.primary
                                          : ThemeService.secondary,
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () async {
                                    await ReviewApi()
                                        .handleDislikes(
                                            userId: widget.person.id,
                                            reviewId: widget.review.id)
                                        .then((value) async {
                                      setState(() {
                                        widget.review.dislikes!
                                                .contains(widget.person.id)
                                            ? widget.review.dislikes!
                                                .remove(widget.person.id)
                                            : widget.review.dislikes!
                                                .add(widget.person.id);
                                      });
                                    });
                                  },
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color: widget.review.dislikes!
                                            .contains(widget.person.id)
                                        ? ThemeService.danger
                                        : ThemeService.secondary,
                                  ),
                                  label: Text(
                                    widget.review.dislikes!.length.toString(),
                                    style: GoogleFonts.lato(
                                      color: widget.review.dislikes!
                                              .contains(widget.person.id)
                                          ? ThemeService.danger
                                          : ThemeService.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(
                          color: ThemeService.secondary,
                          thickness: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeService.width(context) * 0.03,
                        vertical: SizeService.height(context) * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Replies",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<List<Reply>>(
                    stream: replyBloc.stream,
                    initialData: const [],
                    builder: (context, replySnapshot) {
                      for (var each in replySnapshot.data!) {
                        if (!list.contains(each)) {
                          list.add(each);
                        }
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            Reply reply = list[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  reply.person.displayImage!.isEmpty
                                      ? CircleAvatar(
                                          backgroundColor: ThemeService.primary,
                                          child: Text(
                                            reply.person.firstName[0]
                                                .toUpperCase(),
                                            style: GoogleFonts.lato(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              color: ThemeService.light,
                                            ),
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              reply.person.displayImage!),
                                        ),
                                  const SizedBox(width: 5.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(
                                            Intl()
                                                .date("MM/dd/yyyy HH:mm")
                                                .format(reply.createdAt),
                                            style: GoogleFonts.lato(
                                              fontSize: 10.0,
                                              color: ThemeService.secondary,
                                            ),
                                          ),
                                        ),
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10.0),
                                                Text(
                                                  "${reply.person.firstName} ${reply.person.lastName}",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        ThemeService.isDarkMode(
                                                                context)
                                                            ? ThemeService.light
                                                            : Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 5.0),
                                                Text(
                                                  reply.message,
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14.0,
                                                    color:
                                                        ThemeService.isDarkMode(
                                                                context)
                                                            ? ThemeService.light
                                                            : Colors.black87,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    TextButton.icon(
                                                      onPressed: () async {
                                                        await ReplyApi()
                                                            .handleLikes(
                                                                userId: widget
                                                                    .person.id,
                                                                replyId:
                                                                    reply.id)
                                                            .then(
                                                                (value) async {
                                                          setState(() {
                                                            reply.likes!
                                                                    .contains(widget
                                                                        .person
                                                                        .id)
                                                                ? reply.likes!
                                                                    .remove(widget
                                                                        .person
                                                                        .id)
                                                                : reply.likes!
                                                                    .add(widget
                                                                        .person
                                                                        .id);
                                                          });
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.thumb_up,
                                                        size: 16.0,
                                                        color: reply.likes!
                                                                .contains(widget
                                                                    .person.id)
                                                            ? ThemeService
                                                                .primary
                                                            : ThemeService
                                                                .secondary,
                                                      ),
                                                      label: Text(
                                                        reply.likes!.length
                                                            .toString(),
                                                        style: GoogleFonts.lato(
                                                            color: reply.likes!
                                                                    .contains(
                                                                        widget
                                                                            .person
                                                                            .id)
                                                                ? ThemeService
                                                                    .primary
                                                                : ThemeService
                                                                    .secondary,
                                                            fontSize: 12.0),
                                                      ),
                                                    ),
                                                    TextButton.icon(
                                                      onPressed: () async {
                                                        await ReplyApi()
                                                            .handleDislikes(
                                                                userId: widget
                                                                    .person.id,
                                                                replyId:
                                                                    reply.id)
                                                            .then(
                                                                (value) async {
                                                          setState(() {
                                                            reply.dislikes!
                                                                    .contains(
                                                                        widget
                                                                            .person
                                                                            .id)
                                                                ? reply
                                                                    .dislikes!
                                                                    .remove(widget
                                                                        .person
                                                                        .id)
                                                                : reply
                                                                    .dislikes!
                                                                    .add(widget
                                                                        .person
                                                                        .id);
                                                          });
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.thumb_down,
                                                        size: 16.0,
                                                        color: reply.dislikes!
                                                                .contains(widget
                                                                    .person.id)
                                                            ? ThemeService
                                                                .danger
                                                            : ThemeService
                                                                .secondary,
                                                      ),
                                                      label: Text(
                                                        reply.dislikes!.length
                                                            .toString(),
                                                        style: GoogleFonts.lato(
                                                            color: reply
                                                                    .dislikes!
                                                                    .contains(
                                                                        widget
                                                                            .person
                                                                            .id)
                                                                ? ThemeService
                                                                    .danger
                                                                : ThemeService
                                                                    .secondary,
                                                            fontSize: 12.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: list.length,
                        ),
                      );
                    }),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeService.width(context) * 0.03),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: ThemeService.primary,
                      ),
                      onPressed: () {
                        replyBloc.update(
                          widget.review.id,
                          list.length.toString(),
                        );
                      },
                      child: const Text("Load more replies"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 8.0, top: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: ThemeService.secondary),
                    ),
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                        border: InputBorder.none,
                        hintText: "Write Reply...",
                        hintStyle: GoogleFonts.lato(
                          color: ThemeService.secondary,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {});
                      },
                      maxLines: 10,
                      minLines: 1,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: textEditingController.text.isEmpty
                      ? null
                      : () async {
                          await ReplyApi()
                              .create(
                            reviewId: widget.review.id,
                            message: textEditingController.text.trim(),
                            userId: widget.person.id,
                          )
                              .then((value) {
                            textEditingController.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                            replyBloc.update(
                                widget.review.id, list.length.toString());
                          });
                        },
                  icon: Icon(
                    Icons.send,
                    color: textEditingController.text.isEmpty
                        ? ThemeService.secondary
                        : ThemeService.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
