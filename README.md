# BankenSystem – SQL Server Datenbankprojekt

## 📌 Projektbeschreibung

Dieses Projekt stellt die Entwicklung eines relationalen Datenbanksystems für ein Bankszenario dar.
Ziel war es, eine strukturierte und skalierbare Datenbanklösung zur Verwaltung von Kunden, Krediten und Rückzahlungen zu erstellen.

Die Implementierung erfolgte in Microsoft SQL Server unter Verwendung von SQL-Skripten, Stored Procedures, Views und Triggern.
Zusätzlich wurde ein Frontend in Microsoft Access zur Visualisierung und Interaktion mit den Daten entwickelt.

---

## 🧩 Technologien

* Microsoft SQL Server
* Transact-SQL (T-SQL)
* Microsoft Access (Frontend)
* Relationale Datenbankmodellierung

---

## 🗂️ Projektstruktur

```
/schema
    create_database.sql
    create_tables.sql
    create_indexes.sql
    create_foreign_keys.sql
    create_constraints.sql

/views
    view_payment_info.sql
    view_credit_summary.sql
    view_customer_credits.sql
    view_management_report.sql

/functions
    fn_calculate_interest.sql
    fn_calculate_principal.sql
    fn_management_report.sql

/procedures
    sp_record_payment.sql
    sp_special_repayment.sql

/triggers
    trg_update_balance.sql
    trg_update_status.sql

/security
    create_logins_users_roles.sql

/backup
    sp_backup_database.sql

/tests
    test_extra_payment.sql
    test_insert_payment.sql
    test_scalar_functions.sql
    test_update_loan_balance_trigger.sql

/frontend
    BankenSystem.accdb
```

---

## ⚙️ Funktionalitäten

* Erstellung und Verwaltung einer relationalen Datenbankstruktur
* Verwaltung von Kunden, Krediten und Rückzahlungen
* Automatische Berechnung von Zins- und Tilgungsanteilen
* Nutzung von Views für Reporting und Analyse
* Automatisierte Logik durch Trigger
* Durchführung von Sondertilgungen
* Backup-Funktion für die Datenbank
* Frontend zur Dateneingabe und Visualisierung

---

## 👥 Projektkontext

Dieses Projekt wurde im Rahmen einer Gruppenarbeit entwickelt.

Ich war hauptsächlich verantwortlich für:

* Entwurf und Implementierung der Datenbankschemata (Tabellenstruktur)
* Erstellung und Befüllung eines Teils der Tabellen
* Entwicklung mehrerer Views für Analyse und Reporting
* Eigenständige Erstellung von SQL-Skripten im Bereich Schema
* Entwicklung eines Frontends in Microsoft Access zur Interaktion mit der Datenbank

---

## 🚀 Ausführung

1. Datenbank erstellen (`create_database.sql`)
2. Tabellen erstellen (`create_tables.sql`)
3. Indizes und Constraints hinzufügen
4. Views, Funktionen und Prozeduren ausführen
5. Optional: Testskripte ausführen
6. Frontend (`.accdb`) mit der Datenbank verbinden

---

## 📊 Ziel des Projekts

Das Ziel des Projekts war es, praktische Kenntnisse in folgenden Bereichen zu vertiefen:

* Datenbankdesign
* SQL-Programmierung
* Datenanalyse mit Views
* Automatisierung von Geschäftslogik
* Integration eines einfachen Frontends

---

## 📎 Hinweise

Dieses Projekt dient zu Demonstrationszwecken im Rahmen eines Portfolios und zeigt praktische Fähigkeiten im Umgang mit SQL Server und Datenbanksystemen.
