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
local terminal = require("term")
local event = require("event")
local sides = require("sides")
local colors = {
    top_bar_bg = 0x3e1919,
    top_bar_t = 0xFFFFFF,
    btn_active_bg = 0x2A64B8, -- синий
    btn_active_t = 0xd4e0f0, -- светлосиний
    btn_disabled_bg = 0x939899, --серый
    btn_disabled_t = 0x151515 -- почти блэк)
}

local cfg = {
    my_name = "Dragons Trade",
    my_ver = "0.0.0",
    gui_sleep = 0.1, -- задержка в оконной функции
    dev = true, -- флаг вывода дополнительной инфы
    max_x = 0,
    max_y = 0
}
----------------------------------------------------------------------------------------------------
-- кнопки для главного экрана
local buttons_cfg = {
    sX = 125,
    sY = 3,
    W = 35,
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
        colors = {colors.btn_active_bg, colors.btn_disabled_bg, colors.btn_active_t, colors.btn_disabled_t},
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
        colors = {colors.btn_active_bg, colors.btn_disabled_bg, colors.btn_active_t, colors.btn_disabled_t},
        call = btn_sell_onClick,
        perm = "USER",
        enable = false
    },  
    {
        name = "btn_buy", 
        label = "Купить",
        cords = {}, 
        colors = {colors.btn_active_bg, colors.btn_disabled_bg, colors.btn_active_t, colors.btn_disabled_t},
        call = btn_sell_onClick,
        perm = "USER",        
        enable = false
    }, 
    {
        name = "btn_lk", 
        label = "Личный кабинет",
        cords = {}, 
        colors = {colors.btn_active_bg, colors.btn_disabled_bg, colors.btn_active_t, colors.btn_disabled_t},
        call = btn_sell_onClick,
        perm = "USER",
        enable = false
    },
    {
        name = "btn_admin", 
        label = "Админка",
        cords = {}, 
         colors = {colors.btn_active_bg, colors.btn_disabled_bg, colors.btn_active_t, colors.btn_disabled_t},
        call = btn_admin_onClick,
        perm = "ADMIN",
        enable = false
    },
    {
        name = "btn_logout", 
        label = "Выход",
        cords = {}, 
        colors = {colors.btn_active_bg, colors.btn_disabled_bg, colors.btn_active_t, colors.btn_disabled_t},
        call = btn_logout_onClick,
        perm = "USER",
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
            b.cords.y = buttons_cfg.sY + buttons_cfg.H * (k-1) + buttons_cfg.SP * (k-1)
            b.cords.x2 = buttons_cfg.sX + buttons_cfg.W
            b.cords.y2 = b.cords.y + buttons_cfg.H
                       
            gpu.fill(b.cords.x, b.cords.y, buttons_cfg.W, buttons_cfg.H, " ")
            gpu.set(b.cords.x + 2, b.cords.y+buttons_cfg.H/2, b.label)
            gpu.setBackground(oldb)
            gpu.setForeground(oldf)

            print("{"..k.."} " .. b.name .. ">>" .. b.perm)
        end

    end
    -- отрисуем топ бар
    gpu.setBackground(colors.top_bar_bg); gpu.setForeground(colors.top_bar_t);
    gpu.fill(1, 1, cfg.max_x, 1, " ")
    gpu.set(1, 1, cfg.my_name .. "@" .. cfg.my_ver)
    terminal.setCursor(1, 2)
    event_gui()
end

function event_gui()
-- обрабатываем события
    local _, _, cx, cy, cb, cp = event.pull("touch")
    gpu.set(110, 1, "["..cx..":"..cy.."'"..cb.."] "..cp)
end


function clear_gui()
-- очистка экрана
    --color reset
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
    -- заполняем пустотой весь экран
    gpu.fill(1,1, cfg.max_x, cfg.max_y, " ")
    -- курсор в начало
    terminal.setCursor(1, 1)
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
    elseif mode == "cls" or mode == "clear" then
        -- чистим экран
        init_gui(); clear_gui();
        os.exit();
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














--228 - недавно эта строчка была 228-ой
