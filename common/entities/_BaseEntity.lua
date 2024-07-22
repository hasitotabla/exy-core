BaseEntity = Class("BaseEntity");

function BaseEntity:constructor(entityType, id)
    self.__netID = id or getIDForEntityType(self.__type);
    self.__type = entityType or EntityTypes.BASE_ENTITY;
    self.__resourceRoot = GetCurrentResourceName();
    
    self.__metas = {};
end 

function BaseEntity:__postDestroy()
    local uniqueIdentifier = self:getUniqueIdentifier();
    EntityPool[uniqueIdentifier] = nil;
end

-- 
-- Getters / Setters
-- 

function BaseEntity:getNetID() return self.__netID; end
function BaseEntity:getType() return self.__type; end
function BaseEntity:getUniqueIdentifier()
    return self.__type .. ":" .. self.__netID;
end

-- 
-- Internals
-- 

function BaseEntity:__setResourceRoot(resourceRoot)
    self.__resourceRoot = resourceRoot;
end

!if (IS_SERVER) then 
function BaseEntity:__getEntityDataForSync()
    return {
        type = self.__type, 
        netID = self.__netID, 
        metas = self.__metas
    };
end

function BaseEntity:__broadcastMetaChange(key, value)
    TriggerClientEvent("Core::Internal::OnEntityMetaChange", -1, self:getUniqueIdentifier(), key, value);
end
!end

-- 
-- Metadata
-- 

function BaseEntity:setMeta(key, value)
    assert(type(key) == "string", "Arg #1 @ BaseEntity:setMeta | `key` must be a string.");

    local oldValue = self.__metas[key] and self.__metas[key].value or nil;
    local oldType = self.__metas[key] and self.__metas[key].type or nil;

    self.__metas[key] = {
        value = value, 
        type = "local"
    };

    if (oldValue ~= value) then 
        !if (IS_SERVER) then 
        if (oldType and oldType ~= "local") then 
            self:__broadcastMetaChange(key, nil); -- Remove meta from clients, because it became local
        end 
        !end

        dispatchEntityEvent(
            !(IS_SERVER and "onMetaChange" or "onClientMetaChange"), 
            self, key, value, oldValue
        );
    end
end

!if (IS_SERVER) then
function BaseEntity:setSyncedMeta(key, value)
    assert(type(key) == "string", "Arg #1 @ BaseEntity:setSyncedMeta | `key` must be a string.");

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

function BaseEntity:setStreamSyncedMeta(key, value)
    assert(type(key) == "string", "Arg #1 @ BaseEntity:setStreamSyncedMeta | `key` must be a string.");
    
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
!end

function BaseEntity:getMeta(key)
    assert(type(key) == "string", "Arg #1 @ BaseEntity:getMeta | `key` must be a string.");

    if (not self.__metas[key]) then return nil; end
    return self.__metas[key].value;
end

function BaseEntity:getMetaSyncType(key)
    assert(type(key) == "string", "Arg #1 @ BaseEntity:getMetaSyncType | `key` must be a string.");

    return (self.__metas[key] and self.__metas[key].type or nil);
end

function BaseEntity:removeMeta(key)
    assert(type(key) == "string", "Arg #1 @ BaseEntity:removeMeta | `key` must be a string.");

    local oldType = self.__metas[key] and self.__metas[key].type or nil;
    local oldValue = self.__metas[key] and self.__metas[key].value or nil;

    self.__metas[key] = nil;

    !if (IS_SERVER) then
    if (oldType and oldType ~= "local") then 
        self:__broadcastMetaChange(key, nil);
    end
    !end

    dispatchEntityEvent(
        !(IS_SERVER and "onMetaChange" or "onClientMetaChange"), 
        self, key, nil, oldValue
    );
end

-- 
-- Placeholders to be overridden
-- 