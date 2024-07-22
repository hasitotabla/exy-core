local isSpawningInProgress = false;

handleEntityEvent("Player::RequestSpawn", function(player, data)    
    if (not player:isLocal()) then 
        error("Attempted to spawn a non-local player entity.");
    end

    local x, y, z = table.unpack(data.pos);
    local model = data.model or GetHashKey("mp_m_freemode_01");
    local skipFade = data.skipFade or false;

    -- force the values to be floats
    x = x + 0.0;
    y = y + 0.0;
    z = z + 0.0;

    if (isSpawningInProgress) then 
        return;
    end

    isSpawningInProgress = true;

    player:freeze(true);

    if (model) then 
        player:setModel(model);
    end
    
    local playerPed = player:getPed();

    RequestCollisionAtCoord(x, y, z);
    SetEntityCoordsNoOffset(playerPed, x, y, z, false, false, false, true);
    NetworkResurrectLocalPlayer(x, y, z, 0.0, true, false);

    ClearPedTasksImmediately(playerPed);
    RemoveAllPedWeapons(playerPed);
    ClearPlayerWantedLevel(player:getNetID());

    local time = GetGameTimer();
    while (
        not HasCollisionLoadedAroundEntity(playerPed) and 
        (GetGameTimer() - time) < 5000
    ) do
        Wait(100);
    end

    ShutdownLoadingScreen();

    if (IsScreenFadedOut()) then 
        DoScreenFadeIn(500);

        while (not IsScreenFadedIn()) do
            Wait(0);
        end
    end 

    player:freeze(false);

    isSpawningInProgress = false;
end);