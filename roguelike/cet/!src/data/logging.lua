local this = {}

-- This uses explicit error logs for each of the data folders.  These logs should only hold error messages
-- from trying to parse the data folders
--
-- The files get deleted every time the mod reloads.  This should help avoid old errors becoming noise

local LOGFOLDER = ""
local LOGNAME_SPAWN = "ERRORS - spawn points.log"
local LOGNAME_BOSSAREA = "ERRORS - boss areas.log"
local filehandle_spawn = nil
local filehandle_bossarea = nil

-- This deletes existing error logs for each of the data folders
function ClearDeserializeErrorLogs()
    filehandle_spawn = this.DeleteLog(filehandle_spawn, LOGNAME_SPAWN)
    filehandle_bossarea = this.DeleteLog(filehandle_bossarea, LOGNAME_BOSSAREA)
end

function AddError_Spawn(message)
    filehandle_spawn = this.WriteLog(filehandle_spawn, LOGNAME_SPAWN, message)
end
function AddError_BossArea(message)
    filehandle_bossarea = this.WriteLog(filehandle_bossarea, LOGNAME_BOSSAREA, message)
end

function CloseErrorFiles()
    this.CloseLog(filehandle_spawn)
    this.CloseLog(filehandle_bossarea)
end

----------------------------------- Private Methods -----------------------------------

function this.DeleteLog(handle, filename)
    if handle then
        handle:close()
    end

    os.remove(LOGFOLDER .. filename)

    return nil
end

function this.WriteLog(handle, filename, message)
    if not handle then
        handle = io.open(LOGFOLDER .. filename, "a")
    end

    handle:write(message .. "\n\n")     --NOTE: \r\n seems to generate \r\r\n.  So lua must convert \n into the os default of \r\n (on windows)

    return handle
end

function this.CloseLog(handle)
    if handle then
        handle:close()
    end
end