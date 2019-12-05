
import unittest

import adventOfCode2019_05
import adventOfCode2019_05/consts


suite "unit-test suite":
    test "getMessage":
        assert(cHelloWorld == getMessage())
