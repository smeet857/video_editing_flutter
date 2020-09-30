import 'package:flutter/material.dart';

class SaveDialog extends StatefulWidget {

  @override
  _SaveDialogState createState() => _SaveDialogState();
}

class _SaveDialogState extends State<SaveDialog> {
  bool isEmpty = true;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(10),
        height: 170,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter file name',style: TextStyle(
                color: Colors.black,
                fontSize: 25
            ),
            ),
            TextField(
              controller: controller,
              maxLines: 1,
              minLines: 1,
              onChanged: (text){
                text.length == 0?isEmpty = true:isEmpty = false;
                setState(() {});
              },
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(onPressed: (){
                  Navigator.pop(context,'');
                }, child: Text('cancel'),
                  color: Colors.blue,),
                SizedBox(width: 10,),
                FlatButton(onPressed: isEmpty?null:(){
                  Navigator.pop(context,'${controller.text}.mp4');
                }, child: Text('ok'),
                  color: Colors.blue,),
              ],
            )
          ],
        ),
      ),
    );
  }
}
