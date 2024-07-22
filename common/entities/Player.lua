PlayerEntity = Class("PlayerEntity", BaseEntity);

function PlayerEntity:constructor(id)
    self:super(EntityTypes.PLAYER, id);
end

!if (IS_SERVER) then 
    function PlayerEntity:destroy()
        print('destroyed player entity');
    end 

    function PlayerEntity:setPosition(x, y, z)
        SetEntityCoords(GetPlayerPed(self.__netID), x, y, z, 0, 0, 0, 0);
    end
!end

function PlayerEntity:getPosition()
    return table.unpack(GetEntityCoords(GetPlayerPed(self.__netID)));
end

!if (IS_CLIENT) then 
    function PlayerEntity:isLocal()
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
!end

!if (IS_SERVER) then 
    function PlayerEntity:spawn(x, y, z, model)
        triggerEntityEvent("Player::RequestSpawn", self, self.__netID, x, y, z, model);
    end 
!end 
