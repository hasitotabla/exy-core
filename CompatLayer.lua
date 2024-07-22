local DEBUG = !(SHARED_MODE ~= "prod");
local CORE_RESOURCE_NAME = "exy_core";

-- 
-- Imported enums and stuff
-- 

-- local CoreEvents = exports[CORE_RESOURCE_NAME]:__enum__CoreEvents();
local EntityTypes = exports[CORE_RESOURCE_NAME]:__enum__EntityTypes();
local ColShapeTypes = exports[CORE_RESOURCE_NAME]:__enum__ColShapeTypes();

-- 
-- Helpers
-- 

string.split = function(b,c)local c=c or"%s"local d={}local e=1;for f in string.gmatch(b,"([^"..c.."]+)")do d[e]=f;e=e+1 end;return d end
string.capitalize = function(str) return (str:lower():gsub("^%l", string.upper)); end

-- 
-- Wrapper for entities
-- 

local function __isValueEntityReference__(value)
    return (type(value) == "table" and value.__entityMT);
end

local function __convertEntityWrapperToReference__(entity)
    return {
        __entityMT = true, 
        __netID = entity:getNetID(),
        __type = entity:getType()
    };
end

local __entityWrappersCache__ = {};
local __createEntityWrapperMT__ = function(entityId, entityType)
    if (__entityWrappersCache__[entityId]) then 
        return __entityWrappersCache__[entityId];
    end

    local wrapper = {};
    setmetatable(wrapper, {
        __index = function(self, key)
            if (key == "__entityMT") then
                return true;
            end

            return (function(entity_, ...)
                local args = { ... };

                for index, value in ipairs(args) do 
                    if (__isValueEntityReference__(value)) then 
                        args[index] = __convertEntityWrapperToReference__(value);
                    end 
                end

                return table.unpack(
                    exports[CORE_RESOURCE_NAME]:__entities__emitEntityMethod(
                        entityId, 
                        key, 
                        table.unpack(args)
                    )
                );
            end);
        end,

        __tostring = function(self)
            local splitted = string.split(entityId, ":");
            return "EntityWrapper<" .. string.capitalize(splitted[1] or "unk") .. "> { id: " .. (splitted[2] or -1) .. " }"; 
        end,

        __call = function(self, ...) error("Cannot call entity wrapper."); end,
        __newindex = function(self, key, value) error("Cannot set values on entity wrapper."); end,
    });

    __entityWrappersCache__[entityId] = wrapper;
    return wrapper;
end 

local __createEntity__ = function(entityType, ...)
    local entityId = exports[CORE_RESOURCE_NAME]:__createEntity_internal__(entityType, ...);
    if (not entityId or entityId == 0) then 
        return error("Failed to create entity of type " .. entityType);
    end

    local wrappedEntity = __createEntityWrapperMT__(entityId, entityType);
    return wrappedEntity;
end

-- 
-- De/Serializing events
-- 

local __isEventParamEntity__ = function(param) return (type(param) == "table" and param.__entityMT); end
local __getEntityIdFromParam__ = function(param) return param.__type .. ":" .. param.__netID; end

local __originalAddEventHandler = AddEventHandler;
AddEventHandler = function(eventName, callback)
    return __originalAddEventHandler(eventName, function(...)
        local invoking = GetInvokingResource();
        local lastSource = _G.source;
        local lastInvoking = _G.invokingResource;

        if (invoking ~= CORE_RESOURCE_NAME) then 
            _G.source = source;
            _G.invokingResource = invoking;

            local result = { callback(...) };
            _G.source = lastSource;
            _G.invokingResource = lastInvoking;

            return table.unpack(result);
        end 

        local args = { ... };

        -- if no source was passed
        local eventSource = args[1];
        if (not eventSource) then 
            return callback();
        end 

        -- if args[1] is an entity, skip it while iterating
        -- the rest of the args
        local hasSource = false;

        if (__isEventParamEntity__(eventSource)) then 
            hasSource = true;
            _G.source = __createEntityWrapperMT__(
                __getEntityIdFromParam__(eventSource), 
                eventSource.__type
            );
        end 

        for index = (hasSource and 2 or 1), #args do
            local value = args[index];
            
            if (not __isEventParamEntity__(value)) then
                goto continue;
            end
            
            args[index] = __createEntityWrapperMT__(
                __getEntityIdFromParam__(value), 
                value.__type
            );

            ::continue::
        end 

        local result = { callback(table.unpack(args, (hasSource and 2 or 1))) };

        if (hasSource) then 
            _G.source = lastSource;
        end 

        return table.unpack(result);
    end);
end 

-- 
-- all of other shit
-- 

iprint = function(...) return exports[CORE_RESOURCE_NAME]:iprint(...); end

getEntitiesByType = function(entityType, rootResource)
    local entities = exports[CORE_RESOURCE_NAME]:__getEntitiesByType_internal__(entityType, rootResource);
    for index, value in ipairs(entities) do 
        entities[index] = __createEntityWrapperMT__(
            __getEntityIdFromParam__(value), 
            value.__type
        );
    end 

    return entities;
end 

!if (IS_SERVER) then 
    createVehicle = function(...) return __createEntity__(EntityTypes.VEHICLE, ...); end
    createPed = function(...) return __createEntity__(EntityTypes.PED, ...); end
    createObject = function(...) return __createEntity__(EntityTypes.OBJECT, ...); end

    createColSphere = function(...) return __createEntity__(EntityTypes.COLSPHERE, ...); end
!else 

!end 