fs = require 'fs'
assert = require 'assert'
WordCount = require '../lib'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1
    helper input, expected, done

  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!

  it 'should count words in a txt file', (done) ->
    input = fs.readFileSync "#{__dirname}/fixtures/1,9,44.txt", 'utf8', (err, data) ->
    expected = words: 9, lines: 1
    helper input, expected, done

  it 'should count quote words as single word in a txt file', (done) ->
    input = fs.readFileSync "#{__dirname}/fixtures/3,7,46.txt", 'utf8', (err, data) ->
    expected = words: 7, lines: 3
    helper input, expected, done

  it 'should count CamelCase word into two wors', (done) ->
    input = fs.readFileSync "#{__dirname}/fixtures/5,9,40.txt", 'utf8', (err, data) ->
    expected = words: 9, lines: 5
    helper input, expected, done