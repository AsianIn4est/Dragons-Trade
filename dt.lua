--[[
name: Dragon Trade
version: 0.1a#001
autor: Asian_In4est
--]]

----------------------------------------------------------------------------------------------------
local args = ...
local os = require("os")
local io = require("io")
local mode = ""
local gpu
local component = require("component")
local terminal = require("term")
local event = require("event")
local sides = require("sides")
local serialization = require("serialization")
local colors = {
    top_bar_bg = 0x3e1919,
    top_bar_t = 0xFFFFFF,
    btn_active_bg = 0x2A64B8, -- синий
    btn_active_t = 0xd4e0f0, -- светлосиний
    btn_disabled_bg = 0x939899, --серый
    btn_disabled_t = 0x151515, -- почти блэк)
    alert_bar_t = 0xFFFFFF,
    alert_body_bg = 0xBADBAD,
    alert_body_t = 0xC60000
}
    colors.alert_bar_bg = colors.top_bar_bg
local cfg = {
    my_name = "Dragons Trade",
    my_ver = "0.0 alf",
    gui_sleep = 0.1, -- задержка в оконной функции
    dev = true, -- флаг вывода дополнительной инфы
    max_x = 0,
    max_y = 0,
    alert_x = 50,
    alert_y = 20,
    log_path = "/home/log",
}

cfg.alert_w = (100 - cfg.alert_x)
cfg.alert_h = (30 - cfg.alert_y)

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
        call = function () btn_login_onClick() end,
        -- права доступа
        perm = "NOLOGIN",
    },
    {
        name = "btn_sell", 
        label = "Продать",
        cords = {}, 
        colors = {colors.btn_active_bg, colors.btn_disabled_bg, colors.btn_active_t, colors.btn_disabled_t},
        call = function () btn_sell_onClick() end,
        perm = "USER",
    },  
    {
        name = "btn_buy", 
        label = "Купить",
        cords = {}, 
        colors = {colors.btn_active_bg, colors.btn_disabled_bg, colors.btn_active_t, colors.btn_disabled_t},
        call = function () btn_sell_onClick() end,
        perm = "USER",        
    }, 
    {
        name = "btn_lk", 
        label = "Личный кабинет",
        cords = {}, 
        colors = {colors.btn_active_bg, colors.btn_disabled_bg, colors.btn_active_t, colors.btn_disabled_t},
        call = function () btn_sell_onClick() end,
        perm = "USER",
    },
    {
        name = "btn_admin", 
        label = "Админка",
        cords = {}, 
         colors = {colors.btn_active_bg, colors.btn_disabled_bg, colors.btn_active_t, colors.btn_disabled_t},
        call = function () btn_admin_onClick() end,
        perm = "ADMIN",
    },
    {
        name = "btn_logout", 
        label = "Выход",
        cords = {}, 
        colors = {colors.btn_active_bg, colors.btn_disabled_bg, colors.btn_active_t, colors.btn_disabled_t},
        call = function () btn_logout_onClick() end,
        perm = "USER",
    }      
}


local last_click = {
    x = 0, y = 0, b = 0, p = 0
}

local user = {
    perm = "NOLOGIN",
    nick = ""
}

local admins = {"Asian_In4est"}
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
            if b.perm == "NOLOGIN" then b.enable = (user.perm == "NOLOGIN") end;
            if b.perm == "USER" then b.enable = (user.perm == "USER" or user.perm == "ADMIN") end;
            if b.perm == "ADMIN" then b.enable = (user.perm == "ADMIN") end;

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
        end

    end
    -- отрисуем топ бар
    gpu.setBackground(colors.top_bar_bg); gpu.setForeground(colors.top_bar_t);
    gpu.fill(1, 1, cfg.max_x, 1, " ")
    gpu.set(3, 1, cfg.my_name .. " #" .. cfg.my_ver)
    gpu.set(cfg.max_x-18, 1, user.nick)
    terminal.setCursor(1, 2)
    event_gui()
end

function event_gui()
-- обрабатываем события
    local ev, _, ex, ey, eb, ep = event.pull("touch")
    last_click.x = ex
    last_click.y = ey
    last_click.b = eb
    last_click.p = ep

    
    -- если кликнул другой хрен, разлогиниваем
    if last_click.p ~= user.nick and user.nick ~= "" then  
        log({"user_force_logout", user.nick, ep})
        btn_logout_onClick();
    end;

    for k, btn in pairs(buttons) do
        if btn.enable and -- проверим что кнопка активна
            last_click.x >= btn.cords.x and  -- сверим координаты
            last_click.y >= btn.cords.y and 
            last_click.x <= btn.cords.x2 and 
            last_click.y <= btn.cords.y2 then

            btn.call() -- калбэк
        end
    end
    
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

function alert(label, text)
    gpu.setBackground(colors.alert_bar_bg)
    gpu.setForeground(colors.alert_bar_t)
    gpu.fill(cfg.alert_x, cfg.alert_y, cfg.alert_w, cfg.alert_h, " ")
    gpu.set(cfg.alert_x + 2, cfg.alert_y, label)
    gpu.setBackground(colors.alert_body_bg)
    gpu.setForeground(colors.alert_body_t)
    gpu.fill(cfg.alert_x, cfg.alert_y + 1, cfg.alert_w, cfg.alert_h, " ")
    gpu.set(cfg.alert_x + 2, cfg.alert_y + cfg.alert_h / 2, text)
    event.pull("touch")
end

function btn_login_onClick()
    
    alert("Привет "..last_click.p, "Лол кек! Здарова.")
    user.nick = last_click.p
    user.perm = "USER"
    for u = 1, #admins do
        if admins[u] == user.nick then
            user.perm = "ADMIN"
            break
        end
    end
    log({"user_login", user.nick, user.perm})
end

function btn_sell_onClick()

end

function btn_buy_onClick()

end

function btn_lk_onClick()

end

function btn_admin_onClick()

end

function btn_logout_onClick()
    user.nick = ""
    user.perm = "NOLOGIN"
end

function log(t)
    if type(t) ~= "table" then return false end;
    file = io.open(cfg.log_path, "r")
    if file ~= nil then
        data = file:read("a*"); file:close();
        data = serialization.unserialize(data)
    else
        data = {}
    end
    table.insert(data, t)
    data = serialization.serialize(data)
    file = io.open(cfg.log_path, "w")
    file:write(data); file:close();
end
----------------------------------------------------------------------------------------------------


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
