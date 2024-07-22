-- for entityType, entity in pairs(EntityClasses) do 
--     exports("create" .. entityType, function(...)
--         return entity:new(...);
--     end);
-- end

function createEntity(entityType, ...)
    local entityFactory = EntityClasses[entityType];
    if (not entityFactory) then 
        return error("Entity type " .. entityType .. " does not exist.");
    end

    local entity = entityFactory:new(...);
    local uniqueIdentifier = entity:getUniqueIdentifier();

    EntityPool[uniqueIdentifier] = entity;
    
    if (not EntityRefsByType[entityType]) then EntityRefsByType[entityType] = {}; end
    EntityRefsByType[entityType][uniqueIdentifier] = entity;

    dispatchEntityEvent("onEntityCreated", entity);
    TriggerClientEvent("Core::Internal::OnEntityCreated", -1, entity:__getEntityDataForSync());

    return entity;
end 

exports("__createEntity_internal__", function(entityType, ...)
    local invokingResource = GetInvokingResource();
    local entity = createEntity(entityType, ...);
    if (not entity) then 
        return;
    end

    entity:__setResourceRoot(invokingResource);
    local uniqueIdentifier = entity:getUniqueIdentifier();

    return uniqueIdentifier;
end);