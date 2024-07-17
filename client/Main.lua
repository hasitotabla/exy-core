EntityPool = {};

EntityClasses = {
    [EntityTypes.BASE_ENTITY] = BaseWorldEntity,
    [EntityTypes.PLAYER] = PlayerEntity,
    [EntityTypes.VEHICLE] = VehicleEntity,
};

EntityCreateHelpers = {
    [EntityTypes.BASE_ENTITY] = function(entityRemoteData) return BaseWorldEntity:new(entityRemoteData.type, entityRemoteData.netID); end,
    [EntityTypes.PLAYER] = function(entityRemoteData) return PlayerEntity:new(entityRemoteData.netID); end,
    [EntityTypes.VEHICLE] = function(entityRemoteData) return VehicleEntity:new(entityRemoteData.netID); end,
};

local function OnSyncEntities(entities)
    for _, entityData in ipairs(entities) do 
        local entityCreateFunc = EntityCreateHelpers[entityData.type];
        if (not entityCreateFunc) then 
            print("Entity class not found for type " .. entityData.type);
            goto continue;
        end

        local entity = entityCreateFunc(entityData);
        ::continue::
    end
end 

local function Main()
    -- Wait();

    local response = useFetch("Core::Internal::Initialize");
    OnSyncEntities(response.entities);
end 

CreateThread(Main);