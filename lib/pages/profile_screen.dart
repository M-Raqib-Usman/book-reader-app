import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 👤 Avatar
            CircleAvatar(
              radius: 45,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: const Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 12),

            // 📧 User Email (from Firebase)
            Text(
              user?.email ?? 'No user logged in',
              style: theme.textTheme.titleMedium,
            ),

            const SizedBox(height: 30),

            // 📚 Saved Books
            Card(
              child: ListTile(
                leading: const Icon(Icons.bookmark),
                title: const Text('Saved Books'),
                onTap: () {
                  // Optional: navigate to saved tab
                },
              ),
            ),

            // ❤️ Favorite Books
            Card(
              child: ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Favorite Books'),
                onTap: () {
                  // Optional: navigate to favorites tab
                },
              ),
            ),

            // 🚪 Logout
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();

                  // Clear navigation stack and go to login
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                        (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
