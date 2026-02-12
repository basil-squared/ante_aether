-- Polymerization Manager
-- Handles global state, visual badges, and the revert mechanic for Polymerized cards.

local G_VAR = "polymerization_manager"

-- 1. Helper Function: Application
AA.FUNC.set_polymerized = function(card, ingredient1, ingredient2)
    if not card or not ingredient1 or not ingredient2 then return end

    -- Set the custom flag
    card.ability.custom_polymerized = true

    -- Store ingredients
    local ingredients = {}
    for i, c in ipairs({ ingredient1, ingredient2 }) do
        ingredients[i] = {
            rank    = c.base.value,
            suit    = c.base.suit,
            id      = c.base.id,
            edition = c.edition and copy_table(c.edition) or nil,
            seal    = c.seal or nil,
            ability = c.config and c.config.center_key or nil,
        }
    end
    card.ability.extra_polymer_ingredients = ingredients

    -- Visual cue
    card:juice_up(0.8, 0.5)
end

-- 2. Global Hook: Scoring/Revert Logic
-- Switched to hook SMODS.calculate_context, as playing cards don't receive calculate_joker calls for context.after
local smods_calculate_context_ref = SMODS.calculate_context
function SMODS.calculate_context(context, return_table)
    local ret = smods_calculate_context_ref(context, return_table)

    -- Check: Polymerized Revert Logic
    -- Trigger on 'after' context (End of scoring)
    if context.after and context.full_hand then
        for _, card in ipairs(context.full_hand) do
            if card.ability and card.ability.custom_polymerized and not card.debuff then
                -- 1 in 4 chance to revert
                local odds = 4
                if pseudorandom('polymerization_revert') < G.GAME.probabilities.normal / odds then
                    -- REVERT LOGIC
                    local ingredients = card.ability.extra_polymer_ingredients
                    if ingredients then
                        -- Dissolve fused card
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.4,
                            func = function()
                                card:start_dissolve(nil, true)
                                return true
                            end
                        }))

                        -- Respawn ingredients
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.6,
                            func = function()
                                for _, ing in ipairs(ingredients) do
                                    local new_card = create_playing_card({
                                        front = G.P_CARDS[ing.suit .. '_' .. ing.rank],
                                    }, G.deck, nil, nil, { G.C.SECONDARY_SET.Enhanced })

                                    if ing.edition then new_card:set_edition(ing.edition, true) end
                                    if ing.seal then new_card:set_seal(ing.seal, true) end
                                    if ing.ability and ing.ability ~= 'c_base' then
                                        new_card:set_ability(G.P_CENTERS[ing.ability], true)
                                    end
                                end
                                return true
                            end
                        }))

                        -- We can append a message to the return table?
                        -- SMODS.calculate_context returns a table of tables.
                        -- But we are outside the loop.
                        -- We can just create a floaty text manually.
                        card_eval_status_text(card, 'extra', nil, nil, nil,
                            { message = localize('ante_aether_split'), colour = G.C.RED })
                    else
                        -- Cleanup if invalid
                        card.ability.custom_polymerized = nil
                    end
                end
            end
        end
    end

    return ret
end

-- 3. Visual Hook: Badges
local card_generate_ui_ref = Card.generate_UI
function Card:generate_UI(created_nodes, scale, button_pressed)
    local res = card_generate_ui_ref(self, created_nodes, scale, button_pressed)

    if self.ability and self.ability.custom_polymerized then
        -- Generate the badge node
        local badge = create_badge("Polymerized", { 0.1, 0.5, 0.2, 1 }, G.C.WHITE, 1.2)

        if res.nodes and res.nodes[1] then
            table.insert(res.nodes[1].nodes, badge)
        end
    end
    return res
end
