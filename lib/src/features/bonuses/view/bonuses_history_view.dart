import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/date_time_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/int_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
import 'package:dodo_clone/src/features/bonuses/bloc/bonuses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:person_repository/person_repository.dart';

class BonusesHistoryView extends StatelessWidget {
  final BuildContext parentContext;
  const BonusesHistoryView({Key? key, required this.parentContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBluePurple,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 25,
          onPressed: AppRouter.instance().popTop,
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: const Text(
          'История',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            AppImages.splashImage,
            fit: BoxFit.fitHeight,
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.mainBluePurple,
                  AppColors.bgLightOrange.withOpacity(0.93),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.54, 0.9],
              ),
            ),
          ),
          BlocBuilder<BonusesBloc, BonusesState>(
            bloc: BlocProvider.of(parentContext),
            builder: (context, state) {
              final operations = state.coinsOperations;
              if (operations == null) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                );
              }
              final height = MediaQuery.of(context).size.height;
              return SingleChildScrollView(
                child: SizedBox(
                  height: height,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      if (index == operations.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: height * 0.05),
                          child: const Center(
                            child: Text(
                              'Всё, записей больше нет',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                      final operation = operations[index];
                      final sign = operation.type.isReceived ? '+' : '-';
                      return ListTile(
                        textColor: Colors.white,
                        title: Text(operation.title),
                        subtitle: Text(operation.dateTime.bonusHistoryFormat),
                        trailing: Text('$sign${operation.coins.coins}'),
                      );
                    },
                    itemCount: operations.length + 1,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
