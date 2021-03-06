'use strict'

curry = require './curry'

{ isType } = require './types'

# native methods
_hasOwnProperty = Object.prototype.hasOwnProperty
rx_parseJSPath  = /\[("|'|)(.*?)\1\]|([^.\[\]]+)/g

# Repeatedly capture either:
# - a bracketed expression, discarding optional matching quotes inside, or
# - an unbracketed expression, delimited by a dot or a bracket.
# - taken from http://codereview.stackexchange.com/questions/62997/javascript-path-parsing/63010#63010
# parseJavaScriptPathIntoKeyNames :: string -> array
function parseJavaScriptPathIntoKeyNames (path)
    result = []
    while (token = rx_parseJSPath.exec path)?
        result.push (token.2 or token.3)
    result

# empty :: object -> boolean
exports.empty = (obj) ->
    for k of obj then return false
    true

# has :: string -> object -> boolean
exports.has = curry (key, obj) ->
    _hasOwnProperty.call obj, key

# exports.getPath = curry (obj, ks) ->
#     i   = -1
#     len = ks.length
#     ks  =
#         if typeof ks is 'string'
#             parseJavaScriptPathIntoKeyNames ks
#         else if isType 'Array' ks
#             ks
#         else
#             throw new Error 'invalid argument (string | array)'

#     while ++i < len and obj?
#         obj = obj[ks[i]]

#     if i is len then obj else void

# exports.hasPath = curry (obj, ks) ->
#     i   = -1
#     len = ks.length
#     ks  =
#         if typeof ks is 'string'
#             parseJavaScriptPathIntoKeyNames ks
#         else if isType 'Array' ks
#             ks
#         else
#             throw new Error 'invalid argument (string | array)'

#     while (++i < len) and obj?
#         if ks[i] of obj then
#             obj = obj[ks[i]]
#         else
#             return false

#     i is len

# keys :: object -> [string]
exports.keys = (obj) ->
    [k for k of obj]

# values :: object -> [any]
exports.values = (obj) ->
    [v for , v of obj]

# clone :: object -> object
exports.clone = (obj) ->
    exports.deepMixin null, obj

# each :: function -> object -> object
exports.each = curry (f, obj) ->
    for k, v of obj then (f v, k)
    obj

# map :: function -> object -> object
exports.map = curry (f, obj) ->
    {[k, (f v, k)] for k, v of obj}

# filter :: function -> object -> object
exports.filter = curry (f, object) ->
    {[k, v] for k, v of object when (f v, k)}

# partition :: function -> object -> [object]
exports.partition = curry (f, object) ->
    passed = {}
    failed = {}
    for k, v of object
        (if (f v, k) then passed else failed)[k] = v
    [passed, failed]

# keyOf :: any -> object -> string
exports.keyOf = curry (elem, obj) ->
    for k, v of obj
    when v is elem
        return k
    void

# keysOf :: any -> object -> string
exports.keysOf = curry (elem, obj) ->
    [k for k, v of obj when v is elem]

# findKey :: function -> object -> string
exports.findKey = curry (f, obj) ->
    for k, v of obj when (f v, k) then return k
    void

# findKeys :: function -> object -> [string]
exports.findKeys = curry (f, obj) ->
    [k for k, v of obj when (f v, k)]

# fromPairs :: array -> object
exports.fromPairs = (xs) ->
    {[x.0, x.1] for x in xs}

# toPairs :: object -> array
exports.toPairs = (obj) ->
    [[key, value] for key, value of obj]

# fill :: object -> ...object -> object
exports.fill = curry 2 (dest, ...sources) ->
    for src in sources
        for k of dest when src[k]?
            dest[k] = src[k]
    dest

# deepFill :: object -> ...object -> object
exports.deepFill = curry 2 (dest, ...sources) ->
    for src in sources then
        for key, value of dest when value?
            if (isType 'Object' src[key], value)
                dest[key] = exports.deepFill value, src[key]
            else
                dest[key] = src[key]
    dest

# mixin :: object -> ...object -> object
exports.mixin = curry 2 (dest = {}, ...sources) ->
    for src in sources then
        for key, val of src then
            dest[key] = val
    dest

# deepMixin :: object -> ...object -> object
exports.deepMixin = curry 2 (dest = {}, ...sources) ->
    for src in sources then
        for k, v of src then
            if (isType 'Object' dest[k]) and (isType 'Object', v)
            then dest[k] = exports.deepMixin dest[k], v
            else dest[k] = v
    dest

# freeze :: object -> object
exports.freeze = (obj) ->
    Object.freeze obj

# deepFreeze :: object -> object
exports.deepFreeze = (obj) ->
    Object.freeze obj unless Object.isFrozen obj
    for key, value of obj
    when (_hasOwnProperty.call obj, key) and (isType 'Object', value or isType 'Object', value)
        exports.deepFreeze value
    obj

# toString :: object -> string
exports.toString = (obj) -> JSON.stringify obj, null, 2

# fromString :: string -> object
exports.fromString = (obj) -> JSON.parse obj

# definePublic :: object -> string|object -> maybe any -> object
exports.definePublic = curry (obj, key, value) ->
    if isType 'Object' key
        for k, v of key => exports.definePublic obj, k, v
        obj
    else
        Object.defineProperty obj, key, {
            value, +enumerable, +writable, +configurable
        }

# definePrivate :: object -> string|object -> maybe any -> object
exports.definePrivate = curry (obj, key, value) ->
    if isType 'Object' key
        for k, v of key => exports.definePrivate obj, k, v
        obj
    else
        Object.defineProperty obj, key, {
            value, -enumerable, +writable, +configurable
        }

# defineStatic :: object -> string|object -> maybe any -> object
exports.defineStatic = curry (obj, key, value) ->
    if isType 'Object' key
        for k, v of key => exports.defineStatic obj, k, v
        obj
    else
        Object.defineProperty obj, key, {
            value, +enumerable, -writable, +configurable
        }

# defineMeta :: object -> string|object -> maybe any -> object
exports.defineMeta = curry (obj, key, value) ->
    if isType 'Object' key
        for k, v of key => exports.defineMeta obj, k, v
        obj
    else
        Object.defineProperty obj, key, {
            value, -enumerable, -writable, +configurable
        }
