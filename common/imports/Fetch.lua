local IS_SERVER = IsDuplicityVersion();
local RESOURCE_NAME = GetCurrentResourceName();

-- FetchResponses = Enum {
--     SUCCESS = "SUCCESS",
--     ERROR = "ERROR",
--     TIMED_OUT = "TIMED_OUT",
-- };

local pendingRPCRequests = {
    --[[
        Array<{

        }>;
    ]]
};
local rpcEventHandlers = {
    --[[
        [key: string]: (done: (...args: any) => void, client: Entity<Player>, ...args: any) => void
    ]]
};

local function createResponseHandler(eventName, responseToken, responsePromise, client)
    return (function(...)
        local args = { ... };
        local payload = {
            responseToken = responseToken,
            data = args,
        };

        !if (IS_SERVER) then 
            TriggerClientEvent(
                "Core::RPC::Response::" .. eventName,
                client,
                payload
            );
        !else 
            TriggerServerEvent(
                "Core::RPC::Response::" .. eventName,
                payload
            );
        !end 

        responsePromise:resolve(true);
    end);
end 

addFetchHandler = function(eventName, handler)
    if (rpcEventHandlers[eventName]) then 
        print("Fetch handler " .. eventName .. " already exists, overriding..");
        RemoveEventHandler(rpcEventHandlers[eventName]);
    end

    rpcEventHandlers[eventName] = RegisterNetEvent(
        "Core::RPC::Request::" .. eventName,
        function(payload)
            local client = source;

            local responseToken = payload.responseToken;
            assert(responseToken, "RPC request " .. eventName .. " did not contain a response token.");

            local data = payload.data or {};
            assert(type(data) == "table", "RPC request " .. eventName .. " data must be a table.");

            local responsePromise = promise.new();

            local lastSource = source;
            _G.source = client;

            !if (IS_SERVER) then 
                handler(
                    createResponseHandler(eventName, payload.responseToken, responsePromise, client), 
                    table.unpack(data)
                );
            !else 
                handler(
                    createResponseHandler(eventName, payload.responseToken, responsePromise, nil), 
                    table.unpack(data)
                );
            !end 

            _G.source = lastSource;

            SetTimeout(5000, function() responsePromise:resolve(false); end);
            local response = Citizen.Await(responsePromise);

            if (not response) then 
                print("RPC request " .. eventName .. " timed out.");
            end
        end 
    );
end 

!if (IS_SERVER) then 

!else
    local handleFetch = function(eventName, data, handler)
        local responseToken = getRandomString(16);
        local handlePromise = promise.new();

        local listener;
        listener = RegisterNetEvent(
            "Core::RPC::Response::" .. eventName,
            function(payload)
                if (payload.responseToken ~= responseToken) then 
                    return;
                end

                RemoveEventHandler(listener);
                handler(table.unpack(payload.data));
            end 
        );

        local payload = {
            data = data,
            responseToken = responseToken,
        };

        TriggerServerEvent(
            "Core::RPC::Request::" .. eventName,
            payload
        );
    end 

    useFetchAsync = function(eventName, handler, ...)
        local data = { ... };
        handleFetch(eventName, data, handler);
    end

    useFetch = function(eventName, ...)
        print("gecisfaszom#1")
        local data = { ... };
        local responseToken = getRandomString(16);
        local handlePromise = promise.new();

        handleFetch(eventName, data, function(...)
            handlePromise:resolve(...);
        end);

        return Citizen.Await(handlePromise);
    end 

    print("megolom csaladod am#1", useFetch)
!end 