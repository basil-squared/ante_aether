--- Returns a table mapping each faction name to the number of jokers
--- the player currently has of that faction.
--- Example: { resonance = 3, flux = 1 }
---@return table<string, number>
function AA.FUNC.GetJokerFactionCounts()
    
    local counts = {}
    if G.jokers and G.jokers.cards then
        for _, joker in ipairs(G.jokers.cards) do
            local faction = joker.config and joker.config.center and joker.config.center.faction
            if faction then
                counts[faction] = (counts[faction] or 0) + 1
            end
        end
    end
    return counts
end
