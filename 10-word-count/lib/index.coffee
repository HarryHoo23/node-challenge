through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 1
  regExp = /(")([^"]*(")+)/g
  nonSpaceRegExp = /^\s*\S/gm

  transform = (chunk, encoding, cb) ->
    tokens = chunk.split(' ')

    # Return number of lines that matches any non-whitespace character
    linesLength = tokens.toString().match(nonSpaceRegExp).length
    lines = linesLength
    
    # Find the word with double quote.
    quoteToken = chunk.match(regExp) 
    
    if quoteToken
      # Split the quoted words into different words.
      newQuoteToken = quoteToken[0].split(' ')
      # Filter the quoted words out of tokens and then return the new array without quoted words.
      cleanString = tokens.filter((element) -> 
        !newQuoteToken.includes(element)
      ) 

    if quoteToken 
     # Return the length of the words in a String without quote
      wordsCount = cleanString.length
      words = wordsCount + quoteToken.length
    else 
     # Return the length of the words in a String
      # Split CamelCase word into two words and get the length.
      wordsCount = chunk.toString().trim().replace(/([a-z0-9])([A-Z])/g, '$1 $2').split(/\s+/g).length
      words = wordsCount
    
    return cb()
  
  
  flush = (cb) ->
    this.push {words, lines}
    this.push null
    return cb()

  return through2.obj transform, flush
