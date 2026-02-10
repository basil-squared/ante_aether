-- Hook card_h_popup to inject flavor text between description and rarity badge
local card_h_popup_ref = G.UIDEF.card_h_popup

G.UIDEF.card_h_popup = function(card)
    local ret = card_h_popup_ref(card)

    -- Guard: only proceed if config enabled, card exists, and tooltip was built
    if not AA.G.CONFIG.flavor_text then return ret end
    if not card or not card.config or not card.config.center then return ret end
    if not ret then return ret end

    local center = card.config.center
    if not center.set or not center.key then return ret end

    -- Look up the localization entry for flavor text
    local descs = G.localization.descriptions
    if not descs or not descs[center.set] then return ret end

    local loc_target = descs[center.set][center.key]
    if not loc_target or not loc_target.flavor_text then return ret end

    local flavor_lines = loc_target.flavor_text

    -- Support both string and array formats
    if type(flavor_lines) == "string" then
        flavor_lines = { flavor_lines }
    end

    local loc_args = {
        shadow = false,
        scale = 1,
        text_colour = G.C.UI.TEXT_DARK,
        default_col = G.C.UI.TEXT_DARK,
        vars = { colours = {} },
    }

    -- Parse each line through loc_parse_string and SMODS.localize_box
    -- to support format codes like {C:inactive}, {S:0.8}, etc.
    local text_rows = {}
    for _, line in ipairs(flavor_lines) do
        local parsed = loc_parse_string(line)
        local row_nodes = SMODS.localize_box(parsed, loc_args)
        text_rows[#text_rows + 1] = { n = G.UIT.R, config = { align = "cm", maxw = 4 }, nodes = row_nodes }
    end

    -- Build the flavor text box matching desc_from_rows style but with white bg
    local flavor_box = {
        n = G.UIT.R,
        config = {
            align = "cm",
            colour = G.C.UI.BACKGROUND_WHITE,
            r = 0.1,
            padding = 0.04,
            minw = 2,
            minh = 0.4,
            emboss = 0.05,
        },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.03 },
                nodes = text_rows,
            },
        },
    }

    -- Navigate the node tree to find the inner container:
    -- ret.nodes[1].nodes[1].nodes[1].nodes holds: name, desc box, badges
    local ok, inner_nodes = pcall(function()
        return ret.nodes[1].nodes[1].nodes[1].nodes
    end)

    if not ok or not inner_nodes then return ret end

    -- Find the description box (identified by filler = true from desc_from_rows)
    -- and insert our flavor text box right after it
    local insert_idx = nil
    for i, node in ipairs(inner_nodes) do
        if type(node) == "table" and node.config and node.config.filler then
            insert_idx = i + 1
            break
        end
    end

    if insert_idx then
        table.insert(inner_nodes, insert_idx, flavor_box)
    end

    return ret
end
