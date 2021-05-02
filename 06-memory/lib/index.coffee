fs = require 'fs'
readline = require 'readline'

exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  # Read the stream by using fs library
  rStream = fs.createReadStream("#{__dirname}/../data/geo.txt") 
  
  # Create the object from the stream
  rLine = readline.createInterface {
    input: rStream
  }
   
  counter = 0

  rLine.on 'line', (input) ->
    line = input.split '\t'
    if line[3] == countryCode then counter += +line[1] - +line[0]

  # Stop the line reading.
  rLine.on 'close', -> cb null, counter