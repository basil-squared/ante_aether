SMODS.Joker {
    key = "mana_battery",
    atlas = AA.G.JokerAtlas.key,
    pos = { x = 1, y = 0 },
    faction = "resonance",
    config = { extra = { multiIncrem = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.multiIncrem } }
    end,
    calculate = function(self, card, context)
        if context.blueprint then

        end
    end


}
