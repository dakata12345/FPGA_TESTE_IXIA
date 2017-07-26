game_FSM
================
Acest modul reprezinta nucleul jocului pong. Contine automatul care controleaza flow-ul jocului si totodata logica jocului. El transmite ca
si output scorurile pentru ambii jucatori si culorile ce trebuie afisate pe ecranul monitorului.

## Starile automatului 
         ## 1. STATE_RESET :
          ball_x <= screen_width >>1; 
					ball_y <= screen_height >> 1;
				  paddle2_x <= screen_width >> 1; 
					paddle2_y <= border_size << 2;
				 	paddle1_x <= screen_width >> 1; 
					paddle1_y <= screen_height - (border_size << 2);
				 	state <= STATE_PLAYER_SELECT; 
					score_player_1 <= 4'd0;
					score_player_2 <= 4'd0;
					speed_counter <= 6'd0;
					computer_counter <= 6'd0;
          Starea de reset , starea in care sunt date poziitiile pe x,y pentru palete, pozitiile pe x,y pentru minge ( mingea este
          setata sa apara in centrul ecranului ). De asemenea paleta jucatorului 2 nu va aparea decat in momentul in care este selectat modul multiplayer
          Se observa totusi ca :
          - Pentru paleta jucatorului 1 au fost lasate 12 coloane libere intre aceasta si border (paddle1_y <= screen_height - 			    (border_size << 2) linia de cod amintita insemnand faptul ca pozitia pe y a paletei o sa fie screen_height - border*4 =480-		    24 = 456. Pozitia pe x pentru ambele padduri
          este identica fiind situata in centrul ecranului(320 = screen_width/2). Pozitia pe y a paletei jucatorului 2 este paddle2_y <= border_size << 2 adica 24
          ceea ce inseamna exact ca la pozitia pentru paddle 1 o diferenta de 24 linii ( ceea ce simbolizeaza sfarsitul lui feature_size + 13 linii lasate negre).
          Totodata in aceasta stare sunt resetate scorurile playerilor , counterul ce este folosit pentru a determina viteza cu care se 	   deplaseaza mingea  si counterul pentru computer care este folosit in acelasi mod.
           - Trnazitia in starea urmatoare nu are la baza vreo conditie si este implicita.
					
          ## 2 STATE_PLAYER_SELECT :
            Aceasta stare nu necesita o explicatie amanuntita deoarece este foarte clar care este functionalitatea: ea genereaza   	             semnalul.
            prin care se alege modul de joc in functie de inputul primit de la tastatura. Totodata in aceasta stare este setata directia 	     pe axa x si  y (ball_dx ,ball_dy) odata ce a fost selectat modul de joc.            
          
          ## 3 STATE_GAME :
              Aceasta este starea care contine logica efectiva a jocului , tranzitia in aceasta facandu-se din starea anterioara numai 		      la apasarea tastei SPACE.
              Logica acestei stari este urmatoarea , daca este apasat butonul SPACE se trece imediat in starea de pauza daca este apasat 	       butonul ESC se trece in starea de reset
              Daca este apasata tasta A se verifica o conditie astfel incat sa nu se depaseasca zona destinata jocului (acel 			      feature_size + o jumatate de paleta + latura patratului din
              care e compusa mingea) Aceasta conditie este logica deoarece numarul de pixeli cu care se misca paleta este egal cu 		      ball_width si pentru o deplasare in stanga
              inseamna sa scad ball_width pixeli din pozitia curenta a padului si pentru a nu iesi din ecran trebuie sa tin cont de 		      feature size si jumatate din lungimea unui pad.
              La fel se intampla si in momentul in care se doreste o deplasare dreapta a padului doar ca de data aceasta pozitia pe x a 	      padului trebuie sa fie mai mica sau egala cu screen_witdh - aceleasi 
              valori de care am tinut cont in partea stanga. Aceleasi lucruri se intampla identic si pentru player2 cu singura diferenta 		ca este verificat daca semnalul care 
              spune modul jocului este activ.
              * De observat este ca : nu folosesc un counter pentru a permite vizualizarea pe  ecran a miscarii mingii respectiv a 			padului ci doar in momentul in care un frame complet este realizat(ceea ce inseamna actualizarea tuturor celor 640x480 e 		 pixeli) + inca o linie completata +1 pixel ceea ce inseamna echivalentul unui counter care nuamra pana la  640x480 + 640 		  + 1 = 307.841(19 biti) esteefectuat acel case. Acest lucru face ca miscarea padului si a bilei sa fie vizibile pentru 		ochiul uman.
               Avem un counter care numara pana la viteza bilei pe care am setat-o. In momentul in care acest counter atinge acea 			valoare este resetat si se verifica in primul rand daca directia bilei este
               la dreapta pe axa x ( ball_dx = 1). Daca directia este la dreapta se verifica conditia de overflow ( daca bila este in 			screen_width - feature_size - border_size) astfel incat bila sa nu iasa din suprafata de joc
               si se adauga la pozitia pe x a bilei inca un ball_width atata timp cat aceasta conditie este indeplinita.Altfel daca bila 		merge la stanga se verifica o conditie de overflow
               (feature_size + border_size) si se scade din pozitia curenta de pe axa x a bilei ball_width.Daca bila nu mai poate merge 		la stanga sau la dreapta (adica ambele conditii de overflow nu sunt indeplinite) inseamna ca bila
               loveste feature-ul si atunci directia  x (ball_dx)  este setata la 0 sau la 1 in functie de ce margine a ecranului va 			lovi (stanga sau dreapta).
               Daca directia pe y este setata inseamna ca bila merge in jos. In momentul in care bila merge in jos sunt 3 posibilitati :
               -fie bila loveste peretele lateral (feature-ul) mergand pe diagonala ori in stanga ori in dreapta in functie de directia 		pe x
               - fie bila loveste padul
               -fie jucatorul 1 nu plaseaza padul in locatia corecta pentru a lovi mingea ceea ce inseamna ca este un punct pentru 			jucatorul 2
              Conditia pentru ca bila sa loveasca padul este urmatoarea ball_x >= paddle1_x - (paddle_width >> 1)) && (ball_x <= 		      paddle1_x + (paddle_width >> 1)) && (ball_y == paddle1_y - ball_width). Conditia este evidenta deoarece
              presupune exact suprapunerea pozitiei mingii pe x,y cu jumatatea superioara sau inferioara a padului( pozitia pe x a 		      podului si y reprezinta niste puncte de aceea este pusa aceasta conditie, practic este conditia care este folosita pentru
              afisarea padului la care am adaugat conditia ca pozitia bilei pe axa x,y sa coincida cu suprafata padului). Daca bila 		      loveste padul  viteza cu care se deplaseaza mingea este incrementata
              pentru a face aceasta se verifica daca vitea mingii este >1 si se scade 1 din valoarea curenta. Cu cat viteza este mai 		      mica cu atat counter-ul va numara pana la o valorea mai mica 
              ceea ce va face iluzia deplasarii mai rapide a mingii pe ecran.
              Daca directia mingii este in jos si a lovit feature-ul (marginea) inseamna ca la pozitia actuala pe y a mingii adaug inca 	      o latura a mingii( indiferent de directia pe x fie ca este
              stanga sau dreapta mingea isi continua deplasarea in jos.Pentru aceasta este pusa conditia ball_y <= screen_height - 		      feature_size - border_size.
              A 3-a posibiliatate este cea in care mingea a lovit suprafata de sub padul jucatorului 1 ceea ce inseamna punct pentru 		      jucatorul 2.In cazul in care aceasta se intampla automatul va trece in starea STATE_PLAYER2_SCORE
              pozitia mingii va fi setata in centrul ecranului viteza va fi resetata la valoarea prestabilita , pozitia padurilor va fi 	      resetata, iar din aceasta stare se trece in starea game
              la apasarea tastei SPACE.
              In mod identic se intampla si cu paddul2 si exista acelasi 3 posibilitati pentru aceasta directie.
              
              Daca speed_counter nu a ajuns la valoarea prestabilita pentru viteza mingii acesta este incrementat in continuare. Daca 		      player_mode este 0
              ceea ce inseamna single_player este incercata simularea inteligentei artificiale. In mod similar exista un counter pentru 	      computer pentru a determina viteza si totodata nivelul de dificultate pentru
              computer. Computerul se va misca doar in momentul in care se actualizeaza un frame complet si acest counter ajunge la 		      valoarea prestabilita.In momentul in care counter computerului ajunge la acea valoare
              este verificata conditia de overflow pentru ca padul sa nu iasa din zona de joc in functie de pozitia pe x si pe y a 		      mingii iar, counterul e resetat.
              Daca mingea merge la stanga pozitia de pe x a mingii este evident decrementata si atunci si pozitia padului de pe x a lui 	      player 2 este decrementata. Simtetric se intampla pentru o depalsare la dreapta.
              Daca counterul nu a ajuns la acea valoare va numara in continuare.
              
             ## 4 STATE_PLAYER1_SCORE : 
                  Starea este evidenta , se poate iesi din aceasta stare apasand pe space pentru a relua jocul sau ESC pentru a-l reseta
              
             ## 5 STATE_PLAYER2_SCORE :
                  Starea este evidenta , se poate iesi din aceasta stare apasand pe space pentru a relua jocul sau ESC pentru a-l reseta
              
	    ## 6 STATE_PAUSE :
                   In starea de pauza se poate intra doar din starea de joc. Din aceasta stare se paote iesi apasand pe SPACE pentru a 			  relua jocul sau ESC pentru reset
                    
					
					
