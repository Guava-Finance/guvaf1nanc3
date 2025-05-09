import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/resources/util/connection_listener.dart';
import 'package:guava/core/resources/util/permission.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/features/account/presentation/pages/account_page.dart';
import 'package:guava/features/dashboard/presentation/notifier/bottom_nav_notifier.dart';
import 'package:guava/features/dashboard/presentation/notifier/dashboard.notifier.dart';
import 'package:guava/features/dashboard/presentation/widgets/bottom/nav.dart';
import 'package:guava/features/home/presentation/pages/home_page.dart';

// Provider for dashboard initialization state
final dashboardInitProvider = StateProvider<AsyncValue<bool>>((ref) {
  return const AsyncValue.loading();
});

// Isolate message data structure
class DashboardInitMessage {
  final SendPort sendPort;

  const DashboardInitMessage(this.sendPort);
}

// Isolate response data structure
class DashboardInitResult {
  final bool success;
  final String? error;

  const DashboardInitResult({required this.success, this.error});
}

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  // List of screens as a constant
  static const List<Widget> _screens = [
    HomePage(),
    AccountPage(),
  ];

  Completer<void>? _initCompleter;

  @override
  void initState() {
    super.initState();

    _initializeInBackground();
  }

  // Move heavy initialization to separate method
  Future<void> _initializeInBackground() async {
    _initCompleter = Completer<void>();

    // Set loading state
    ref.read(dashboardInitProvider.notifier).state = const AsyncValue.loading();

    try {
      // Listen for connectivity status
      ref.read(connectivityStatusProvider);

      // Start the heavy initialization in an isolate
      await _startInitializationIsolate();

      // Mark initialization as complete
      if (!_initCompleter!.isCompleted) {
        _initCompleter!.complete();

        // Call performBackgroundOperations to execute the background tasks
        performBackgroundOperations();
      }
    } catch (e) {
      // Handle errors
      ref.read(dashboardInitProvider.notifier).state =
          AsyncValue.error(e, StackTrace.current);
      if (!_initCompleter!.isCompleted) {
        _initCompleter!.completeError(e);
      }
    }
  }

  Future<void> _startInitializationIsolate() async {
    final receivePort = ReceivePort();

    await Isolate.spawn(
      _isolateInitialization,
      DashboardInitMessage(receivePort.sendPort),
    );

    final result = await receivePort.first as DashboardInitResult;

    if (result.success) {
      ref.read(dashboardInitProvider.notifier).state =
          const AsyncValue.data(true);

      // Now that initialization is done, request permissions
      Future.delayed(Durations.extralong4, () {
        ref
            .read(permissionManagerProvider)
            .requestCameraAndNotificationPermissions();
      });
    } else {
      throw Exception(result.error ?? 'Unknown initialization error');
    }
  }

  // Static function to run in isolate
  static void _isolateInitialization(DashboardInitMessage message) async {
    try {
      // Send success result back
      message.sendPort.send(const DashboardInitResult(success: true));
    } catch (e) {
      // Send error result back
      message.sendPort.send(DashboardInitResult(
        success: false,
        error: e.toString(),
      ));
    }
  }

  void performBackgroundOperations() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only perform these operations after initialization
      _initCompleter?.future.then((_) {
        ref.read(dashboardNotifierProvider).checkNCreateUSDCAccount();
        ref.read(dashboardNotifierProvider).hasLocationChanged();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch initialization state
    final initState = ref.watch(dashboardInitProvider);
    final selectedIndex = ref.watch(bottomNavProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: initState.when(
          loading: () => const DashboardLoadingView(),
          error: (error, stackTrace) => DashboardErrorView(
            error: error,
            onRetry: _initializeInBackground,
          ),
          data: (_) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: _screens[selectedIndex],
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(initState, selectedIndex),
      ),
    );
  }

  Widget _buildBottomNavBar(AsyncValue<bool> initState, int selectedIndex) {
    // Use standard height values to avoid layout thrashing
    final double navBarHeight = Platform.isIOS ? 100.h : 70.h;

    return Container(
      height: navBarHeight,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: BrandColors.textColor.withValues(alpha: .3),
          ),
        ),
      ),
      child: initState.maybeWhen(
        data: (_) => const BottomNavigator(),
        orElse: () => 0.verticalSpace,
      ),
    );
  }
}

// Loading state widget
class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Setting up your dashboard...'),
        ],
      ),
    );
  }
}

// Error view widget
class DashboardErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const DashboardErrorView({
    required this.error,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to initialize dashboard',
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
