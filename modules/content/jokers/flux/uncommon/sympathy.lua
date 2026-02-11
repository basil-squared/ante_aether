local is_suit_ref = Card.is_suit

function Card:is_suit(suit, bypass_debuff, flush_calc)
    if G.jokers and G.jokers.cards then
        for _, joker in ipairs(G.jokers.cards) do
            if joker.ability and joker.ability.set == 'Joker'
                and joker.config.center.key == 'j_ante_aether_sympathy' then
                -- Check highlighted cards (live preview) then played cards (scoring)
                local cards = G.hand and G.hand.highlighted or {}
                if #cards < 2 and G.play and G.play.cards and #G.play.cards > 1 then
                    cards = G.play.cards
                end

                if #cards > 1 and cards[1]:is_face(true) then
                    local lead_suit = cards[1].base.suit
                    for i = 2, #cards do
                        if cards[i] == self then
                            return suit == lead_suit
                        end
                    end
                end
                break
            end
        end
    end
    return is_suit_ref(self, suit, bypass_debuff, flush_calc)
end

SMODS.Joker {
    key = "sympathy",
    faction = 'flux',
    atlas = AA.G.JokerAtlas.key,
    pos = { x = 00, y = 0 },
    rarity = 2,
    config = { extra = {} },
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker then
            local first_card = context.scoring_hand[1]
            if first_card and first_card:is_face() then
                return {
                    message = localize("ante_aether_transmit"),
                    colour = G.C.SUITS[first_card.base.suit] or G.C.BLUE,
                }
            end
        end
    end
}
