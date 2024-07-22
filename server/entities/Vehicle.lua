VehicleEntity = Class("VehicleEntity", BaseEntity);

function VehicleEntity:constructor(model, position, heading)
    self.__isRepairPending = false;

    local heading = heading or 0.0;

    assert(type(model) == "string", "Model must be a string.");
    assert(type(position) == "vector3", "Position must be a vector3.");
    assert(type(heading) == "number", "Heading must be a number.");

    local vehicleHandle = CreateVehicle(
        GetHashKey(model), 
        position.x, position.y, position.z, 
        heading, true, true);

    self:super(EntityTypes.VEHICLE, vehicleHandle);
end

function VehicleEntity:destroy()
    if (DoesEntityExist(self.__netID)) then 
        DeleteEntity(self.__netID);
    end

    self:__postDestroy();
end

function VehicleEntity:getPosition() return table.unpack(GetEntityCoords(self.__netID)); end
function VehicleEntity:setPosition(x, y, z) 
    SetEntityCoords(self.__netID, x, y, z, false, false, false, false); 
end

function VehicleEntity:getHeading() return GetEntityHeading(self.__netID); end
function VehicleEntity:setHeading(heading) SetEntityHeading(self.__netID, heading); end

function VehicleEntity:repair()
    local netOwner = NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(self.__netID));
    if (not netOwner) then 
        self.__isRepairPending = true;
        return; 
    end

    self.__isRepairPending = false;
    TriggerClientEvent(netOwner, "Core::Internal::RepairVehicle", self.__netID);
end 

function VehicleEntity:setPrimaryColor(r, g, b)
    SetVehicleCustomPrimaryColour(self.__netID, r, g, b);
end 

function VehicleEntity:setSecondaryColor(r, g, b)
    SetVehicleCustomSecondaryColour(self.__netID, r, g, b);
end