BaseWorldEntity = Class("BaseWorldEntity");

function BaseWorldEntity:constructor(entityType, netID)
    self.__type = entityType or EntityTypes.BASE_ENTITY;
    self.__netID = tonumber(netID);
    self.__metas = {};
    self.__events = {};

    local uniqueIdentifier = self:getUniqueIdentifier();
    EntityPool[uniqueIdentifier] = self;
end 

-- 
-- Getters / Setters
-- 

function BaseWorldEntity:getNetID() return self.__netID; end
function BaseWorldEntity:getType() return self.__type; end
function BaseWorldEntity:getUniqueIdentifier()
    return self.__type .. ":" .. self.__netID;
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
        dispatchEntityEvent("onClientMetaChange", self, key, value, oldValue);
    end
end

function BaseWorldEntity:getMeta(key)
    assert(type(key) == "string", "Arg #1 @ BaseWorldEntity:getMeta | `key` must be a string.");

    if (not self.__metas[key]) then return nil; end
    return self.__metas[key].value;
end

function BaseWorldEntity:removeMeta(key)
    assert(type(key) == "string", "Arg #1 @ BaseWorldEntity:removeMeta | `key` must be a string.");

    local oldType = self.__metas[key] and self.__metas[key].type or nil;
    local oldValue = self.__metas[key] and self.__metas[key].value or nil;

    self.__metas[key] = nil;

    dispatchEntityEvent("onClientMetaChange", self, key, nil, oldValue);
end

-- 
-- Placeholders to be overridden
-- 

function BaseWorldEntity:getPosition()
    return vec3(0, 0, 0);
end 