MAX_VALID_ENTITY_ID = 91111111111;

EntityPool = {
    --[[
        [key: `EntityType:ID`]: Entity;
    ]]
};
EntitiesIDPools = {
    --[[
        [key in EntityTypes]: number;
    ]]
};

EntityClasses = {
    [EntityTypes.BASE_ENTITY] = BaseWorldEntity,
    [EntityTypes.PLAYER] = PlayerEntity,
    [EntityTypes.VEHICLE] = VehicleEntity,

    [EntityTypes.COLSHAPE] = ColShapeEntity, -- Base class for colshapes
    [EntityTypes.COLSPHERE] = ColSphereEntity,
};

function getIDForEntityType(entityType)
    if (not EntitiesIDPools[entityType]) then 
        EntitiesIDPools[entityType] = 0;
    end

    for i = 0, MAX_VALID_ENTITY_ID do 
        if (not EntityPool[entityType .. ":" .. i]) then 
            return i;
        end
    end

    error("No valid entity ID found for type " .. entityType);
end 

CreateThread(function()
    Wait(500);

    -- local testPlayer = PlayerEntity:new(GetPlayers()[1]);
    -- testPlayer:setSyncedMeta("APAD HALOTT", 911);

    -- local testVehicle = exports[GetCurrentResourceName()]:createVehicle("adder", testPlayer:getPosition() + vec3(5, 0, 2));
    -- iprint(testVehicle)

    -- testVehicle:setMeta("test", "asdxd");
    -- print(testVehicle:getPosition())
end);

addFetchHandler("Core::Internal::Initialize", function(done, ...)
    local client = source;
    local entitiesToSync = {};

    for entityID, entity in pairs(EntityPool) do 
        table.insert(entitiesToSync, entity:__getEntityDataForSync());
    end

    done({
        entities = entitiesToSync
    });
end);

AddEventHandler("onEntityCreated", function(entity)
    -- iprint("onEntityCreated", entity:setMeta("rakos", "geci", true));
end);

-- local testPlayer = new 'PlayerEntity'(1);
-- iprint(testPlayer:getPosition());
-- testPlayer:setMeta("test", "test", true);

-- local testCol = new 'ColshapeCuboid'(1);
-- iprint(testCol);

-- -- local testPlayer = PlayerEntity(2);
-- -- local testVehicle = VehicleEntity(
-- --     "adder", 0, 10, 75
-- -- );

-- addFetch("Core::FetchEntities", function(client, done)
--     iprint("fetch from", client, GetPlayerName(client), done);

--     local entitiesToSync = {};
--     for entityType, entities in pairs(EntityPool) do 
--         for _, entity in pairs(entities) do 
--             table.insert(entitiesToSync, entity:getEntityDataForSync());
--         end
--     end

--     done({
--         entities = entitiesToSync
--     })
-- end);

-- function getEntitiesFromType(entityType)
--     assert(
--         EntityPool[string.upper(entityType)] ~= nil, 
--         "Entity type " .. entityType .. " does not exist."
--     );

--     return EntityPool[string.upper(entityType)];
-- end
-- exports("getEntitiesFromType", getEntitiesFromType);