AddEventHandler("onResourceStart", function(resourceName)
    if (resourceName ~= GetCurrentResourceName()) then 
        return;
    end

    for _, playerID in ipairs(GetPlayers()) do 
        playerEntity = createEntity(EntityTypes.PLAYER, playerID);
    end
end);

AddEventHandler("onResourceStop", function(resourceName)
    for entityId, entity in pairs(EntityPool) do 
        if (entity.__resourceRoot == resourceName) then 
            entity:destroy();
        end
    end 
end);