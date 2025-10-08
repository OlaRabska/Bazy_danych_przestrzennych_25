--1. Utwórz now¹ bazê danych nazywaj¹c j¹ firma. 
	create database firma
	use firma
--2. Dodaj schemat o nazwie ksiegowosc.  
	create schema ksiegowoœæ

--3. Dodaj cztery tabele: 
--• pracownicy (id_pracownika, imie, nazwisko, adres, telefon)  
--• godziny (id_godziny, data, liczba_godzin , id_pracownika)  
--• pensja (id_pensji, stanowisko, kwota)  
--• premia (id_premii, rodzaj, kwota)  
--• wynagrodzenie ( id_wynagrodzenia, data, id_pracownika, id_godziny, id_pensji, id_premii) 
--przyjmuj¹c nastêpuj¹ce za³o¿enia: 
--i. typy atrybutów maj¹ zostaæ dobrane tak, aby sk³adowanie danych by³o optymalne, 
--ii. klucz g³ówny dla ka¿dej tabeli oraz klucze obce tam, gdzie wystêpuj¹ powi¹zania pomiêdzy tabelami,  
--iii. opisy/komentarze dla ka¿dej tabeli – u¿yj polecenia COMMENT 

	--BRAK POLECENIA COMMENT W SQL SERVER

	create table pracownicy (
		id_pracownika int primary key,
		imie nvarchar(50) not null,
		nazwisko nvarchar(50) not null,
		adres nvarchar(100),
		telefon nvarchar(15)); 
		--tabela zawieraj¹ca dane o pracownikach
	
	create table godziny (
		id_godziny int primary key,
		data date not null,
		liczba_godzin decimal(5,2) not null,
		id_pracownika int not null,
		foreign key (id_pracownika) references pracownicy(id_pracownika)) 
		--tabela zawieraj¹ca informacje o przepracowanych godzinach przez danego pracownika

	create table pensja (
		id_pensji int primary key,
		stanowisko nvarchar(50) not null,
		kwota decimal(10,2) not null) 
		--tabela zawieraj¹ca informacje o pensji na danym stanowisku

	create table premia (
		id_premii int primary key,
		rodzaj nvarchar(50),
		kwota decimal(10,2)) 
		--tabela zawieraj¹ca informacje o rodzaju i wysokoœci premii

	create table wynagrodzenie (
		id_wynagrodzenia int primary key,
		data date not null,
		id_pracownika int not null,
		id_godziny int not null,
		id_pensji int not null,
		id_premii int not null,
		foreign key (id_pracownika) references pracownicy(id_pracownika),
		foreign key (id_godziny) references godziny(id_godziny),
		foreign key (id_pensji) references pensja(id_pensji),
		foreign key (id_premii) references premia(id_premii)) 
		--tabela zawieraj¹ca informacje o ca³kowitym wynagrodzeniu pracownika
			   
