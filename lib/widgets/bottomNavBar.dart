import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:post_job_application/jobs/jobs_screen.dart';
import 'package:post_job_application/jobs/upload_job.dart';
import 'package:post_job_application/search/profile_company.dart';
import 'package:post_job_application/search/search_companies.dart';
import 'package:post_job_application/user_state.dart';

class BottomNavigationBarForApp extends StatelessWidget {
  int indexNum = 0;
  BottomNavigationBarForApp({required this.indexNum});

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white70,
                    size: 36,
                  ),
                ),
              ],
            ),
            content: Text(
              'Do you want to log out from App?',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(
                  'No',
                  style: TextStyle(
                      color: Color.fromARGB(255, 209, 57, 46), fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => UserState()));
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Color(0xff044404), fontSize: 18),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Color(0xff044404),
      backgroundColor: Colors.black,
      buttonBackgroundColor: Color(0xff044404),
      height: 52,
      index: indexNum,
      items: <Widget>[
        Icon(
          Icons.list,
          size: 18,
          color: Colors.white,
        ),
        Icon(
          Icons.search,
          size: 18,
          color: Colors.white,
        ),
        Icon(
          Icons.add,
          size: 18,
          color: Colors.white,
        ),
        Icon(
          Icons.person_pin,
          size: 18,
          color: Colors.white,
        ),
        Icon(
          Icons.exit_to_app,
          size: 18,
          color: Colors.white,
        )
      ],
      animationDuration: Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => JobScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AllWorkersScreen()));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UploadJobNow()));
        } else if (index == 3) {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final User? user = _auth.currentUser;
          final String uid = user!.uid;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                        userID: uid,
                      )));
        } else if (index == 4) {
          _logout(context);
        }
      },
    );
  }
}
