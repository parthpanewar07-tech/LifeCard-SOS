import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers.dart';

// Import screens (which we will create next)
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/sos/sos_screen.dart';
import '../../features/profile/profile_edit_screen.dart';
import '../../features/medical/medical_edit_screen.dart';
import '../../features/medical/medical_view.dart';
import '../../features/contacts/contact_add_edit_screen.dart';
import '../../features/contacts/contacts_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final settingsAsync = ref.watch(settingsProvider);
  final initialLocation = ref.watch(initialLocationProvider);

  return GoRouter(
    initialLocation: initialLocation,
    redirect: (context, state) {
      final settings = settingsAsync.value;
      if (settings == null) return null; // Wait until loaded

      final isSetupCompleted = settings.isSetupCompleted;
      final isGoingToOnboarding = state.matchedLocation == '/onboarding';

      if (!isSetupCompleted && !isGoingToOnboarding) {
        return '/onboarding';
      }
      if (isSetupCompleted && isGoingToOnboarding) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/sos',
        builder: (context, state) => const SosScreen(),
      ),

      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: '/medical/edit',
        builder: (context, state) => const MedicalEditScreen(),
      ),
      GoRoute(
        path: '/medical_view',
        builder: (context, state) => const MedicalView(),
      ),
      GoRoute(
        path: '/contacts/add',
        builder: (context, state) => const ContactAddEditScreen(),
      ),
      GoRoute(
        path: '/contacts_view',
        builder: (context, state) => const ContactsView(),
      ),
      GoRoute(
        path: '/contacts/edit/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ContactAddEditScreen(contactId: id);
        },
      ),
    ],
  );
});
