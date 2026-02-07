SMODS.current_mod.optional_features = {
    cardareas = {
        unscored = true,
        discard = true,
        retrigger_joker = true
    }
}

local NFS = require("nativefs")
AA = {}
AA.G = {}
AA.G.MODPATH = SMODS.current_mod.path
AA.FUNC = {}

-- Original code from Charcuterie, also my mod :)
function AA.FUNC.RequireFolderRecursive(path)
    local function scan(currentPath)
        local fullpath = AA.G.MODPATH .. "/" .. currentPath
        local files = NFS.getDirectoryItemsInfo(fullpath)

        for _, fileInfo in ipairs(files) do
            local fileType = fileInfo.type
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
