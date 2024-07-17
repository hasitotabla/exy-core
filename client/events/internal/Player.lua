local isSpawningInProgress = false;

handleEntityEvent("Player::RequestSpawn", function(player, x, y, z, model)
    --[[
        if not spawn.skipFade then
            DoScreenFadeOut(500)

            while not IsScreenFadedOut() do
                Citizen.Wait(0)
            end
        end
    ]]
    
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
        not HasCollisionLoadedAroundEntity(ped) and 
        (GetGameTimer() - time) < 5000
    ) do
        Wait(0);
    end

    ShutdownLoadingScreen();

    if (IsScreenFadedOut()) then 
        DoScreenFadeIn(500);

        while not IsScreenFadedIn() do
            Wait(0);
        end
    end 

    player:freeze(false);

    isSpawningInProgress = false;
end);