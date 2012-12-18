# encoding: utf-8
namespace :db do
    desc "Fill database with sample data"
    task populate: :environment do

      [ Offer, EventType, CostItemType, Company, Client, Address, 
        Order, OrderItem, Training, Product, Seat, Segment, TrainingSegment,
        EventTypeTraining ].each(&:delete_all)

      # make_offers
      make_event_types_and_segments
      make_example_trainings
      # make_cost_item_types
      
      # make_events
      # make_participants
      # assign_participants_to_events

      # make_companies
      # make_clients
      # assign_client_to_companies
      # make_users
      # make_addresses_and_assign_to_customers
      # make_orders
      # make_trainings
      # make_order_items
      # make_products
      # make_products
      # assign_clients_to_order_items
      # assign_products_to_event_types


  end
end

def make_event_types_and_segments
  include Texts
  p2f  = EventType.new(name: "P2F")
  p2p  = EventType.new(name: "P2P")
  itil = EventType.new(name: "ITIL")

  p2f.description              = p2f_description
  p2f.default_price_per_person = 2600.00
  p2f.default_number_of_days   = 3

  p2p.description              = p2p_description
  p2p.default_price_per_person = 2200.00
  p2p.default_number_of_days   = 3

  itil.description              = itil_description
  itil.default_price_per_person = 1800.00
  itil.default_number_of_days   = 3

  p2f1 = Segment.new(name: "P2F Dzień 1", number_of_hours: 8, default_lineup: 1, scenario: p2f1_scenario)
  p2f2 = Segment.new(name: "P2F Dzień 2", number_of_hours: 8, default_lineup: 2, scenario: p2f2_scenario)
  p2f3 = Segment.new(name: "P2F Dzień 3", number_of_hours: 8, default_lineup: 3, scenario: p2f3_scenario)
  p2f4 = Segment.new(name: "P2F Egzamin", number_of_hours: 2, default_lineup: 4, scenario: p2f4_scenario)

  p2p1 = Segment.new(name: "P2P Dzień 1", number_of_hours: 8, default_lineup: 1, scenario: p2p1_scenario)
  p2p2 = Segment.new(name: "P2P Dzień 2", number_of_hours: 8, default_lineup: 2, scenario: p2p2_scenario)
  p2p3 = Segment.new(name: "P2P Egzamin", number_of_hours: 2, default_lineup: 3, scenario: p2p3_scenario)

  itil1 = Segment.new(name: "ITIL Dzień 1", number_of_hours: 8, default_lineup: 1, scenario: itil1_scenario)
  itil2 = Segment.new(name: "ITIL Dzień 2", number_of_hours: 8, default_lineup: 2, scenario: itil2_scenario)
  itil3 = Segment.new(name: "ITIL Dzień 3", number_of_hours: 8, default_lineup: 3, scenario: itil3_scenario)
  itil4 = Segment.new(name: "ITIL Egzamin", number_of_hours: 2, default_lineup: 4, scenario: itil4_scenario)

  p2f.segments  << [p2f1, p2f2, p2f3, p2f4]
  p2p.segments  << [p2p1, p2p2, p2p3]
  itil.segments << [itil1, itil2, itil3, itil4]

  [p2f1, p2f2, p2f3, p2f4, p2p1, p2p2, p2p3, itil1, itil2, itil3, itil4].each { |s| s.save! }

  [p2f,p2p,itil].each { |et| et.save! }  
end

