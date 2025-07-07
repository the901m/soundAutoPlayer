#!/bin/bash

# Check if player name argument is provided.
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 \"player name\""
    exit 1
fi

TARGET_PLAYER="$1"

while true; do
    other_player_playing=0

    # Iterate over all players.
    for player in $(playerctl --list-all); do
        status=$(playerctl -p "$player" status 2>/dev/null)

        # If a player is playing and it's not the target, then signal to pause the target.
        if [ "$status" = "Playing" ] && [ "$player" != "$TARGET_PLAYER" ]; then
            other_player_playing=1
            break
        fi
    done

    if [ $other_player_playing -eq 1 ]; then
        # Other player is playing: pause the target.
        playerctl pause -p "$TARGET_PLAYER"
    else
        # No other player is playing: play the target.
        playerctl play -p "$TARGET_PLAYER"
    fi

    sleep 0.5
done

