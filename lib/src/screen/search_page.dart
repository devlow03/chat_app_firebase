import 'package:chat_app/src/screen/message_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/user_model.dart';
class SearchPage extends StatefulWidget {
  UserModel user;
  SearchPage(this.user);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchControl = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;

  void onSearch()async{
    setState((){
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance. collection("user").where("name",isEqualTo: searchControl.text).get().then((value){
      if(value.docs.length<1){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Không tìm thấy")));
        setState((){
          isLoading=false;
        });
        return;
      }
      value.docs.forEach((user) {
        if(user.data()['email']!=widget.user.email){
          searchResult.add(user.data());
          setState((){});
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: const Color(0xff292F3F),
    appBar: AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      // backgroundColor: const Color(0xff292F3F),
      actions: [
        TextButton(
        child: Text('Hủy bỏ',
        
        style: TextStyle(color: Colors.blue),
        ),
        onPressed: () {
          Get.back();
        },
      ),
      ],
      title: TextField(
              controller: searchControl,
              maxLines: 1,
              onSubmitted: (value){
                onSearch();
              },
              onTap: (){
                Get.to(SearchPage(widget.user));
              },
              textInputAction: TextInputAction.search,
              
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  fillColor: Colors.blueGrey.shade50,
                  filled: true,
                  hintText: "Tìm kiếm",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.transparent, width: 0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: 0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                  )),
            ),
      
      
    ),
      body: ListView(
        children: [
          SizedBox(height: 20,),
          if(searchResult.length>0)
            Expanded(
              child: ListView.separated(
              itemCount: searchResult.length,
              shrinkWrap: true,
              itemBuilder: (context,index){
                return InkWell(
                  onTap: (){
                    setState((){
                      searchControl.text='';
                    });
                    Get.to(MessageScreen(
                      currentUser: widget.user,
                      friendId: searchResult[index]['uid'],
                      friendName: searchResult[index]['name'],
                      friendImage: searchResult[index]['image'],
                    ));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(searchResult[index]['image']),
                      radius: 20,
                    ),
                    title: Text(searchResult[index]['name'],
                    style: TextStyle(
                      color: Colors.black
                    ),
                    ),
                    subtitle: Text(searchResult[index]['email'],
                      style: TextStyle(
                          color: Colors.black
                        ),
                    ),
                    trailing: Icon(
                     Icons.message,
                      color: Colors.black,
                      ),


                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 10,);
              },
              ),
            )
        ],
      ),
    );
  }
}
