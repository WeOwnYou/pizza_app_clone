import 'dart:math';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/features/menu/bloc/menu_bloc/menu_bloc.dart';
import 'package:dodo_clone/src/features/menu/ui/widgets/product_card.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final TextEditingController _controller;
  late final String hintText;
  List<Product> _selectedProducts = [];
  int test = 0;

  @override
  void initState() {
    super.initState();
    final allProducts =
        context.read<MenuBloc>().state.deliverProducts;
    _controller = TextEditingController()
      ..addListener(() {
        if(_controller.text.length <= 1) {
          return;
        }
        setState(() {
          _selectedProducts = allProducts
              .where(
                (element) => (element.title.toLowerCase())
                    .contains(_controller.text.toLowerCase()),
              )
              .toList();
        });
      });
    hintText = allProducts[Random().nextInt(allProducts.length)].title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        leadingWidth: 15,
        leading: const SizedBox.shrink(),
        title: CupertinoSearchTextField(
          prefixIcon: const Icon(Icons.search),
          borderRadius: BorderRadius.circular(10),
          controller: _controller,
          suffixIcon: const Icon(Icons.close),
          placeholder: hintText,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 15,
              right: 7,
              left: 8,
            ),
            child: TextButton(
              child: const Text(
                'Отменить',
                style: TextStyle(fontSize: 15),
              ),
              onPressed: () async {
                await AppRouter.instance().popTop();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: Colors.orangeAccent,
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: ListView.builder(
        itemBuilder: (_, index) {
          return ProductCard.searched(product: _selectedProducts[index],
          );
        },
        itemCount: _selectedProducts.length,
      ),
    );
  }
}
