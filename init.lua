---@diagnostic disable: duplicate-set-field
SMODS.current_mod.optional_features = {
    cardareas = {
        unscored = true,
        discard = true,
        retrigger_joker = true
    }
}

SMODS.current_mod.config = {
    flavor_text = true
}


local mod_config = SMODS.current_mod.config

SMODS.current_mod.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", padding = 0.05, colour = G.C.CLEAR },
        nodes = {
            {
                n = G.UIT.C,
                config = { align = "cm", padding = 0.05, r = 0.1, colour = G.C.BLACK, emboss = 0.05 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.05 },
                        nodes = {
                            create_toggle({
                                label = "Flavor Text",
                                ref_table = mod_config,
                                ref_value = "flavor_text"
                            })
                        }
                    }
                }
            }
        }
    }
end

local NFS = require("nativefs")
AA = {}
AA.G = {}
AA.G.MODPATH = SMODS.current_mod.path
AA.FUNC = {}
AA.G.CONFIG = SMODS.current_mod.config

-- Original code from Charcuterie, also my mod :)
function AA.FUNC.RequireFolderRecursive(path)
    local function scan(currentPath)
        local fullpath = AA.G.MODPATH .. "/" .. currentPath
        local files = NFS.getDirectoryItemsInfo(fullpath)

        for _, fileInfo in ipairs(files) do
            local fileType = fileInfo.type
            ---@diagnostic disable-next-line: undefined-field
            local fileName = fileInfo.name
            local childPath = currentPath == "" and fileName or currentPath .. "/" .. fileName

            if fileType == "directory" then
                scan(childPath)
            elseif fileType == "file" and fileName:sub(-4) == ".lua" then
                assert(SMODS.load_file(childPath))()
                print("Loaded " .. childPath)
            end
        end
    end
    scan(path)
end

AA.FUNC.RequireFolderRecursive("modules/priority")
AA.FUNC.RequireFolderRecursive("modules/content")
