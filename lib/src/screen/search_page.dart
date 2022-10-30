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
      backgroundColor: const Color(0xff292F3F),
    appBar: AppBar(
      elevation: 0,
      backgroundColor: const Color(0xff292F3F),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Get.back();
        },
      ),
      title: TextField(
        onSubmitted: (value){
          onSearch();
        },
        textInputAction: TextInputAction.search,
        style: TextStyle(
          color: Colors.white
        ),
        controller: searchControl,
        decoration: InputDecoration(

          contentPadding: EdgeInsets.all(10),
            hintStyle: TextStyle(
              color: Colors.white
            ),
            fillColor: Color(0xff1B202D),
            filled: true,
            hintText: "Tìm kiếm",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.black
                )
            ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: Colors.black
              )
          ),
          suffixIcon: Icon(Icons.search,color: Colors.white,)
        ),


      ),
    ),
      body: Column(
        children: [

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
                      color: Colors.white
                    ),
                    ),
                    subtitle: Text(searchResult[index]['email'],
                      style: TextStyle(
                          color: Colors.white
                        ),
                    ),
                    trailing: Icon(
                     Icons.message,
                      color: Colors.white,
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
