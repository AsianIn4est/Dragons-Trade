--[[
name: Dragon Trade
version: 0.1a#001
autor: Asian_In4est
--]]

----------------------------------------------------------------------------------------------------
local args = ...
local os = require("os")
local mode = ""
local gpu
local component = require("component")

local event = require("event")
local sides = require("sides")
local colors
local cfg = {
    gui_sleep = 0.1, -- задержка в оконной функции
    dev = true, -- флаг вывода дополнительной инфы
    max_x = 0,
    max_y = 0
}
----------------------------------------------------------------------------------------------------
-- кнопки для главного экрана
local buttons_cfg = {
    sX = 110,
    sY = 6,
    W = 40,
    H = 6,
    SP = 2 -- space между кнопками
}

-- слой для показа на главном экране
local layer

local buttons = {
    {
        -- имя кнопки
        name = "btn_login", 
        -- надпись
        label = "Логин",
        cords = {}, 
        --     фон: ВКЛ       ВЫКЛ      ВКЛ      ВЫКЛ     
        colors = {0xFFDEAD, 0xFFF8DC, 0x000000, 0x000000},
        -- обработчик кликов
        call = btn_login_onClick,
        -- права доступа
        perm = "NOLOGIN",
        enable = true
    },
    {
        name = "btn_sell", 
        label = "Продать",
        cords = {}, 
        colors = {0xFFDEAD, 0xFFF8DC, 0x000000, 0x000000},
        call = btn_sell_onClick,
        perm = "USER",
        enable = true,
    },  
    {
        name = "btn_buy", 
        label = "Купить",
        cords = {}, 
        colors = {0xFFDEAD, 0xFFF8DC, 0x000000, 0x000000},
        call = btn_sell_onClick,
        perm = "USER",        
        enable = true
    }, 
    {
        name = "btn_lk", 
        label = "Личный кабинет",
        cords = {}, 
        colors = {0xFFDEAD, 0xFFF8DC, 0x000000, 0x000000},
        call = btn_sell_onClick,
        perm = "USER",
        enable = true
    },
    {
        name = "btn_admin", 
        label = "Админка",
        cords = {}, 
        colors = {0xFFDEAD, 0xFFF8DC, 0x000000, 0x000000},
        call = btn_admin_onClick,
        perm = "ADMIN",
        enable = false
    }   
}


----------------------------------------------------------------
--  GUI 
----------------------------------------------------------------

function init_gui()
-- вызывается перед началом оконного цикла
    gpu = component.gpu
    layer = "main"
    cfg.max_x, cfg.max_y = gpu.getResolution()
end

function mode_gui()
-- оконный цикл
    clear_gui()
    if layer == "main" then
        for k, b in pairs(buttons) do
            local oldb, oldf = gpu.getBackground(), gpu.getForeground()
            -- рисуем наши кнопочки
            if b.enable then
                gpu.setBackground(b.colors[1])
                gpu.setForeground(b.colors[3])
            else
                gpu.setBackground(b.colors[2])
                gpu.setForeground(b.colors[4])                   
            end

            b.cords.x = buttons_cfg.sX
            b.cords.y = buttons_cfg.sY + ((k-1)*buttons_cfg.H)
            b.cords.x2 = buttons_cfg.sX + buttons_cfg.W
            -- спейсик между кнопочками )))
            if k > 1 then b.cords.y2 = b.cords.y2 + buttons_cfg.SP end
            gpu.fill(b.cords.x, b.cords.y, buttons_cfg.W, buttons_cfg.H, " ")
            gpu.set(b.cords.x + 2, b.cords.y+buttons_cfg.H/2, b.label)
            gpu.setBackground(oldb)
            gpu.setForeground(oldf)

            print("{"..k.."} " .. b.name .. ">>" .. b.perm)
        end

    end
    event_gui()
end

function event_gui()
-- обрабатываем события
    local _ = event.pull("touch")
end


function clear_gui()
-- очистка экрана
    gpu.fill(1,1, cfg.max_x, cfg.max_y, " ")
end


function btn_login_onClick()

end

function btn_sell_onClick()

end

function btn_buy_onClick()

end

function btn_lk_onClick()

end

function btn_admin_onClick()

end




----------------------------------------------------------------------------------------------------
-- void main () {
----------------------------------------------------------------------------------------------------
if type(args) == "string" then
    mode = args
    -- режим торг. автомата
    if mode == "gui" then
            init_gui()
            while 1 do
                -- если режим работы gui вызываем оконную функцию
                mode_gui()
                os.sleep(cfg.gui_sleep)
            end
    elseif mode == "server" then
        -- режим сервака
    elseif mode == "unit" then
        -- режим разработчика
        debug = true
    else
        print("Bad argument. Usage dt type (gui or server)")
        os.exit()
    end
else
    print("No argument. Usage: $ dt <type>. Bye!")
    os.exit()
end

----------------------------------------------------------------------------------------------------
-- }
----------------------------------------------------------------------------------------------------