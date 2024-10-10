import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_build_balancer/core/localization/l10n.dart';
import 'package:team_build_balancer/core/utils/core_utils.dart';
import 'package:team_build_balancer/src/skills/presentation/skills_screen.dart';
import 'package:team_build_balancer/src/sports/domain/model/sports.dart';
import 'package:team_build_balancer/src/sports/presentation/bloc/sports_bloc.dart';
import 'package:team_build_balancer/src/sports/presentation/views/widgets/sports_item_card.dart';

class SportsScreen extends StatefulWidget {
  const SportsScreen({Key? key}) : super(key: key);
  static const String routeName = '/sports';

  @override
  State<SportsScreen> createState() => _SportsScreenState();
}

class _SportsScreenState extends State<SportsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SportsBloc>().add(GetSportsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('appTitle')),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocConsumer<SportsBloc, SportsState>(
        builder: (context, state) {
          if (state is SportsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SportsListLoaded) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: state.sports.length,
                itemBuilder: (context, index) {
                  return SportsItemCard(
                    imageUrl: state.sports[index].image ?? '',
                    title: state.sports[index].name,
                    onTap: () {
                      final sport = state.sports[index];
                      _handleSportSelection(context, sport);
                    },
                  );
                },
              ),
            );
          } else if (state is SportsError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text(AppLocalizations.of(context)!.translate('noDataAvailable')));
        },
        listener: (context, state) {
          if (state is SportsLoading) {
          } else if (state is SportsListLoaded) {
          } else if (state is SportsError) {
            CoreUtils.showSnackBar(context, state.message);
          }
        },
      ),
    );
  }

  void _handleSportSelection(BuildContext context, SportsModel sport) {
    Navigator.pushNamed(
      context,
      SkillsScreen.routeName,
      arguments: sport,
    );
  }
}
