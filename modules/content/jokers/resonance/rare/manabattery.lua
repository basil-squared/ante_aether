SMODS.Joker {
    key = "mana_battery",

    atlas = AA.G.JokerAtlas.key,
    rarity = 3,
    pos = { x = 1, y = 0 },
    faction = "resonance",
    config = { extra = { multiIncrem = 0.2, currIncrem = 1 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { set = "Other", key = "ante_aether_surge_info" }
        return { vars = { card.ability.extra.multiIncrem } }
    end,
    calculate = function(self, card, context)
        if context.surge then
            card.ability.extra.currIncrem = card.ability.extra.currIncrem + card.ability.extra.multiIncrem
            return {
                message = localize("k_upgrade_ex")
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.currIncrem
            }
        end
        if context.end_of_round and context.main_eval then
            card.ability.extra.currIncrem = 1
            return {
                message = localize("k_reset")
            }
        end
    end


}
