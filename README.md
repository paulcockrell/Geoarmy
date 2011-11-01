# Geoarmy.net

A geocaching website built on Rails 2. The idea of Geoarmy is to make geocaching a more fun, and it does this by rewarding you points for finding or hiding geocaches. The more points you get, the higher you get promoted in the Geoarmy Army.

It has a mobile (Android only) application that communicates with this site, which can be found at this repo: http://github.com/paulcockrell/Geoarmy_Android. This is used to find the geocaches that are listed on the main site, and record finds against your account.


## Requirements

* Ruby 1.8.7
* Rails 2.3.8
* Sqlite 3

## Installation

Build the database:

	rake db:migrate

## Usage

In the rails application root run:

	script/server

In your browser enter the following address (assuming that you are using the Rails default port)

	http://localhost:3000

## Features

...

## More info

View the *live* site at: http://geoarmy.net

---
Copyright (c) 2011 Paul Cockrell, released under the MIT license
