SMODS.Joker {
    key = 'switchboard',
    atlas = AA.G.JokerAtlas.key,
    pos = { x = 0, y = 0 },
    faction = 'resonance',
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local target = context.other_card
            if not target or target.ability.aa_switchboard_swapped then return end

            local original_chips = target:get_chip_bonus()
            local original_mult = target:get_chip_mult()

            -- Offset perma values so displayed chips = original mult, displayed mult = original chips
            target.ability.perma_bonus = (target.ability.perma_bonus or 0) + (original_mult - original_chips)
            target.ability.perma_mult = (target.ability.perma_mult or 0) + (original_chips - original_mult)
            target.ability.aa_switchboard_swapped = true

            return {
                message = localize('k_swapped_ex'),
                card = card
            }
        end
    end
}
