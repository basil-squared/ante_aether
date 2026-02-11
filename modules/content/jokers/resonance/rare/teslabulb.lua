SMODS.Joker {
    key = "tesla_bulb",
    faction = 'resonance',
    rarity = 3,
    atlas = AA.G.JokerAtlas.key,
    pos = { x = 3, y = 0 },
    config = { extra = { repetitions = 2 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold

        return { vars = { card.ability.extra.repetitions, card.ability.extra.repetitions > 1 and "times" or "time" } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand then
            if SMODS.has_enhancement(context.other_card, 'm_steel') or SMODS.has_enhancement(context.other_card, 'm_gold') then
                return {
                    repetitions = card.ability.extra.repetitions,
                    message = localize('k_again_ex')
                }
            end
        end
    end


}
