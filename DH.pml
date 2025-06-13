/* Parametri globali */
#define P   23      /* modulo primo */
#define G   5       /* generatore */

/* Esponenziazione modulare */
inline modexp(base, exp) {
    int _i; int _res;
    _res = 1; _i = 0;
    do
    :: (_i < exp) ->
         _res = (_res * base) % P;
         _i++;
    :: else -> break
    od;
    return _res;
}

/* Canali di comunicazione */
chan A_to_I = [1] of { int };  /* Alice → Intruder */
chan I_to_B = [1] of { int };  /* Intruder → Bob */
chan B_to_I = [1] of { int };  /* Bob → Intruder */
chan I_to_A = [1] of { int };  /* Intruder → Alice */

/* Chiavi e flag */
int keyA_A, keyA_I;    /* chiave Alice vs Intruso */
int keyB_B, keyB_I;    /* chiave Bob   vs Intruso */
bool doneA=false, doneB=false, doneI=false;

/* Processo Alice */
proctype Alice() {
    int a = 6, GA, recv;
    GA = modexp(G, a);
    printf("Alice: invio g^a mod p = %d", GA);
    A_to_I ! GA;                 /* Fase 1 */

    I_to_A ? recv;               /* Fase 4: riceve GI = g^c mod(p)*/
    printf("Alice: ricevuto g^c = %d", recv);

    keyA_A = modexp(recv, a);    /* calcola (g^c)^a mod(p)*/
    printf("Alice: keyA_A = %d", keyA_A);

    doneA = true;
}

/* Processo Bob */
proctype Bob() {
    int b = 15, GB, recv;
    I_to_B ? recv;               /* Fase 2: riceve g^c mod(p)*/
    printf("Bob: ricevuto g^c = %d", recv);

    GB = modexp(G, b);
    printf("Bob: invio g^b mod p = %d", GB);
    B_to_I ! GB;                 /* Fase 3 */

    keyB_B = modexp(recv, b);    /* calcola (g^c)^b mod(p)*/
    printf("Bob: keyB_B = %d", keyB_B);

    doneB = true;
}

/* Processo Intruder */
proctype Intruder() {
    int c = 13, x;

    /* Step 1: MITM su Alice */
    A_to_I ? x;                      /* intercetta g^a mod(p)*/
    printf("Intruso: intercettato g^a = %d", x);
    keyA_I = modexp(x, c);           /* (g^a)^c mod(p)*/
    printf("Intruso: keyA_I = ", keyA_I);

    x = modexp(G, c);                /* g^c mod(p)*/
    printf("Intruso: invio g^c = %d a Bob", x);
    I_to_B ! x;

    /* --- Step 2: MITM su Bob→Alice --- */
    B_to_I ? x;                      /* intercetta g^b mod(p)*/
    printf("Intruso: intercettato g^b = %d", x);
    keyB_I = modexp(x, c);           /* (g^b)^c mod(p)*/
    printf("Intruso: keyB_I = %d", keyB_I);

    x = modexp(G, c);                /* g^c mod(p)*/
    printf("Intruso: invio g^c = %d ad Alice", x);
    I_to_A ! x;

    doneI = true;
}

/* init e verifica */
init {
    run Alice();
    run Bob();
    run Intruder();

    do
    :: (doneA && doneB && doneI) ->
        printf("Verifica chiavi...");
        /* Intruso vs Alice */
        assert(keyA_I == keyA_A);
        /* Intruso vs Bob */
        assert(keyB_I == keyB_B);
        /* Alice vs Bob */
        assert(keyA_A == keyB_B);    /* conferma MITM */
        break
    od
}
