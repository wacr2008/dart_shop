import "package:flutter/material.dart";

class UserList extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color color;
  final double height;
  final Function onTap;
  const UserList({
    this.color=Colors.black38,
    this.text,
    this.height=45.0,
    this.icon,
    @required this.onTap
  });

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: GestureDetector(
          onTap:widget.onTap,
          child: Container(
            width:MediaQuery.of(context).size.width,height:widget.height,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Colors.black38,
                        width:0.5
                    )
                )
            ),
            padding: EdgeInsets.only(left: 10.0,right:10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment:CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child:Container(
                        color: widget.color,
                        width:30.0,
                        height:30.0,
                        child: Icon(widget.icon,color: Colors.white,size:16),
                      ) ,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(widget.text,style:TextStyle(fontSize: 16)),
                    )
                  ],
                ),
                Icon(Icons.chevron_right,size:30,color:Color(0xFFbdbcbc))
              ],
            ),
          ),
        )
      )
    );
  }
}

