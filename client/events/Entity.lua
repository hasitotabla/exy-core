local queuedEvents = {
    --[[
        [key: `entityID`]: {
            [key: `eventName`]: Array<{
                callback: Function,
                args: Array<any>,
            }>,
        }
    ]]
};

function handleEntityEvent(eventName, callback)
    RegisterNetEvent("Core::Internal::EventBridge::" .. eventName, function(entityID, ...)
        local entity = EntityPool[entityID];
        if (not entity) then 
            print("Entity not found for ID " .. entityID);

            if (not queuedEvents[entityID]) then 
                queuedEvents[entityID] = {};
            end

            if (not queuedEvents[entityID][eventName]) then
                queuedEvents[entityID][eventName] = {};
            end

            table.insert(queuedEvents[entityID][eventName], {
                callback = callback,
                args = { ... },
            });

            return;
        end

        callback(entity, ...);
    end);
end 

function processQueuedEntityEvents(entityID)
    print('csinalas for ', entityID)
    if (not queuedEvents[entityID]) then 
        return;
    end

    for eventName, events in pairs(queuedEvents[entityID]) do 
        for _, event in ipairs(events) do 
            event.callback(EntityPool[entityID], unpack(event.args));
        end
    end

    queuedEvents[entityID] = nil;
end 