def make_example_trainings
  p2f_n = Training.new
  p2f_n.craft!([EventType.find_by_name("P2F")])
  p2f_n.exemplary = true
  p2f_n.name         = p2f_n_example_name
  p2f_n.introduction = p2f_n_example_intro
  p2f_n.number_of_hours = 26
  p2f_n.number_of_days = 3
  p2f_n.save!

  p2p_n = Training.new
  p2p_n.craft!([EventType.find_by_name("P2P")])
  p2p_n.exemplary = true
  p2p_n.name         = p2p_n_example_name
  p2p_n.introduction = p2p_n_example_intro
  p2p_n.number_of_hours = 18
  p2p_n.number_of_days = 3
  p2p_n.save!

  p2f_w = Training.new
  p2f_w.craft!([EventType.find_by_name("P2F")])
  p2f_w.exemplary = true
  p2f_w.name         = p2f_w_example_name
  p2f_w.introduction = p2f_w_example_intro
  p2f_w.number_of_hours = 26
  p2f_w.number_of_days = 4
  p2f_w.save!

  p2p_w = Training.new
  p2p_w.craft!([EventType.find_by_name("P2P")])
  p2p_w.exemplary = true
  p2p_w.name         = p2p_w_example_name
  p2p_w.introduction = p2p_w_example_intro
  p2p_w.number_of_hours = 18
  p2p_w.number_of_days = 3
  p2p_w.save!

  prince_combo = Training.new
  prince_combo.craft!([EventType.find_by_name("P2F"), EventType.find_by_name("P2P")])
  prince_combo.exemplary = true
  prince_combo.name         = prince_combo_example_name
  prince_combo.introduction = prince_combo_example_intro
  prince_combo.number_of_hours = 26
  prince_combo.number_of_days = 5
  prince_combo.price_per_person = 3900

  prince_combo.training_segments.find_by_name("P2F Dzień 1").update_attributes(lineup: 1)
  prince_combo.training_segments.find_by_name("P2F Dzień 2").update_attributes(lineup: 2)
  prince_combo.training_segments.find_by_name("P2F Dzień 3").update_attributes(lineup: 3)
  prince_combo.training_segments.find_by_name("P2P Dzień 1").update_attributes(lineup: 4)
  prince_combo.training_segments.find_by_name("P2P Dzień 2").update_attributes(lineup: 5)
  prince_combo.training_segments.find_by_name("P2F Egzamin").update_attributes(lineup: 6)
  prince_combo.training_segments.find_by_name("P2P Egzamin").update_attributes(lineup: 7)

  prince_combo.save!

  itil = Training.new
  itil.craft!([EventType.find_by_name("ITIL")])
  itil.exemplary = true
  itil.name         = itil_example_name
  itil.introduction = itil_example_intro
  itil.number_of_hours = 26
  itil.number_of_days = 3
  itil.save!
end

def make_offers
  10.times do
    name = Faker::Company.name
    Offer.create!(name: name)
  end
end

def make_cost_item_types
  types = ["trener", "sala", "materiały", "egzamin", "podręczniki", "przerwy kawowe",
           "obiady", "dojazd trenera", "noclegi", "dodatkowe koszty", "budżet ryzyka"].each do |n|
    CostItemType.create!(name: n)
  end
end

def make_events
  5.times do
    name = Faker::Lorem.sentence(1)
    Event.create!(name: name, date: Date.today, event_type_id: rand(0..3), city: Event.new.cities[rand(0..4)], price_per_participant: 2000 )
  end
end

def make_participants
  10.times do
    name = Faker::Name.name
    email = Faker::Internet.email(name)
    Participant.create!(name: name, email: email)
  end
end

def assign_participants_to_events
  offset = 0
  Event.all.each do |event|
    Participant.limit(2).offset(offset).each do |part|
      part.register_for_event!(event)
    end
    offset += 2
  end  
end

def make_companies
  3.times do
    name = Faker::Company.name
    phone_1 = Faker::PhoneNumber.phone_number
    phone_2 = Faker::PhoneNumber.cell_phone
    Company.create!(name: name, nip: "123", regon: "456", phone_1: phone_1, phone_2: phone_2)
  end
end

def make_clients
  5.times do
    name = Faker::Name.name
    email = Faker::Internet.email(name)
    phone_1 = Faker::PhoneNumber.phone_number
    phone_2 = Faker::PhoneNumber.cell_phone
    Client.create!(name: name, email: email, phone_1: phone_1, phone_2: phone_2)
  end
end

def assign_client_to_companies
  Company.find(1).employees << Client.find(1)
  Company.find(2).employees << Client.find(2)
  Company.find(2).employees << Client.find(3)
  Client.find(3).company_primary_contact = true
end

