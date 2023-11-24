---@diagnostic disable: duplicate-index
---@class TLOZone
__TLOZone = {
    ---@return CurrentZoneType|ZoneType
    ---@overload fun(zoneId:number)
    ---@overload fun(zoneName:string)
    Zone = __CurrentZoneType,
}