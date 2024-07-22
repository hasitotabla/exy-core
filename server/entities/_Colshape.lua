ColShapeEntity = Class("ColShapeEntity", BaseEntity);

function ColShapeEntity:constructor(colType, x, y, z)
    assert(colType and ColShapeTypes[colType], "Type must be a ColShapeTypes.");
    assert(type(position) == "vector3", "Position must be a vector3.");
    assert(type(size) == "vector3", "Size must be a vector3.");

    self.__colType = colType;
    self.__position = vector3(x, y, z);

    self:super(EntityTypes.COLSHAPE, colShapeHandle);
end

-- 
-- Getters / Setters
-- 

function ColShapeEntity:getPosition() return table.unpack(self.__position); end 
function ColShapeEntity:setPosition(x, y, z)
    self.__position = vector3(x, y, z);
end

-- 
-- To be overridden
-- 

function ColShapeEntity:isPointWithin(x, y, z)
    error("isPointWithin must be overridden.");
end

function ColShapeEntity:isEntityWithin(entity)
    error("isEntityWithin must be overridden.");
end

function ColShapeEntity:getEntitiesWithin()
    error("getEntitiesWithin must be overridden.");
end