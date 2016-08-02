require! './packing': {pack}

export function merge_1 (obj1, ...sources)
    for obj2 in sources
        # merge rest one by one
        for p of obj2
            try

                throw if typeof! obj2[p] isnt \Object
                obj1[p] = obj1[p] `merge` obj2[p]
            catch
                if obj2[p] isnt void
                        obj1[p] = obj2[p]
                else
                        delete obj1[p]
    obj1

export function merge (obj1, ...sources)
    for obj2 in sources
        # merge rest one by one
        for p of obj2
            if typeof obj2[p] is \object
                if obj1[p]
                    obj1[p] `merge` obj2[p]
                else
                    obj1[p] = obj2[p]
            else
                if obj2[p] isnt void
                    obj1[p] = obj2[p]
                else
                    delete obj1[p]
    obj1





tests =
  'simple merge': ->
        a=
          a: 1
          b: 2
          c:
            ca: 1
            cb: 2
        b=
          c:
            cb: 5

        result = a `merge` b

        expected =
            a: 1
            b: 2
            c:
                ca: 1
                cb: 5

        {result, expected}
  'deleting something': ->
        # delete
        a=
          a: 1
          b: 2
          c:
            ca: 11
            cb: 2

        result = merge a, {c: void}

        expected =
            a: 1
            b: 2

        {result, expected}
  'force overwrite': ->
        # force overwrite
        a=
          a: 1
          b: 2
          c:
            ca: 11
            cb: 2
        b=
          c:  # do not merge, force overwrite
            cb: 5

        result = merge a, {c: void}, b

        expected =
            a: 1
            b: 2
            c:
                cb: 5

        {result, expected}
  'merging object with functions': ->
        # object with functions
        a=
          a: 1
          b: 2
          c:
            ca: 11
            cb: 2
        b=
          c:
            cb: (x) -> x

        result = merge a, b

        expected =
            a: 1
            b: 2
            c:
                ca: 11
                cb: (x) -> x

        {result, expected}

try
    for name, test of tests
        {result, expected} = test!
        throw if (pack expected) isnt pack(result)
catch
    console.log "merge test failed test: ", name
    console.log "EXPECTED: ", expected
    console.log "RESULT  : ", result
    throw "Test failed in merge.ls!, test: #{name}"
