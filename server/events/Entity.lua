
function triggerEntityEvent(eventName, entity, playerToTrigger, ...)
    print(debug.traceback())
    print("triggerEntityEvent", eventName, entity, playerToTrigger, ...);

    local entityId = entity:getUniqueIdentifier();
    TriggerClientEvent("Core::Internal::EventBridge::" .. eventName, playerToTrigger, entityId, ...);
end 