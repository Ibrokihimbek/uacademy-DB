import 'package:flutter/material.dart';
import 'package:uacademy_db/data/local_db/local_db.dart';
import 'package:uacademy_db/data/models/cached_user_model.dart';

class UserDataPage extends StatefulWidget {
  const UserDataPage({super.key});

  @override
  State<UserDataPage> createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  FocusNode ageFocusNode = FocusNode();
  List<CachedUser> cachedUsers = [];

  _init() async {
    cachedUsers = await LocalDatabase.getAllCachedUsers();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(hintText: 'Enter name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              focusNode: ageFocusNode,
              decoration: const InputDecoration(hintText: 'Enter age'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () async {
                  await LocalDatabase.insertCachedUser(
                    CachedUser(
                      age: int.parse(ageController.text),
                      userName: nameController.text,
                    ),
                  );
                  nameController.clear();
                  ageController.clear();
                  ageFocusNode.unfocus();
                  cachedUsers = await LocalDatabase.getAllCachedUsers();
                  setState(() {});
                },
                child: const Text("Add User")),
            Expanded(
                child: ListView(
              children: List.generate(cachedUsers.length, (index) {
                var item = cachedUsers[index];
                return ListTile(
                  title: Text('Name ${item.userName}'),
                  subtitle: Text('Age ${item.age}'),
                  trailing: IconButton(
                    onPressed: () async {
                      LocalDatabase.deleteCachedUserById(item.id!);
                      cachedUsers = await LocalDatabase.getAllCachedUsers();
                      setState(() {});
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              }),
            ))
          ],
        ),
      ),
    );
  }
}
