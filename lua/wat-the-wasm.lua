local M = {}

M.cfg = {

}

local state_enum = {
  WAT = "WAT",
  WASM = "WASM",
  WASM_VERBOSE = "WASM_VERBOSE",
  WAT_GENERATED = "WAT_GENERATED",
}
local state = state_enum.WAT
local original_buffer = {}

M.to_wasm = function()
  if state == state_enum.WAT then
    local file_path = vim.fn.expand("%:p")
    original_buffer[file_path] = table.concat(vim.fn.readfile(file_path), "\n")
    vim.cmd(":%!wat2wasm " .. file_path .. " --output=-")
    state = state_enum.WASM
  else
    vim.notify("Cannot convert to WASM, buffer content is not WAT", vim.log.levels.WARN)
  end
end

M.revert = function()
  if state ~= state_enum.WAT then
    local file_path = vim.fn.expand("%:p")
    local current_buffer = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(current_buffer, 0, -1, false, { original_buffer[file_path] })
    original_buffer[file_path] = nil
    state = state_enum.WAT
  else
    vim.notify("Doesn't need to revert, buffer content is already WAT", vim.log.levels.WARN)
  end
end

M.to_wat = function()
  if state == state_enum.WASM then
    local current_buffer = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false)
    local wasm_string = table.concat(lines, "\n")
    print(wasm_string)
    -- vim.api.nvim_buf_set_text(current_buffer, 0, -1, false, { wasm_string })
    vim.cmd(":%!wasm2wat - " .. wasm_string)
    state = state_enum.WAT_GENERATED
  else
    vim.notify("Cannot convert to WAT, buffer content is " .. state, vim.log.levels.WARN)
  end
end

M.to_wasm_verbose = function()
  if state == state_enum.WAT then
    local file_path = vim.fn.expand("%:p")
    original_buffer[file_path] = table.concat(vim.fn.readfile(file_path), "\n")
    vim.cmd(":%!wat2wasm -v " .. file_path .. " --output=-")
    state = state_enum.WASM_VERBOSE
  else
    vim.notify("Cannot convert to WASM, buffer content is not WAT", vim.log.levels.WARN)
  end
end

M.toggle = function()
  if state == state_enum.WAT then
    M.to_wasm_verbose()
  elseif state == state_enum.WASM_VERBOSE then
    M.revert()
    M.to_wasm()
    M.to_wat()
  else
    M.revert()
  end
end

M.setup = function(args)
  M.cfg = vim.tbl_deep_extend("force", M.cfg, args or {})

  vim.api.nvim_create_user_command("Wat2Wasm", M.to_wasm, {})
  vim.api.nvim_create_user_command("WatRevert", M.to_wat, {})
  vim.api.nvim_create_user_command("Wasm2Wat", M.to_wasm, {})
  vim.api.nvim_create_user_command("WatTheWasm", M.to_wasm_verbose, {})
  vim.api.nvim_create_user_command("WatToggle", M.toggle, {})
end

return M
