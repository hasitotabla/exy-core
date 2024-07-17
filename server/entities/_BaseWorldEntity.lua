BaseWorldEntity = Class("BaseWorldEntity");

function BaseWorldEntity:constructor(entityType, netID)
    self.__resourceRoot = GetCurrentResourceName();
    self.__type = entityType or EntityTypes.BASE_ENTITY;
    self.__netID = netID or getIDForEntityType(self.__type);
    self.__metas = {};
end 

function BaseWorldEntity:__postDestroy()
    local uniqueIdentifier = self:getUniqueIdentifier();
    EntityPool[uniqueIdentifier] = nil;
end

function BaseWorldEntity:destroy()
    error("BaseWorldEntity:destroy() must be overridden in the child class.");
end

-- 
-- Getters / Setters
-- 

function BaseWorldEntity:getNetID() return self.__netID; end
function BaseWorldEntity:getType() return self.__type; end
function BaseWorldEntity:getUniqueIdentifier()
    return self.__type .. ":" .. self.__netID;
end

function BaseWorldEntity:__setResourceRoot(resourceRoot)
    self.__resourceRoot = resourceRoot;
end

-- 
-- Internals
-- 

function BaseWorldEntity:__getEntityDataForSync()
    return {
        type = self.__type, 
        netID = self.__netID, 
        metas = self.__metas
    };
end

function BaseWorldEntity:__broadcastMetaChange(key, value)
    TriggerClientEvent("Core::Internal::OnEntityMetaChange", -1, self:getUniqueIdentifier(), key, value);
end

-- 
-- Metadata
-- 

function BaseWorldEntity:setMeta(key, value)
    assert(type(key) == "string", "Arg #1 @ BaseWorldEntity:setMeta | `key` must be a string.");

    local oldValue = self.__metas[key] and self.__metas[key].value or nil;
    local oldType = self.__metas[key] and self.__metas[key].type or nil;

    self.__metas[key] = {
        value = value, 
        type = "local"
    };

    if (oldValue ~= value) then 
        if (oldType and oldType ~= "local") then 
            self:__broadcastMetaChange(key, nil); -- Remove meta from clients, because it become local
        end 

        dispatchEntityEvent("onMetaChange", self, key, value, oldValue);
    end
end

function BaseWorldEntity:setSyncedMeta(key, value)
    assert(type(key) == "string", "Arg #1 @ BaseWorldEntity:setSyncedMeta | `key` must be a string.");

    local oldValue = self.__metas[key] and self.__metas[key].value or nil;
    self.__metas[key] = {
        value = value, 
        type = "synced"
    };

    if (oldValue ~= value) then 
        self:__broadcastMetaChange(key, value);
        dispatchEntityEvent("onMetaChange", self, key, value, oldValue);
    end
end 

function BaseWorldEntity:setStreamSyncedMeta(key, value)
    assert(type(key) == "string", "Arg #1 @ BaseWorldEntity:setStreamSyncedMeta | `key` must be a string.");
    
    local oldValue = self.__metas[key] and self.__metas[key].value or nil;
    self.__metas[key] = {
        value = value, 
        type = "stream_synced"
    };

    if (oldValue ~= value) then 
        self:__broadcastMetaChange(key, value);
        dispatchEntityEvent("onMetaChange", self, key, value, oldValue);
    end
end 

function BaseWorldEntity:getMeta(key)
    assert(type(key) == "string", "Arg #1 @ BaseWorldEntity:getMeta | `key` must be a string.");

    if (not self.__metas[key]) then return nil; end
    return self.__metas[key].value;
end

function BaseWorldEntity:getMetaSyncType(key)
    assert(type(key) == "string", "Arg #1 @ BaseWorldEntity:getMetaSyncType | `key` must be a string.");

    return (self.__metas[key] and self.__metas[key].type or nil);
end

function BaseWorldEntity:removeMeta(key)
    assert(type(key) == "string", "Arg #1 @ BaseWorldEntity:removeMeta | `key` must be a string.");

    local oldType = self.__metas[key] and self.__metas[key].type or nil;
    local oldValue = self.__metas[key] and self.__metas[key].value or nil;

    self.__metas[key] = nil;

    if (oldType and oldType ~= "local") then 
        self:__broadcastMetaChange(key, nil);
    end

    dispatchEntityEvent("onMetaChange", self, key, nil, oldValue);
end

-- 
-- Placeholders to be overridden
-- 

function BaseWorldEntity:getPosition()
    return 0, 0, 0;
end 