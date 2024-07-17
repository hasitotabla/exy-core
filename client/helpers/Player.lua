function getLocalPlayer()
    local localPlayerId = GetPlayerServerId(PlayerId());
    return (EntityPool[EntityTypes.PLAYER .. ":" .. localPlayerId]);
end 