.PHONY: clean 


CFLAGS +=  -Og -g -Wall  -Wextra #-fPIC
LDFLAGS	 +=-lm  #-shared 
#--------LIBRAIRIE-----------------------------------------

EXEC=start 
GPP=g++
$(EXEC) : main.o  plateau.o  player.o base.o card.o
	$(GPP) $(CFLAGS) -o $@ $^ $(LDFLAGS)
	rm *.o

%.o : %.cpp 
	$(GPP) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<



clean :
	$(RM) -rf *.o $(EXEC)


#Liste de dependences
main.o: main.cpp  plateau.o  
base.o: base.cpp base.h
plateau.o: plateau.cpp plateau.h base.h card.h player.h
player.o: player.cpp player.h base.h
card.o: card.cpp card.h base.h
