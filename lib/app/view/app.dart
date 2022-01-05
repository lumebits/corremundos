import 'package:auth_repository/auth_repository.dart';
import 'package:corremundos/app/bloc/app_bloc.dart';
import 'package:corremundos/app/routes/routes.dart';
import 'package:corremundos/l10n/l10n.dart';
import 'package:corremundos/theme.dart';
import 'package:corremundos/trips/cubit/trips_cubit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trips_repository/trips_repository.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(key: key);

  final AuthRepository _authRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              authRepository: _authRepository,
            ),
          ),
          BlocProvider(
            create: (_) =>
                TripsCubit(FirebaseTripsRepository(), AuthRepository())
                  ..loadCurrentTrip()
                  ..loadMyTrips(),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AppStatus.authenticated) {
          context.read<TripsCubit>().loadCurrentTrip();
          context.read<TripsCubit>().loadMyTrips();
        }
      },
      child: MaterialApp(
        theme: theme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FlowBuilder<AppState>(
          state: context.select((AppBloc bloc) => bloc.state),
          onGeneratePages: onGenerateAppViewPages,
        ),
      ),
    );
  }
}
