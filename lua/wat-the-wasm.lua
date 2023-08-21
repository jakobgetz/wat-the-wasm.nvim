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

M.to_wasm = function()
  if not is_wat_file() then
    vim.notify("This command can only be used on .wat files", vim.log.levels.ERROR)
    return
  end
  M.revert()
  local file_path = vim.fn.expand("%:p")
  original_buffer[file_path] = table.concat(vim.fn.readfile(file_path), "\n")
  vim.cmd(":%!wat2wasm " .. file_path .. " --output=-")
end

M.revert = function()
  if not is_wat_file() then
    vim.notify("This command can only be used on .wat files", vim.log.levels.ERROR)
    return
  end
  local file_path = vim.fn.expand("%:p")
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
  original_buffer[file_path] = table.concat(vim.fn.readfile(file_path), "\n")
  vim.cmd(":%!wat2wasm " .. file_path .. " --output=- | wasm2wat -")
end

M.to_wasm_verbose = function()
  if not is_wat_file() then
    vim.notify("This command can only be used on .wat files", vim.log.levels.ERROR)
    return
  end
  M.revert()
  local file_path = vim.fn.expand("%:p")
  original_buffer[file_path] = table.concat(vim.fn.readfile(file_path), "\n")
  vim.cmd(":%!wat2wasm -v " .. file_path .. " --output=-")
end

M.setup = function(args)
  M.cfg = vim.tbl_deep_extend("force", M.cfg, args or {})

  vim.api.nvim_create_user_command("Wat2Wasm", M.to_wasm, {})
  vim.api.nvim_create_user_command("WatRevert", M.revert, {})
  vim.api.nvim_create_user_command("Wat2Wat", M.to_wat, {})
  vim.api.nvim_create_user_command("WatTheWasm", M.to_wasm_verbose, {})
end

return M