--4. Wype³nij ka¿d¹ tabelê 10. rekordami.
	insert into pracownicy values
	(1, 'Jan', 'Nowak', 'ul. Kwiatowa 1', '303499234'),
	(2, 'Katarzyna', 'Wójcik', 'ul. Jesionowa 36', '473555098'),
	(3, 'Tomasz', 'Kamiñski', 'ul. Grabowa 117', '123654789'),
	(4, 'Magdalena', 'Nowicka', 'ul. Modrzewiowa 38', '344765585'),
	(5, 'Jadwiga', 'Nowakowska', 'ul. Malinowa 210', '999333444'),
	(6, 'Micha³', 'Szymañski', 'ul. Ró¿ana 11', '546222746'),
	(7, 'Patrycja', 'B¹k', 'ul. Œwierkowa 43', '344245654'),
	(8, '£ukasz', 'Lis', 'ul. Lawendowa 22', '235987045'),
	(9, 'Dorota', 'Witkowska', 'ul. Polna 24', '235436776'),
	(10, 'Monika', 'Baran', 'ul. Parkowa 28', '233454777')

	insert into godziny values
	(11, '2020-07-01', 175, 1),
	(12, '2020-07-01', 166, 2),
	(13, '2020-07-01', 159, 3),
	(14, '2020-07-01', 180, 4),
	(15, '2020-07-01', 155, 5),
	(16, '2020-07-01', 172, 6),
	(17, '2020-07-01', 157, 7),
	(18, '2020-07-01', 155, 8),
	(19, '2020-07-01', 164, 9),
	(20, '2020-07-01', 180, 10)

	insert into pensja values
	(21, 'Kierownik', 5000),
	(22, 'Specjalista', 3200),
	(23, 'Asystent', 1100),
	(24, 'Ksiêgowy', 3800),
	(25, 'Sprzedawca', 2400),
	(26, 'Asystent', 1100),
	(27, 'Sekretarka', 2300),
	(28, 'Programista', 4500),
	(29, 'Kierownik', 4000),
	(30, 'Sprzedawca', 1700)
	
	insert into premia values
	(111, 'Za wyniki', 500),
	(112,'brak', 0),
	(113, 'Za frekwencjê', 250),
	(114, 'brak', 0),
	(115, 'Okolicznoœciowa', 300),
	(116, 'Roczna', 600),
	(117, 'Brak', 0),
	(118, 'Motywacyjna', 350),
	(119, 'Okolicznoœciowa', 300),
	(120, 'Roczna', 600)

	insert into wynagrodzenie values
	(110, '2020-07-30', 1, 11, 21, 111),
	(222, '2020-07-30', 2, 12, 22, 112),
	(333, '2020-07-30', 3, 13, 23, 113),
	(444,'2020-07-30', 4, 14, 24, 114),
	(555, '2020-07-30', 5, 15, 25, 115),
	(666, '2020-07-30', 6, 16, 26, 116),
	(777, '2020-07-30', 7, 17, 27, 117),
	(888, '2020-07-30', 8, 18, 28, 118),
	(999, '2020-07-30', 9, 19, 29, 119),
	(1000, '2020-07-30', 10, 20, 30, 120)

--5. Wykonaj nastêpuj¹ce zapytania: 
--a) Wyœwietl tylko id pracownika oraz jego nazwisko. 
	select id_pracownika, nazwisko from pracownicy

--b) Wyœwietl id pracowników, których p³aca jest wiêksza ni¿ 1000.
	select w.id_pracownika from wynagrodzenie w join pensja p on w.id_pensji = p.id_pensji where p.kwota > 1000
	
--c) Wyœwietl id pracowników nieposiadaj¹cych premii, których p³aca jest wiêksza ni¿ 2000.  
	select w.id_pracownika from wynagrodzenie w join pensja p on w.id_pensji = p.id_pensji join premia pr on w.id_premii = pr.id_premii 
	where p.kwota > 2000 and pr.kwota = 0

--d) Wyœwietl pracowników, których pierwsza litera imienia zaczyna siê na literê ‘J’.  
	select * from pracownicy where imie like '[J]%'
	
--e) Wyœwietl pracowników, których nazwisko zawiera literê ‘n’ oraz imiê koñczy siê na literê ‘a’.  
	select * from pracownicy where nazwisko like '%n%' and imie like '%a'

--f) Wyœwietl imiê i nazwisko pracowników oraz liczbê ich nadgodzin, przyjmuj¹c, i¿ standardowy czas pracy to 160 h miesiêcznie. 
	select p.imie, p.nazwisko, g.liczba_godzin -160 as 'liczba nadgodzin' from pracownicy p join godziny g on p.id_pracownika = g.id_pracownika  

--g) Wyœwietl imiê i nazwisko pracowników, których pensja zawiera siê w przedziale 1500 – 3000 PLN.  
	select p.imie, p.nazwisko from pracownicy p join wynagrodzenie w on w.id_pracownika = p.id_pracownika join pensja pe on pe.id_pensji = w.id_pensji 
	where pe.kwota between 1500 and 3000

