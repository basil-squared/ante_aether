SMODS.Joker {
    key = "line_tapper",
    atlas = AA.G.JokerAtlas.key,
    pos = { x = 0, y = 0 },
    config = { extra = { moneyEarned = 4 } },
    faction = 'resonance',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Purple
        info_queue[#info_queue + 1] = G.P_SEALS.Blue

        return { vars = { card.ability.extra.moneyEarned } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card.seal == 'Purple' then
            return {
                dollars = card.ability.extra.moneyEarned,

            }
        end
        if context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker then
            for _, c in ipairs(G.hand.cards) do
                if c.seal == 'Blue' then
                    ease_dollars(card.ability.extra.moneyEarned)
                    card_eval_status_text(card, 'dollars', card.ability.extra.moneyEarned)
                end
            end
        end
    end,
}
