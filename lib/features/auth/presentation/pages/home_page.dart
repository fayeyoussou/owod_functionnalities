import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('عيد أضحى مبارك'),
        leading: IconButton(onPressed: () {
          // À la lumière de cette Eid bénie,
          // Je cherche votre grâce pour mes erreurs infinies.
          // Si mes mots ou actes ont un jour causé de la peine,
          // Je demande pardon, le cœur serein, sans haine.
        },
          icon: const Icon(Icons.calendar_today),),
      ),
      body: const Center(
        child: Text('EID MUBARAK 🐑 , From Youssoupha'),
      ),
    );
  }
}
