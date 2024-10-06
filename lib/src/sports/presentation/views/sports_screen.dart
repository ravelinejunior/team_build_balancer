import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_build_balancer/core/utils/core_utils.dart';
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
        title: const Text('Sports'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocConsumer<SportsBloc, SportsState>(
        builder: (context, state) {
          if (state is SportsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SportsListLoaded) {
            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.8,
              ),
              itemCount: state.sports.length,
              itemBuilder: (context, index) {
                return SportsItemCard(
                  imageUrl: state.sports[index].image ?? '',
                  title: state.sports[index].name,
                  onTap: () {
                    //TODO "Navigate to Skills screen and pass sports as data"
                  },
                );
              },
            );
          } else if (state is SportsError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No data available'));
        },
        listener: (context, state) {
          if (state is SportsLoading) {
            CoreUtils.showSnackBar(context, 'Loading');
          } else if (state is SportsListLoaded) {
            CoreUtils.showSnackBar(context, 'Loaded');
          } else if (state is SportsError) {
            CoreUtils.showSnackBar(context, state.message);
          }
        },
      ),
    );
  }
}
