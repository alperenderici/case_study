import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iwallet_case_study/src/provider/user_provider.dart';
import 'package:iwallet_case_study/src/domain/user.dart';
import 'package:iwallet_case_study/src/home/user_item.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  bool isSearch = false;
  bool _searching = false;
  final TextEditingController searchTextController = TextEditingController();
  List<User> _filteredUsers = [];

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "iwallet case study",
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.blue[700]!,
                Colors.purple,
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 8,
              child: _buildSearchBar(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  color: Colors.orange[200],
                  child: CustomScrollView(
                    slivers: [
                      if (_searching)
                        const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        )
                      else if (isSearch && _filteredUsers.isNotEmpty)
                        ...buildSearchResults()
                      else if (isSearch)
                        SliverFillRemaining(
                          child: _buildNoUser,
                        )
                      else
                        ..._buildUserList(users),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 20,
          width: MediaQuery.of(context).size.width / 1.2,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.black,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(64.0),
            ),
          ),
          child: TextFormField(
            controller: searchTextController,
            cursorColor: Colors.black,
            onChanged: (value) {
              _search();
            },
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(left: 15, top: 10),
              suffixIcon: searchTextController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          searchTextController.clear();
                          isSearch = false;
                          _filteredUsers.clear();
                        });
                      },
                      child: Container(
                        height: 14,
                        width: 14,
                        // alignment: Alignment.center,
                        // padding: EdgeInsets.zero,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : null,
              hintText: "Kullanıcı Ara",
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildSearchResults() {
    /* if (_searching) {
      return <Widget>[
        const SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
        ),
      ];
    } */
    return <Widget>[
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final user = _filteredUsers[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: UserItem(user: user),
                ),
              ),
            );
          },
          childCount: _filteredUsers.length,
        ),
      ),
    ];
  }

  List<Widget> _buildUserList(List<User> users) {
    final displayedUsers = _filteredUsers.isEmpty ? users : _filteredUsers;

    return <Widget>[
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final user = displayedUsers[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: UserItem(user: user),
                ),
              ),
            );
          },
          childCount: displayedUsers.length,
        ),
      ),
    ];
  }

  Widget get _buildNoUser => const Center(
        child: Text(
          "Kullanıcı bulunamadı!",
        ),
      );

  Future<void> _search() async {
    final searchTerm = searchTextController.text.trim().toLowerCase();

    if (searchTerm.isEmpty) {
      setState(() {
        _filteredUsers.clear();
        _searching = false;
        isSearch = false;
      });
      return;
    }

    final users = ref.read(userProvider.notifier).state;

    setState(() {
      _searching = true;
      isSearch = true;
      _filteredUsers = users
          .where((user) => user.username!.toLowerCase().contains(searchTerm))
          .toList();
      _searching = false;
      if (_filteredUsers.isEmpty) {
        isSearch = true;
      }
    });
  }
}
