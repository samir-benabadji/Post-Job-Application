import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone/jobs/jobs_screen.dart';
import 'package:linkedin_clone/widgets/job_widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search query";

  Widget _buildSearchField(){
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: InputDecoration(
        hintText: "Search for jobs...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions(){
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: (){
          _clearSearchQuery();
        },
      ),
    ];
  }

  void updateSearchQuery (String newQuery){
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  void _clearSearchQuery(){
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        leading: IconButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => JobScreen()));
            },
            icon: Icon(Icons.arrow_back),
        ),
        title: _buildSearchField(),
        actions: _buildActions(),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:  FirebaseFirestore.instance
        .collection('jobs')
            .where('jobTitle', isGreaterThanOrEqualTo: searchQuery)
            .where('recruitment', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting)
            {
              return Center(child: CircularProgressIndicator());
            }
          else if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.data?.docs.isNotEmpty == true){
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index){
                    return JobWidget(
                        jobTitle: snapshot.data?.docs[index]['jobTitle'],
                        jobDescription: snapshot.data?.docs[index]['jobDescription'],
                        jobId: snapshot.data?.docs[index]['jobId'],
                        uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                        userImage: snapshot.data?.docs[index]['userImage'],
                        name: snapshot.data?.docs[index]['name'],
                        recruitment: snapshot.data?.docs[index]['recruitment'],
                        email: snapshot.data?.docs[index]['email'],
                        location: snapshot.data?.docs[index]['location'],
                    );
                    }
                );
              }else{
                return Center(
                  child: Text('There is no jobs'),
                );
              }
            }
          return Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            )
          );
        },
      ),
    );
  }
}



