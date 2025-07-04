-- luacheck: global hs

hs.logger.defaultLogLevel = "info"

-- some global variables (gh:zzamboni/dot-hammerspoon)
local hyper               = { "cmd", "alt", "ctrl", "shift" }
local ctrl_cmd            = { "cmd", "ctrl" }
local col                 = hs.drawing.color.x11

local spaces              = require("hs.spaces")
local meh                 = { "alt", "ctrl", "shift" }

-- Simple debugging function
local function printSpaces()
    local allSpaces = spaces.allSpaces()
    local current = spaces.focusedSpace()

    print("Current space: " .. current)
    print("All spaces:")
    for screen, screenSpaces in pairs(allSpaces) do
        print("  Screen " .. screen .. ":")
        for i, space in ipairs(screenSpaces) do
            print("    Space " .. i .. ": " .. space .. (space == current and " (current)" or ""))
        end
    end
end


-- Helper function to find the screen ID containing the current space
local function getCurrentScreenAndSpaces()
    local currentSpace = spaces.focusedSpace()
    local allSpaces = spaces.allSpaces()

    for screenID, screenSpaces in pairs(allSpaces) do
        for i, spaceID in ipairs(screenSpaces) do
            if spaceID == currentSpace then
                return screenID, screenSpaces, i
            end
        end
    end

    -- If we get here, we couldn't find the current space
    return nil, nil, nil
end


