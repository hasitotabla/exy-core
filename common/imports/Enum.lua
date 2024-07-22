Enum = function(props)
    local enum = {};

    for i = 1, #props do 
        local prop = props[i];
        enum[prop] = i;
    end

    for key, value in pairs(props) do 
        enum[key] = value;
    end

    return enum;
end 