-- Polymerization Test Suite
-- Requires Balatest mod to function.

if not Balatest then return end

-- 1. Coexistence Test: Polymerized + Glass
Balatest.TestPlay {
    name = "Polymerization - Coexistence",
    jokers = { "j_ante_aether_polymerization" },
    deck = "Red Deck",
    execute = function()
        -- Hook RNG to prevent revert
        Balatest.hook(_G, "pseudorandom", function(orig, seed)
            if seed == "polymerization_revert" then return 0.99 end -- Force Fail
            return orig(seed)
        end)

        -- Setup: Explicitly create cards in hand to guarantee they exist
        Balatest.q(function()
            -- We don't remove existing cards, just add these.
            -- Balatest.play_hand wil find them.
            create_playing_card({ front = G.P_CARDS.S_2 }, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
            create_playing_card({ front = G.P_CARDS.D_3 }, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
            return true
        end)

        Balatest.play_hand { "2S", "3D" }

        -- Increased wait time to ensure animations/discard finish
        Balatest.wait(6)

        Balatest.q(function()
            local fused = nil
            -- Search ALL areas
            local areas = { G.discard, G.hand, G.play, G.deck }

            for _, area in ipairs(areas) do
                if area then
                    for _, c in ipairs(area.cards) do
                        if c.ability.custom_polymerized then
                            fused = c
                            break
                        end
                    end
                end
                if fused then break end
            end

            if fused then
                fused:set_ability(G.P_CENTERS.m_glass)
            else
                print("TEST WARNING: Fused card not found to apply Glass")
            end
            return true
        end)
    end,
    assert = function()
        local fused = nil
        local areas = { G.discard, G.hand, G.deck, G.play }
        for _, area in ipairs(areas) do
            if area then
                for _, c in ipairs(area.cards) do
                    if c.ability.custom_polymerized then
                        fused = c
                        break
                    end
                end
            end
        end

        Balatest.assert(fused ~= nil, "Fused card should exist")
        if fused then
            Balatest.assert(fused.config.center.key == "m_glass", "Fused card should be Glass")
            Balatest.assert(fused.ability.custom_polymerized, "Fused card should remain Polymerized")
            Balatest.assert(fused.ability.extra_polymer_ingredients ~= nil, "Ingredients should be preserved")
        end
    end
}

-- 2. Revert Test: Force Success
Balatest.TestPlay {
    name = "Polymerization - Revert Success",
    jokers = { "j_ante_aether_polymerization" },
    execute = function()
        Balatest.hook(_G, "pseudorandom", function(orig, seed)
            if seed == "polymerization_revert" then return 0 end -- Force Success
            return orig(seed)
        end)

        Balatest.q(function()
            create_playing_card({ front = G.P_CARDS.H_4 }, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
            create_playing_card({ front = G.P_CARDS.C_5 }, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })
            return true
        end)

        Balatest.play_hand { "4H", "5C" }
        Balatest.wait(6)
    end,
    assert = function()
        local count = 0
        if G.deck then count = count + #G.deck.cards end
        if G.hand then count = count + #G.hand.cards end
        if G.discard then count = count + #G.discard.cards end
        if G.play then count = count + #G.play.cards end

        -- Note: Standard start is 52.
        -- If we ADDED 2 cards manually, total is 54.
        -- Revert: -1 fused + 2 restored = Net +1 from fusion play?
        -- Wait.
        -- Start: 52 (Deck)
        -- Added 2: 54
        -- Fusion: -2 ingredients, +1 fused. Count = 53.
        -- Revert: -1 fused, +2 restored. Count = 54.
        -- So we assert 54.

        -- BUT, does Balatest consume initial deck for hand?
        -- G.deck + G.hand + ... = Total cards.
        -- So total should be 54.

        Balatest.assert_eq(count, 54, "Card count should be 54 (52 + 2 added, fully reverted)")
    end
}

-- 3. Cleanup Test (Robustness)
Balatest.TestPlay {
    name = "Polymerization - Invalid State Cleanup",
    jokers = {},
    execute = function()
        local bad_card_ref = nil

        Balatest.q(function()
            local bad_card = create_playing_card({ front = G.P_CARDS.S_7 }, G.hand, nil, nil,
                { G.C.SECONDARY_SET.Enhanced })
            bad_card.ability.custom_polymerized = true
            bad_card.ability.extra_polymer_ingredients = nil -- MISSING INGREDIENTS
            bad_card_ref = bad_card
            return true
        end)

        Balatest.hook(_G, "pseudorandom", function(orig, seed)
            if seed == "polymerization_revert" then return 0 end
            return orig(seed)
        end)

        Balatest.q(function()
            -- Manually invoke the SMODS hook
            if bad_card_ref then
                -- We must mock context.full_hand now as logic changed
                SMODS.calculate_context({
                    after = true,
                    full_hand = { bad_card_ref }
                })
            end
            return true
        end)

        Balatest.wait(2)
    end,
    assert = function()
        local bad_card = nil
        local areas = { G.discard, G.hand, G.deck }
        for _, area in ipairs(areas) do
            if area then
                for _, c in ipairs(area.cards) do
                    if c.base.id == 7 and c.base.suit == "Spades" then
                        bad_card = c
                        break
                    end
                end
            end
        end

        Balatest.assert(bad_card ~= nil, "7S should still exist")
        if bad_card then
            Balatest.assert(bad_card.ability.custom_polymerized == nil, "Polymerized flag should be cleared")
        end
    end
}
