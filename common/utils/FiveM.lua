function isFunction(val)
    return (
        (type(val) == "function") or 
        (type(val) == "table" and type(val['__cfx_functionReference']) == "string")
    );
end 

function getFunctionSignature(func)
    if (type(func) == "function") then 
        return tostring(func);
    elseif (type(func) == "table" and type(func['__cfx_functionReference']) == "string") then 
        return func['__cfx_functionReference'];
    end 

    return nil;
end

function isFunctionExternal(func)
    return (type(func) == "table" and type(func['__cfx_functionReference']) == "string");
end