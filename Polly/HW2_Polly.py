def scanner(string, separators):
    keywords = {'for', 'to', 'downto', 'do'}
    result_string = ''
    flag = True

    def is_identifier(token):
        return token.isalnum() and not token.isdigit()

    def is_literal(token):
        return token.isdigit() or (token[0] == '-' and token[1:].isdigit())

    def skip_spaces(s):
        while s and s[0].isspace():
            s = s[1:]
        return s

    string = skip_spaces(string)

    while string:
        if string[0] not in separators:
            index = 0
            while index < len(string) and string[index] not in separators:
                index += 1
            token = string[:index]
            string = string[index:]

            if token in keywords:
                curr_token = token.lower()
                print('Ключевое слово:', curr_token)
                result_string += '@@' if curr_token == 'for' else ''
                if curr_token == 'for':
                    curr_token = 'fr'
                elif curr_token == 'downto':
                    curr_token = 'to'
                result_string += curr_token
            else:
                if is_identifier(token):
                    print('Идентификатор:', token)
                    result_string += 'V_'
                elif is_literal(token):
                    print('Целое:', token)
                    result_string += 'C_'
                else:
                    flag = False
                    print('Неверный токен:', token)
                    return flag
        else:
            result_string += string[0]
            if string[0] == ';':
                print('Специальный символ:', string[0])
                string = string[1:]
                result_string += '_'
            elif len(string) > 1 and string[1] == '=':
                print('Специальный символ:', string[:2])
                result_string += string[1]
                string = string[2:]
            else:
                flag = False
                print('Неверный символ:', string[0])
                return flag

        string = skip_spaces(string)

    print('После сканирования:', result_string)
    return result_string


def stack_method(string, table):
    stack = "##"
    i = -1
    commands = []
    end = False
    success = False
    while not end:
        ind_str = 0
        ind_col = 0
        if len(stack) >= 2:
            if stack[-2:] == '##':
                ind_str = 0
            elif stack[-2:] == ':=':
                ind_str = 1
            elif stack[-2:] == 'fr':
                ind_str = 2
            elif stack[-2:] == 'to':
                ind_str = 3
            elif stack[-2:] == 'do':
                ind_str = 4

        if len(string) >= 4:
            if string[2:4] == ':=':
                ind_col = 0
            elif string[2:4] == 'fr':
                ind_col = 1
            elif string[2:4] == 'to':
                ind_col = 2
            elif string[2:4] == 'do':
                ind_col = 3
            elif string[2:4] == ';_':
                ind_col = 4
            else:
                ind_col = 5

        case = table[ind_str][ind_col]
        if case == 1:
            stack += "<." + string[:4]
            string = string[4:]
        elif case == 2:
            stack += string[:4]
            string = string[4:]
        elif case == 3:
            i += 1
            k = stack.rfind("<.")
            if stack[k + 2:k + 4] == "@@":
                commands.append(stack[k + 4:])
            else:
                commands.append(stack[k + 2:])
            stack = stack[:k]
            if stack[-1] == "@":
                stack = stack[:-2]
            commands[i] += string[:2]
            string = string[2:]
            if commands[i][0:2].lower() == 'fr':
                string = 'Of' + string
            elif commands[i][2:4] == ':=':
                string = 'Op' + string
        elif case == 4:
            success = True
            end = True
            for i1 in range(0, i + 1):
                print(f"Команда: {commands[i1]}")
        elif case == -1:
            end = True
            for i1 in range(0, i + 1):
                print(f"Команда: {commands[i1]}")
            print(f"Остаток строки: {string}")
    return success, string


# Таблица предшествования
table = [
    [1, 1, -1, -1, 4, -1],
    [-1, -1, 3, -1, 3, -1],
    [1, -1, 2, -1, -1, -1],
    [-1, -1, -1, 2, -1, -1],
    [1, 1, -1, -1, 3, -1]
]
# Разделители
separators = {' ', ':', ';', '='}

# Успешные тесты
test_string1 = "for i:=1 to 10 do for jj:=20 downto 10 do a:=5;"
test_string2 = "for a57:=0 to 5 do c1 := -7;"
test_string3 = "a := -101;"
test_string4 = "for a1:=1 to 10 do for b2:=20 downto 10 do for c3:=100 downto 10 do d5:=0;"
# Тесты с ошибкой
test_string5 = "for i:=1 to 10 for jj:=20 downto 10 do a:=5;"
test_string6 = "a57:=0 to 5 do c1 := -7;"
test_string7 = "a = 505;"
test_string8 = "for for a:=0 to 5 do c := 0;"


if __name__ == '__main__':
    inp = input("Введите строку для анализа или end: ")
    while inp != 'end':
        result = scanner(inp, separators)
        if result:
            print('Начинаем синтаксический анализ...\n')
            result, remaining_statement = stack_method(result, table)
            if result:
                print('\nПроверка пройдена!\n')
            else:
                print('\nОшибка на этапе синтаксического анализа!\n')
        else:
            print('Ошибка на этапе лексического анализа!\n')
        inp = input("______________________\nВведите строку для анализа или end: ")



