ColSphereEntity = Class("ColSphereEntity", ColShapeEntity);

function ColSphereEntity:constructor(x, y, z, radius)
    assert(colType and ColShapeTypes[colType], "Type must be a ColShapeTypes.");
    assert(type(position) == "vector3", "Position must be a vector3.");
    assert(type(size) == "vector3", "Size must be a vector3.");

    self:super(EntityTypes.COLSHAPE, colShapeHandle);
end