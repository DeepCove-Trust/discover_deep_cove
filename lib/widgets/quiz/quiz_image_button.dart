import 'package:flutter/material.dart';

class QuizImageButton extends StatelessWidget {
  final VoidCallback onTap;
  final String imagePath;
  final String title;

  const QuizImageButton({this.onTap, this.imagePath, this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.2,
        height: (MediaQuery.of(context).size.height / 100 * 23.45),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black,
                    offset: Offset(2.5, 2.5),
                    blurRadius: 5.0),
              ],
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                title != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            color: Color.fromARGB(190, 0, 0, 0),
                            height:
                                (MediaQuery.of(context).size.height / 100) * 5,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    title,
                                    style: Theme.of(context).textTheme.body1,
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ),
                          ),
                        ],
                      )
                    : null,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
