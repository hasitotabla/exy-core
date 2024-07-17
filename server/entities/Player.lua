PlayerEntity = Class("PlayerEntity", BaseWorldEntity);

function PlayerEntity:constructor(netID)
    self:super(EntityTypes.PLAYER, netID);
end

function PlayerEntity:destroy()
    print('destroyed player entity');
end 

function PlayerEntity:getPosition()
    return table.unpack(GetEntityCoords(GetPlayerPed(self.__netID)));
end

function PlayerEntity:spawn(x, y, z, model)
    triggerEntityEvent("Player::RequestSpawn", self, self.__netID, x, y, z, model);
end 