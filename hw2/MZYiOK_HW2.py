def scanner(string, separators):
    keywords = {'if', 'then', 'else'}
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
                print('Ключевое слово:', token)
                result_string += '@@' if token.lower() == 'if' else ''
                result_string += token[:2]
            else:
                if is_identifier(token):
                    print('Идентификатор:', token)
                    result_string += 'V_'
                elif is_literal(token):
                    print('Целое:', token)
                    result_string += 'L_'
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
            elif stack[-2:] == 'if':
                ind_str = 2
            elif stack[-2:] == 'th':
                ind_str = 3
            elif stack[-2:] == 'el':
                ind_str = 4

        if len(string) >= 4:
            if string[2:4] == ':=':
                ind_col = 0
            elif string[2:4] == 'if':
                ind_col = 1
            elif string[2:4] == 'th':
                ind_col = 2
            elif string[2:4] == 'el':
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
            if commands[i][0:2].lower() == 'if':
                string = 'OI' + string
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
    [-1, -1, -1, 3, 3, -1],
    [-1, -1, 2, -1, -1, -1],
    [1, 1, -1, 2, 3, -1],
    [1, 1, -1, -1, 3, -1]
]
# Разделители
separators = {' ', ':', ';', '='}
# success tests
test_string1 = "if d then gyu:=5 else if r then u:=-78 else gju:=ty;"
test_string2 = "if a57 then c1 := -7;"
test_string3 = "a := -101;"
test_string4 = "if h51 then c := 0 else u1 := -10;"
test_string5 = "if a then b:=5 else if c then d:=-78 else if e then f:=-5;"
# fail tests
test_string6 = "if d then gyu:=5 if r then u:=-78 else gju:=ty;"
test_string7 = "a = -101;"
test_string8 = "if a then b:=5 else if c then d:=-78 else then f:=-5;"
test_string9 = "if b if c then d:=0;"
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
