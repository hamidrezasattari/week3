// [bonus] implement an example game from part d
pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/poseidon.circom";

/*
https://www.youtube.com/watch?v=A8cPn60OvNE
"Guess which hand" is a very simple game, has two player
A player hide and object in one hand (hide it from other player),
And other player has one time chance to guess which hand it is it
*/

template Bonus() {
    signal input pubGuessA;
    signal input pubGuessB;
    // Private inputs
    signal input privSolnA;
    signal input privSolnB;
    signal input privSalt;
    signal input pubSolnHash;

    // Output
    signal output solnHashOut;

    var guess[2] = [pubGuessA, pubGuessB];
    var soln[2] =  [privSolnA, privSolnB];
    var j = 0;
    var k = 0;
    component lessThan[4];
    component equalGuess[4];
    component equalSoln[4];
    var equalIdx = 0;


    // Create a constraint that the solution and guess digits are all less than 2 ( 1 or 0).
    for (j=0; j<2; j++) {
        lessThan[j] = LessThan(2);
        lessThan[j].in[0] <== guess[j];
        lessThan[j].in[1] <== 2;
        lessThan[j].out === 1;
        lessThan[j+2] = LessThan(2);
        lessThan[j+2].in[0] <== soln[j];
        lessThan[j+2].in[1] <== 2;
        lessThan[j+2].out === 1;
        for (k=j+1; k<2; k++) {
            // no duplication constraint.
            equalGuess[equalIdx] = IsEqual();
            equalGuess[equalIdx].in[0] <== guess[j];
            equalGuess[equalIdx].in[1] <== guess[k];
            equalGuess[equalIdx].out === 0;
            equalSoln[equalIdx] = IsEqual();
            equalSoln[equalIdx].in[0] <== soln[j];
            equalSoln[equalIdx].in[1] <== soln[k];
            equalSoln[equalIdx].out === 0;
            equalIdx += 1;
        }
    }






    // validate actual vs generated pubSolnHash
    component poseidon = Poseidon(3);
    poseidon.inputs[0] <== privSalt;
    poseidon.inputs[1] <== privSolnA;
    poseidon.inputs[2] <== privSolnB;


    solnHashOut <== poseidon.out;
    pubSolnHash === solnHashOut;
}

component main {public [pubGuessA, pubGuessB]} = Bonus();