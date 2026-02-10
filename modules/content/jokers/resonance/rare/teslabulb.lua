SMODS.Joker {
    key = "tesla_bulb",
    rarity = 3,
    atlas = AA.G.JokerAtlas.key,
    pos = { x = 3, y = 0 },
    config = { extra = { repeitions = 2 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
        info_queue[#info_queue + 1] = { set = 'Other', key = 'ante_aether_surge_info' }
        return { vars = { card.ability.extra.repeitions, card.ability.extra.repeitions > 1 and "times" or "time" } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand then
            if SMODS.has_enhancement(context.other_card, 'm_steel') or SMODS.has_enhancement(context.other_card, 'm_gold') then
                return {
                    repetitions = 2,
                    message = localize('k_again_ex')
                }
            end
        end
    end


}
