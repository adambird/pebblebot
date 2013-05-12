# Pebblebot

I wanted to have a go at pushing information to my [Pebble Watch](http://getpebble.com) so set up a simple script to do so.

Am currently using Twitter DMs to send message and rely on iPhone notifications to propogate to the Pebble. I believe there's a push API coming but can't find any docs for it yet.

It's pretty hard-coded to my requirements but extensibility should be fairly obvious.

Running this everymorning as a Heroku scheduled task.

# Weather

Usage 

    bin/pebblebot weather

This gets five-day forecast from the [UK Met Office](http://www.metoffice.gov.uk) and sends me the current day info that's relevant to cycling, eg

    Sun 12 - BEESTON
    11C Light rain
    11mph WSW
    Rain 84%

