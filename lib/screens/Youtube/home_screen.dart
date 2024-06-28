import 'package:flutter/material.dart';
import 'package:Youtube_supabase/screens/Youtube/Youtube_video.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'video_screen.dart';
import 'profile_screen.dart'; // Import your ProfileScreen here

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeContent(), // Your Home content widget
    ProfileScreen(), // Your Profile screen widget
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<dynamic>> fetchVideos() async {
    final response = await supabase.from('videos').select().execute();
    if (response.error != null) {
      print('Error: ${response.error!.message}');
      throw response.error!;
    }
    print('Response Data: ${response.data}');
    return response.data as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchVideos(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No videos found.'));
        } else {
          List<dynamic> videos = snapshot.data!;
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return ListTile(
                title: Text(video['title'] ?? 'Untitled'),
                subtitle: Text(video['description'] ?? ''),
                leading: Image.network(video['thumbnail_url'] ??
                    'https://via.placeholder.com/150'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          YouTubeVideoScreen(videoUrl: video['url']),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
