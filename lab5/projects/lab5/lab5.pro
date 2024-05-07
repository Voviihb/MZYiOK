CONFIG += c++11 console # консольное приложение
CONFIG -= app_bundle
DEFINES += QT_DEPRECATED_WARNINGS
SOURCES += main.cpp
OBJECTS += text.o # подключение объектного модуля ассемблерной
# подпрограммы
DISTFILES += text.asm \ # включение в проект исходного модуля
    text.asm
# на ассемблере для удобства вызова его
# исходного текста в текстовый редактор
CONFIG ~= s/-O[0123s]//g # отключение оптимизации
CONFIG += -O0
