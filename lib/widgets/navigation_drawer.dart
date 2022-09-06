import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soldoza_app/providers/auth_provider.dart';
import 'package:soldoza_app/router/app_routes.dart';
import 'package:soldoza_app/theme/app_theme.dart';

class NavigationDrawer extends StatelessWidget {
  final Function setPosition;

  const NavigationDrawer({
    Key? key,
    required this.setPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Drawer(
        child: SingleChildScrollView(
      child: Column(
        children: [
          userProfile(authProvider),
          MenuOptions(setPosition: setPosition),
        ],
      ),
    ));
  }

  Container userProfile(AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      height: 250,
      color: AppTheme.orangeColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(55),
            child: FadeInImage(
              image: NetworkImage(
                  'https://storagewo.blob.core.windows.net/perfiles/${authProvider.userMap['userPhoto']}'),
              placeholder: const AssetImage('assets/jar-loading.gif'),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 300),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '${authProvider.userMap["name"]} ${authProvider.userMap["lastName"]}',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          )
        ],
      ),
    );
  }
}

class MenuOptions extends StatelessWidget {
  final Function setPosition;

  const MenuOptions({
    Key? key,
    required this.setPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          ListTile(
            leading: Icon(AppRoutes.menuOptions[1].icon),
            title: Text(AppRoutes.menuOptions[1].name),
            onTap: () {
              setPosition(0, AppRoutes.menuOptions[1].name);

              // Navigator.pushReplacementNamed(context, AppRoutes.menuOptions[index].route);
            },
          ),
          if (authProvider.userMap["userType"]["id"] == 1)
            ListTile(
              leading: Icon(AppRoutes.menuOptions[2].icon),
              title: Text(AppRoutes.menuOptions[2].name),
              onTap: () {
                setPosition(1, AppRoutes.menuOptions[2].name);

                // Navigator.pushReplacementNamed(context, AppRoutes.menuOptions[index].route);
              },
            ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              authProvider.updateFirebaseToken(
                  '', authProvider.userMap['id'].toString());

              Navigator.of(context).pushNamedAndRemoveUntil(
                  'login', (Route<dynamic> route) => false);
            },
          )
        ],
      ),
    );
  }
}



// ListTile(
//             leading: Icon(AppRoutes.menuOptions[index].icon),
//             title: Text(AppRoutes.menuOptions[index].name),
//             onTap: () {
//               setPosition(index, AppRoutes.menuOptions[index].name);

//               // Navigator.pushReplacementNamed(context, AppRoutes.menuOptions[index].route);
//             },
//           );


//           Container(
//       height: double.maxFinite,
//       child: ListView.builder(
//         itemCount: AppRoutes.menuOptions.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: Icon(AppRoutes.menuOptions[index].icon),
//             title: Text(AppRoutes.menuOptions[index].name),
//             onTap: () {
//               setPosition(index, AppRoutes.menuOptions[index].name);

//               // Navigator.pushReplacementNamed(context, AppRoutes.menuOptions[index].route);
//             },
//           );
//         },
//       ),
//     );