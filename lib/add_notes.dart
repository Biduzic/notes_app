import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/database_provider.dart';
import 'package:provider/provider.dart';

class AddNotes extends StatefulWidget {
  final int? noteId;
  final String? initialTitle;
  final String? initialDesc;
  const AddNotes({ this.noteId,this.initialTitle,this.initialDesc,Key? key}):super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  late TextEditingController _titleController=TextEditingController();
  late TextEditingController _descController=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController=TextEditingController(text: widget.initialTitle ?? '');
    _descController=TextEditingController(text: widget.initialDesc ?? '');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 30,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(onPressed: (){}, icon:Icon(Icons.turn_left,size: 30,color:Colors.grey.shade600,)),
          SizedBox(width: 5,),
          IconButton(onPressed: (){}, icon: Icon(Icons.turn_right,size: 30,color:Colors.grey.shade600,)),
          SizedBox(width: 5,),
          IconButton(onPressed: ()async{
            String title=_titleController.text.trim();
            String desc=_descController.text.trim();

            if(title.isNotEmpty && desc.isNotEmpty){
              bool result=await Provider.of<DatabaseProvider>(context,listen: false).insertNote(title: title, desc: desc);

              if(result){
                Navigator.of(context).pop(true);
              }else{
                print('error inserting note');
              }
            }
          }, icon: Icon(Icons.check,size: 30,)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 30.0),
            ),
            Row(
              children: [
                Text('22 June 6:35 PM',style: TextStyle(color:Colors.grey.shade600),),
                SizedBox(width: 16,),
                Text('0 characters',style: TextStyle(color:Colors.grey.shade600),),
              ],
            ),
            SizedBox(height: 16,),
            Expanded(
              child: TextField(
                controller: _descController,
                decoration: InputDecoration(
                  hintText: 'Start typing..',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 19,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 19),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
