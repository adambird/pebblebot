# Pebblebot

I wanted to have a go at pushing information to my [Pebble Watch](http://getpebble.com) so set up a simple script to do so.

There is no dedicated API for doing this but by default the Pebble smartphone app sends Notifications so you can use an app that receives push notifications to get it to work.

I'm running this every morning as a Heroku scheduled task.

        Usage:
               bin/pebblebot [options] <command> [command_options]
        where [options] are:
           --twitter, -t <s>:   twitter username
          --pushover, -p <s>:   pushover user key
     --suppress-weekends, -s:   flag to indicate whether to suppress weekends
               --version, -v:   Print version and exit
                  --help, -h:   Show this message

It's here in case someone finds it useful :smile:

I'm running this for a few people as well so let me know if you'd like to be added to the list. Just send me your location and time you'd like the alert.

## Channels

Currenly support Twitter and [Pushover](http://pushover.net) as channels

The script will support multiple channels simultaneously if you provide the arguments.

### Twitter

Sends `@mention` to the user with the info requested.

Twitter requires the following environment variables to be set for your application and account to use for send the DM.

    TWITTER_CONSUMER_KEY
    TWITTER_CONSUMER_SECRET
    TWITTER_OAUTH_TOKEN
    TWITTER_OAUTH_TOKEN_SECRET

Then you just pass the twitter username to @mention

    bin/pebblebot --twitter adambird weather --location 350299

### Pushover

Discovered this simple app for sending push notifications to a dedicated app, more on [the Pushover web site](http://pushover.net).

Just need the application api key from Pushover in the following enviroment variable

    PUSHOVER_APP_KEY

Then the argument to the pushover parameter is the `user key`

    bin/pebblebot --pushover kahdiaudhaiud2387y237y weather --location 350299


## Commands

### Weather

    Options:
      --location, -l <i>:   Met Office location id

This gets five-day forecast from the [UK Met Office](http://www.metoffice.gov.uk) and sends the current day info that's relevant to cycling, eg:

    Sun 12 - BEESTON
    11C Light rain
    11mph WSW
    Rain 84%

You'll need to set an enviroment variable for the API key

    MET_OFFICE_API_KEY

You can get your location id from the MetOffice [UK site locations list](http://www.metoffice.gov.uk/datapoint/support/uk-locations-site-list-detailed-documentation)