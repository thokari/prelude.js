'use strict'

curry = require './curry'
array = require './arrays'

# repeat :: string -> string
exports.repeat = curry (n, str) ->
    [str for til n].join ''

# reverse :: string -> string
exports.reverse = (str) ->
    i = 0
    len = str.length
    result = new Array len
    until len is 0
        result[--len] = str.char-at i++
    result.join ''

# capitalize :: string -> string
exports.capitalize = (str) ->
  (str.char-at 0).to-upper-case! + str.slice 1

# capitalizeSentence :: string -> string
exports.capitalizeSentence = (str) ->
    str.replace /(^.|\s.)/g, (, c) -> (c ? '').to-upper-case!

# decapitalize :: string -> string
exports.decapitalize = (str) ->
  (str.char-at 0).to-lower-case! + str.slice 1

# decapitalize :: string -> string
exports.decapitalizeSentence = (str) ->
  str.replace /(^.|\s.)/g, (, c) -> (c ? '').to-lower-case!

# camelize :: string -> string
exports.camelize = (str) ->
    str.replace /[-_]+(.)?/g, (, c) -> (c ? '').to-upper-case!

# dasherize :: string -> string
exports.dasherize = (str) ->
    str
        .replace /([^-A-Z])([A-Z]+)/g, (, lower, upper) ->
            upper =
                if upper.length > 1
                then upper
                else upper.to-lower-case!
            lower + '-' + upper
        .replace /^([A-Z]+)/, (, upper) ->
            if upper.length > 1
            then upper + '-'
            else upper.to-lower-case!
