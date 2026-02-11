SMODS.Joker {
    key = 'repeater',
    faction = 'resonance',
    rarity = 3,
    atlas = AA.G.JokerAtlas.key,
    pos = { x = 0, y = 0 },
    config = { extra = { repetitions = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions, card.ability.extra.repetitions > 1 and 'times' or 'time' } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.scoring_name == 'High Card' then
                return {
                    repetitions = card.ability.extra.repetitions,
                    message = localize('k_again_ex')
                }
            end
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            if context.scoring_name == 'High Card' and G.GAME.current_round.hands_left > 0 and not G.GAME.blind.defeated then
                local held_cards = {}
                for _, v in ipairs(G.hand.cards) do
                    held_cards[#held_cards + 1] = v
                end
                if #held_cards > 0 then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        func = function()
                            for _, v in ipairs(held_cards) do
                                G.hand:add_to_highlighted(v)
                            end
                            G.FUNCS.discard_cards_from_highlighted()
                            return true
                        end
                    }))
                end
            end
        end
    end
}
