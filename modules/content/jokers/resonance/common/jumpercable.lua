SMODS.Joker {
    key = "jumper_cable",
    faction = 'resonance',
    atlas = AA.G.JokerAtlas.key,
    pos = { x = 0, y = 0 },
    config = { extra = { repetitions = 1 } },
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
            if context.other_card == context.scoring_hand[1] then
                return {
                    repetitions = card.ability.extra.repetitions,
                    message = localize('k_again_ex')
                }
            end
        end
    end
}
