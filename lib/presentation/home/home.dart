import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:plextractor/presentation/home/library_section_widget.dart';
import 'package:plextractor/presentation/home/selection_drawer.dart';
import 'package:plextractor/presentation/home/text_input.dart';
import 'package:plextractor/viewmodels/plex_cubit.dart';
import 'package:plextractor/viewmodels/plex_library.dart';
import 'package:plextractor/viewmodels/plex_state.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isAboveHalfWay = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => setState(() {}));
    scrollController.addListener(() {
      final halfWay = scrollController.position.maxScrollExtent / 2;
      final currentScrollPosition = scrollController.position.pixels;
      setState(() {
        isAboveHalfWay = currentScrollPosition < halfWay;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        progressIndicatorTheme: const ProgressIndicatorThemeData(),
      ),
      home: BlocBuilder<PlexCubit, PlexState>(builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.small(
            child: Icon(
                isAboveHalfWay ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: () {
              scrollController.jumpTo(isAboveHalfWay
                  ? scrollController.position.maxScrollExtent
                  : 0);
            },
          ),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 178, 193, 201),
            title: TextInput(
              controller: searchController,
              hintText: "Search...",
            ),
          ),
          drawer: const SelectionDrawer(),
          backgroundColor: const Color.fromARGB(255, 178, 193, 201),
          body: SafeArea(
            child: state.libraries.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: RawScrollbar(
                          thumbColor: const Color.fromARGB(255, 14, 25, 74),
                          controller: scrollController,
                          trackVisibility: true,
                          thumbVisibility: true,
                          thickness: 10,
                          child: CustomScrollView(
                            controller: scrollController,
                            slivers: [
                              ...state.libraries
                                  .filterByName(searchController.text)
                                  .filterByQuality(state.show4k, state.show1080,
                                      state.showOther)
                                  .map(
                                    (e) => e.visible
                                        ? LibrarySectionWidget(library: e)
                                        : SliverStickyHeader(),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(state.error ??
                        "No Data found, Open the menu to Connect"),
                  ),
          ),
        );
      }),
    );
  }
}

final globalNavigatorKey = GlobalKey<NavigatorState>();
