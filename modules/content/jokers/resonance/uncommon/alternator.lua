SMODS.Joker {
    key = 'alternator',
    faction = 'resonance',
    rarity = 2,
    atlas = AA.G.JokerAtlas.key,
    pos = { x = 0, y = 0 },
    config = { extra = { repetitions = 2 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.repetitions,
                card.ability.extra.repetitions > 1 and 'times' or 'time'
            }
        }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if #context.scoring_hand >= 2 then
                if context.other_card == context.scoring_hand[2] then
                    return {
                        repetitions = card.ability.extra.repetitions,
                        message = localize('k_again_ex')
                    }
                end
                if #context.scoring_hand >= 4 then
                    if context.other_card == context.scoring_hand[4] then
                        return {
                            repetitions = card.ability.extra.repetitions,
                            message = localize('k_again_ex')
                        }
                    end
                end
            end
        end
    end
}
