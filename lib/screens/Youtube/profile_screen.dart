import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  late String userName;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = supabase.auth.user();
    if (user != null) {
      setState(() {
        userName = user.email?.split('@')[0] ?? 'DefaultUsername';
        // Handle null safety here
        userEmail = user.email ?? 'DefaultEmail@example.com';
      });
    }
  }

  Future<void> updateProfile(String newName) async {
    final user = supabase.auth.user();
    if (user != null) {
      final response = await supabase
          .from('profiles')
          .update({'name': newName})
          .eq('user_id', user.id)
          .single()
          .execute();

      if (response.error != null) {
        print('Error updating profile: ${response.error!.message}');
        // Handle error as needed, e.g., show error to user
      } else {
        print('Profile updated successfully');
        // Handle success, e.g., update local state or UI
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://www.example.com/default_profile.jpg', // Replace with actual default profile image URL
              ),
            ),
            SizedBox(height: 20),
            Text('Name'),
            TextFormField(
              initialValue: userName,
              onChanged: (value) {
                // Uncomment below to update instantly
                // updateProfile(value);
              },
              onFieldSubmitted: (value) {
                // Update name when submitted
                updateProfile(value);
              },
            ),
            SizedBox(height: 20),
            Text('Email'),
            Text(userEmail),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement sign out functionality
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
