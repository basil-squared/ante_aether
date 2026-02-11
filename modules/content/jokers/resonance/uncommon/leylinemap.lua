SMODS.Joker {
    key = 'leyline_map',
    rarity = 2,
    faction = 'resonance',
    atlas = AA.G.JokerAtlas.key,
    pos = { x = 2, y = 0 },
    config = { extra = { chipincrem = 5 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { set = "Other", key = "ante_aether_surge_info" }
        return { vars = { card.ability.extra.chipincrem } }
    end,
    calculate = function(self, card, context)
        if context.surge and context.other_card then
            context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) +
                card.ability.extra.chipincrem
            return {
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chipincrem } },
                colour = G.C.CHIPS
            }
        end
    end
}
