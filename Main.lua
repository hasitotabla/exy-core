IS_DEBUG_ENABLED = !(DEBUG == true);
exports("isDebugEnabled", function() return IS_DEBUG_ENABLED; end);

EntityClasses = {
    [EntityTypes.BASE_ENTITY] = BaseEntity,
    [EntityTypes.PLAYER] = PlayerEntity,
    [EntityTypes.VEHICLE] = VehicleEntity,

    [EntityTypes.COLSHAPE] = ColShapeEntity, -- Base class for colshapes
    [EntityTypes.COLSPHERE] = ColSphereEntity,
};
EntityPool = {
    --[[
        [key: `EntityType:ID`]: Entity;
    ]]
};
EntityRefsByType = {
    --[[
        [key: `EntityType`]: { [key: ID]: Entity };
    ]]
};

!if (IS_SERVER) then 
    EntitiesIDPools = {
        --[[
            [key in EntityTypes]: number;
        ]]
    };
!end

!if (IS_CLIENT) then 
    IS_CORE_INITIALIZED = false;

    EntityCreateHelpers = {
        [EntityTypes.BASE_ENTITY] = function(entityRemoteData) return BaseEntity:new(entityRemoteData.type, entityRemoteData.netID); end,
        [EntityTypes.PLAYER] = function(entityRemoteData) return PlayerEntity:new(entityRemoteData.netID); end,
        [EntityTypes.VEHICLE] = function(entityRemoteData) return VehicleEntity:new(entityRemoteData.netID); end,
    };
!end 

!if (IS_SERVER) then 
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

    addFetchHandler("Main::Initialize", function(done, ...)
        local client = source;
    
        local playerEntity = EntityPool[EntityTypes.PLAYER .. ":" .. client];
        if (not playerEntity) then 
            playerEntity = createEntity(EntityTypes.PLAYER, client);
        end
    
        local entitiesToSync = {};
        for entityID, entity in pairs(EntityPool) do 
            table.insert(entitiesToSync, entity:__getEntityDataForSync());
        end
        
        done({ entities = entitiesToSync });
    end);
!else
    local function main()        
        local response = useFetch("Main::Initialize");
        if (not response) then 
            return;
        end

        for _, entityData in ipairs(response.entities) do 
            local entityCreateFunc = EntityCreateHelpers[entityData.type];
            if (not entityCreateFunc) then 
                print("Entity class not found for type " .. entityData.type);
                goto continue;
            end

            local entity = entityCreateFunc(entityData);
            EntityPool[entity:getUniqueIdentifier()] = entity;

            ::continue::
        end

        IS_CORE_INITIALIZED = true;
        processPendingEntityCreations();
    end 

    CreateThread(main);
!end