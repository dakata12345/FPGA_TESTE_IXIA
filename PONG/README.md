PONG
================

"Pong (comercializat sub numele de PONG) este unul dintre primele jocuri video arcade; 
Este un joc de sport de tenis, care are o grafică simplă bidimensională.
În timp ce alte jocuri video arcade, cum ar fi Computer Space, au venit înainte, Pong a fost unul dintre primele jocuri video pentru a ajunge la popularitatea mainstream.
Scopul este de a învinge adversarul într-un joc de tenis de masă simulat câștigând un scor mai mare. 
Jocul a fost inițial produs de Atari Incorporated (Atari), care l-a lansat în 1972." Wikipedia


## Introducere: Conceptul și regulile jocului
 Scopul principal al jocului este obtinerea de 9 puncte acumulate de catre un jucator  in urma lovirii mingii de border-ul special din spatele paletei adversarului. Am incorporat 2 moduri diferite de joc : single player , multiplayer(2 jucatori). Tastele prin care se selecteaza modul de joc sunt butoanele de la tastatura "1" si "2".
## Multiplayer
 1.Se apasa pe butonul "2" de la tastatura.
 2. Dupa ce a aparut paleta in partea de sus a ecranului, prin apasarea tastei SPACE jocul poate incepe.
 3. Dupa ce un jucator inscrie scorul este actualizat pe afisazul cu 7 segmente , cifra de pe afisaj notata cu HEX0 corespunzand jucatorului numarul 1, iar cifra de pe afisaj notata cu HEX3 corespunde jucatorului cu numarul 2 si totodata in mod automat dupa fiecare punct inscris jocul intra in pauza si asteapta apasarea tastei space pentru a fi reluat.
 4. In orice moment se poate apasa pe tasta ESC pentru a se iesi din joc si a incepe un altul.
 
 ## SinglePlayer(VS computer)
 1.Se apasa pe butonul "1" de la tastatura sau se apasa direct pe tasta SPACE.
 2.Paleta apare automat in partea  de sus a ecranului, iar PLAYER2 va fi o simulare a inteligentei artificiale care incearca sa urmareasca deplasarea mingii si sa contracareze incercarile de a inscrie ale PLAYER1 .
 3. Dupa ce un jucator inscrie scorul este actualizat pe afisazul cu 7 segmente , cifra de pe afisaj notata cu HEX0 corespunzand jucatorului numarul 1, iar cifra de pe afisaj notata cu HEX3 corespunde jucatorului cu numarul 2 si totodata in mod automat dupa fiecare punct inscris jocul intra in pauza si asteapta apasarea tastei SPACE pentru a fi reluat.
 4. In orice moment se poate apasa pe tasta ESC pentru a se iesi din joc si a incepe un altul.
 
## Tastele folosite
  ## PLAYER1:
            A -> miscarea plaetei catre stanga
            D -> miscarea paletei catre dreapta
  
  ## PLAYER2:
            J -> miscarea plaetei catre stanga
            L -> miscarea paletei catre dreapta  
  
  ## Taste de control
              1 -> SinglePlayer (vs Computer)
              2 -> Multiplayer
              SPACE -> START/PAUSE
              ESC -> Exit current game 
<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/PongVideoGameCabinet.jpg/250px-PongVideoGameCabinet.jpg" />

## Top-level block diagram 
 Aceasta reprezinta schema interconectarii blocurilor

<blockquote class="imgur-embed-pub" lang="en" data-id="a/JHNMm"><a href="//imgur.com/JHNMm"></a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>

## Inputs: 

* clock
* reset
* ps2_data
* ps2_clock


## Outputs: 

* h_sync, 
* v_sync, 
* color  (primii 4 biti reprezinta culaorea rosu urmatorii 4 verde si ultimii patru albastru , acestia sunt legati la portul VGA)
* out_1 (reprezinta scorul PLAYER1 si e legat la HEX0 de pe afisajul cu 7 segmente)
* out_2 (reprezinta scorul PLAYER2 si e legat la HEX3 de pe afisajul cu 7 segmente)
* out_3 ( mereu high stinge segmentul HEX1)
* out_4 ( mereu high stinge segmentul HEX2)

## Module:

* clk_divider – divizor de ceas , primeste ca input un ceas de 50Mhz output un ceas de 25Mhz ( pentru rezolutie)
* keyboard –modul care se ocupa cu citirea datelor de la tastatura si verificarea corectitudinii acestora , totdata genereaza un semnal de done doar in momentul in care datele de la tastatura sunt diferite de F0 (break code)
* game _FSM – automatul care controleaza jocul efectiv si contine logica de joc, contine 6 stari din fiecare stare se poate reveni la starea de reset
* vga – modulul vga care asigura sincronizarea pentru ecranul monitorului si care transmite daca este in zona activa pozitia pe x si pe y  
* pong_top - modulul de top in care sunt instantiate si conectate toate aceste module

  
  