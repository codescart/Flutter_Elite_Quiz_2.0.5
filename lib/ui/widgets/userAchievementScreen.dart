import 'package:flutter/material.dart';

class UserAchievementContainer extends StatelessWidget {
  final String title;
  final String value;
  const UserAchievementContainer({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height:  MediaQuery.of(context).size.height*0.007,),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).backgroundColor.withOpacity(0.9),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height*0.007,),
        Container(
          width: MediaQuery.of(context).size.width*0.08,
          height: 0.5,
          color: Theme.of(context).backgroundColor,
        ),
       SizedBox(height: MediaQuery.of(context).size.height*0.007,),
        Text(
          value,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).backgroundColor,
          ),
        ),

      ],
    );
  }
}
