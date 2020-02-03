# Assignment-3-PHP
Assingment 3 in PHP Course 

# Assignment description
Ni ska bygga en bankapplikation. Applikationen ska byggas med PHP, MySQL och lite JavaScript (för Ajax-delarna).

# G-krav
- [ ] Systemet ska ha stöd för olika användare, säg 5-10 stycken. Ni behöver dock inte göra någon inloggning utan när man går in på sidan kan ni se till att ni redan är inloggade som en av era användare, typ som att ni har gått igenom en inloggning. Ni får lov att spara den aktuella användaren i en session eller liknande om det underlättar.
- [x] Varje användare ska ha ett konto med en egen balans. Konton och användare ska ligga i olika tabeller i databasen. Ett konto får inte ha negativ balans, dvs saldot måste alltid vara minst 0.
- [ ] Er inloggade användare ska kunna föra över pengar från sitt konto till en annan användares konto. Anävndartabellen behöver ha det data ni behöver för att kunna göra en överföring, t ex kontonummer, mobilnr (om ni har tänkt göra en Swish-överföring) eller liknande.
- [ ] En överföring måste felkontrolleras, t ex att mottagaren finns, att det finns tillräckligt med pengar på avsändarens konto osv.
- [ ] Om ett fel uppstår (t ex att det saknas pengar) ska ni kasta ett exception. Ni måste också kunna hantera exceptions med en try ... catch så att skriptet inte dör.
- [x] Ni behöver inte visa upp ett kontoutdrag eller liknande på sidan, men i databasen ska man kunna se alla transaktioner som involverar ett visst konto, t ex att Kalle har fått x kr från Olle vid tidpunkten y eller skickat pengar till Lisa vid tidpunkten z. Det som måste finnas på varje rad är alltså sändarens kontonr, mottagarens kontonr, tidpunkt, belopp och ev valuta.
- [x] Allt som rör databasen (främst överföringar, tänker jag då) ska ske med hjälp av API-anrop och PDO.
- [ ] Ni ska visa att ni kan använda AJAX, t ex genom att hämta en mottagarlista med AJAX, göra API-anropet som hanterar en överföring eller liknande.
- [ ] Ni ska visa att ni kan använda dependency injection. Om ni t ex behöver ett databasobjekt för att hämta användare eller skapa en överföring så får det inte finnas dependencies i klassen utan det måste lösas genom att man t ex skickar med databasobjektet till konstruktorn. Typ:

    public function __construct(Database $db) {
      // ...
    }

- [ ] Ni får inte heller låta en userklass ärva från en databasklass eller liknande. Arv ska användas för klasser som liknar varandra, inte för beroenden.

# VG-krav

- [ ] Klassen som hanterar överföringar ska ta emot ett typehintat interface i konstruktorn för olika betalningslösningar och låta minst två klasser implementera interfacet (t ex swish, banköverföring, betalkort). 

    Exempel:

    public function __construct(Database $db) {
      // ...
    }

- [ ] Tips: En klass kan både implementera ett interface och ärva från en basklass: https://stackoverflow.com/questions/652157/can-a-class-extend-both-a-class-and-implement-an-interface

- [ ] Konton ska ha en viss valuta och överföringar ska kunna ske mellan konton i olika valutor. Om Kalle använder SEK i sitt konto och Olle använder USD ska en överföring visa t ex -89,68 (SEK) på Kalles konto och +10 (USD) på Olles För att det ska fungera måste ni på PHP-sidan hämta valutakurser från exempelvis det API vi använde häromdagen: https://exchangeratesapi.io/ 

Redovisning sker dels muntligt nästa fredag, dels genom att skicka in en zippad mapp med ert projekt och er exporterade databas. (Vi kan kolla på i nästa vecka hur man exporterar en databas om det finns intresse för det.) Er databas ska heta bank och man ska kunna logga in på databaser med hjälp av uppgifter i en .env-fil. (Så jag slipper skapa 30 olika databaser eller byta lösenord mellan varje student.)