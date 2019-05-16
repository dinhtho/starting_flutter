import 'package:flutter/material.dart';
import 'package:starting_flutter/model/user.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserItem extends StatefulWidget {
  User user;
  int position;
  ItemActionCallback onItemAction;

  UserItem({@required this.user, this.position, this.onItemAction});

  @override
  State<StatefulWidget> createState() => UserItemState();


}

class UserItemState extends State<UserItem> {
  User user;
  int position;
  ItemActionCallback onItemAction;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    position = widget.position;
    onItemAction = widget.onItemAction;
  }

  @override
  Widget build(BuildContext context) {
    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: new Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(user.profileImageUrl),
          ),
          title: Text(
            user.name,
            style: TextStyle(fontSize: 18.0),
          ),
          subtitle: Text(user.email),
          onTap: () => onItemAction(ItemActionType.item, position),
        ),
      ),
      actions: <Widget>[
        new IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => onItemAction(ItemActionType.archive, position),
        ),
        new IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => onItemAction(ItemActionType.share, position),
        ),
      ],
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'More',
          color: Colors.black45,
          icon: Icons.more_horiz,
          onTap: () => onItemAction(ItemActionType.more, position),
        ),
        new IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => onItemAction(ItemActionType.delete, position),
        ),
      ],
    );
  }
}

typedef void ItemActionCallback(ItemActionType actionType, int position);
enum ItemActionType { item, archive, share, more, delete }
