#!/bin/bash
#╔═════════════════════════════════════════════════════════════════════════════╗
#║  iTunes Command Line Control v1.1                                           ║
#║  by David Schlosnagle                                                       ║
#║  and forked by rahul kumar - gist.github.com/rkumar/503162                  ║
#║                                                                             ║
#║  Current release edits by Christopher Engelmann                             ║
#║  published as github.com/webcitizen-de/itunesctl                            ║
#╚═════════════════════════════════════════════════════════════════════════════╝

showHelp () {
    echo "-----------------------------";
    echo "iTunes Command Line Interface";
    echo "-----------------------------";
    echo "Usage: `basename $0` subcommand";
    echo;
    echo "Options:";
    echo " status          = Shows iTunes' status, current artist and track.";
    echo " play            = Start playing iTunes.";
    echo " pause           = Pause iTunes.";
    echo " next            = Go to the next track.";
    echo " prev            = Go to the previous track.";
    echo " mute            = Mute iTunes' volume.";
    echo " unmute          = Unmute iTunes' volume.";
    echo " vol up          = Increase iTunes' volume by 10%";
    echo " vol down        = Increase iTunes' volume by 10%";
    echo " vol #           = Set iTunes' volume to # [0-100]";
    echo " speaker up      = Increase system speaker volume by 10%";
    echo " speaker down    = Decrease system speaker volume by 10%";
    echo " speaker #       = Set system speaker volume to # [0-10]";
    echo " stop            = Stop iTunes.";
    echo " quit            = Quit iTunes.";
    echo " list            = Show playlists saved in iTunes.";
    echo " list <Playlist> = Stops current playlist, starts the given one.";
    echo " tracks          = Show tracks for current or given playlist.";
    echo " shuf            = Shuffle current playlist";
    echo " nosh            = Do not shuffle current playlist";
}

if [ $# = 0 ]; then
    showHelp;
fi

function volumectl {
    if [ $1 = "up" ]; then
        newvol=$(( vol+1 ));
    elif [ $1 = "down" ]; then
        newvol=$(( vol-1 ));
    elif [ $1 -gt -1 ]; then
        newvol=$1;
    fi
}

function split_into_sorted_multilines {

    # remove the separator ", " and create a newline instead
    # remove the trailing default semicolon of the putput

    sed -e 's/, /\
/g' -e 's/;//g' <<< "$1" | sort

}

while [ $# -gt 0 ]; do
    arg=$1;
    case $arg in
        "status" ) state=`osascript -e 'tell application "Music" to player state as string'`;
            echo "iTunes is currently $state.";
            if [ $state = "playing" ]; then
                artist=`osascript -e 'tell application "Music" to artist of current track as string'`;
                track=`osascript -e 'tell application "Music" to name of current track as string'`;
                echo "Current track $artist:  $track";
            fi
            break ;;

        "play"    ) echo "Playing iTunes.";
            osascript -e 'tell application "Music" to play';
            break ;;

        "pause"   ) echo "Pausing iTunes.";
            osascript -e 'tell application "Music" to pause';
            break ;;

        "next"    ) echo "Going to next track." ;
            osascript -e 'tell application "Music" to next track';
            break ;;

        "prev"    ) echo "Going to previous track.";
            osascript -e 'tell application "Music" to previous track';
            break ;;

        "mute"    ) echo "Muting iTunes volume level.";
            osascript -e 'tell application "Music" to set mute to true';
            break ;;

        "unmute"  ) echo "Unmuting iTunes volume level.";
            osascript -e 'tell application "Music" to set mute to false';
            break ;;

        "vol"     ) echo "Changing iTunes volume level.";
            vol=`osascript -e 'tell application "Music" to sound volume as integer'`;
            volumectl $2
            osascript -e "tell application \"iTunes\" to set sound volume to $newvol";
            break ;;

        "speaker" ) echo "Changing Mac speaker volume level.";
            volumectl $2
            osascript -e "set Volume $newvol"
            break ;;

        "stop"    ) echo "Stopping iTunes.";
            osascript -e 'tell application "Music" to stop';
            break ;;

        "quit"    ) echo "Quitting iTunes.";
            osascript -e 'tell application "Music" to quit';
            exit 1 ;;

       # addition playlist of choice
       list | playlist )
          if [ -n "$2" ]; then
             echo "Changing iTunes playlists to '$2'.";
             osascript -e 'tell application "Music"' -e "set new_playlist to \"$2\" as string" -e "play playlist new_playlist" -e "end tell";
            break ;

          else
            # Show available iTunes playlists.
            available_playlists="$(
                osascript -e 'tell application "Music"' -e "set allPlaylists to (get name of every playlist)" -e "end tell"
            );"
            echo
            split_into_sorted_multilines "$available_playlists"
            break;

         fi
         break;;

       "shuf" ) echo "Shuffle is ON.";
             osascript -e 'tell application "Music" to set shuffle of current playlist to 1';
             break ;;

       "nosh" ) echo "Shuffle is OFF.";
             osascript -e 'tell application "Music" to set shuffle of current playlist to 0';
             break ;;
       "tracks" )
          if [ -n "$2" ]; then
             osascript -e 'tell application "Music"' -e "set new_playlist to \"$2\" as string" -e " get name of every track in playlist new_playlist" -e "end tell";
             break;
         fi
             osascript -e 'tell application "Music" to get name of every track in current playlist';
             break ;;
        "help" | * ) echo "help:";
            showHelp;


            break ;;
    esac
done
