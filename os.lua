-- FluxOS - Main Kernel
-- A sleek operating system for CC: Tweaked

local function loginScreen()
  while true do
    term.clear()
    term.setBackgroundColor(colors.purple)
    term.setTextColor(colors.white)
    
    -- Clear screen with purple background
    for i = 1, select(2, term.getSize()) do
      term.setCursorPos(1, i)
      term.clearLine()
    end
    
    -- Title
    term.setCursorPos(10, 5)
    term.write("FLUX OS")
    term.setCursorPos(8, 6)
    term.write("Welcome Back")
    
    -- Username input
    term.setCursorPos(8, 10)
    term.write("Username: ")
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(20, 10)
    local user = read()
    
    -- Password input
    term.setBackgroundColor(colors.purple)
    term.setTextColor(colors.white)
    term.setCursorPos(8, 12)
    term.write("Password: ")
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(20, 12)
    local pass = read("*")
    
    if user == "admin" and pass == "1234" then
      return true
    else
      term.setBackgroundColor(colors.purple)
      term.setTextColor(colors.white)
      term.setCursorPos(8, 14)
      term.write("Invalid credentials!")
      sleep(2)
    end
  end
end

local function desktopMenu()
  while true do
    term.clear()
    term.setBackgroundColor(colors.purple)
    term.setTextColor(colors.white)
    
    term.setCursorPos(10, 3)
    term.write("FLUX OS")
    term.setCursorPos(8, 4)
    term.write("========")
    
    term.setCursorPos(5, 7)
    term.write("[1] System Info")
    term.setCursorPos(5, 9)
    term.write("[2] Calculator")
    term.setCursorPos(5, 11)
    term.write("[3] File Browser")
    term.setCursorPos(5, 13)
    term.write("[4] Shutdown")
    term.setCursorPos(5, 15)
    term.write("[5] Reboot")
    
    local event, key = os.pullEvent("key")
    
    if key == keys.one then
      systemInfo()
    elseif key == keys.two then
      calculator()
    elseif key == keys.three then
      fileBrowser()
    elseif key == keys.four then
      term.clear()
      term.setBackgroundColor(colors.black)
      term.setTextColor(colors.white)
      os.shutdown()
    elseif key == keys.five then
      term.clear()
      term.setBackgroundColor(colors.black)
      term.setTextColor(colors.white)
      os.reboot()
    end
  end
end

local function systemInfo()
  term.clear()
  term.setBackgroundColor(colors.purple)
  term.setTextColor(colors.white)
  
  term.setCursorPos(8, 2)
  term.write("SYSTEM INFO")
  term.setCursorPos(8, 3)
  term.write("===========")
  
  term.setCursorPos(5, 5)
  term.write("OS: FluxOS v1.0")
  term.setCursorPos(5, 6)
  term.write("Lua: " .. _VERSION)
  term.setCursorPos(5, 7)
  term.write("Computer ID: " .. os.getComputerID())
  term.setCursorPos(5, 8)
  term.write("Label: " .. (os.getComputerLabel() or "None"))
  
  term.setCursorPos(5, 10)
  term.write("Peripherals:")
  
  local periphList = peripheral.getNames()
  if #periphList > 0 then
    for i, peri in ipairs(periphList) do
      term.setCursorPos(7, 11 + i - 1)
      term.write("- " .. peri .. " (" .. peripheral.getType(peri) .. ")")
    end
  else
    term.setCursorPos(7, 12)
    term.write("None")
  end
  
  term.setCursorPos(5, 18)
  term.write("Press any key to return...")
  os.pullEvent("key")
end

local function calculator()
  local display = "0"
  local firstNum = nil
  local operation = nil
  
  while true do
    term.clear()
    term.setBackgroundColor(colors.purple)
    term.setTextColor(colors.white)
    
    term.setCursorPos(10, 2)
    term.write("CALCULATOR")
    term.setCursorPos(10, 3)
    term.write("===========")
    
    -- Display
    term.setCursorPos(6, 6)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.write(string.rep(" ", 20))
    term.setCursorPos(8, 6)
    term.write(display)
    
    term.setBackgroundColor(colors.purple)
    term.setTextColor(colors.white)
    
    term.setCursorPos(5, 9)
    term.write("[7] [8] [9] [+]")
    term.setCursorPos(5, 10)
    term.write("[4] [5] [6] [-]")
    term.setCursorPos(5, 11)
    term.write("[1] [2] [3] [*]")
    term.setCursorPos(5, 12)
    term.write("[0] [.] [=] [/]")
    term.setCursorPos(5, 14)
    term.write("[C] Clear  [Q] Quit")
    
    local event, key = os.pullEvent("key")
    
    if key == keys.c then
      display = "0"
      firstNum = nil
      operation = nil
    elseif key == keys.q then
      break
    elseif key >= keys.zero and key <= keys.nine then
      local digit = key - 1
      if display == "0" then
        display = tostring(digit)
      else
        display = display .. tostring(digit)
      end
    elseif key == keys.period then
      if not display:find("%.") then
        display = display .. "."
      end
    elseif key == keys.add or key == keys.subtract or key == keys.multiply or key == keys.divide then
      firstNum = tonumber(display)
      if key == keys.add then operation = "+"
      elseif key == keys.subtract then operation = "-"
      elseif key == keys.multiply then operation = "*"
      elseif key == keys.divide then operation = "/"
      end
      display = "0"
    elseif key == keys.equal then
      if firstNum and operation then
        local secondNum = tonumber(display)
        if operation == "+" then
          display = tostring(firstNum + secondNum)
        elseif operation == "-" then
          display = tostring(firstNum - secondNum)
        elseif operation == "*" then
          display = tostring(firstNum * secondNum)
        elseif operation == "/" and secondNum ~= 0 then
          display = tostring(firstNum / secondNum)
        end
        firstNum = nil
        operation = nil
      end
    end
  end
end

local function fileBrowser()
  local path = "/"
  
  while true do
    term.clear()
    term.setBackgroundColor(colors.purple)
    term.setTextColor(colors.white)
    
    term.setCursorPos(8, 2)
    term.write("FILE BROWSER")
    term.setCursorPos(8, 3)
    term.write("============")
    
    term.setCursorPos(5, 5)
    term.write("Path: " .. path)
    
    term.setCursorPos(5, 7)
    local fileList = fs.list(path)
    table.sort(fileList)
    
    for i, file in ipairs(fileList) do
      if i > 12 then break end
      if fs.isDir(fs.combine(path, file)) then
        term.write("[" .. file .. "]")
      else
        term.write(file)
      end
      term.setCursorPos(5, 7 + i)
    end
    
    term.setCursorPos(5, 20)
    term.write("[B] Back  [Q] Quit")
    
    local event, key = os.pullEvent("key")
    
    if key == keys.b then
      if path ~= "/" then
        path = fs.getDir(path)
      end
    elseif key == keys.q then
      break
    end
  end
end

-- Main program
local ok, err = pcall(function()
  if loginScreen() then
    desktopMenu()
  end
end)

if not ok then
  term.clear()
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.red)
  print("FLUX OS ERROR:")
  print(err)
  print("\nStarting CraftOS...")
  sleep(3)
  term.clear()
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
end
