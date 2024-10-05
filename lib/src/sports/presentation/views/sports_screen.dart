import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_build_balancer/core/utils/core_utils.dart';
import 'package:team_build_balancer/src/sports/presentation/bloc/sports_bloc.dart';

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
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocConsumer<SportsBloc, SportsState>(
        builder: (context, state) {
          if (state is SportsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SportsListLoaded) {
            return ListView.builder(
              itemCount: state.sports.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(state.sports[index].name),
                    leading: SizedBox(
                      height: 120,
                      width: 120,
                      child:  CircleAvatar(
                        backgroundImage: NetworkImage(state.sports[index].image??''),
                      )
                    ),
                  ),
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
