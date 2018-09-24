# itunesctl

### Upstream
The origin source exists as a Gist which I've forked and imported into this Git repo
cf. https://gist.github.com/rkumar/503162

### How to use
Not much to say. A few shell commands to control iTunes.

    Usage: itunes.sh <option>

    Options:
     status       = Shows iTunes' status, current artist and track.
     play         = Start playing iTunes.
     pause        = Pause iTunes.
     next         = Go to the next track.
     prev         = Go to the previous track.
     mute         = Mute iTunes' volume.
     unmute       = Unmute iTunes' volume.
     vol up       = Increase iTunes' volume by 10%
     vol down     = Increase iTunes' volume by 10%
     vol #        = Set iTunes' volume to # [0-100]
     speaker up   = Increase system speaker volume by 10%
     speaker down = Decrease system speaker volume by 10%
     speaker #    = Set system speaker volume to # [0-10]
     stop         = Stop iTunes.
     quit         = Quit iTunes.
     playlist     = Show playlists saved in iTunes.
     tracks       = Show tracks for current or given playlist.
     shuf         = Shuffle current playlist
     nosh         = Do not shuffle current playlist


### What did I do?
Just added an extra command to control the systems volume control (speaker) for total volume control.

### Any plans for the future?
Dunno. I was just in a practical need of that enhanced control feature. :)
