local Translations = {
error = {
    not_enough_cash_to_rent_room = 'não tem dinheiro suficiente para alugar um quarto!',
    you_already_have_room_here = 'você já tem um quarto aqui!',
    you_dont_have_room_here = "você não tem um quarto aqui!",
    not_enough_cash = "você não tem dinheiro suficiente para isso!",
},
success = {
    you_rented_room = 'você alugou um quarto ',
    room_credit_added_for = 'crédito do quarto adicionado para ',
},
primary = {
    your_credit_is_now = 'seu crédito agora é de $',
},
menu = {
    open = 'Abrir ',
    check_in = 'Check-In',
    rent_room_deposit = 'Alugar um Quarto ($ %{startCredit} de Depósito)',
    close_menu = 'Fechar Menu',
    room_menu = 'Menu do Quarto',
    hotel_room = 'Quarto de Hotel: ',
    add_credit = 'Adicionar Crédito',
    wardrobe = 'Guarda-Roupas',
    room_locker = 'Armário do Quarto',
    leave_room = 'Sair do Quarto',
    add_credit_room = 'Adicionar Crédito ao Quarto ',
    room = 'Quarto ',
},
text = {
    current_credit = 'crédito atual $',
    amount = 'Valor ($)',
},
commands = {
    var = 'texto vai aqui',
},
progressbar = {
    var = 'texto vai aqui',
},

}

if GetConvar('rsg_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
