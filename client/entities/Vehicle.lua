VehicleEntity = Class("VehicleEntity", BaseWorldEntity);

function VehicleEntity:constructor(netID)
    self.__entityID = NetworkGetEntityFromNetworkId(netID);
    self:super(EntityTypes.VEHICLE, netID);
end

function VehicleEntity:getPosition()
    return GetEntityCoords(self.__entityID);
end