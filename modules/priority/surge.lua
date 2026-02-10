-- context.surge
-- Fires SMODS.calculate_context({ surge = true, ... })
-- whenever a card (playing card or joker) is retriggered.


local original_eval_card = eval_card

function eval_card(card, context)
    if context.retrigger_joker then
        SMODS.calculate_context({
            surge = true,
            other_card = card,
            retrigger_card = context.retrigger_joker ~= true and context.retrigger_joker or nil,
        })
    end
    return original_eval_card(card, context)
end

local original_score_card = SMODS.score_card

function SMODS.score_card(card, context)
    local reps = { 1 }
    local j = 1
    while j <= #reps do
        if reps[j] ~= 1 then
            SMODS.calculate_context({
                surge = true,
                other_card = card,
            })

            local _, eff = next(reps[j])
            while eff.retrigger_flag do
                SMODS.calculate_effect(eff, eff.card); j = j + 1; _, eff = next(reps[j])
            end
            SMODS.calculate_effect(eff, eff.card)
            percent = percent + percent_delta
        end

        context.main_scoring = true
        local effects = { eval_card(card, context) }
        SMODS.calculate_quantum_enhancements(card, effects, context)
        context.main_scoring = nil
        context.individual = true
        context.other_card = card

        if next(effects) then
            SMODS.calculate_card_areas('jokers', context, effects, { main_scoring = true })
            SMODS.calculate_card_areas('individual', context, effects, { main_scoring = true })
        end

        local flags = SMODS.trigger_effects(effects, card)

        context.individual = nil
        if reps[j] == 1 and flags.calculated then
            context.repetition = true
            context.card_effects = effects
            SMODS.calculate_repetitions(card, context, reps)
            context.repetition = nil
            context.card_effects = nil
        end
        j = j + (flags.calculated and 1 or #reps)
        context.other_card = nil
        card.lucky_trigger = nil
    end
end