def make_users
  2.times do
    name = Faker::Name.name
    email = Faker::Internet.email(name)
    User.create!(email: email)
  end
end

def make_addresses_and_assign_to_customers
  16.times do
    line_1    = Faker::Address.street_address
    city      = Faker::Address.city
    postcode  = Faker::Address.postcode
    country   = Faker::Address.country
    Address.create!(line_1: line_1, city: city, postcode: postcode, country: country)
  end

  Customer.all.each_with_index do |c,i|
    a=[0,0]
    a = case i
      when 0 then [1,2]
      else [i*2+1,i*2+2]
    end
    c.addresses << Address.find(a[0])
    c.addresses << Address.find(a[1])
  end
end


def make_trainings
  5.times do
    name = Faker::Lorem.sentence(1)
    Training.create!(name: name, start_date: Date.today, end_date: Date.tomorrow, training_type_id: 2, city: "Krakow", price_per_person: 2000 )
  end
end

def make_orders
  Customer.all.each do |c|
    c.orders.create!(:date_placed => Time.now, :status => "new")
  end
end

def make_order_items
  t1 = Training.find(1)
  t2 = Training.find(2)
  oi1 = Order.find(1).order_items.create!(quantity: 1)
  oi2 = Order.find(2).order_items.create!(quantity: 3)
  oi3 = Order.find(3).order_items.create!(quantity: 4)
  t1.order_items << oi1
  t2.order_items << oi2
  t2.order_items << oi3
end

def make_products
  Product.create!(name: "Prince Foundation Book", price: 300)
end

def assign_clients_to_order_items
  oi1 = Order.find(1).order_items.first
  oi2 = Order.find(2).order_items.first
  oi1.participants << Client.find(1)
  oi2.participants << Client.find(1)
  oi2.participants << Client.find(2)
  oi2.participants << Client.find(3)
end

def assign_products_to_event_types
  EventType.find_by_name("P2P").products << Product.find(1)
end


