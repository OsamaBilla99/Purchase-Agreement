// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract PurchaseAgreement {
    // Denne variablen holder verdien av produktet til salgs
    uint public value;

    // address er en type i solidity, "payable" gir tilgang til funksjoner for å utføre transaksjoner
    address payable public seller;
    address payable public buyer;

    // lager egendefinert type, hensikten er å lage en variabel ut av denne
    // for å holde kontraktens tilstand
    // Noen funksjoner kan kun kjøres når applikasjonen er i en viss state
    enum State { Created, Locked, Release, Inactive }
    State public state;

    // constructor funksjoner tilkalles kun en gang når kontrakten blir deployed
    // msg er en global variabel som inneholder attributter til brukeren som kaller på funksjonen
    constructor() payable {
        seller = payable(msg.sender);
        value = msg.value / 2;
    }


    // trippel "/" er syntax for å spesifisere error message til custom error
    /// The function cannot be called at the current state
    error InvalidState();
    /// Only the buyer can call this function
    error OnlyBuyer();
    /// Only the seller can call this function
    error OnlySeller();

    // modifiers brukes for å sjekke at visse conditions er tilfredsstilt, hovedsaklig før funksjonen blir kjørt
    // modifiers kan endre en funksjons oppførsel
    // nyttig pga kan gjenbrukes
    modifier inState(State state_) {
        if(state != state_) {
            revert InvalidState();
        }

        _;
    }

    modifier onlyBuyer() {
        if (msg.sender != buyer) {
            revert OnlyBuyer();
        }

        _;
    }

    modifier onlySeller() {
        if (msg.sender != seller) {
            revert OnlySeller();
        }

        _;
    }

    // external funksjoner kan bli tilkalt av personer utenfor programmet (kunder)
    // i dette tilfellet vil msg.sender bli adressen til personen som tilkalte denne funksjonen (kunden)
    function confirmPurchase() external inState(State.Created) payable {
        require(msg.value == (2 * value), "Please send in 2x the purchase amount");
        buyer = payable(msg.sender);

        state = State.Locked;
    }

    // Hvis state er riktig -> Endrer state og sender depositum til buyer
    function confirmReceived() external onlyBuyer inState(State.Locked) {
        state = State.Release;
        buyer.transfer(value);

    }

    // Hvis state er riktig -> Endrer state og sender depositum + salgspris til selger
    function paySeller() external onlySeller inState(State.Release) {
        state = State.Inactive;

        seller.transfer(3 * value);
    }

    // Hvis state er riktig -> Endrer state og sender tilbake depositum til selger
    function abort() external onlySeller inState(State.Created) {
        state = State.Inactive;

        seller.transfer(address(this).balance);
    }

}