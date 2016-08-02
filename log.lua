--
-- User: brian.ujiie
-- Date: 7/26/16
--

function INFO(Message, Tokens)
    assert(Message ~= nil)
    LOGINFO(ResolveTokensInString(Message, Tokens))
end

function WARN(Message, Tokens)
    assert(Message ~= nil)
    LOGWARNING(ResolveTokensInString(Message, Tokens))
end

function ERROR(Message, Tokens)
    assert(Message ~= nil)
    LOGERROR(ResolveTokensInString(Message, Tokens))
end