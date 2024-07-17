PlayerEntity = Class("PlayerEntity", BaseWorldEntity);

function PlayerEntity:constructor(netID)
    self:super(EntityTypes.PLAYER, netID);
end

function PlayerEntity:isLocal()
    print(
        "PlayerEntity:isLocal()",
        type(self.__netID), self.__netID,
        type(GetPlayerServerId(PlayerId())), GetPlayerServerId(PlayerId())
    );
    return self.__netID == GetPlayerServerId(PlayerId());
end

function PlayerEntity:getPed()
    return GetPlayerPed(self.__netID);
end

function PlayerEntity:setModel(model)
    local hash = type(model) == "string" and GetHashKey(model) or model;

    requestModel(hash);
    SetPlayerModel(PlayerId(), hash);
    SetModelAsNoLongerNeeded(hash);
end 

function PlayerEntity:freeze(state)
    if (not self:isLocal()) then
        print("Attempted to freeze a non-local player entity.");
        return;
    end

    -- SetEntityInvincible(PlayerPedId(), state);
    FreezeEntityPosition(PlayerPedId(), state);
    SetPlayerControl(PlayerId(), not state, 0);
end 