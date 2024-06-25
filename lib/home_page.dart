import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/add_notes.dart';
import 'package:notes_app/app_database.dart';
import 'package:notes_app/database_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 // List<Map<String,dynamic>> allNotes=[];
  @override
  void initState() {
    super.initState();
    Provider.of<DatabaseProvider>(context,listen: false).fetchAllNotes();
  }
  @override
  Widget build(BuildContext context) {
    AppDatabase db=AppDatabase.db;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
      ),
      body: Consumer<DatabaseProvider>(
        builder: (_,ProviderValue,__){
          List<Map<String,dynamic>> allNotes=ProviderValue.notes;
          if(allNotes.isNotEmpty) {
            return
              ListView.builder(
                  itemCount: allNotes.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: Text(
                          allNotes[index][AppDatabase.COLUMN_NOTE_TITLE]),
                      subtitle: Text(
                          allNotes[index][AppDatabase.COLUMN_NOTE_DESC]),
                     onLongPress: (){
                        _NoteDetailsBottomSheet(context, allNotes[index]);
                     },
                    );
                  }
              );
          }else{
               return Center(child: Text('no notes yet'),);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          bool? result=await Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNotes()));
         if(result=true){
             Provider.of<DatabaseProvider>(context,listen: false).fetchAllNotes();
         }
        },
        child: Icon(Icons.add),
      ),
    );
  }
  void _NoteDetailsBottomSheet(BuildContext context,Map<String,dynamic> note){
    showModalBottomSheet(context: context,
        builder: (BuildContext context){
         return Container(
           child: Padding(
             padding: const EdgeInsets.all(16.0),
             child: Column(crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisSize: MainAxisSize.min,
               children: [
                 Text(
                   note[AppDatabase.COLUMN_NOTE_TITLE],
                   style: TextStyle(fontSize:24,fontWeight: FontWeight.bold),
                 ),
                 Text(note[AppDatabase.COLUMN_NOTE_DESC],
                 style: TextStyle(fontSize: 18),
                 ),
                 Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                   ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                    NavigateUpdateNote(context, note);
                   }, child: Text('Update')),
                   ElevatedButton(onPressed: (){
                     Provider.of<DatabaseProvider>(context,listen: false).deleteNote(id: note[AppDatabase.COLUMN_NOTE_ID]);
                     Navigator.pop(context);
                   }, child: Text('Delete'))
                 ],
                 ),
               ],
             ),
           ),
         );
        });
  }
    void NavigateUpdateNote(BuildContext context,Map<String,dynamic> note){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNotes(
          noteId:note[AppDatabase.COLUMN_NOTE_ID],
          initialTitle:note[AppDatabase.COLUMN_NOTE_TITLE],
          initialDesc:note[AppDatabase.COLUMN_NOTE_DESC]
      ),
      ),
      );
    }
}
