RegisterNetEvent("Core::Internal::RepairVehicle", function(vehicleNetId)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId);
    if (not DoesEntityExist(vehicle)) then return; end

    SetVehicleEngineHealth(vehicle, 1000);
	SetVehicleEngineOn(vehicle, true, true);
	SetVehicleFixed(vehicle);
end);