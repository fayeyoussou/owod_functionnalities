import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owod_functionnalities/core/common/widgets/side_menu.dart';

class BlogPage extends StatelessWidget {
  static MaterialPageRoute route = MaterialPageRoute(builder: (context)=> BlogPage());
   BlogPage({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(scaffoldKey: _scaffoldKey,),
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [IconButton(onPressed: (){
          Navigator.of(context).pushNamed('/add_new_blog');
        }, icon: const Icon(CupertinoIcons.add_circled))],
      ),
    );
  }
}
