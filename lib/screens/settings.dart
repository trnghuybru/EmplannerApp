import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  O3DController o3dController = O3DController();

  @override
  Widget build(BuildContext context) {
    return Center(
        // child: O3D.asset(
        //   src: 'assets/model.glb',
        //   controller: o3dController,
        //   autoPlay: true,
        // ),
        );
  }
}
