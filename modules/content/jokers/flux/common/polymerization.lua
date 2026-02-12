-- Rank ID helper: Aces count as 1 for fusion sum, everything else uses base.id
local function get_fusion_rank(card)
    if card.base.id == 14 then return 1 end -- Ace = 1
    return card.base.id
end

-- Map a numeric rank value (2-10) to a Balatro rank string
local RANK_FROM_VALUE = {
    [2] = '2',
    [3] = '3',
    [4] = '4',
    [5] = '5',
    [6] = '6',
    [7] = '7',
    [8] = '8',
    [9] = '9',
    [10] = '10',
}

SMODS.Joker {
    key = 'polymerization',
    faction = 'flux',
    atlas = AA.G.JokerAtlas.key,
    pos = { x = 0, y = 0 },
    rarity = 1,
    config = { extra = { cards = 2, odds = 4 } },
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.cards,
                G.GAME.probabilities.normal,
                card.ability.extra.odds,
            }
        }
    end,

    calculate = function(self, card, context)
        -- PHASE 1: FUSION (before hand scores)
        if context.before and not context.blueprint and not context.retrigger_joker then
            local hand = context.full_hand
            if not hand or #hand ~= card.ability.extra.cards then return end

            local card_a, card_b = hand[1], hand[2]
            local rank_sum = get_fusion_rank(card_a) + get_fusion_rank(card_b)

            if not RANK_FROM_VALUE[rank_sum] then return end

            -- 1. Create Fused Card Synchronously (so it scores)
            local fused = create_playing_card({
                front = G.P_CARDS[card_a.base.suit .. '_' .. RANK_FROM_VALUE[rank_sum]],
            }, G.play, nil, nil, { G.C.SECONDARY_SET.Enhanced })

            -- Position it over the first card for visual continuity
            fused.T.x = card_a.T.x
            fused.T.y = card_a.T.y

            -- Apply State (using Manager)
            if AA.FUNC.set_polymerized then
                AA.FUNC.set_polymerized(fused, card_a, card_b)
            end

            -- 2. Update scoring_hand Synchronously
            -- Clear originals from scoring (but they remain in G.play until dissolved)
            for i = #context.scoring_hand, 1, -1 do
                table.remove(context.scoring_hand, i)
            end
            context.scoring_hand[1] = fused

            -- 3. Queue Visuals
            -- Dissolve originals
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    card_a:start_dissolve(nil, true)
                    card_b:start_dissolve(nil, true)
                    return true
                end
            }))

            -- Materialize fused (visual pop)
            fused:start_materialize()

            return {
                message = localize('ante_aether_fused'),
                colour = G.C.FILTER,
            }
        end
    end

}
