import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mini_chat_application/utils/chat_utils.dart';
import 'chat_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isUsersTab = true;
  bool _showHeader = true;

  final List<String> users = [
    "Aarav Sharma","Vivaan Mehta","Diya Patel","Ananya Singh",
    "Kabir Verma","Riya Kapoor","Aditya Nair","Sneha Iyer",
    "Rahul Joshi","Meera Das","Arjun Malhotra","Ishita Roy",
    "Kunal Bansal","Priya Menon","Rohan Kulkarni",
    "Simran Kaur","Devansh Gupta","Neha Choudhary"
  ];

  final List<Map<String, dynamic>> chatHistory = [
    {"name":"Aarav Sharma","msg":"Are we meeting today?","time":"2m","unread":2},
    {"name":"Diya Patel","msg":"Sent files.","time":"5m","unread":0},
    {"name":"Kabir Verma","msg":"Call me.","time":"10m","unread":1},
    {"name":"Riya Kapoor","msg":"That was funny 😂","time":"15m","unread":0},
    {"name":"Aditya Nair","msg":"Reached home.","time":"20m","unread":0},
    {"name":"Sneha Iyer","msg":"Trip plan?","time":"25m","unread":3},
    {"name":"Rahul Joshi","msg":"Check this ","time":"30m","unread":0},
    {"name":"Meera Das","msg":"Good night ","time":"45m","unread":0},
    {"name":"Arjun Malhotra","msg":"Game tonight?","time":"1h","unread":0},
    {"name":"Ishita Roy","msg":"On my way.","time":"1h","unread":1},
    {"name":"Priya Menon","msg":"Meeting rescheduled","time":"3h","unread":0},
    {"name":"Rohan Kulkarni","msg":"Where are you?","time":"5h","unread":2},
    {"name":"Simran Kaur","msg":"See you soon!","time":"6h","unread":0},
    {"name":"Devansh Gupta","msg":"Project approved!","time":"8h","unread":0},
    {"name":"Neha Choudhary","msg":"Typing...","time":"1d","unread":0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: isUsersTab
          ? FloatingActionButton(
        backgroundColor: Colors.blue[800],
        onPressed: () {
          final newUser = "User ${users.length + 1}";
          setState(() => users.add(newUser));
          Utils.showFlushBar(context: context, message: "User has been added successfully!",backgroundColor: Colors.green.shade300);
        },
        child: const Icon(Icons.person_add, color: Colors.white),
      )
          : null,

      body: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _showHeader
                ? SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        _buildTabButton("Users", isUsersTab),
                        _buildTabButton("Chat History", !isUsersTab),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: isUsersTab
                ? _usersListWithScrollListener()
                : _chatHistoryList(),
          ),
        ],
      ),
    );
  }

  Widget _usersListWithScrollListener() {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction == ScrollDirection.reverse) {
          if (_showHeader) setState(() => _showHeader = false);
        } else if (notification.direction == ScrollDirection.forward) {
          if (!_showHeader) setState(() => _showHeader = true);
        }
        return true;
      },
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => _userItem(users[index], index),
      ),
    );
  }

  Widget _chatHistoryList() {
    return ListView.builder(
      itemCount: chatHistory.length,
      itemBuilder: (context, index) =>
          _historyItem(chatHistory[index], index),
    );
  }

  Widget _buildTabButton(String title, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isUsersTab = title == "Users"),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            boxShadow: active
                ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                : [],
          ),
          child: Center(
            child: Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: active ? Colors.black : Colors.grey)),
          ),
        ),
      ),
    );
  }

  Widget _userItem(String name, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.primaries[index % Colors.primaries.length],
        child: Text(name[0], style: const TextStyle(color: Colors.white)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: const Text("Online"),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatScreen(name: name)),
      ),
    );
  }

  Widget _historyItem(Map<String, dynamic> data, int index) {
    final String name = data["name"];
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.primaries[index % Colors.primaries.length],
        child: Text(name[0], style: const TextStyle(color: Colors.white)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(data["msg"], maxLines: 1),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data["time"],
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          if (data["unread"] > 0)
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Text("${data["unread"]}",
                  style: const TextStyle(color: Colors.white, fontSize: 10)),
            ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatScreen(name: name)),
      ),
    );
  }
}
