local M = {}

M.cfg = {

}

local original_buffer = {}

local is_wat_file = function()
  local file_extension = vim.fn.expand("%:t"):match("^.+%.(.+)$")
  if file_extension == "wat" then
    return true
  end
  return false
end

local cmd_success = function(cmd)
  local exit_code = 0
  local job_id = vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      exit_code = code
    end
  })
  vim.fn.jobwait(job_id, "w")
  if exit_code == 0 then
    return true
  end
  return false
end

local execute = function(command)
  vim.fn.jobstart(command, {
    on_exit = function(_, code)
      if code == 0 then
        local file_path = vim.fn.expand("%:p")
        original_buffer[file_path] = table.concat(vim.fn.readfile(file_path), "\n")
        vim.cmd(":%!" .. command)
        return
      end
      vim.cmd(":!" .. command)
    end
  })
end

M.to_wasm = function()
  if not is_wat_file() then
    vim.notify("This command can only be used on .wat files", vim.log.levels.ERROR)
    return
  end
  M.revert()
  local file_path = vim.fn.expand("%:p")
  local command = "wat2wasm " .. file_path .. " --output=-"
  execute(command)
end

M.revert = function()
  if not is_wat_file() then
    vim.notify("This command can only be used on .wat files", vim.log.levels.ERROR)
    return
  end
  local file_path = vim.fn.expand("%:p")
  if original_buffer[file_path] == nil then
    return
  end
  local current_buffer = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(current_buffer, 0, -1, false, { original_buffer[file_path] })
  original_buffer[file_path] = nil
end

M.to_wat = function()
  if not is_wat_file() then
    vim.notify("This command can only be used on .wat files", vim.log.levels.ERROR)
    return
  end
  M.revert()
  local file_path = vim.fn.expand("%:p")
  local command = "wat2wasm " .. file_path .. " --output=- | wasm2wat -"
  execute(command)
end

M.to_wasm_verbose = function()
  if not is_wat_file() then
    vim.notify("This command can only be used on .wat files", vim.log.levels.ERROR)
    return
  end
  M.revert()
  local file_path = vim.fn.expand("%:p")
  local command = "wat2wasm -v " .. file_path .. " --output=-"
  execute(command)
end

M.setup = function(args)
  M.cfg = vim.tbl_deep_extend("force", M.cfg, args or {})

  vim.api.nvim_create_user_command("Wat2Wasm", M.to_wasm, {})
  vim.api.nvim_create_user_command("WatRevert", M.revert, {})
  vim.api.nvim_create_user_command("Wat2Wat", M.to_wat, {})
  vim.api.nvim_create_user_command("WatTheWasm", M.to_wasm_verbose, {})
end

return M
