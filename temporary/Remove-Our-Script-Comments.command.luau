-- Stop Play, paste this entire file into Studio's Command Bar, and run.
-- Removes ordinary comments from the listed scripts, including original comments.
-- Preserves strings, line numbers, and --! compiler directives.
-- To undo: set RESTORE_BACKUP to the printed backup folder name, then run again.
local RESTORE_BACKUP = nil
local EXTRA_PATHS = {} -- Optional additional full paths, separated with /.
local function stripComments(source)
    local i, n, count = 1, #source, 0
    local output = {}
    local function copyTo(last)
        table.insert(output, source:sub(i, last))
        i = last + 1
    end
    local function longEnd(at)
        local opening = source:sub(at):match('^%[(=*)%[')
        if opening == nil then return nil end
        local _, last = source:find(']' .. opening .. ']', at + #opening + 2, true)
        assert(last, 'Unterminated long string/comment at byte ' .. at)
        return last
    end
    local code
    local function quoted(quote)
        local first = i
        i += 1
        while i <= n do
            local c = source:sub(i,i)
            if c == '\\' then
                i += 2
            elseif c == quote then
                i += 1
                table.insert(output, source:sub(first,i-1))
                return
            else
                i += 1
            end
        end
        error('Unterminated string at byte ' .. first)
    end
    local function interpolated()
        copyTo(i)
        while i <= n do
            local c = source:sub(i,i)
            if c == '\\' then
                copyTo(math.min(i+1,n))
            elseif c == '`' then
                copyTo(i)
                return
            elseif c == '{' then
                copyTo(i)
                code(true)
            else
                copyTo(i)
            end
        end
        error('Unterminated interpolated string')
    end
    code = function(inExpression)
        local depth = 0
        while i <= n do
            local c = source:sub(i,i)
            if source:sub(i,i+1) == '--' then
                local last = longEnd(i+2)
                if not last then
                    local newline = source:find('[\r\n]',i+2)
                    last = newline and newline-1 or n
                end
                if source:sub(i,i+2) == '--!' then
                    copyTo(last)
                else
                    local blank = source:sub(i,last):gsub('[^\r\n]', ' ')
                    table.insert(output,blank)
                    i = last+1
                    count += 1
                end
            elseif c == '"' or c == "'" then
                quoted(c)
            elseif c == '[' then
                copyTo(longEnd(i) or i)
            elseif c == '`' then
                interpolated()
            elseif c == '{' then
                depth += 1
                copyTo(i)
            elseif c == '}' and inExpression then
                copyTo(i)
                if depth == 0 then return end
                depth -= 1
            else
                copyTo(i)
            end
        end
        assert(not inExpression, 'Unterminated interpolation expression')
    end
    code(false)
    return table.concat(output), count
end
local TARGET_PATHS = {
    "ReplicatedStorage/Assets/Killers/!@Gubby/Behavior",
    "ReplicatedStorage/Assets/Killers/!Brimstone/Behavior",
    "ReplicatedStorage/Assets/Killers/!DoombringerRework/Behavior",
    "ReplicatedStorage/Assets/Killers/!DukeErisia/Behavior",
    "ReplicatedStorage/Assets/Killers/!Erlking/Behavior",
    "ReplicatedStorage/Assets/Killers/!Herobrine/Behavior",
    "ReplicatedStorage/Assets/Killers/!Sancho/Behavior",
    "ReplicatedStorage/Assets/Killers/!SukunaKiller/Behavior",
    "ReplicatedStorage/Assets/Killers/#NoliRework/Behavior",
    "ReplicatedStorage/Assets/Killers/1x1x1x1/Behavior",
    "ReplicatedStorage/Assets/Killers/Azure/Behavior",
    "ReplicatedStorage/Assets/Killers/Azure/Behavior/sv_AzureConstruct",
    "ReplicatedStorage/Assets/Killers/Azure/Behavior/sv_AzureConstruct/sv_Vine",
    "ReplicatedStorage/Assets/Killers/Azure/Config",
    "ReplicatedStorage/Assets/Killers/Doombringer/Behavior",
    "ReplicatedStorage/Assets/Killers/JohnDoe/Behavior",
    "ReplicatedStorage/Assets/Killers/Noli/Behavior",
    "ReplicatedStorage/Assets/Killers/Nosferatu/Behavior",
    "ReplicatedStorage/Assets/Killers/Sixer/Behavior",
    "ReplicatedStorage/Assets/Killers/Slasher/Behavior",
    "ReplicatedStorage/Assets/Killers/Slasher/Config",
    "ReplicatedStorage/Assets/Killers/Swordsmaster/Behavior",
    "ReplicatedStorage/Assets/Killers/c00lkidd/Behavior",
    "ReplicatedStorage/Assets/Killers/kos601swordmaster/Behavior",
    "ReplicatedStorage/Assets/Killers/nolifromrussiathink/Behavior",
    "ReplicatedStorage/Assets/Skins/Killers/Noli/nolifromrussiathink/Behavior",
    "ReplicatedStorage/Assets/Skins/Killers/c00lkidd/#BoomerFormulaC00l/Behavior",
    "ReplicatedStorage/Assets/Survivors/Guest1337Rework/Behavior",
    "ReplicatedStorage/Assets/Survivors/Guest1337Rework/Config",
    "ReplicatedStorage/Modules/Actors",
    "ReplicatedStorage/Modules/Hitboxes",
    "ReplicatedStorage/Modules/StatusEffects/KillerExclusive/Atropa",
    "ReplicatedStorage/Modules/StatusEffects/Resistance",
    "ReplicatedStorage/Modules/Statuses",
    "ReplicatedStorage/Modules/Util",
    "ReplicatedStorage/Systems/Player/Game/SmoothShiftLock",
    "ReplicatedStorage/Systems/Player/Networks/ActorNetwork",
    "ServerScriptService/Server/Modules/ActorBehaviors/Killer/TeamC00lkidd",
    "ServerScriptService/Server/Modules/BotKillers",
    "ServerStorage/AeternusConfig",
}
assert(not game:GetService('RunService'):IsRunning(), 'Stop Play before running this.')
local editor = game:GetService('ScriptEditorService')
local storage = game:GetService('ServerStorage')
local function resolve(path)
    local node = game
    for name in path:gmatch('[^/]+') do
        node = node:FindFirstChild(name)
        if not node then return nil end
    end
    return node
end
local function write(node, before, after)
    editor:UpdateSourceAsync(node, function(current)
        assert(current == before, 'Source changed during cleanup: ' .. node:GetFullName())
        return after
    end)
end
local prepared, seen = {}, {}
if RESTORE_BACKUP then
    local backup = assert(storage:FindFirstChild(RESTORE_BACKUP), 'Backup not found')
    assert(backup:GetAttribute('CommentCleanupBackup'), 'Not a comment-cleanup backup')
    for _, entry in backup:GetChildren() do
        local path = entry:GetAttribute('ModulePath')
        local node = assert(resolve(path), 'Missing restore target: ' .. path)
        local parts, text = entry:GetChildren(), {}
        table.sort(parts,function(a,b) return a.Name < b.Name end)
        for _, part in parts do table.insert(text,part.Value) end
        table.insert(prepared,{node=node,path=path,before=editor:GetEditorSource(node),after=table.concat(text)})
    end
else
    for _, path in EXTRA_PATHS do table.insert(TARGET_PATHS,path) end
    for _, path in TARGET_PATHS do
        if not seen[path] then
            seen[path] = true
            local node = resolve(path)
            if not node then
                warn('Skipped missing script: ' .. path)
            else
                assert(node:IsA('LuaSourceContainer'), 'Not a script: ' .. path)
                local before = editor:GetEditorSource(node)
                local ok, after, count = pcall(stripComments,before)
                assert(ok, 'Cannot parse ' .. path .. ': ' .. tostring(after) .. '. No changes applied.')
                if before ~= after then
                    table.insert(prepared,{node=node,path=path,before=before,after=after,count=count})
                end
            end
        end
    end
end
if #prepared == 0 then print('No ordinary comments to remove in the existing target scripts.'); return end
local backup = Instance.new('Folder')
backup.Name = 'CommentCleanupBackup_' .. os.time() .. '_' .. game:GetService('HttpService'):GenerateGUID(false):sub(1,8)
backup:SetAttribute('CommentCleanupBackup',true)
backup.Parent = storage
for index, item in prepared do
    local entry = Instance.new('Folder')
    entry.Name = string.format('%04d',index)
    entry:SetAttribute('ModulePath',item.path)
    entry.Parent = backup
    for offset = 1,#item.before,50000 do
        local part = Instance.new('StringValue')
        part.Name = string.format('SourcePart%05d',math.floor((offset-1)/50000)+1)
        part.Value = item.before:sub(offset,offset+49999)
        part.Parent = entry
    end
end
local applied = {}
local ok, err = pcall(function()
    for _, item in prepared do
        write(item.node,item.before,item.after)
        table.insert(applied,item)
    end
end)
if not ok then
    for index = #applied,1,-1 do
        local item = applied[index]
        local restored, failure = pcall(write,item.node,item.after,item.before)
        if not restored then warn('Rollback failed: ' .. item.path .. ': ' .. tostring(failure)) end
    end
    error('Cleanup failed; rollback attempted. Backup: ServerStorage.' .. backup.Name .. '\n' .. tostring(err))
end
local count = 0
for _, item in prepared do
    count += item.count or 0
    print((RESTORE_BACKUP and 'Restored: ' or 'Cleaned: ') .. item.path)
end
print(string.format('Done: %d scripts; %d ordinary comments removed. Backup: ServerStorage.%s',#prepared,count,backup.Name))
