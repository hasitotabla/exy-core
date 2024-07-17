Cipher = {};

Cipher.encode = function(str, secret1, secret2)
    if (not __SharedEventSecret) then 
        return false;
    end 

    local Key53 = __SharedEventSecret.Key53;
    local Key14 = __SharedEventSecret.Key14; 

    if not inv256 then
        inv256 = {};
        for M = 0, 127 do
            local inv = -1;

            repeat
                inv = inv + 2;
            until inv * (2 * M + 1) % 256 == 1;

            inv256[M] = inv;
        end
    end

    local K, F = Key53, 16384 + Key14;
    
    return (str:gsub(
        ".",
        function(m)
            local L = K % 274877906944;
            local H = (K - L) / 274877906944;
            local M = H % 128;
            m = m:byte();
            local c = (m * inv256[M] - (H - M) / 128) % 256;
            K = L * F + H + c + m;
            return ("%02x"):format(c);
        end
    ))
end

Cipher.decode = function(str, secret1, secret2)
    if (not __SharedEventSecret) then 
        return false;
    end 

    local Key53 = __SharedEventSecret.Key53;
    local Key14 = __SharedEventSecret.Key14; 

    local K, F = Key53, 16384 + Key14;
    return (str:gsub(
        "%x%x",
        function(c)
            local L = K % 274877906944;
            local H = (K - L) / 274877906944;
            local M = H % 128;
            c = tonumber(c, 16);
            local m = (c + (H - M) / 128) * (2 * M + 1) % 256;
            K = L * F + H + c + m;
            return string.char(m);
        end
    ))
end
