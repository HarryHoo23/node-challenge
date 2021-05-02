fs = require 'fs'
readline = require 'readline'

exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  rStream = fs.createReadStream("#{__dirname}/../data/geo.txt") 
  rLine = readline.createInterface {
    input: rStream
  }
   
  counter = 0

  rLine.on 'line', (input) ->
    line = input.split '\t'
    if line[3] == countryCode then counter += +line[1] - +line[0]


  rLine.on 'close', -> cb null, counter