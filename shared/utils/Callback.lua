GenerateUniqueEventId = function(eventName)
    return (type(Cipher.encode) == "function") 
        and Cipher.encode(eventName)
        or false;
end
