'use strict'

# curry :: function -> number? -> function
module.exports = (n, fn) ->
    if typeof n is 'function'
        fn = n
        n = fn.length

    curry = (args) ->
        unless n > 1
        then fn
        else ->
            params = args.slice!
            if (params.push.apply params, &) < n and &.length
            then curry params
            else fn.apply null, params

    curry []
