import 'package:flutter/material.dart';
import 'package:owod_functionnalities/core/common/widgets/drawer_list_tile.dart';
import 'package:owod_functionnalities/core/theme/app_pallete.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key, required GlobalKey<ScaffoldState> scaffoldKey})
      : _scaffoldKey = scaffoldKey,
        super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppPalette.gradient1,
      child: Column(
        children: [
          DrawerHeader(child: Image.asset("assets/images/owod_logo.png")),
          DrawerListTile(
            title: 'Messagerie',
            icon: const Icon(Icons.message_outlined),
            press: () async {
              _scaffoldKey.currentState?.closeDrawer();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/chats', (context) => false);
            },
          ),
          DrawerListTile(
            title: 'Blog',
            icon: const Icon(Icons.medical_information),
            press: () async {
              _scaffoldKey.currentState?.closeDrawer();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/blog', (context) => false);
            },
          ),
        ],
      ),
    );
  }
}
