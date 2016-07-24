--
-- User: brian.ujiie
-- Date: 7/23/16
--

cLogger = {}
cLogger.__index = cLogger

function cLogger:INFO(a_Message, a_Params)
    assert(a_Message ~= nil)
    LOGINFO(ResolveParams(a_Message, a_Params))
end

function cLogger:WARN(a_Message, a_Params)
    assert(a_Message ~= nil)
    LOGWARNING(ResolveParams(a_Message, a_Params))
end

function cLogger:ERROR(a_Message, a_Params)
    assert(a_Message ~= nil)
    LOGERROR(ResolveParams(a_Message, a_Params))
end


cMessage = {}
cMessage.__index = cMessage

function cMessage:Send(a_Player, a_Message, a_Params)
    assert(a_Message ~= nil)
    a_Player:SendMessageInfo(ResolveParams(a_Message, a_Params))
end

function cMessage:SendSuccess(a_Player, a_Message, a_Params)
    assert(a_Message ~= nil)
    a_Player:SendMessageSuccess(ResolveParams(a_Message, a_Params))
end

function cMessage:SendFailure(a_Player, a_Message, a_Params)
    assert(a_Message ~= nil)
    a_Player:SendMessageFailure(ResolveParams(a_Message, a_Params))
end


function ResolveParams(a_Message, a_Params)
    local Message

    if(a_Params == nil) then
        a_Params = {}
    end

    local replace = function(token)
        return a_Params[token:sub(3, -2)] or token
    end

    if(TableLength(a_Params) == 0) then
        Message = a_Message
    else
        Message = (a_Message:gsub('($%b{})', replace))
    end

    return "[Walter]: " .. Message
end

function TableLength(Table)
    local Length = 0

    for _ in pairs(Table) do
        Length = Length + 1
    end
    return Length
end

function CheckGlobalFlag(a_Global)
    if(a_Global == "-g" or a_Global == "--global") then
        return true
    end
    return false
end

function Tail(list)
    return { select(2, unpack(list)) }
end