import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';
import 'database/app_database.dart';
import 'repository/counter_repository.dart';
import 'services/api_service.dart';
import 'services/network_service.dart';
import 'services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  final repository = CounterRepository(database: database);
  final apiService = ApiService();
  final networkService = NetworkService();
  final syncService = SyncService(
    database: database,
    apiService: apiService,
    networkService: networkService,
  );

  runApp(
    MyApp(
      repository: repository,
      syncService: syncService,
      networkService: networkService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final CounterRepository repository;
  final SyncService syncService;
  final NetworkService networkService;

  const MyApp({
    Key? key,
    required this.repository,
    required this.syncService,
    required this.networkService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App - Offline First',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) {
          final bloc = CounterBloc(
            repository: repository,
            syncService: syncService,
          );

          bloc.add(LoadCounterEvent());

          networkService.connectionStatus().listen((isOnline) {
            bloc.add(ConnectionStatusChangedEvent(isOnline: isOnline));
          });

          return bloc;
        },
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter BLoC App - Offline First'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Counter Value:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Text(
                      '${state.counterValue}',
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: state.isOnline ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.isOnline ? '🟢 Online' : '🟠 Offline',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (state.syncMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.syncMessage!,
                        style: TextStyle(
                          fontSize: 14,
                          color: state.isSyncing ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                    if (state.isSyncing)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<CounterBloc>().add(DecrementEvent());
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrement'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<CounterBloc>().add(IncrementEvent());
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Increment'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                const Text(
                  'API Operations:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<CounterBloc>().add(PullFromApiEvent());
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Pull'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<CounterBloc>().add(PushToApiEvent());
                      },
                      icon: const Icon(Icons.upload),
                      label: const Text('Push'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
