import 'dart:io';

import 'package:Tunein/plugins/nano.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/services/musicService.dart';
import 'package:flutter/material.dart';
import 'package:Tunein/models/playerstate.dart';
import 'package:Tunein/globals.dart';
import 'package:Tunein/models/ContextMenuOption.dart';
class MyCard extends StatelessWidget {
  final Tune _song;
  final VoidCallback onTap;
  final VoidCallback onContextTap;
  final musicService = locator<MusicService>();
  final List<Color>colors;
  List<ContextMenuOptions> choices;
  final void Function(ContextMenuOptions) onContextSelect;
  final void Function(ContextMenuOptions) onContextCancel;
  MyCard({Key key, @required Tune song, VoidCallback onTap, VoidCallback onContextTap, this.colors, @required this.choices, @required this.onContextCancel, @required this.onContextSelect})
      : _song = song,
        onTap=onTap,
        onContextTap=onContextTap,
        super(key: key);



  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: musicService.playerState$,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<PlayerState, Tune>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final Tune _currentSong = snapshot.data.value;
        final bool _isSelectedSong = _song == _currentSong;
        final _textColor = _isSelectedSong ? colors!=null?colors[1]:Colors.white : colors!=null?colors[1].withAlpha(65):Colors.white54;
        final _fontWeight = _isSelectedSong ? FontWeight.w900 : FontWeight.w400;

        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: MyTheme.darkgrey,
                      child:Container(
                        constraints: BoxConstraints.expand(),
                        child:  Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: SizedBox(
                                height: 62,
                                width: 62,
                                child: FadeInImage(
                                  placeholder: AssetImage('images/track.png'),
                                  fadeInDuration: Duration(milliseconds: 200),
                                  fadeOutDuration: Duration(milliseconds: 100),
                                  image: _song.albumArt != null
                                      ? FileImage(
                                    new File(_song.albumArt),
                                  )
                                      : AssetImage('images/track.png'),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      (_song.title == null)
                                          ? "Unknon Title"
                                          : _song.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: _fontWeight,
                                        color: colors!=null?colors[1]:Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    (_song.artist == null)
                                        ? "Unknown Artist"
                                        : _song.artist,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: _fontWeight,
                                      color: _textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: (){
                        onTap();
                      },
                    ),
                  ),
                ),
                flex: 12,
              ),
              Expanded(
                flex: 2,
                child: Material(
                  child: PopupMenuButton<ContextMenuOptions>(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: MyTheme.darkgrey,
                        radius: 30.0,
                        child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child:Icon(
                              IconData(0xea7c, fontFamily: 'boxicons'),
                              size: 22,
                              color: Colors.white70,
                            )
                        ),
                      ),
                    ),
                    elevation: 3.2,
                    onCanceled: () {
                      print('You have not chosen anything');
                    },
                    tooltip: 'Playing options',
                    onSelected: (ContextMenuOptions choice){
                      onContextSelect(choice);
                    },
                    itemBuilder: (BuildContext context) {
                      return choices.map((ContextMenuOptions choice) {
                        return PopupMenuItem<ContextMenuOptions>(
                          value: choice,
                          child: Text(choice.title),
                        );
                      }).toList();
                    },
                  ),
                  color: Colors.transparent,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}