-- Switch to a specific desktop number on the current screen
local function switchToDesktop(desktopNumber)
    local screenID, screenSpaces = getCurrentScreenAndSpaces()

    if not screenID or not screenSpaces then
        hs.alert.show("Could not determine current screen")
        return
    end

    if desktopNumber > 0 and desktopNumber <= #screenSpaces then
        local spaceID = screenSpaces[desktopNumber]
        hs.alert.show("Switching to desktop " .. desktopNumber .. " (ID: " .. spaceID .. ")")
        spaces.gotoSpace(spaceID)
    else
        hs.alert.show("Invalid desktop number: " .. desktopNumber .. ". Available: 1-" .. #screenSpaces)
    end
end

-- Switch to the next desktop on the current screen
local function switchToNextDesktop()
    local screenID, screenSpaces, currentIndex = getCurrentScreenAndSpaces()

    if not screenID or not screenSpaces or not currentIndex then
        hs.alert.show("Could not determine current space")
        return
    end

    -- Calculate next space index (wrap around to beginning if needed)
    local nextIndex = currentIndex % #screenSpaces + 1
    local nextSpaceID = screenSpaces[nextIndex]

    hs.alert.show("Switching to next desktop: " .. nextIndex .. " (ID: " .. nextSpaceID .. ")")
    spaces.gotoSpace(nextSpaceID)
end

-- Switch to the previous desktop on the current screen
local function switchToPreviousDesktop()
    local screenID, screenSpaces, currentIndex = getCurrentScreenAndSpaces()

    if not screenID or not screenSpaces or not currentIndex then
        hs.alert.show("Could not determine current space")
        return
    end

    -- Calculate previous space index (wrap around to end if needed)
    local prevIndex = (currentIndex - 2) % #screenSpaces + 1
    local prevSpaceID = screenSpaces[prevIndex]

    hs.alert.show("Switching to previous desktop: " .. prevIndex .. " (ID: " .. prevSpaceID .. ")")
    spaces.gotoSpace(prevSpaceID)
end

-- Print spaces info when we reload config (for debugging)
local function printSpaces()
    local allSpaces = spaces.allSpaces()
    local current = spaces.focusedSpace()

    print("Current space: " .. current)
    print("All spaces:")
    for screen, screenSpaces in pairs(allSpaces) do
        print("  Screen " .. screen .. ":")
        for i, space in ipairs(screenSpaces) do
            print("    Space " .. i .. ": " .. space .. (space == current and " (current)" or ""))
        end
    end
end

-- Optional: Print spaces info on startup
printSpaces()

-- Set up hotkeys
hs.hotkey.bind(meh, "h", switchToPreviousDesktop)
hs.hotkey.bind(meh, "l", switchToNextDesktop)
hs.hotkey.bind(meh, "1", function() switchToDesktop(1) end)
hs.hotkey.bind(meh, "2", function() switchToDesktop(2) end)
hs.hotkey.bind(meh, "3", function() switchToDesktop(3) end)
hs.hotkey.bind(meh, "4", function() switchToDesktop(4) end)
hs.hotkey.bind(meh, "5", function() switchToDesktop(5) end)


hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall.use_syncinstall = true
Install = spoon.SpoonInstall

-- Returns the bundle ID of an application, given its path.
function appID(app)
    if hs.application.infoForBundlePath(app) then
        return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
    end
end

-- Returns a function that takes a URL and opens it in the given Chrome profile
-- Note: the value of `profile` must be the name of the profile directory under
-- ~/Library/Application Support/Google/Chrome/
function braveProfile(profile)
    return function(url)
        hs.task.new("/usr/bin/open", nil, { "-n",
            "-a", "Brave Browser",
            "--args",
            "--profile-directory=" .. profile,
            url }):start()
    end
end

-- Define the IDs of the various applications used to open URLs
braveBrowser   = appID('/Applications/Brave Browser.app')
safariBrowser  = appID('/Applications/Safari.app')
firefoxBrowser = appID('/Applications/Firefox.app')

-- Define my default browsers for various purposes
browsers       = {
    default   = braveBrowser,
    company   = braveProfile("Company"),
    personal  = braveProfile("Personal"),
    customer1 = braveBrowser,
}

-- Read URL patterns from text files
URLfiles       = {
    company   = "local/company_urls.txt",
    customer1 = "local/customer1_urls.txt"
}

Install:andUse("URLDispatcher",
    {
        config = {
            default_handler = browsers.default,
            url_patterns = {
                -- URLs that get redirected to applications
                { "https://company.atlassian.net/", company },
                { "https://meet%.google%.com/",     company },
                -- Customer-specific URLs open in their own Chrome profile
                { URLfiles.customer1,               browsers.customer1 },
                -- AWS console URLs open by default in Firefox because it
                -- has better plugins to improve the experience. This comes
                -- after customer1 URLs because I have patterns for that
                -- customer's accounts to open in its corresponding
                -- profile.
                { "console%.aws%.amazon%.com/.*",   personal },
                -- Work-related URLs open in the default Chrome profile
                { URLfiles.company,                 company },
            },
            url_redir_decoders = {
                -- Most URLs opened from within MS Teams are normally sent
                -- through a redirect which messes the matching, so we
                -- extract the final URL before dispatching it. The final
                -- URL is passed as parameter "url" to the redirect URL,
                -- which makes it easy to extract it using a function-based
                -- decoder.
                -- Some URLs (e.g. Sharepoint) are not sent through the
                -- decoder, so if there is no url parameter, we process the
                -- full original URL.
                { "MS Teams links", function(_, _, params, fullUrl)
                    if params.url then
                        return params.url
                    else
                        return fullUrl
                    end
                end, nil, true, "Microsoft Teams" },
                -- URLs within a tracking link
                { "awstrack.me links",   "https://.*%.awstrack%.me/.-/(.*)", "%1" },
                -- Chime meeting URLs get rewritten to open in the Chime app
                { "Chime meeting links", "https://chime%.aws/(%d+)",         "chime://meeting?pin=%1" }
            }
        },
        start = true,
        -- loglevel = 'debug'
    }
)


---
--- Reload Config (Hyper + R)
---
hs.hotkey.bind(hyper, "R", function()
    hs.reload()
end)
hs.alert.show("⚒ Config loaded")


---
--- Launch Apps with Right Command key (r⌘)
---
Install:andUse("LeftRightHotkey", {
    config = {
        right = { "rCmd" }
    },
    -- works like a "callback" function for LeftRightHotkey
    fn = function(lrHotkey)
        --- Brave: right ⌘ + B
        lrHotkey:bind({ "r⌘" }, "B", function()
            hs.application.launchOrFocus("Brave Browser")
        end)
        --- Ghostty: right ⌘ + G
        lrHotkey:bind({ "rCmd" }, "G", function()
            hs.application.launchOrFocus("Ghostty")
        end)
        --- Hammerspoon Console: right ⌘ + H
        lrHotkey:bind({ "rCmd" }, "H", function()
            hs.application.launchOrFocus("Hammerspoon")
        end)
        --- Messages: right ⌘ + K
        lrHotkey:bind({ "rCmd" }, "K", function()
            hs.application.launchOrFocus("Keymapp")
        end)
        --- Messages: right ⌘ + M
        lrHotkey:bind({ "rCmd" }, "M", function()
            hs.application.launchOrFocus("Messages")
        end)
        --- Obsidian: right ⌘ + O
        lrHotkey:bind({ "rCmd" }, "O", function()
            hs.application.launchOrFocus("Obsidian")
        end)
        --- PyCharm: right ⌘ + P
        lrHotkey:bind({ "rCmd" }, "P", function()
            hs.application.launchOrFocus("PyCharm")
        end)
        --- Ghostty: right ⌘ + S
        lrHotkey:bind({ "rCmd" }, "S", function()
            hs.application.launchOrFocus("Slack")
        end)
        --- Whasapp: right ⌘ + W
        lrHotkey:bind({ "rCmd" }, "W", function()
            hs.application.launchOrFocus("Whatsapp")
        end)
        --- Zed: right ⌘ + Z
        lrHotkey:bind({ "rCmd" }, "Z", function()
            hs.application.launchOrFocus("Zed")
        end)
    end,
    start = true
})


---
--- Caffeine prevents sleep
---
Install:andUse("Caffeine", {
    start = true,
    hotkeys = {
        toggle = { hyper, "1" }
    },
})

---
--- MiroWindowsManager moves app windows to sides/corners/etc.
---
Install:andUse("MiroWindowsManager", {
    hotkeys = {
        up = { hyper, "k" },
        right = { hyper, "l" },
        down = { hyper, "j" },
        left = { hyper, "h" },
        fullscreen = { hyper, "f" },
        nextscreen = { hyper, "n" },
        nextwindow = { hyper, "w" },
    },
})

---
--- Keyboard flags in the menubar
---
-- Install:andUse("MenubarFlag",
--     {
--         config = {
--             colors = {
--                 ["U.S."] = {},
--                 Spanish = { col.green, col.white, col.red },
--                 Albanian = { col.red, col.black, col.red },
--                 German = { col.black, col.red, col.yellow },
--             }
--         },
--         start = true
--     }
-- )


-- Install:andUse("BrewInfo",
--     {
--         config = {
--             brew_info_style = {
--                 textFont = "Inconsolata",
--                 textSize = 14,
--                 radius = 10
--             }
--         },
--         hotkeys = {
--             show_brew_info = { hyper, "b" },
--             open_brew_url = { meh, "b" },
--         }
--     }
-- )

-- Install:andUse("KSheet",
--     {
--         hotkeys = {
--             toggle = { hyper, "/" }
--         }
--     })
