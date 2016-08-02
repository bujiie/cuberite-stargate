--
-- User: brian.ujiie
-- Date: 7/23/16
--

function Set (list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

ReservedWords = Set { "spawn", "nether", "overworld", "end", "last_death" }

function IsReservedWord(Word)
    return ReservedWords[Word] ~= nil
end

function ResolveTokensInString(String, Tokens)
    local ResolvedString

    if Tokens == nil then
        Tokens = {}
    end

    local Replace = function(Token)
        return Tokens[Token:sub(2,-2)] or Token
    end

    if TableSize(Tokens) == 0 then
        ResolvedString = String
    else
        ResolvedString = (String:gsub('(%b{})', Replace))
    end

    return ResolvedString
end

function TableSize(Table)
    local Length = 0

    for _ in pairs(Table) do
        Length = Length + 1
    end
    return Length
end

function Head(Table)
    return table.remove(Table, 1)
end

function Tail(Table)
    return { select(2, unpack(Table)) }
end