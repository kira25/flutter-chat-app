import 'package:flutter/material.dart';
import 'package:flutter_chat/models/users.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final users = [
    Users(uid: '1', name: 'Maria', email: 'test1@gmail.com', online: true),
    Users(uid: '2', name: 'Jose', email: 'test2@gmail.com', online: true),
    Users(uid: '3', name: 'Alberto', email: 'test3@gmail.com', online: false),
    Users(uid: '4', name: 'Fernando', email: 'test4@gmail.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Mi nombre',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.check_circle,
                color: Colors.blue,
              ),
            )
          ],
          leading: IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.black,
              onPressed: () {}),
        ),
        body: SmartRefresher(
          onRefresh: _loadUsers,
          header: WaterDropHeader(
            waterDropColor: Colors.blue[400],
            complete: Icon(Icons.check, color: Colors.blue[400]),
          ),
          controller: _refreshController,
          child: _listViewUsers(),
          enablePullDown: true,
        ));
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _userListTile(users[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: users.length,
    );
  }

  ListTile _userListTile(Users user) {
    return ListTile(
      title: Text(user.name),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(user.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: user.online ? Colors.green : Colors.red),
      ),
    );
  }

  _loadUsers() async {
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }
}
