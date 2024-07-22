ObjectEntity = Class("ObjectEntity", BaseEntity);

function ObjectEntity:constructor(modelHash, position, isMissionEntity, doorFlag)
    local isMissionEntity = isMissionEntity or false;
    local doorFlag = doorFlag or false;

    assert(type(modelHash) == "number", "Model must be a number.");
    assert(type(position) == "vector3", "Position must be a vector3.");
    assert(type(isMissionEntity) == "boolean", "isMissionEntity must be a boolean.");
    assert(type(doorFlag) == "boolean", "doorFlag must be a boolean.");

    local objectHandle = CreateObject(
        modelHash, 
        position.x, position.y, position.z, 
        isMissionEntity, doorFlag
    );

    self:super(EntityTypes.OBJECT, objectHandle);
end

function ObjectEntity:destroy()
    if (DoesEntityExist(self.__netID)) then 
        DeleteEntity(self.__netID);
    end

    self:__postDestroy();
end 

function ObjectEntity:getPosition()
    return GetEntityCoords(self.__netID);
end