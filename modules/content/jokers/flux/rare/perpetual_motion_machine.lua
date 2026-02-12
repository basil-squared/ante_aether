SMODS.Joker {
    key = 'perpetual_motion',
    atlas = AA.G.JokerAtlas.key,
    pos = { x = 0, y = 0 },
    faction = 'flux',
    config = {
        extra = {
            rule_hand = 1,
            rule_ban = 1,
            rule_trigger = 1,
            rule_tag = 'tag_standard', -- Start with Standard
            rule_ban_rank = 2,         -- Target for specific rank ban
            is_valid = false           -- Current validity state for UI
        }
    },

    logic_pools = {
        hands = { 'Straight', 'Flush', 'Full House', 'Three of a Kind', 'Two Pair', 'Pair', 'High Card' },
        bans = {
            { id = 'face',          label = 'Face Cards' },
            { id = 'even',          label = 'Even Cards' },
            { id = 'odd',           label = 'Odd Cards' },
            { id = 'club',          label = 'Clubs' },
            { id = 'spade',         label = 'Spades' },
            { id = 'heart',         label = 'Hearts' },
            { id = 'diamond',       label = 'Diamonds' },
            { id = 'red',           label = 'Red Cards' },
            { id = 'specific_rank', label = 'Rank' } -- Dynamic Label
        },
        triggers = {
            { id = 'has_7',      label = 'contains a 7' },
            { id = 'has_ace',    label = 'contains an Ace' },
            { id = 'size_5',     label = 'exactly 5 Cards' },
            { id = 'low_chip',   label = '< 30 Chips' },
            { id = 'prime_sum',  label = 'Prime Rank Sum' },
            { id = 'square_sum', label = 'Square Rank Sum' },
            { id = 'fib_rank',   label = 'Fibonacci Ranks' },
            { id = 'ascending',  label = 'Ascending Ranks' },
            { id = 'sandwich',   label = 'Sandwich Rank' },
            { id = 'monochrome', label = 'Monochrome Hand' },
            { id = 'parity_mix', label = 'Odd & Even Mix' },
            { id = 'prod_200',   label = 'Rank Product > 200' },
            { id = '3_suits',    label = '3 Unique Suits' }
        },
        tags = {
            'tag_standard', 'tag_charm', 'tag_meteor', 'tag_buffoon',
            'tag_handy', 'tag_garbage', 'tag_ethereal', 'tag_top_up',
            'tag_orbit', 'tag_double', 'tag_coupon', 'tag_d_six'
        }
    },

    -- Helper: Validate Logic
    -- Returns: valid (bool), reason (string/nil)
    check_validity = function(self, card, hand_list, poker_hands)
        if not hand_list or #hand_list == 0 then return false end

        -- 1. Check Main Hand Type
        local required_hand = self.logic_pools.hands[card.ability.extra.rule_hand]
        -- If poker_hands triggers provided (from calculate context), use it.
        -- Otherwise (from update), we must evaluate.
        local hands_to_check = poker_hands
        if not hands_to_check then
            -- Evaluate purely based on hand_list?
            -- This simulates game logic.
            local _text, _disp, _hands = G.FUNCS.get_poker_hand_info(hand_list)
            hands_to_check = _hands
        end

        if not hands_to_check[required_hand] then return false end

        -- 2. Check Trigger ("Trap Active")
        local trap_active = false
        local trig_id = self.logic_pools.triggers[card.ability.extra.rule_trigger].id

        if trig_id == 'has_7' then
            for _, v in ipairs(hand_list) do
                if v.base.nominal == 7 then
                    trap_active = true; break
                end
            end
        elseif trig_id == 'has_ace' then
            for _, v in ipairs(hand_list) do
                if v.base.nominal == 14 then
                    trap_active = true; break
                end
            end
        elseif trig_id == 'size_5' then
            if #hand_list == 5 then trap_active = true end
        elseif trig_id == 'low_chip' then
            -- Chip calculation is complex to simulate in update.
            -- We assume context passes it, or estimate base chips?
            -- "low_chip" implies SCORING chips.
            -- Using "hand_chips" from calculate context.
            -- In update, we can't easily guess.
            -- We'll assume TRUE for update preview if chips < 30 (unlikely for 5 cards).
            -- This trigger is brittle in update loop.
            -- We'll check if context provided.
            if card.context_hand_chips then
                if card.context_hand_chips < 30 then trap_active = true end
            end
        elseif trig_id == 'prime_sum' then
            local sum = 0
            for _, v in ipairs(hand_list) do sum = sum + v.base.nominal end
            -- Primes up to 5*14 = 70.
            local primes = {
                [2] = true,
                [3] = true,
                [5] = true,
                [7] = true,
                [11] = true,
                [13] = true,
                [17] = true,
                [19] = true,
                [23] = true,
                [29] = true,
                [31] = true,
                [37] = true,
                [41] = true,
                [43] = true,
                [47] = true,
                [53] = true,
                [59] = true,
                [61] = true,
                [67] = true,
                [71] = true,
                [73] = true,
                [79] = true
            }
            if primes[sum] then trap_active = true end
        elseif trig_id == 'square_sum' then
            local sum = 0
            for _, v in ipairs(hand_list) do sum = sum + v.base.nominal end
            -- Squares: 1, 4, 9, 16, 25, 36, 49, 64, 81, 100
            local squares = { [1] = true, [4] = true, [9] = true, [16] = true, [25] = true, [36] = true, [49] = true,
                [64] = true, [81] = true, [100] = true }
            if squares[sum] then trap_active = true end
        elseif trig_id == 'fib_rank' then
            -- Fibonacci: 2, 3, 5, 8, 13 (King=13)
            local fibs = { [2] = true, [3] = true, [5] = true, [8] = true, [13] = true }
            local all_fib = true
            for _, v in ipairs(hand_list) do
                -- Check nominal (2-14) or id?
                -- Fibonacci sequence usually based on integer values.
                -- Let's use nominal.
                if not fibs[v.base.nominal] then
                    all_fib = false; break
                end
            end
            if all_fib then trap_active = true end
        elseif trig_id == 'ascending' then
            if #hand_list < 2 then
                trap_active = true
            else
                local sorted_hand = {}
                for k, v in ipairs(hand_list) do sorted_hand[k] = v end
                table.sort(sorted_hand, function(a, b) return a.base.id < b.base.id end)

                -- Check strictly increasing
                -- Wait, if we sort it, it's always ascending unless equal?
                -- User request: "Ascending Ranks".
                -- Interpretation: PLAYED hand is sorted?
                -- Or "No duplicates and gaps allowed"?
                -- If we sort it, we just check for duplicates?
                -- No, usually "Ascending" means played order?
                -- Balatro sorts played cards by rank usually.
                -- Let's interpret as "Unique Ranks".
                -- Or maybe "Strictly distinct ranks"?
                -- Let's go with: No duplicates.
                -- Actually, "Ascending order" in a sorted hand just means no duplicates.
                -- Let's check for NO DUPLICATE RANKS.
                local seen = {}
                local unique = true
                for _, v in ipairs(hand_list) do
                    if seen[v.base.id] then
                        unique = false; break
                    end
                    seen[v.base.id] = true
                end
                if unique then trap_active = true end
            end
        elseif trig_id == 'sandwich' then
            if #hand_list >= 3 then
                local sorted_hand = {}
                for k, v in ipairs(hand_list) do sorted_hand[k] = v end
                table.sort(sorted_hand, function(a, b) return a.base.id < b.base.id end)

                local outer_rank = sorted_hand[1].base.id
                local outer_match = (sorted_hand[#sorted_hand].base.id == outer_rank)

                if outer_match then
                    local inner_mismatch = true
                    for i = 2, #sorted_hand - 1 do
                        if sorted_hand[i].base.id == outer_rank then
                            inner_mismatch = false
                            break
                        end
                    end
                    if inner_mismatch then trap_active = true end
                end
            end
        elseif trig_id == 'monochrome' then
            if #hand_list > 0 then
                local first_suit = hand_list[1].base.suit
                local first_col = (first_suit == 'Hearts' or first_suit == 'Diamonds') and 'Red' or 'Black'
                trap_active = true
                for _, v in ipairs(hand_list) do
                    local s = v.base.suit
                    local c = (s == 'Hearts' or s == 'Diamonds') and 'Red' or 'Black'
                    if c ~= first_col then
                        trap_active = false; break
                    end
                end
            end
        elseif trig_id == 'parity_mix' then
            local has_even = false
            local has_odd = false
            for _, v in ipairs(hand_list) do
                if v.base.nominal % 2 == 0 then has_even = true else has_odd = true end
            end
            if has_even and has_odd then trap_active = true end
        elseif trig_id == 'prod_200' then
            local prod = 1
            for _, v in ipairs(hand_list) do prod = prod * v.base.nominal end
            if prod > 200 then trap_active = true end
        elseif trig_id == '3_suits' then
            local suits = {}
            local count = 0
            for _, v in ipairs(hand_list) do
                if not suits[v.base.suit] then
                    suits[v.base.suit] = true
                    count = count + 1
                end
            end
            if count == 3 then trap_active = true end
        end

        -- 3. Check Ban (If Trap Active)
        if trap_active then
            local ban_id = self.logic_pools.bans[card.ability.extra.rule_ban].id

            if ban_id == 'face' then
                for _, v in ipairs(hand_list) do if v:is_face() then return false end end
            elseif ban_id == 'even' then
                for _, v in ipairs(hand_list) do if v.base.nominal % 2 == 0 then return false end end
            elseif ban_id == 'odd' then
                for _, v in ipairs(hand_list) do if v.base.nominal % 2 ~= 0 then return false end end
            elseif ban_id == 'club' then
                for _, v in ipairs(hand_list) do if v.base.suit == 'Clubs' then return false end end
            elseif ban_id == 'spade' then
                for _, v in ipairs(hand_list) do if v.base.suit == 'Spades' then return false end end
            elseif ban_id == 'heart' then
                for _, v in ipairs(hand_list) do if v.base.suit == 'Hearts' then return false end end
            elseif ban_id == 'diamond' then
                for _, v in ipairs(hand_list) do if v.base.suit == 'Diamonds' then return false end end
            elseif ban_id == 'red' then
                for _, v in ipairs(hand_list) do if v.base.suit == 'Hearts' or v.base.suit == 'Diamonds' then return false end end
            elseif ban_id == 'specific_rank' then
                local banned_rank = card.ability.extra.rule_ban_rank or 2
                for _, v in ipairs(hand_list) do if v.base.nominal == banned_rank then return false end end
            end
        end

        return true
    end,

    loc_vars = function(self, info_queue, card)
        local h = self.logic_pools.hands[card.ability.extra.rule_hand]
        local b_conf = self.logic_pools.bans[card.ability.extra.rule_ban]
        local b = b_conf.label

        -- Dynamic Ban Label
        if b_conf.id == 'specific_rank' then
            local r = card.ability.extra.rule_ban_rank or 2
            if r == 14 then
                b = "Aces"
            elseif r == 13 then
                b = "Kings"
            elseif r == 12 then
                b = "Queens"
            elseif r == 11 then
                b = "Jacks"
            else
                b = tostring(r) .. "s"
            end
        end

        local t = self.logic_pools.triggers[card.ability.extra.rule_trigger].label

        -- Tag Info
        local tag_key = card.ability.extra.rule_tag or 'tag_standard'
        local tag_proto = G.P_TAGS[tag_key]
        local tag_name = tag_proto and localize { type = 'name_text', set = 'Tag', key = tag_key } or "Unknown Tag"

        -- Show Status based on updated state
        local status_text = "INVALID (X)"
        local status_col = G.C.RED
        if card.ability.extra.is_valid then
            status_text = "VALID (O)"
            status_col = G.C.GREEN
        end

        -- Formatting for main text
        return {
            vars = { h, b, t, status_text, tag_name },
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = status_col, r = 0.05, padding = 0.05 },
                            nodes = {
                                { n = G.UIT.T, config = { text = status_text, colour = G.C.UI.TEXT_LIGHT, scale = 0.3 } }
                            }
                        }
                    }
                }
            }
        }
    end,

    update = function(self, card, dt)
        if G.hand and G.hand.highlighted then
            -- Simple check logic for UI update
            -- We can't access poker hands easily here without calling evaluate.
            -- But evaluate is expensive per frame?
            -- Actually, Balatro evaluates play constantly for "Play Hand" button color.
            -- So calling get_poker_hand_info is fine.

            -- Throttle updates? dt check?
            -- For now, run every few frames or just run every frame.

            local valid = self:check_validity(card, G.hand.highlighted, nil)
            card.ability.extra.is_valid = valid
        else
            card.ability.extra.is_valid = false
        end
    end,

    calculate = function(self, card, context)
        -- 1. SCRAMBLE LOGIC (End of Round)
        if context.end_of_round and not context.repetition and not context.blueprint then
            card.ability.extra.rule_hand = pseudorandom('perp_h', 1, #self.logic_pools.hands)
            card.ability.extra.rule_ban = pseudorandom('perp_b', 1, #self.logic_pools.bans)
            card.ability.extra.rule_trigger = pseudorandom('perp_t', 1, #self.logic_pools.triggers)

            -- If specific rank ban, pick a rank (2-14)
            if self.logic_pools.bans[card.ability.extra.rule_ban].id == 'specific_rank' then
                card.ability.extra.rule_ban_rank = pseudorandom('perp_r', 2, 14)
            end

            -- Reward Randomization
            local tag_idx = pseudorandom('perp_tag', 1, #self.logic_pools.tags)
            card.ability.extra.rule_tag = self.logic_pools.tags[tag_idx]

            return { message = 'Recalibrating...' }
        end

        -- 2. THE SPAGHETTI CHECK (Joker Main)
        if context.joker_main then
            -- Store chips context if needed by update (hacky but useful)
            card.context_hand_chips = context.hand_chips

            local valid = self:check_validity(card, context.scoring_hand, context.poker_hands)

            if valid then
                -- Final Tag Award
                local tag_key = card.ability.extra.rule_tag or 'tag_standard'

                G.E_MANAGER:add_event(Event({
                    func = function()
                        add_tag(Tag(tag_key))
                        play_sound('timpani')
                        return true
                    end
                }))
                return {
                    message = 'Actuated!',
                    colour = G.C.GREEN,
                    card = card
                }
            else
                -- Feedback (Keep quiet on invalid to not spam)
            end
        end
    end
}
