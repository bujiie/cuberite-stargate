--
-- User: brian.ujiie
-- Date: 8/1/16
--

function RunTests(Split, Player)
    local TestCount = 0
    local FailureCount = 0
    local X, Y

    function UpdateCounts(Test, Failure)
        TestCount = TestCount + Test
        FailureCount = FailureCount + Failure
    end



    X, Y = TestTableSize()
    UpdateCounts(X, Y)

    X, Y = TestIsReservedWord()
    UpdateCounts(X, Y)

    X, Y = TestHead()
    UpdateCounts(X, Y)

    X, Y = TestTail()
    UpdateCounts(X, Y)

    X, Y = TestReplaceAnonymousMethod()
    UpdateCounts(X, Y)

    X, Y = TestReplaceTokenMethod()
    UpdateCounts(X, Y)

    X, Y = TestReplaceTokensInStringMethod()
    UpdateCounts(X, Y)

    return TestCount, FailureCount
end


function TestTableSize()
    local TestCount = 2
    local FailureCount = 0
    local EmptyTable = {}
    local NonEmptyTable = {key1="value1", key2="value2" }

    if TableSize(EmptyTable) ~= 0 then
        FailureCount = FailureCount + 1
        ERROR("Empty table size does not equal zero.")
    end

    if TableSize(NonEmptyTable) ~= 2 then
        FailureCount = FailureCount + 1
        ERROR("Non empty table size does not equal two.")
    end

    return TestCount, FailureCount
end

function TestIsReservedWord()
    local TestCount = 2
    local FailureCount = 0

    if not IsReservedWord("spawn") then
        FailureCount = FailureCount + 1
        ERROR("Known reserved word not found in Set.")
    end

    if IsReservedWord("cantalop") then
        FailureCount = FailureCount + 1
        ERROR("Unknown word found in reserved words Set.")
    end

    return TestCount, FailureCount
end

function TestHead()
    local TestCount = 1
    local FailureCount = 0
    local Table = {8,6,7,5,3,0,9 }

    if Head(Table) ~=8 then
        FailureCount = FailureCount + 1
        ERROR("Head value of table was incorrect.")
    end

    return TestCount, FailureCount
end

function TestTail()
    local TestCount = 1
    local FailureCount = 0
    local VerifyTail = Tail({8,6,7,5,3,0,9 })
    local AnswerTail = {6,7,5,3,0,9 }
    local Match = true

    for Index=1,6, 1 do
        if VerifyTail[Index] ~= AnswerTail[Index] then
            Match = false
            break
        end
    end

    if not Match then
        FailureCount = FailureCount + 1
        ERROR("Tail of table is incorrect.")
    end

    return TestCount, FailureCount
end

function TestReplaceAnonymousMethod()
    local TestCount = 2
    local FailureCount = 0

    local Tokens = {key1="value1", key2="value2"}

    local Subject = function(Token)
        return Tokens[Token:sub(2,-2)] or Token
    end

    if Subject("Xkey1X") ~= "value1" then
        FailureCount = FailureCount + 1
        ERROR("Replace did not find a matching key.")
    end

    if Subject("key1") == "value1" then
        FailureCount = FailureCount + 1
        ERROR("Replace did not strip the first and last characters away.")
    end

    return TestCount, FailureCount
end

function TestReplaceTokenMethod()
    local TestCount = 2
    local FailureCount = 0
    local SubjectOne = "Test {key1}"
    local SubjectTwo = "Test {wrong}"

    local Tokens = {key1="value1", key2="value2"}

    local Replace = function(Token)
        return Tokens[Token:sub(2,-2)] or Token
    end

    if (SubjectOne:gsub('(%b{})', Replace)) ~= "Test value1" then
        FailureCount = FailureCount + 1
        ERROR("Replace did not find a matching key.")
    end

    if (SubjectTwo:gsub('(%b{})', Replace)) ~= "Test {wrong}" then
        FailureCount = FailureCount + 1
        ERROR("Replace did not return the unmatched token..")
    end

    return TestCount, FailureCount
end

function TestReplaceTokensInStringMethod()
    local TestCount = 2
    local FailureCount = 0

    local SubjectOne = "Test {key1}"
    local SubjectTwo = "Test {wrong}"

    local Tokens = {key1="value1", key2="value2"}

    local Replace = function(Token)
        return Tokens[Token:sub(2,-2)] or Token
    end

    if ResolveTokensInString(SubjectOne, Tokens) ~= "Test value1" then
        FailureCount = FailureCount + 1
        ERROR("Replace did not find a matching key.")
    end

    if ResolveTokensInString(SubjectTwo, Tokens) ~= "Test {wrong}" then
        FailureCount = FailureCount + 1
        ERROR("Replace did not return the unmatched token..")
    end

    return TestCount, FailureCount
end