--h) Wyœwietl imiê i nazwisko pracowników, którzy pracowali w nadgodzinach i nie otrzymali premii.  
	select p.imie, p.nazwisko from pracownicy p join wynagrodzenie w on p.id_pracownika = w.id_pracownika join godziny g on g.id_godziny = w.id_godziny 
	join premia pr on w.id_premii = pr.id_premii where g.liczba_godzin > 160 and pr.kwota = 0

--i) Uszereguj pracowników wed³ug pensji. 
	select p.imie, p.nazwisko, pe.kwota from pracownicy p join wynagrodzenie w on w.id_pracownika = p.id_pracownika join pensja pe on
	pe.id_pensji = w.id_pensji order by pe.kwota

--j) Uszereguj pracowników wed³ug pensji i premii malej¹co.  
	select p.imie, p.nazwisko, pe.kwota as pensja, pr.kwota as premia from pracownicy p join wynagrodzenie w on w.id_pracownika = p.id_pracownika join pensja pe on
	pe.id_pensji = w.id_pensji join premia pr on pr.id_premii = w.id_premii order by pe.kwota desc, pr.kwota desc

--k) Zlicz i pogrupuj pracowników wed³ug pola ‘stanowisko’.  
	select pe.stanowisko, count(*) as 'liczba pracowników' from wynagrodzenie w join pensja pe on pe.id_pensji = w.id_pensji group by pe.stanowisko

--l) Policz œredni¹, minimaln¹ i maksymaln¹ p³acê dla stanowiska ‘kierownik’ (je¿eli takiego nie masz, to przyjmij dowolne inne).  
	select avg(pe.kwota) as 'œrednia p³aca', MIN(pe.kwota) as 'minimalna p³aca', max(pe.kwota) as 'maksymalna p³aca' from wynagrodzenie w 
	join pensja pe on pe.id_pensji = w.id_pensji where pe.stanowisko = 'kierownik'

--m) Policz sumê wszystkich wynagrodzeñ.  
	select sum(pe.kwota + pr.kwota) as 'suma wynagrodzeñ' from wynagrodzenie w join pensja pe on w.id_pensji = pe.id_pensji join premia pr 
	on w.id_premii = pr.id_premii 

--f) Policz sumê wynagrodzeñ w ramach danego stanowiska.  
	select pe.stanowisko, sum(pe.kwota + pr.kwota) as 'suma wynagrodzeñ w ramach danego stanowiska' from wynagrodzenie w join pensja pe on 
	pe.id_pensji = w.id_pensji join premia pr on w.id_premii = pr.id_premii group by pe.stanowisko

--g) Wyznacz liczbê premii przyznanych dla pracowników danego stanowiska.  
	select pe.stanowisko, COUNT(w.id_premii) as 'suma premii przyznanych dla pracowników danego stanowiska' from wynagrodzenie w join pensja pe 
	on pe.id_pensji = w.id_pensji join premia pr on w.id_premii = pr.id_premii where pr.kwota > 0 group by pe.stanowisko 
		--stanowiska bez premii nie s¹ wyœwietlane

	select pe.stanowisko, COUNT(case when pr.kwota > 0 then 1 end) as 'suma premii przyznanych dla pracowników danego stanowiska' from wynagrodzenie w join pensja pe 
	on pe.id_pensji = w.id_pensji join premia pr on w.id_premii = pr.id_premii group by pe.stanowisko 

--h) Usuñ wszystkich pracowników maj¹cych pensjê mniejsz¹ ni¿ 1200 z³.
	delete w from wynagrodzenie w join pensja pe on w.id_pensji = pe.id_pensji where pe.kwota < 1200

	delete g from godziny g where g.id_pracownika not in (select id_pracownika from wynagrodzenie);

	delete p from pracownicy p where p.id_pracownika not in (select id_pracownika from wynagrodzenie);



