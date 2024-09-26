BaseWorldEntity = Class("BaseWorldEntity");

function BaseWorldEntity:constructor(entityType, id)
    self.__position = { x = 0, y = 0, z = 0 };

    self:super(EntityTypes.BASE_WORLD_ENTITY, id);
end 

function BaseWorldEntity:destroy()

end

-- 
-- Placeholders to be overridden
-- 

function BaseWorldEntity:setPosition(x, y, z)
    self.__position = { x = x, y = y, z = z };
end

function BaseWorldEntity:getPosition()
    return self.__position.x, self.__position.y, self.__position.z;
end 