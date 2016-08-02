--
-- User: brian.ujiie
-- Date: 7/26/16
--

function Message(Player, Message, Tokens)
    assert(Message ~= nil)
    Player:SendMessage(ResolveTokensInString(Message, Tokens))
end

function InfoMessage(Player, Message, Tokens)
    assert(Message ~= nil)
    Player:SendMessageInfo(ResolveTokensInString(Message, Tokens))
end

function SuccessMessage(Player, Message, Tokens)
    assert(Message ~= nil)
    Player:SendMessageSuccess(ResolveTokensInString(Message, Tokens))
end

function WarningMessage(Player, Message, Tokens)
    assert(Message ~= nil)
    Player:SendMessageWarning(ResolveTokensInString(Message, Tokens))
end

function FailureMessage(Player, Message, Tokens)
    assert(Message ~= nil)
    Player:SendMessageFailure(ResolveTokensInString(Message, Tokens))
end

function FatalMessage(Player, Message, Tokens)
    assert(Message ~= nil)
    Player:SendMessageFatal(ResolveTokensInString(Message, Tokens))
end

function PrivateMessage(Sender, Receiver, Message, Tokens)
    assert(Message ~= nil)
    Receiver:SendMessagePrivateMsg(ResolveTokensInString(Message, Tokens), Sender:GetName())
end





function EveryoneMessage(Message, Tokens)
    assert(Message ~= nil)
    cRoot:BroadcastChat(ResolveTokensInString(Message, Tokens))
end

function EveryoneInfoMessage(Message, Tokens)
    assert(Message ~= nil)
    cRoot:BroadcastChatInfo(ResolveTokensInString(Message, Tokens))
end

function EveryoneSuccessMessage(Message, Tokens)
    assert(Message ~= nil)
    cRoot:BroadcastChatSuccess(ResolveTokensInString(Message, Tokens))
end

function EveryoneWarningMessage(Message, Tokens)
    assert(Message ~= nil)
    cRoot:BroadcastChatWarning(ResolveTokensInString(Message, Tokens))
end

function EveryoneFailureMessage(Message, Tokens)
    assert(Message ~= nil)
    cRoot:BroadcastChatFailure(ResolveTokensInString(Message, Tokens))
end

function EveryoneFatalMessage(Message, Tokens)
    assert(Message ~= nil)
    cRoot:BroadcastChatFatal(ResolveTokensInString(Message, Tokens))
end

function EveryoneDeathMessage(Message, Tokens)
    assert(Message ~= nil)
    cRoot:BroadcastChatDeath(ResolveTokensInString(Message, Tokens))
end