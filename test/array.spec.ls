'use strict'

<-! suite 'prelude.array'

suite 'empty()' !->
    { empty } = prelude.arrays

    test 'returns correctly with valid inputs' !->
        strictEqual (empty []), true
        strictEqual (empty [1]), false

suite 'clone()' !->
    { clone } = prelude.arrays

    test 'returns the same as input' !->
        deepEqual do
            (clone [1 2 3])
            [1 2 3]

    test 'returns a copy' !->
        original = [1 2 3 4 5]
        copy     = clone original
        copy.2   = 'foo'

        strictEqual original.2, 3
        strictEqual copy.2, 'foo'

suite 'head()' !->
    { head } = prelude.arrays

    test 'return first element' !->
        strictEqual (head [1 2 3]), 1

suite 'first()' !->
    { first } = prelude.arrays

    test 'return first element' !->
        strictEqual (first [1 2 3]), 1

suite 'tail()' !->
    { tail } = prelude.arrays

    test 'return tail' !->
        deepEqual (tail [1 2 3]), [2 3]

suite 'last()' !->
    { last } = prelude.arrays

    test 'return first element' !->
        strictEqual (last [1 2 3]), 3

suite 'initial()' !->
    { initial } = prelude.arrays

    test 'return all elements but the last' !->
        deepEqual (initial [1 2 3 4]), [1 2 3]

suite 'slice()' !->
    { slice } = prelude.arrays

    test 'slice array' !->
        deepEqual (slice 0, 3 [1 2 3 4]), [1 2 3]

    test 'slice with negative index' !->
        deepEqual (slice 0, -1 [1 2 3 4]), [1 2 3]

suite 'flatten()' !->
    { flatten } = prelude.arrays
    test 'flatten array' !->
        deepEqual do
            flatten [[1 2], [3 4]]
            [1 2 3 4]

suite 'each()' !->
    { each } = prelude.arrays

    test 'curries' !->
        isFunction each (->)
        isArray each (->), [1 2 3]

    test 'iterates over the complete array' !->
        count = 0
        each (-> count += 1), [1 2 3 4]
        strictEqual count, 4

    test 'iterator receives index and value' !->
        ['foo' 'bar' 'qaz'] |> each (value, index) ->
            isString value
            isNumber index
            if index is 0 then strictEqual value, 'foo'
            if index is 1 then strictEqual value, 'bar'
            if index is 2 then strictEqual value, 'qaz'

suite 'map()' !->
    { map } = prelude.arrays

    test 'curries' !->
        isFunction map (->)
        isArray map (->), [1 2 3]

    test 'iterates over the complete array' !->
        count = 0
        map (-> ++count), [1 2 3]
        strictEqual count, 3

    test 'iterator receives index and value' !->
        ['foo' 'bar' 'qaz'] |> map (value, index) ->
            isString value
            isNumber index
            if index is 0 then strictEqual value, 'foo'
            if index is 1 then strictEqual value, 'bar'
            if index is 2 then strictEqual value, 'qaz'

    test 'remap values' !->
        deepEqual do
            [0 1 2] |> map (-> it + 1)
            [1 2 3]

suite 'filter()' !->
    { filter } = prelude.arrays

    test 'curries' !->
        isFunction filter (->)
        isArray    filter (->), [1 2 3]

    test 'iterates over the complete array' !->
        count = 0
        filter (-> ++count), [1 2 3]
        strictEqual count, 3

    test 'iterator receives index and value' !->
        ['foo' 'bar' 'qaz'] |> filter (value, index) ->
            isString value
            isNumber index
            if index is 0 then strictEqual value, 'foo'
            if index is 1 then strictEqual value, 'bar'
            if index is 2 then strictEqual value, 'qaz'

    test 'filters values' !->
        deepEqual do
            filter (-> typeof it isnt 'string'), [1 'foo' 2]
            [1 2]

suite 'shuffle()' !->
    { shuffle } = prelude.arrays

    test 'shuffles array' !->
        i = 100
        while --i
            throws do
                -> deepEqual (shuffle [1 2 3 4 5 6 7 8 9]), [1 2 3 4 5 6 7 8 9]
                -> true

suite 'reverse()' !->
    { reverse } = prelude.arrays

    test 'reverses array' !->
        deepEqual do
            reverse [1 2 3]
            [3 2 1]

suite 'zip()' !->
    { zip } = prelude.arrays

    test 'zips array' ->
        deepEqual do
            zip [1 2] [3 4]
            [[1 3], [2 4]]

    test 'zip with uneven array length (1)' ->
        deepEqual do
            zip [1 2 9] [3 4]
            [[1 3], [2 4]]

    test 'zip with uneven array length (2)' ->
        deepEqual do
            zip [1 2] [3 4 9]
            [[1 3], [2 4]]

suite 'zipWith()' !->
    { zipWith } = prelude.arrays

    test 'curries' !->
        isFunction zipWith (->)
        isFunction zipWith (->), [1 2 3]
        isArray    zipWith (->), [1 2 3] [1 2 3]

    test 'zips array' ->
        deepEqual do
            zipWith (-> &0 + &1), [1 2] [3 4]
            [4 6]

    test 'zips multible arrays' ->
        deepEqual do
            zipWith (-> &0 + &1 + &2), [1 2] [2 1] [10 20]
            [13 23]

    test 'zip with uneven array length (1)' ->
        deepEqual do
            zipWith (-> &0 + &1), [1 2 9] [3 4]
            [4 6]

    test 'zip with uneven array length (2)' ->
        deepEqual do
            zipWith (-> &0 + &1), [1 2] [3 4 9]
            [4 6]

suite 'partition()' !->
    { partition } = prelude.arrays

    test 'curries' !->
        isFunction partition (->)
        isArray    partition (->), [1 2 3]

    test 'partitions array' !->
        deepEqual do
            partition (-> it is 2), [1 2 3 4]
            [[2], [1 3 4]]

suite 'unique()' !->
    { unique } = prelude.arrays

    test 'return unique items' !->
        deepEqual do
            unique [1 1 2 3 3 4 5]
            [1 2 3 4 5]

suite 'uniqueBy()' !->
    { uniqueBy } = prelude.arrays

    test 'curries' !->
        deepEqual do
            <[fo fo foo fooo fooo]> |> uniqueBy (.length)
            <[fo foo fooo]>

    test 'return unique items' !->
        deepEqual do
            uniqueBy (.length), <[fo fo foo fooo fooo]>
            <[fo foo fooo]>

suite 'difference()' !->
    { difference } = prelude.arrays

    test 'return difference' !->
        deepEqual do
            difference [1 2 3], [1 4 5]
            [2 3]

suite 'intersection()' !->
    { intersection } = prelude.arrays

    test 'return intersecting' !->
        deepEqual do
            intersection [1 2 3], [1 2 5]
            [1 2]

suite 'union()' !->
    { union } = prelude.arrays

    test 'curries' !->
        deepEqual do
            [1 3 4] |> union [1 2]
            [1 2 3 4]

    test 'return unions' !->
        deepEqual do
            union [1 2], [1 3 4], [1 5]
            [1 2 3 4 5]
