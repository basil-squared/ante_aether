local function hex(str)
    str = str:gsub("#", "")
    return {
        tonumber(str:sub(1, 2), 16) / 255,
        tonumber(str:sub(3, 4), 16) / 255,
        tonumber(str:sub(5, 6), 16) / 255,
        1,
    }
end

-- colors
local FACTION_COLORS = {
    resonance = {
        bg   = hex("#73BF40"),
        text = hex("#ffffff"),
    },
    dominion = {
        bg   = hex("#592699"),
        text = hex("#FFFFFF"),
    },
    entropy = {
        bg   = hex("#141414"),
        text = hex("#D92626"),
    },
    nullity = {

        bg         = hex("#1F1F2E"),
        text_cycle = {
            hex("#9933E6"),
            hex("#33B3E6"),
            hex("#E64D80"),
            hex("#4DE699"),
            hex("#E6CC33"),
        },
    },
}

local FACTION_LABELS = {
    resonance = "Resonance",
    dominion = "Dominion",
    entropy = "Entropy",
    nullity = "Nullity",
}

-- hooking into the card_h_popup so that I can inject the popup and faction text
local card_h_popup_ref = G.UIDEF.card_h_popup

G.UIDEF.card_h_popup = function(card)
    local ret = card_h_popup_ref(card)

    if not card or not card.config or not card.config.center then return ret end
    if not ret then return ret end

    local center = card.config.center

    -- grabs the container
    local ok, inner_nodes = pcall(function()
        return ret.nodes[1].nodes[1].nodes[1].nodes
    end)
    if not ok or not inner_nodes then return ret end

    -- flavor text
    if AA.G.CONFIG.flavor_text and center.set and center.key then
        local descs = G.localization.descriptions
        if descs and descs[center.set] then
            local loc_target = descs[center.set][center.key]
            if loc_target and loc_target.flavor_text then
                local flavor_lines = loc_target.flavor_text
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

                local text_rows = {}
                for _, line in ipairs(flavor_lines) do
                    local parsed = loc_parse_string(line)
                    local row_nodes = SMODS.localize_box(parsed, loc_args)
                    text_rows[#text_rows + 1] = {
                        n = G.UIT.R,
                        config = { align = "cm", maxw = 4 },
                        nodes = row_nodes,
                    }
                end

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

                -- after desc box
                for i, node in ipairs(inner_nodes) do
                    if type(node) == "table" and node.config and node.config.filler then
                        table.insert(inner_nodes, i + 1, flavor_box)
                        break
                    end
                end
            end
        end
    end

    -- faction badge post rarity badge
    local faction = center.faction
    if not faction or not FACTION_COLORS[faction] then return ret end

    local fc = FACTION_COLORS[faction]
    local label = FACTION_LABELS[faction] or faction

    local text_node
    if fc.text_cycle then
        -- checks if theres a fluctuating color and does dynatext if so
        text_node = {
            n = G.UIT.O,
            config = {
                object = DynaText({
                    string = { label },
                    colours = fc.text_cycle,
                    float = true,
                    shadow = true,
                    offset_y = -0.05,
                    silent = true,
                    spacing = 1,
                    scale = 0.33,
                    pop_in = 0,
                    cycle_time = 0.8,
                }),
            },
        }
    else
        --  regular text is dynamic too for consistency
        text_node = {
            n = G.UIT.O,
            config = {
                object = DynaText({
                    string = { label },
                    colours = { fc.text },
                    float = true,
                    shadow = true,
                    offset_y = -0.05,
                    silent = true,
                    spacing = 1,
                    scale = 0.33,
                }),
            },
        }
    end

    local faction_badge = {
        n = G.UIT.R,
        config = { align = "cm", padding = 0.03 },
        nodes = {
            {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    colour = fc.bg,
                    r = 0.1,
                    minw = 2,
                    minh = 0.4,
                    emboss = 0.05,
                    padding = 0.03,
                },
                nodes = {
                    { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                    text_node,
                    { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                },
            },
        },
    }

    -- Append at the end of inner_nodes (after rarity badge)
    inner_nodes[#inner_nodes + 1] = faction_badge

    return ret
end
