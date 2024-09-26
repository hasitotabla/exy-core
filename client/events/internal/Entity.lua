QueuedEntityCreations = {};

local function createEntityFromRemote(entityData)
    assert(type(entityData) == "table", "Entity data must be a table.");

    local entityType = entityData.type;
    if (not EntityClasses[entityType]) then 
        print("Entity class not found for type " .. entityType);
        return;
    end

    if (not EntityCreateHelpers[entityType]) then 
        print("Create helper not found for type " .. entityType);
        return;
    end

    return EntityCreateHelpers[entityType](entityData);
end 

function processPendingEntityCreations()
    for _, entityData in ipairs(QueuedEntityCreations) do 
        local entity = createEntityFromRemote(entityData);
        EntityPool[entity:getUniqueIdentifier()] = entity;

        dispatchEntityEvent("onClientEntityCreated", entity);
    end

    QueuedEntityCreations = {};
end 

RegisterNetEvent("Core::Internal::OnEntityCreated", function(entityData)
    if (not IS_CORE_INITIALIZED) then 
        table.insert(QueuedEntityCreations, entityData);
        return;
    end

    local entity = createEntityFromRemote(entityData);
    EntityPool[entity:getUniqueIdentifier()] = entity;

    dispatchEntityEvent("onClientEntityCreated", entity);
    processQueuedEntityEvents(entity:getUniqueIdentifier());
end);

RegisterNetEvent("Core::Internal::OnEntityMetaChange", function(entityID, key, value)
    local entity = EntityPool[entityID];
    if (not entity) then 
        print("Entity not found for ID " .. entityID);
        return;
    end

    entity:setMeta(key, value);
end);