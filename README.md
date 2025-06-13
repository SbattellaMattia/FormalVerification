# Verifica formale di protocolli di autenticazione Diffie–Hellman
Progetto del corso di Sistemi Operativi Dedicati.
## Scopo del progetto

Come primo approccio all verifica formale, questo progetto ha l'obiettivo di analizzare formalmente la sicurezza del protocollo Diffie–Hellman, con particolare attenzione alla vulnerabilità Man-in-the-Middle (MITM). La verifica viene condotta mediante due approcci distinti:

- **SPIN / Promela**: per la modellazione esplicita dei processi concorrenti coinvolti (Alice, Bob, Intruder) e l’osservazione di possibili violazioni tramite `assert`.
- **Tamarin Prover**: per l’analisi simbolica di protocolli crittografici, la definizione di lemmi di sicurezza (autenticazione e segretezza) e la generazione di attacchi in presenza di un attaccante attivo.

---

## 🛠Strumenti utilizzati

- **SPIN**: model checker basato su logica temporale lineare (LTL), adatto per sistemi concorrenti.
- **Promela**: linguaggio di modellazione utilizzato con SPIN.
- **Tamarin Prover**: strumento per la verifica formale di protocolli crittografici, basato su logica del primo ordine e rewriting di multiset.
- **Tamarin GUI**: interfaccia grafica per visualizzare prove e attacchi simbolici.

---


## Risultati principali

- SPIN evidenzia la violazione dell’autenticazione tramite `assert`.
- Tamarin genera automaticamente un attacco MITM, mostrando la violazione di lemmi di autenticazione e segretezza in più sessioni.

---

## Autori
- Sbattella Mattia
- Coloccioni Jacopo

