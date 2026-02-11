SMODS.Joker {
    key = 'superconductor',
    atlas = AA.G.JokerAtlas.key,
    pos = { x = 0, y = 0 },
    faction = 'resonance',
    config = { extra = { xmult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { set = 'Other', key = 'ante_aether_surge_info' }
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.surge then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}
