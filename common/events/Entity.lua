print('toltodjel be retkes kurva')

local function convertEntityToReference(entity)
    return {
        __entityMT = true, 
        __netID = entity:getNetID(),
        __type = entity:getType()
    };
end 

local function convertReferenceToEntity(ref)
    return EntityPool[ref.__type .. ":" .. ref.__netID];
end 

local function isValueEntityReference(value) 
    return (type(value) == "table" and value.__entityMT); 
end

local __eventEntityIndexes = {};
function dispatchEntityEvent(eventName, entity, ...)
    entity = convertEntityToReference(entity);
    
    local args = { ... };
    for index, value in ipairs(args) do 
        if (type(value) == "table" and value:instanceOf(BaseEntity)) then 
            args[index] = convertEntityToReference(value);
        end 
    end
    
    TriggerEvent(eventName, entity, table.unpack(args));
end 

exports("__entities__emitEntityMethod", function(entityId, methodName, ...)
    local entity = EntityPool[entityId];
    if (not entity) then 
        return error("Entity with ID '" .. entityId .. "' does not exist.");
    end
    
    local calledMethod = getmetatable(entity).__index[methodName];
    if (not calledMethod) then 
        return error("Entity method '" .. methodName .. "' does not exist.");
    end
    
    local args = { ... };
    for index, value in ipairs(args) do 
        if (isValueEntityReference(value)) then 
            args[index] = convertReferenceToEntity(value);
        end 
    end

    return { calledMethod(entity, table.unpack(args)) };
end);

exports("__getEntitiesByType_internal__", function(entityType, resourceRoot)
    local entities = {};
    
    for uniqueIdentifier, entity in pairs(EntityPool) do 
        if (
            entity:getType() == entityType and 
            (not resourceRoot or entity:getResourceRoot() == resourceRoot)
        ) then 
            table.insert(entities, convertEntityToReference(entity));
        end
    end

    return entities;
end);