-- EntityTypes = {
--     BASE_ENTITY = "BASE_ENTITY", 
--     PLAYER = "PLAYER", 
--     VEHICLE = "VEHICLE",
--     OBJECT = "OBJECT",
--     PED = "PED",
-- };

EntityTypes = Enum {
    BASE_ENTITY = "BASE_ENTITY", 

    COLSHAPE = "COLSHAPE",
    COLSPHERE = "COLSPHERE",

    PLAYER = "PLAYER", 
    VEHICLE = "VEHICLE",
    OBJECT = "OBJECT",
    PED = "PED",
}; exports("__enum__EntityTypes", function() return EntityTypes; end);