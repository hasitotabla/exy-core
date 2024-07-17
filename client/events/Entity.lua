function handleEntityEvent(eventName, callback)
    RegisterNetEvent("Core::Internal::EventBridge::" .. eventName, function(entityID, ...)
        local entity = EntityPool[entityID];
        if (not entity) then 
            print("Entity not found for ID " .. entityID);
            return;
        end

        callback(entity, ...);
    end);
end 