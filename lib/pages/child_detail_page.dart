import 'package:flutter/material.dart';

import '../utils/default_padding.dart';
import '../widgets/fade_in.dart';

class ChildDetailPage extends StatelessWidget {
  final int index;
  final bool startToAnimate = true;
  ChildDetailPage(this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: 'child_avatar_$index',
              child: CircleAvatar(
                radius: 100,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 210, left: DefaultPadding.horizontal, right: DefaultPadding.horizontal),
            child: ListView(
              children: <Widget>[
                FadeIn(
                  delay: 1,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Nome da Crianca',
                    ),
                  ),
                ),
                FadeIn(
                  delay: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Escola',
                    ),
                  ),
                ),
                FadeIn(
                  delay: 2.5,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Periodo',
                    ),
                  ),
                ),
                FadeIn(
                  delay: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Nome da Crianca',
                    ),
                  ),
                ),
                FadeIn(
                  delay: 3.5,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Idade',
                    ),
                  ),
                ),
                FadeIn(
                  delay: 4,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Motorista',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(AsyncSnapshot snap) {
    if (snap.connectionState == ConnectionState.done) {
      return Padding(
        padding: EdgeInsets.only(top: 200, left: DefaultPadding.horizontal, right: DefaultPadding.horizontal),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome da Crianca',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Escola',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Periodo',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome da Crianca',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Idade',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Motorista',
              ),
            ),
          ],
        ),
      );
    }
    return Center(child: CircularProgressIndicator());
  }
}
