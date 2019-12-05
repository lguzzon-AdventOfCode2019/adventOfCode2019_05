import parsecsv
from streams import newFileStream
import strutils

type
    tMemory = array[1000, int64]


proc memoryFromInput(aInput: string = "input"): tMemory =
    var lFileStream = aInput.newFileStream(fmRead)
    if lFileStream == nil:
        quit("cannot open the file" & aInput)
    var lCsvParser: CsvParser
    lCsvParser.open(lFileStream, aInput)
    var lIndex = 0
    while lCsvParser.readRow:
        # echo "new row: "
        for val in lCsvParser.row.items:
            result[lIndex] = val.parseBiggestInt
            lIndex += 1
            # echo "##", val, "##"
        # echo "Instructions " & $lIndex
    close(lCsvParser)


proc runProgram(aMemory: var tMemory, aInput: BiggestInt = 1): int64 =
    var lInstructionPointer: BiggestInt = 0
    while true:
        let lInstructionStr = ($aMemory[lInstructionPointer]).align(5, '0')
        # echo "IP[$1] - $2"%[$lInstructionPointer, lInstructionStr]
        let lOpCode = lInstructionStr[3..4].parseBiggestInt
        # echo "IP[$1] - $2"%[$lInstructionPointer, $lOpCode]
        case lOpCode
        of 1:
            var lA = aMemory[lInstructionPointer + 1]
            var lB = aMemory[lInstructionPointer + 2]
            let lC = aMemory[lInstructionPointer + 3]
            # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
            # var lShow = false
            if ('0' == lInstructionStr[2]):
                lA = aMemory[lA]
                # lShow = true
            if ('0' == lInstructionStr[1]):
                lB = aMemory[lB]
                # lShow = true
            # if (lShow):
                # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
            aMemory[lC] = (lA + lB)
            lInstructionPointer += 4

        of 2:
            var lA = aMemory[lInstructionPointer + 1]
            var lB = aMemory[lInstructionPointer + 2]
            let lC = aMemory[lInstructionPointer + 3]
            # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
            # var lShow = false
            if ('0' == lInstructionStr[2]):
                lA = aMemory[lA]
                # lShow = true
            if ('0' == lInstructionStr[1]):
                lB = aMemory[lB]
                # lShow = true
            # if (lShow):
                # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
            aMemory[lC] = (lA * lB)
            lInstructionPointer += 4

        of 3:
            var lA = aMemory[lInstructionPointer + 1]
            # echo "-- Values $1"%[$lA]
            aMemory[lA] = aInput
            lInstructionPointer += 2

        of 4:
            var lA = aMemory[lInstructionPointer + 1]
            # echo "-- Values $1"%[$lA]
            # var lShow = false
            if ('0' == lInstructionStr[2]):
                lA = aMemory[lA]
                # lShow = true
            # if (lShow):
                # echo "-- Values $1"%[$lA]
            # echo "Output --> " & $lA
            result = lA
            lInstructionPointer += 2

        of 5:
            var lA = aMemory[lInstructionPointer + 1]
            var lB = aMemory[lInstructionPointer + 2]
            # echo "-- Values $1,$2"%[$lA, $lB]
            # var lShow = false
            if ('0' == lInstructionStr[2]):
                lA = aMemory[lA]
                # lShow = true
            if ('0' == lInstructionStr[1]):
                lB = aMemory[lB]
                # lShow = true
            # if (lShow):
                # echo "-- Values $1,$2"%[$lA, $lB]
            if (0 != lA):
                lInstructionPointer = lB
            else:
                lInstructionPointer += 3

        of 6:
            var lA = aMemory[lInstructionPointer + 1]
            var lB = aMemory[lInstructionPointer + 2]
            # echo "-- Values $1,$2"%[$lA, $lB]
            # var lShow = false
            if ('0' == lInstructionStr[2]):
                lA = aMemory[lA]
                # lShow = true
            if ('0' == lInstructionStr[1]):
                lB = aMemory[lB]
                # lShow = true
            # if (lShow):
                # echo "-- Values $1,$2"%[$lA, $lB]
            if (0 == lA):
                lInstructionPointer = lB
            else:
                lInstructionPointer += 3

        of 7:
            var lA = aMemory[lInstructionPointer + 1]
            var lB = aMemory[lInstructionPointer + 2]
            let lC = aMemory[lInstructionPointer + 3]
            # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
            # var lShow = false
            if ('0' == lInstructionStr[2]):
                lA = aMemory[lA]
                # lShow = true
            if ('0' == lInstructionStr[1]):
                lB = aMemory[lB]
                # lShow = true
            # if (lShow):
                # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
            if (lA < lB):
                aMemory[lC] = 1
            else:
                aMemory[lC] = 0
            lInstructionPointer += 4

        of 8:
            var lA = aMemory[lInstructionPointer + 1]
            var lB = aMemory[lInstructionPointer + 2]
            let lC = aMemory[lInstructionPointer + 3]
            # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
            # var lShow = false
            if ('0' == lInstructionStr[2]):
                lA = aMemory[lA]
                # lShow = true
            if ('0' == lInstructionStr[1]):
                lB = aMemory[lB]
                # lShow = true
            # if (lShow):
                # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
            if (lA == lB):
                aMemory[lC] = 1
            else:
                aMemory[lC] = 0
            lInstructionPointer += 4

        else:
            # echo "Current IP [$1] Value [$2]"%[$lInstructionPointer, lInstructionStr]
            break


proc test00 =
    var lMemory: tMemory = memoryFromInput("test00")
    echo "test00 $1"%[$runProgram(lMemory, 8)]

proc test01 =
    var lMemory: tMemory = memoryFromInput("test01")
    echo "test01 $1"%[$runProgram(lMemory, 4)]
    echo "test01 $1"%[$runProgram(lMemory, 8)]
    echo "test01 $1"%[$runProgram(lMemory, 81)]


proc partOne =
    var lMemory: tMemory = memoryFromInput()
    echo "partOne $1"%[$runProgram(lMemory)]

proc partTwo =
    var lMemory: tMemory = memoryFromInput()
    echo "partTwo $1"%[$runProgram(lMemory, 5)]



# test00()
# test01()

partOne() #6761139
partTwo() #9217546
