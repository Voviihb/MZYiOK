program: main.o lab5.o
	g++ -o program main.o lab5.o

main.o: main.cpp
	g++ -c main.cpp -o main.o

lab5.o: lab5.asm
	nasm -f elf64 lab5.asm -o lab5.o

clean:
	rm -f program main.o lab5.o
	
run: program
	./program

debug: program
	edb --run program
