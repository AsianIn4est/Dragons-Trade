--[[
name: Dragon Trade
version: 0.1a#001
autor: Asian_In4est
--]]

----------------------------------------------------------------------------------------------------
local args = ...
local os = require("os")
local mode = ""
local debug = false
local gpu, event, component, sides, colors
----------------------------------------------------------------------------------------------------

if type(args) == "string" then
    mode = args[0]
    if mode == "gui" then
        -- режим торг. автомата
        gpu = component.gpu

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

----------------------------------------------------------------
--  GUI 
----------------------------------------------------------------

-- кнопки для главного экрана
local buttons_cfg{
    sX = 110,
    sY = 6,
    W = 40,
    H = 6
}

local buttons = {
    {
        -- имя кнопки
        name = "btn_login", 
        -- надпись
        text = "Логин",
        cords = {}, 
        --     фон: ВКЛ       ВЫКЛ      ВКЛ      ВЫКЛ     
        colors = {0xFFDEAD, 0xFFF8DC, 0x000000, 0x000000},
        -- обработчик кликов
        call = btn_login_onClick,
        -- права доступа
        perm = "NOLOGIN"
    },
    {
        name = "btn_sell", 
        text = "Продать",
        cords = {}, 
        colors = {0xFFDEAD, 0xFFF8DC, 0x000000, 0x000000},
        call = btn_sell_onClick,
        perm = "USER"
    },  
    {
        name = "btn_buy", 
        text = "Купить",
        cords = {}, 
        colors = {0xFFDEAD, 0xFFF8DC, 0x000000, 0x000000},
        call = btn_sell_onClick,
        perm = "USER"
    }, 
    {
        name = "btn_lk", 
        text = "Личный кабинет",
        cords = {}, 
        colors = {0xFFDEAD, 0xFFF8DC, 0x000000, 0x000000},
        call = btn_sell_onClick,
        perm = "USER"
    },
    {
        name = "btn_admin", 
        text = "Админка",
        cords = {}, 
        colors = {0xFFDEAD, 0xFFF8DC, 0x000000, 0x000000},
        call = btn_admin_onClick,
        perm = "ADMIN"
    }   
}

function mode_gui()

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