# -----------------------------------------------------------------------
module Texts
  def p2f_description
    '<h5>Opis szkolenia</h5><p>PRINCE2® Foundation wersja 2009 jest trwającym 3 dni szkoleniem akredytowanym przez APMG w Wielkiej Brytanii. Celem szkolenia jest poznanie metodyki zarządzania projektami PRINCE2® i przygotowanie się do egzaminu PRINCE2® Foundation. Szkolenie zakończone jest egzaminem, który odbywa się 3 dnia po szkoleniu lub w dniu czwartym; w przypadku pozytywnego wyniku egzaminu uczestnicy otrzymują międzynarodowy certyfikat PRINCE2® Foundation.</p><p>
    </p><p>Przed szkoleniem uczestnicy zaopatrywani są w materiały przygotowawcze, dzięki czemu mają okazję się z nimi wcześniej zapoznać. Wszystkie materiały, jak również szkolenie odbywa się w języku polskim.</p>
    <h5>Adresaci</h5>
    <p>Szkolenie skierowane jest do osób, które:</p>
    <ul>
    <li>są kierownikami projektów
    </li><li>są członkami zespołów projektowych
    </li><li>są menedżerami zaangażowanymi w proces wsparcia i nadzoru kierownika projektu
    </li><li>chcą podnieść swoje kwalifikacje w zakresie zarządzania projektami
    </li></ul>
    <h5>Korzyści</h5>
    <p>Po ukończeniu szkolenia uczestnik będzie:</p>
    <ul>
    <li>potrafił wykorzystać techniki i narzędzia stosowane w projektach realizowanych zgodnie z PRINCE2®
    </li><li>potrafił dobrać odpowiednie elementy metodyki PRINCE2® do określonych sytuacji w projekcie
    </li><li>efektywniej zarządzał ryzykiem zarówno biznesowym, jak i projektowym
    </li><li>potrafił kontrolować przebieg projektu
    </li></ul>
    <h5>W cenę szkolenia wliczono</h5>
    <ul>
    <li>catering (przerwy kawowe, obiad)</li>
    <li>materiały szkoleniowe (segregator z prezentacją omawianych zagadnień,  zestawy ćwiczeń)</li>
    <li>podręcznik "PRINCE2® 2009: Skuteczne Zarządzanie Projektami” – akredytowany podręcznik do metodyki PRINCE2®</li>
    <li>certyfikaty ukończenia szkolenia akredytowanego</li>
    <li>w wypadku zdania egzaminu - imienne certyfikaty wydawane przez APM Group zaświadczające o zdaniu egzaminu na poziomie PRINCE2® Foundation</li></ul>
    <p>Od 01.01.2011r. na usługi szkoleniowe został nałożony VAT w wysokości 23%. Cena szkolenia brutto wynosi: 3198 zł.</p>'
  end

  def p2p_description
    '<p><em>Uwaga Promocja!<br/>
    W cenie tego szkolenia wezmą Państwo bezpłatnie udział w egzaminie na poziomie Practitioner!</em></p>
    <h5>Opis szkolenia</h5>
    <p>Szkolenie PRINCE2® Practitioner wersja 2009 jest trwającym 2 dni szkoleniem akredytowanym przez APMG w Wielkiej Brytanii. Celem szkolenia jest poznanie metodyki zarządzania projektami PRINCE2® i przygotowanie się do egzaminu PRINCE2® Practitioner, który odbywa się 3 dnia.</p>
    <p>Szkolenie zakończone jest egzaminem; w przypadku pozytywnego wyniku egzaminu uczestnicy otrzymują międzynarodowy certyfikat PRINCE2® Practitioner.</p>
    <p>Przed szkoleniem uczestnicy zaopatrywani są w materiały przygotowawcze, dzięki czemu mają okazję się z nimi wcześniej zapoznać. Wszystkie materiały, jak również szkolenie odbywa się w języku polskim.</p>
    <p>Szkolenie dostępne jest tylko dla posiadaczy certyfikatu PRINCE2® Foundation.</p>
    <h5>Adresaci</h5>
    <p>Szkolenie skierowane jest do osób, które:</p>
    <ul>
    <li>są kierownikami projektów</li>
    <li>są członkami zespołów projektowych</li>
    <li>są menedżerami zaangażowanymi w proces wsparcia i nadzoru kierownika projektu</li>
    <li>chcą podnieść swoje kwalifikacje w zakresie zarządzania projektami</li>
    </ul>
    <h5>Korzyści</h5>
    <p>Po ukończeniu szkolenia uczestnik będzie:</p>
    <ul>
    <li>potrafił wykorzystać techniki i narzędzia stosowane w projektach realizowanych zgodnie z PRINCE2®</li>
    <li>potrafił dobrać odpowiednie elementy metodyki PRINCE2® do określonych sytuacji w projekcie</li>
    <li>efektywniej zarządzał ryzykiem zarówno biznesowym, jak i projektowym</li>
    <li>potrafił kontrolować przebieg projektu</li>
    </ul>
    <h5>W cenę szkolenia wliczono:</h5>
    <ul>
    <li>catering (przerwy kawowe, obiad)</li>
    <li>materiały szkoleniowe (segregator z prezentacją omawianych zagadnień, zestawy ćwiczeń)</li>
    <li>certyfikaty ukończenia szkolenia akredytowanego</li>
    <li>w wypadku zdania egzaminu - imienne certyfikaty wydawane przez APM Group zaświadczające o zdaniu egzaminu na poziomie PRINCE2® Practitioner</li>
    </ul>
    <p>Od 01.01.2011r. na usługi szkoleniowe został nałożony VAT w wysokości 23%. Cena szkolenia brutto wynosi: 2706 zł.</p>
    <p><em>Uwagi: PRINCE2® jest zarejestrowanym znakiem handlowym należącym do Cabinet Office.</em></p>'
  end

  def itil_description
    '<h5>Opis szkolenia</h5>
    <p>Uczestnicy uczą się zasad i podstawowych elementów charakterystycznych dla Zarządzania Cyklem Życia Usługi w Zarządzaniu Usługami IT według ITIL ®v3. W czasie kursu stosowane są: prezentacje, dyskusje, praktyczne symulacje przygotowujące uczestników do egzaminu ITIL® v3 Foundation (dodatkowo płatny 135 Euro netto).</p>
    <h5>Adresaci:</h5>
    <ul>
    <li>Menadżerowie IT, pracownicy IT i właściciele procesów,</li>
    <li>Menadżerowie aplikacji, projektu i komórek biznesowych - ukierunkowani na IT,</li>
    <li>Pracownicy organizacji IT dostarczającej jakiekolwiek usługi IT.</li>
    </ul>
    <h5>Główne cele:</h5>
    <ul>
    <li>Zrozumienie podstawowych procesów, relacji, korzyści i wyzwań w metodyce ITIL® v3,</li>
    <li>Wgląd w Cykl Życia Usługi (Service Lifecycle), na którym opiera się funkcjonowanie biblioteki ITIL® v3,</li>
    <li>Zrozumienie modelu procesowego, który wpływa na przekształcenie organizacji IT w dobrze zarządzaną komórkę,</li>
    <li>Poznanie podstawowych definicji z zakresu tematyki ITIL® v3,</li>
    <li>Zapoznanie ze standardowym słownictwem z zakresu ITIL® v3,</li>
    <li>Przygotowanie do certyfikowanego egzaminu ITIL® v3 Foundation.</li>
    </ul>
    <p>Kurs przygotowuje uczestników do egzaminu, który pozwala uzyskać certyfikat ITIL® v3 Foundation. Uczestnicy, którzy zdecydują się na opcję egzaminu są w pełni do tego przygotowani poprzez egzamin próbny oraz informację zwrotną przekazaną przez trenera. Egzamin składa się z 40 pytań.</p>
    <p>Jest to test wielokrotnego wyboru. Zdany egzamin uprawniający do odebrania certyfikatu oznacza prawidłowe odpowiedzi na 26 pytań.
    Na specjalne życzenie wydajemy certyfikat pozwalający zakwalifikować punkty PDUs w organizacji PMI.</p>
    <h5>Uwagi</h5>
    <p><em>Szkolenie jest realizowane we współpracy z 500Solutions posiadającą status ITIL® Accredited Training Provider - akredytacja nadana przez EXIN, jeden z instytutów egzaminacyjnych (Examination Institute) ITIL® licencjonowanych przez APM Group - oficjalnego akredytora ITIL®, uprawniająca do prowadzenia akredytowanych szkoleń ITIL®.</em></p>
    <p><em>ITIL® jest zarejestrowanym znakiem handlowym należącym do Cabinet Office.</em></p>'
  end

  def p2f1_scenario
    '<h5>—– Dzień Pierwszy —–</h5>
    Moduł 1 – Przegląd metodyki PRINCE2<br/>
    Moduł 2 – Temat Organizacja<br/>
    Moduł 3 – Proces Przygotowanie Projektu<br/>
    Moduł 4 – Temat Uzasadnienie Biznesowe<br/>
    Moduł 5 – Proces Inicjowanie Projektu Praca domowa<br/>'
  end

  def p2f2_scenario
    '<h5>—– Dzień Drugi —–</h5>
    Moduł 6 – Temat Plany<br/>
    Moduł 7 – Temat Jakość<br/>
    Moduł 8 – Temat Ryzyko<br/>
    Moduł 9 – Proces Zarządzanie Końcem Etapu<br/>
    Moduł 10 – Temat Postępy<br/>
    Praca domowa<br/>' 
  end

  def p2f3_scenario
    '<h5>—– Dzień Trzeci —–</h5>
    Moduł 11 – Proces Sterowanie Etapem<br/>
    Moduł 12 – Temat Zmiana<br/>
    Moduł 13 – Proces Zarządzanie Dostarczaniem Produktów<br/>
    Moduł 14 – Proces Zamykanie Projektu<br/>
    Moduł 15 – Proces Zarządzanie Strategiczne Projektem<br/>'   
  end

  def p2f4_scenario
    '<h5>—– Egzamin PRINCE2® Foundation —–</h5>
    Zapraszamy uczestników naszego szkolenia na Egzamin PRINCE2® Foundation, który daje możliwość uzyskania oficjalnego certyfikatu APM Group „PRINCE2® Foundation”.<br/>
    Egzamin organizowany jest w godzinach popołudniowych, ostatniego dnia szkolenia lub w dniu czwartym. Więcej informacji znajdą Państwo w harmonogramie.<br/>'   
  end

  def p2p1_scenario
    '<h5>—– Dzień 1 —–</h5>
    Organizacja szkolenia<br/>
    Zasady egzaminu PRINCE2® Practitioner<br/>
    Planowanie oparte na produktach<br/>
    Zapis Obiektu Konfiguracji<br/>
    Zarządzanie Konfiguracją<br/>
    Próbny egzamin PRINCE2® Practitioner nr 1<br/>
    Sprawdzenie wyników i omówienie watpliwości<br/>'   
  end

  def p2p2_scenario
    '<h5>—– Dzień 2 —–</h5>
    Omówienie rozwiązań pracy domowej<br/>
    Zawężenie Zakresu Projektu<br/>
    Konsolidacja Postępów<br/>
    Analiza Ryzyka<br/>
    Przedwczesne Zamykanie Projektu<br/>
    Próbny egzamin PRINCE2® Practitioner nr 2<br/>
    Sprawdzenie wyników i omówienie watpliwości<br/>'   
  end

  def p2p3_scenario
    '<h5>—– Egzamin PRINCE2® Practitioner —–</h5>
    Zapraszamy uczestników naszego szkolenia na Egzamin PRINCE2® Practitioner, który daje możliwość uzyskania oficjalnego certyfikatu APM Group „PRINCE2® Practitioner”. Egzamin organizowany jest trzeciego dnia. Więcej informacji znajdą Państwo w harmonogramie.'   
  end

  def itil1_scenario
    '<h5>—– Dzień 1 —–</h5>
    Wprowadzenie do ITIL® i najlepszych praktyk.<br/>
    Cykl Życia Usługi, Eksploatacja Usług (m.in. Zarządzanie Incydentami i Service Desk). 3. Przekazanie Usług (m.in. Zarządzanie Zmianą).<br/>'   
  end

  def itil2_scenario
    '<h5>—– Dzień 2 —–</h5>
    Strategia Usług (m.in. 4 główne składniki strategii.<br/>
    Portfel Usług i Katalog Usług).<br/>
    Projektowanie Usług (m.in. Pakiet Projektowania Usług, Zarządzanie Poziomem Usług i 4P: Ludzie (People), Procesy (Processes), Produkty (Products), Partners<br/>'   
  end

  def itil3_scenario
    '<h5>—– Dzień 3 —–</h5>
    Ustawiczne Doskonalenie Usług (m.in. 7-stopniowy proces doskonalenia).<br/>
    Cykl Deminga i Model Ustawicznego Doskonalenia Usług).<br/>
    Próbny Egzamin.<br/>'   
  end

  def itil4_scenario
    '<h5>—– Egzamin ITIL® v3 Foundation (opcjonalnie 3 dnia) —–</h5>
    Kurs przygotowuje uczestników do egzaminu, który pozwala uzyskać certyfikat ITIL® v3 Foundation (egzamin opcjonalny - 135 EUR netto). Uczestnicy, którzy zdecydują się na opcję egzaminu są w pełni do tego przygotowani poprzez egzamin próbny oraz informację zwrotną przekazaną przez trenera. Egzamin składa się z 40 pytań. Jest to test wielokrotnego wyboru. Zdany egzamin uprawniający do odebrania certyfikatu oznacza prawidłowe odpowiedzi na 26 pytań.<br/>'   
  end

  def p2f_n_example_name
    'PRINCE2 ® Foundation szkolenie akredytowane + Egzamin Gratis'
  end

  def p2f_n_example_intro
    'PRINCE2® Foundation wersja 2009 jest trwającym 3 dni szkoleniem akredytowanym przez APMG w Wielkiej Brytanii. Celem szkolenia jest poznanie metodyki zarządzania projektami PRINCE2® i przygotowanie się do egzaminu PRINCE2® Foundation.<br/>
     <small><em>* Zastrzegamy prawo do anulowania termnu w przypadku niskiego zainteresowania.</em></small>'
  end

  def p2p_n_example_name
    'PRINCE2 ® Practitioner szkolenie akredytowane + Egzamin Gratis'
  end

  def p2p_n_example_intro
    'Szkolenie PRINCE2 ® Practitioner wersja 2009 jest trwającym 2 dni szkoleniem akredytowanym przez APMG w Wielkiej Brytanii. Celem szkolenia jest poznanie metodyki zarządzania projektami PRINCE2® i przygotowanie się do egzaminu PRINCE2® Practitioner, który odbywa się 3 dnia.'
  end

  def p2f_w_example_name
    'PRINCE2 ® Foundation szkolenie akredytowane + Egzamin Gratis - edycja weekendowa'
  end

  def p2f_w_example_intro
    'PRINCE2 ® Foundation - edycja weekendowa jest trwającym przez 3 dni (dwa następujące po sobie weekendy) szkoleniem akredytowanym przez APMG w Wielkiej Brytanii. Celem szkolenia jest poznanie metodyki zarządzania projektami PRINCE2® i przygotowanie się do egzaminu PRINCE2® Foundation.'
  end

  def p2p_w_example_name
    'PRINCE2 ® Practitioner szkolenie akredytowane + Egzamin Gratis - edycja weekendowa'
  end

  def p2p_w_example_intro
    'Szkolenie PRINCE2 ® Practitioner wersja 2009 jest trwającym 2 dni szkoleniem akredytowanym przez APMG w Wielkiej Brytanii. Celem szkolenia jest poznanie metodyki zarządzania projektami PRINCE2® i przygotowanie się do egzaminu PRINCE2® Practitioner, który odbywa się 3 dnia.'
  end

  def prince_combo_example_name
    'Kurs łączony PRINCE2 ® Foundation i PRINCE2 ® Practitioner - szkolenie akredytowane + Egzaminy Gratis'
  end

  def prince_combo_example_intro
    'Kurs łaczony PRINCE2® Foundation i PRINCE2® wersja 2009 jest trwającym 5 dni szkoleniem akredytowanym przez APMG w Wielkiej Brytanii. Celem szkolenia jest poznanie metodyki zarządzania projektami PRINCE2® i przygotowanie się do egzaminów PRINCE2® Foundation i PRINCE2® Practitioner.
     <small><em>* Zastrzegamy prawo do anulowania termnu w przypadku niskiego zainteresowania.</small></em>'
  end

  def itil_example_name
    'ITIL ® v3 z opcją egzaminu'
  end

  def itil_example_intro
    'ITIL ® v3 (wersja 3) Foundation jest najnowszym, podstawowym kursem certyfikującym w Zarządzaniu Usługami IT (ITSM). Jest podsumowaniem najlepszych praktyk ITIL® z perspektywy Cyklu Życia Usługi (Service Lifecycle). Szkolenie przedstawia zasady i podstawowe elementy procesowego Zarządzania Usługami (ITSM) bazujące na bibliotece ITIL® v3.
     <br/>Po szkoleniu istnieje możliwość zdania egzaminu z poziomu Foundation (płatny dodatkowo 135 Euro netto)'
  end

end


# def make_users
#   admin = User.create!(name: "Example User",
#                email: "example@railstutorial.org",
#                password: "foobar",
#                password_confirmation: "foobar")

#   admin.toggle!(:admin)
  
#   99.times do |n|
#     name  = Faker::Name.name
#     email = "example-#{n+1}@railstutorial.org"
#     password  = "password"
#     User.create!(name: name,
#                  email: email,
#                  password: password,
#                  password_confirmation: password)
#   end
# end

# def make_microposts
#   users = User.all(limit: 6)

#   50.times do
#     content = Faker::Lorem.sentence(5)
#     users.each { |u| u.microposts.create!(content: content) }
#   end
# end

# def make_relationships
#   users = User.all
#   user = users.first
#   followed_users  = users[2..50]
#   followers       = users[3..40]
#   followed_users.each { |followed| user.follow!(followed) }
#   followers.each      { |follower| follower.follow!(user)  }  
# end
