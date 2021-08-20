local this = {}

-- This uses explicit error logs for each of the data folders.  These logs should only hold error messages
-- from trying to parse the data folders
--
-- The files get deleted every time the mod reloads.  This should help avoid old errors becoming noise

local LOGFOLDER = ""
local LOGNAME_SPAWN = "ERRORS - spawn points.log"
local filehandle_spawn = nil

-- This deletes existing error logs for each of the data folders
function ClearDeserializeErrorLogs()
    filehandle_spawn = this.DeleteLog(filehandle_spawn, LOGNAME_SPAWN)
end

function AddError_Spawn(message)
    filehandle_spawn = this.WriteLog(filehandle_spawn, LOGNAME_SPAWN, message)
end

function FlushErrorFiles()
    this.FlushLog(filehandle_spawn)
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

function this.FlushLog(handle)
    if handle then
        handle:flush()
    end
end