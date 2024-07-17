function requestModel(modelName)
    RequestModel(modelName);
    
    while (not HasModelLoaded(modelName)) do
        RequestModel(modelName);
        Wait(0);
    end
    
    return modelName;
end